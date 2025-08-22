{
  config,
  pkgs,
  ghostty,
  lib,
  ...
}:

{
  # TODO please change the username & home directory to your own
  home.username = "pasokata";
  home.homeDirectory = "/home/pasokata";
  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    fastfetch

    # archives
    zip
    unzip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    fd
    xclip
    bat
    duf
    dust
    sd
    btop
    htop
    procs

    # networking tools
    nmap # A utility for network discovery and security auditing

    # misc
    file
    which
    tree

    # nix related

    # productivity

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring

    # system tools

    # terminal
    ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    tmux
    zellij

    # dev
    gnumake
    gcc

    # Deskstop
    discord

  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "pasokata";
    userEmail = "84432010+pasokata@users.noreply.github.com";
    #     extraConfig = {
    #       credential."https://github.com".helper = "!gh auth git-credential";
    #     };
  };
  programs.gh.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza";
    };
    interactiveShellInit = ''
      set fish_greeting "
      fzf keybindings
      CTRL-T: fuzzy find files and directories
      CTRL-R: fuzzy find command histories
      ALT-C : fuzzy cd
      "

      set ZELLIJ_AUTO_ATTACH true
      #set ZELLIJ_AUTO_EXIT true
      if status is-interactive
        eval (zellij setup --generate-auto-start fish | string collect)
      end
    '';
  };
  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = false;
      cmd_duration.disabled = true;
    };
  };

  programs.obsidian.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraConfig = "";
    extraPackages = with pkgs; [
      # LSP
      lua-language-server
      vim-language-server
      bash-language-server
      nil
      # formatter
      stylua
      nixfmt-rfc-style
    ];
    extraLuaConfig = "";
    extraLuaPackages = luaPkgs: with luaPkgs; [ ];
    plugins = with pkgs.vimPlugins; [ lazy-nvim ];
  };
  xdg.configFile =
    let
      plugins = with pkgs.vimPlugins; [
        gitsigns-nvim
        nvim-lspconfig
        fidget-nvim
        blink-cmp
        which-key-nvim
        guess-indent-nvim
        todo-comments-nvim
        nvim-treesitter
        mini-nvim
        tokyonight-nvim
        conform-nvim
        nvim-lint
        nvim-autopairs
        # telescope
        telescope-nvim
        plenary-nvim
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
        telescope-file-browser-nvim
        telescope-zoxide
        nvim-web-devicons
      ];
      mkEntryFromDrv =
        drv:
        if lib.isDerivation drv then
          {
            name = "${lib.getName drv}";
            path = drv;
          }
        else
          drv;
      lazy-plugins = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
      };

    in
    {
      "nvim/init.lua".source = pkgs.replaceVars ./.config/nvim/init.lua {
        lazy-plugins-store-path = lazy-plugins;
      };
      "nvim/lsp".source = with pkgs.vimPlugins; "${nvim-lspconfig}/lsp";
      "nvim/parser".source = "${parsers}/parser";
    }
    // {
      "nvim/lua/plugins".source = ./.config/nvim/lua/plugins;
      "fcitx5/profile".source = ./.config/fcitx5/profile;
      "qmk/qmk.ini".source = ./.config/qmk/qmk.ini;
      "ghostty".source = ./.config/ghostty;
      "zellij".source = ./.config/zellij;
    };
  xdg.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.eza = {
    enable = true;
  };
}
