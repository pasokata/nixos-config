{ config, pkgs, ghostty, lib, ... }:

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
    interactiveShellInit = ''
      set fish_greeting "
      fzf keybindings
      CTRL-T: fuzzy find files and directories
      CTRL-R: fuzzy find command histories
      ALT-C : fuzzy cd
      "
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

  programs.neovim = 
  {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraConfig = "";
    extraPackages = with pkgs;[lua-language-server vim-language-server bash-language-server nil];
    extraLuaConfig = "";
    extraLuaPackages = luaPkgs: with luaPkgs; [ ];
    plugins = with pkgs.vimPlugins; [ lazy-nvim ];
  };
  xdg.configFile."nvim/init.lua".source = 
    let
      plugins = with pkgs.vimPlugins; [
        gitsigns-nvim
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
    in
      pkgs.replaceVars ./.config/nvim/init.lua {
        lazy-plugins-store-path = lazy-plugins;
      };
  


  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.enable = true;
  xdg.configFile = {
    "nvim/lua/plugins".source = ./.config/nvim/lua/plugins;
    #"nvim" = {
    #  source = ./.config/nvim;
    #  recursive = true;
    #};
    "fcitx5/profile".source = ./.config/fcitx5/profile;
    "qmk/qmk.ini".source = ./.config/qmk/qmk.ini;
  };
}
