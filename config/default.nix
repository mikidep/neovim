{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./telescope.nix
    ./agda.nix
    ./cmp.nix
    ./lsp.nix
    ./syntax.nix
  ];

  # colorscheme = "midnight";
  colorschemes.ayu.enable = true;
  plugins = {
    auto-session.enable = true;
    lualine.enable = true;
    luasnip.enable = true;
    #   luasnip.fromLua = [{paths = ./nvim-snips.lua;}];
    markdown-preview = {
      enable = true;
    };
    #  noice.enable = true;
    neo-tree = {
      enable = true;
      openFilesInLastWindow = false;
      window.width = 30;
      eventHandlers.file_opened = ''
        function(file_path)
          --auto close
          require("neo-tree").close_all()
        end
      '';
    };
    which-key.enable = true;
    floaterm.enable = true;
  };
  extraPlugins = with pkgs; [
    (vimUtils.buildVimPlugin {
      name = "midnight.nvim";
      src = inputs.midnight-nvim;
    })
    {
      plugin = vimUtils.buildVimPlugin {
        name = "floating-help.nvim";
        src = inputs.floating-help-nvim;
      };
      config = ''
        lua << EOF
          require 'floating-help'.setup({

          })
        EOF
      '';
    }
    vimPlugins.vim-visual-multi
  ];
  clipboard = {
    providers.wl-copy.enable = true;
    register = "unnamedplus";
  };

  globals.mapleader = " ";
  opts = {
    expandtab = true;
    shiftwidth = 2;
    tabstop = 2;
    smartindent = true;
    number = true;
    relativenumber = true;
    wrap = false;
    scrolloff = 10;
  };
  extraFiles = {
    "lua/nvfs-keymaps.lua" = builtins.readFile "${inputs.nvfs}/lua/user/keymaps.lua";
  };
  extraConfigLua = ''
    require("nvfs-keymaps")
  '';
  keymaps = let
    leaderkm =
      map (km: km // {key = "<leader>" + km.key;})
      [
        {
          options.desc = "Open NeoTree";
          key = "nt";
          action = "<cmd>Neotree focus toggle=true<CR>";
        }
        {
          options.desc = "Format code";
          key = "cf";
          action = ''
            function()
              vim.lsp.buf.format { async = true }
            end
          '';
          lua = true;
        }
        {
          options.desc = "LSP code actions";
          key = "ca";
          action = ''vim.lsp.buf.code_action'';
          lua = true;
        }
        {
          options.desc = "Close all";
          key = "qq";
          action = ''<cmd>qa<CR>'';
        }
        {
          options.desc = "Save all and close";
          key = "wq";
          action = ''<cmd>wqa<CR>'';
        }
        {
          options.desc = "Open LazyGit";
          key = "g";
          action = ''<cmd>FloatermNew ${pkgs.lazygit}/bin/lazygit<CR>'';
        }
        {
          options.desc = "Open floating terminal";
          key = "t";
          action = ''<cmd>FloatermNew<CR>'';
        }
        {
          options.desc = "Paste GitHub URL as a flake URL";
          key = "mg";
          action = ''vt"pT"dtgf.cf/:<Esc>'';
        }
      ];
  in
    leaderkm
    ++ [
      # c and d don't cut the removed text
      {
        key = "c";
        action = ''"_c'';
        mode = "x";
      }
      {
        key = "d";
        action = ''"_d'';
        mode = "x";
      }
      {
        # move to the end of region after yanking
        key = "y";
        action = ''y']'';
        mode = "x";
      }
    ];
}
