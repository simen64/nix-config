#!/usr/bin/env python3

import argparse
import os
import platform
import socket
import subprocess
import sys


# ── ANSI colours ────────────────────────────────────────────────────────────
RESET = "\033[0m"
BOLD = "\033[1m"
RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
CYAN = "\033[36m"
DIM = "\033[2m"


def c(color: str, text: str) -> str:
    return f"{color}{text}{RESET}"


def info(msg: str) -> None:
    print(c(CYAN, "→ ") + msg)


def success(msg: str) -> None:
    print(c(GREEN, "✓ ") + msg)


def warn(msg: str) -> None:
    print(c(YELLOW, "⚠ ") + msg)


def error(msg: str) -> None:
    print(c(RED, "✗ ") + msg, file=sys.stderr)


def section(title: str) -> None:
    width = 60
    print()
    print(c(BOLD, f"{'─' * width}"))
    print(c(BOLD, f"  {title}"))
    print(c(BOLD, f"{'─' * width}"))


# ── Helpers ──────────────────────────────────────────────────────────────────
def run(cmd: list[str], **kwargs) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, **kwargs)


def run_output(cmd: list[str]) -> str:
    return subprocess.check_output(cmd, text=True).strip()


def has_changes() -> bool:
    result = run(["git", "status", "--porcelain"], capture_output=True, text=True)
    return bool(result.stdout.strip())


def notify(message: str, title: str = "Nix Rebuild") -> None:
    if platform.system() == "Darwin":
        run(
            [
                "osascript",
                "-e",
                f'display notification "{message}" with title "{title}"',
            ]
        )
    else:
        run(["notify-send", "-e", title, message, "--icon=software-update-available"])


def get_machine() -> str:
    if platform.system() == "Darwin":
        return "macbook"
    hostname = socket.gethostname()
    mapping = {
        "simens-laptop": "thinkpad",
        "desktop-p": "desktop-p",
    }
    if hostname in mapping:
        return mapping[hostname]
    return input("Could not detect machine. Enter MACHINE name: ").strip()


def get_flake_path(machine: str) -> str:
    if platform.system() == "Darwin":
        return f"/Users/simen/nix#{machine}"
    return f"/etc/nixos/#{machine}"


def get_rebuild_cmd(machine: str) -> list[str]:
    flake = get_flake_path(machine)
    if platform.system() == "Darwin":
        return ["sudo", "darwin-rebuild", "switch", "--flake", flake]
    return ["sudo", "nixos-rebuild", "switch", "--flake", flake]


def get_current_generation(is_darwin: bool) -> str:
    try:
        if is_darwin:
            out = run_output(["sudo", "darwin-rebuild", "--list-generations"])
        else:
            out = run_output(["nixos-rebuild", "list-generations"])
        for line in out.splitlines():
            if "current" in line:
                return line.replace("   (current)", "").strip()
    except Exception:
        pass
    return "unknown"


def generate_commit_message() -> str:
    try:
        diff = run_output(["git", "diff", "-U0"])
        if not diff:
            diff = run_output(["git", "diff", "--cached", "-U0"])
        prompt = (
            "Using this git diff create a one sentence git commit message. "
            "ALWAYS follow conventional commits. "
            "ONLY output the commit message nothing else. "
            "Keep the language simple. "
            f"Git diff: {diff}"
        )
        return run_output(["qwen", "-p", prompt])
    except Exception:
        return ""


def ask_commit_message(suggested: str) -> str:
    if suggested:
        while True:
            answer = input(f"\nUse {c(CYAN, repr(suggested))}? [y/n]: ").strip().lower()
            if answer in ("y", "yes"):
                return suggested
            if answer in ("n", "no"):
                break
            print("Please answer y or n.")

    return input("Enter commit message: ").strip()


# ── Main ─────────────────────────────────────────────────────────────────────
def main() -> None:
    parser = argparse.ArgumentParser(
        description="Rebuild NixOS / nix-darwin and commit the config."
    )
    parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        help="Skip the git-changes check and rebuild even when nothing changed.",
    )
    parser.add_argument(
        "-m",
        "--message",
        nargs="?",
        default=None,
        help="Commit message (skips AI generation prompt).",
    )
    args = parser.parse_args()

    is_darwin = platform.system() == "Darwin"
    nix_dir = "/Users/simen/nix" if is_darwin else "/etc/nixos"

    # Change to nix config directory
    os.chdir(nix_dir)

    # ── 1. Check for changes ─────────────────────────────────────────────────
    section("Checking for changes")
    if not args.force and not has_changes():
        warn("No changes detected. Use -f / --force to rebuild anyway.")
        sys.exit(0)
    if args.force:
        info("Force flag set — skipping change check.")
    else:
        success("Changes detected.")

    # ── 2. Detect machine ────────────────────────────────────────────────────
    machine = get_machine()
    info(f"Machine: {c(BOLD, machine)}")

    # ── 3. Format with alejandra ─────────────────────────────────────────────
    section("Formatting (alejandra)")
    fmt = run(["alejandra", "."])
    if fmt.returncode != 0:
        error("alejandra formatting failed — aborting.")
        sys.exit(1)
    success("Formatting complete.")

    # Show diff summary after formatting
    diff_stat = run(["git", "diff", "-U0"], capture_output=True, text=True)
    if diff_stat.stdout:
        print(c(DIM, diff_stat.stdout))

    # ── 4. Commit message ────────────────────────────────────────────────────
    section("Commit message")
    if args.message:
        commit_msg = args.message
        info(f"Using provided message: {c(CYAN, commit_msg)}")
    else:
        info("Generating commit message via qwen…")
        suggested = generate_commit_message()
        if not suggested:
            warn("Could not generate a message (is qwen available?).")
        commit_msg = ask_commit_message(suggested)

    if not commit_msg:
        error("Commit message cannot be empty — aborting.")
        sys.exit(1)

    # ── 5. Stage all changes ─────────────────────────────────────────────────
    section("Staging")
    run(["git", "add", "-A"])
    success("All changes staged.")

    # ── 6. Rebuild ───────────────────────────────────────────────────────────
    section("Rebuilding")
    rebuild_cmd = get_rebuild_cmd(machine)
    info(f"Running: {' '.join(rebuild_cmd)}")
    print()

    # Authenticate sudo up-front so the output isn't interrupted
    run(["sudo", "echo", "Authentication complete"])

    result = run(rebuild_cmd, capture_output=True, text=True)

    if result.returncode != 0:
        # ── Pretty-print the error ───────────────────────────────────────────
        print()
        print(c(RED + BOLD, "═" * 60))
        print(c(RED + BOLD, "  Rebuild FAILED"))
        print(c(RED + BOLD, "═" * 60))

        # Nix errors often appear on stderr; strip duplicate blank lines
        error_output = (result.stderr or result.stdout or "").strip()
        relevant_lines = []
        prev_blank = False
        for line in error_output.splitlines():
            is_blank = not line.strip()
            if is_blank and prev_blank:
                continue
            relevant_lines.append(line)
            prev_blank = is_blank

        for line in relevant_lines:
            if line.startswith("error:"):
                print(c(RED, line))
            elif line.startswith("warning:"):
                print(c(YELLOW, line))
            else:
                print(c(DIM, line))

        print(c(RED + BOLD, "═" * 60))
        print()
        error("Unstaging changes and aborting — nothing was committed or pushed.")
        run(["git", "restore", "--staged", "."])
        sys.exit(1)

    success("Rebuild succeeded.")

    # ── 7. Notification ──────────────────────────────────────────────────────
    notify("Nix rebuild finished successfully")

    # ── 8. Commit & push ─────────────────────────────────────────────────────
    section("Committing & pushing")
    gen = get_current_generation(is_darwin)
    full_message = f"{commit_msg} | {machine}: {gen}"
    info(f"Commit: {c(CYAN, full_message)}")

    commit_result = run(["git", "commit", "-am", full_message], capture_output=True, text=True)
    if commit_result.returncode != 0:
        error("git commit failed:")
        print(c(RED, commit_result.stderr.strip() or commit_result.stdout.strip()))
        warn("Rebuild succeeded but changes were NOT committed.")
        sys.exit(1)
    success("Committed.")

    push_result = run(["git", "push"], capture_output=True, text=True)
    if push_result.returncode != 0:
        error("git push failed:")
        print(c(RED, push_result.stderr.strip() or push_result.stdout.strip()))
        warn("Rebuild and commit succeeded but changes were NOT pushed.")
        sys.exit(1)
    success("Pushed.")

    print()
    success(c(GREEN + BOLD, "Done!"))


if __name__ == "__main__":
    main()
