{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  isNixOS = lib.hasAttr "nixos" osConfig.system;
  flakePath =
    if isNixOS
    then "/etc/nixos"
    else if pkgs.stdenv.isDarwin
    then "/Users/simen/nix"
    else "/home/simen/.config/nix-config";
in {
  options = {
    terminal = {
      enable = lib.mkEnableOption "Enable terminal module";
    };
  };

  config = lib.mkIf config.terminal.enable {
    programs.ghostty = {
      enable = true;
      package =
        if pkgs.stdenv.isDarwin
        then null
        else pkgs.ghostty;
      enableZshIntegration = true;
      settings = {
        font-family = "AdwaitaMono Nerd Font";
        font-size = 14;
        window-padding-x = 10;
        window-padding-y = 10;
        theme = "everforest-dark";
        keybind = "ctrl+t=new_tab";
      };
      themes = {
        everforest-dark = {
          background = "2D353B";
          foreground = "D3C6AA";
          cursor-color = "E69875";
          selection-background = "543A48";
          selection-foreground = "D3C6AA";
          palette = [
            "0=#232A2E"
            "1=#E67E80"
            "2=#A7C080"
            "3=#DBBC7F"
            "4=#7FBBB3"
            "5=#D699B6"
            "6=#83C092"
            "7=#4F585E"
            "8=#3D484D"
            "9=#543A48"
            "10=#425047"
            "11=#4D4C43"
            "12=#3A515D"
            "13=#514045"
            "14=#83C092"
            "15=#D3C6AA"
          ];
        };
      };
    };

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history.size = 1000;
      history.save = 1000;

      setOptions = ["EXTENDED_GLOB"];

      shellAliases = {
        ls = "ls --color";
        cd = "z";
        nano = "echo 'use vim brah 🙏🥀'";
      };

      initContent = ''
        eval "$(ssh-agent -s)" &>/dev/null

        # Keybinds
        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word
        bindkey '^H' backward-kill-word
        bindkey '^f' autosuggest-accept
        WORDCHARS='*?._-[]~=&;!#$%^(){}<>'
      '';
    };

    # zsh plugins
    home.packages = with pkgs; [
      pkgs.zsh-completions
      pkgs.zsh-autosuggestions
      pkgs.zsh-syntax-highlighting
    ];

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--style=full"
        "--layout reverse"
        "--height=40%"
        "--color 'pointer:green:bold,bg+:-1:,fg+:green:bold,info:blue:bold,marker:yellow:bold,hl:gray:bold,hl+:yellow:bold'"
        "--input-label ' Search '"
        "--color 'input-border:blue,input-label:blue:bold'"
        "--list-label ' Results '"
        "--color 'list-border:green,list-label:green:bold'"
        "--preview-label ' Preview '"
        "--color 'preview-border:magenta,preview-label:magenta:bold'"
      ];
    };

    programs.oh-my-posh = {
      enable = true;
      settings = {
        palette = {
          os = "#9da9a0";
          closer = "p:os";
          orange = "#e69875";
          green = "#a7c080";
          blue = "#7fbbb3";
        };

        blocks = [
          {
            alignment = "left";
            segments = [
              {
                foreground = "p:os";
                style = "plain";
                template = "{{.Icon}} ";
                type = "os";
              }
              {
                foreground = "p:blue";
                style = "plain";
                template = "{{ .UserName }} ";
                type = "session";
              }
              {
                foreground = "p:orange";
                properties = {
                  folder_icon = "....";
                  home_icon = "~";
                  style = "agnoster_short";
                };
                style = "plain";
                template = "{{ .Path }} ";
                type = "path";
              }
              {
                foreground = "p:green";
                properties = {
                  branch_icon = " ";
                  cherry_pick_icon = " ";
                  commit_icon = " ";
                  fetch_status = false;
                  fetch_upstream_icon = false;
                  merge_icon = " ";
                  no_commits_icon = " ";
                  rebase_icon = " ";
                  revert_icon = " ";
                  tag_icon = " ";
                };
                template = "{{ .HEAD }} ";
                style = "plain";
                type = "git";
              }
              {
                type = "python";
                style = "plain";
                foreground = "#DBBC7F";
                template = "  {{ if .Venv }}{{ .Venv }}{{ end }} ";
              }
              {
                style = "plain";
                foreground = "p:closer";
                template = "";
                type = "text";
              }
            ];
            type = "prompt";
          }
        ];

        final_space = true;
        version = 3;
      };
    };

    #home.file = {
    #  ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/zshrc";
    #};
  };
}
