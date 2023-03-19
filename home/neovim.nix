{ pkgs, ... }:
{
  imports = [
    ./neovim/telescope.nix
    ./neovim/coc.nix
    ./neovim/haskell.nix
    # which-key must be the last import for it to recognize the keybindings of
    # previous imports.
    ./neovim/which-key.nix
  ];
  programs.neovim = {
    enable = true;

    extraPackages = [
      pkgs.lazygit
    ];

    # Full list here,
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/generated.nix
    plugins = with pkgs.vimPlugins; [
      # Status bar for vim

      # For working mouse support when running inside tmux
      terminus

      {
        plugin = lazygit-nvim;
        type = "lua";
        config = ''
          nmap("<leader>gg", ":LazyGit<cr>")
        '';
      }

      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      # Preferred theme
      tokyonight-nvim
      sonokai
      dracula-vim
      gruvbox
      papercolor-theme

      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup {
            options = {
              theme = 'tokyonight'
            }
          }
        '';
      }

      # Buffer tabs
      {
        plugin = bufferline-nvim;
        type = "lua";
        config = ''
          require("bufferline").setup{ }
          nmap("<leader>b", ":BufferLineCycleNext<cr>")
          nmap("<leader>B", ":BufferLineCyclePrev<cr>")
        '';
      }

      # Developing plugins in Haskell
      nvim-hs-vim

      # Language support
      vim-nix

      vim-markdown
    ];

    # Add library code here for use in the Lua config from the
    # plugins list above.
    extraConfig = ''
      lua << EOF
      ${builtins.readFile ./neovim.lua}
      EOF
    '';
  };

}
