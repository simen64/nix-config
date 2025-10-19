{pkgs, ...}: {

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = "Droid Sans Mono";
      font-size = 14;
      window-padding-x = 10;
      window-padding-y = 10;
      theme = "Everforest Dark - Hard";
      keybind = "ctrl+t=new_tab";
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    
    shellAliases = {
      ls = "ls --color";
      cd = "z";
      nano = "echo 'use vim brah 🙏🥀'";
    };
  };

  # Strictly for zsh plugins
  home.packages = [
   pkgs.zsh-completions
   pkgs.zsh-autosuggestions
   pkgs.zsh-syntax-highlighting
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
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
              folder_icon = "..\ue5fe..";
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
              branch_icon = "\ue725 ";
              cherry_pick_icon = "\ue29b ";
              commit_icon = "\uf417 ";
              fetch_status = false;
              fetch_upstream_icon = false;
              merge_icon = "\ue727 ";
              no_commits_icon = "\uf0c3 ";
              rebase_icon = "\ue728 ";
              revert_icon = "\uf0e2 ";
              tag_icon = "\uf412 ";
            };
            template = "{{ .HEAD }} ";
            style = "plain";
            type = "git";
          }
          {
            style = "plain";
            foreground = "p:closer";
            template = ">";
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
}

