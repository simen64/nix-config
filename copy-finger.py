#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p libfprint gusb gobject-introspection python3 python3Packages.pygobject3 python3Packages.click

import os
import sys
import gi

gi.require_version("FPrint", "2.0")
from gi.repository import FPrint
import click


@click.command()
@click.argument("fingerprint_path")
@click.argument("new_user")
def copy_fingerprint(fingerprint_path: str, new_user: str):
    """
    Tool to copy a fingerprint from one user to another.
    Must be run as root.
    """
    if os.geteuid() != 0:
        print(
            "Error: this script must be run as root (use run0 or sudo).",
            file=sys.stderr,
        )
        sys.exit(1)

    # Duplication code found from tests here:
    # https://github.com/freedesktop/libfprint-fprintd/blob/b440acb57daf0459f2b8b8de82d8284c2040b720/tests/fprintd.py#L827
    print(f"We will copy fingerprint from {fingerprint_path} to user {new_user}")
    print(
        "Note that duplicated fingers is NOT SUPPORTED by fprintd for a reason! "
        "Use of this tool may break the ability to identify a user by their fingerprint. "
        "No warranty is implied."
    )
    print(
        "See comment here for why duplicate fingers are not supported:\n"
        "https://gitlab.freedesktop.org/libfprint/fprintd/-/blob/master/src/device.c#L2226"
    )

    with open(fingerprint_path, "rb") as orig_file:
        dup_print = FPrint.Print.deserialize(orig_file.read())

    current_user = dup_print.get_username()
    print(f"Copying {dup_print.get_finger()} finger from user {current_user}")

    dup_print.set_username(new_user)
    print(f'Successfully applied new username "{new_user}" to print.')

    # Reuse path structure from original file.
    # Note that the path is specific to device and finger.
    new_fp_path = fingerprint_path.replace(current_user, new_user)
    os.makedirs(os.path.dirname(new_fp_path), exist_ok=True)

    with open(new_fp_path, "wb") as new_file:
        new_file.write(dup_print.serialize())

    print("Fingerprint successfully copied! Try it out with the fprintd-verify tool.")


if __name__ == "__main__":
    copy_fingerprint()
