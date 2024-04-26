{pkgs, ...}: {
  imports = [./agda.nix];

  colorschemes.tokyonight.enable = true;
  plugins = {
    auto-session.enable = true;
    lualine.enable = true;
    luasnip.enable = true;
    luasnip.fromLua = [{paths = ./nvim-snips.lua;}];
    markdown-preview = {
      enable = true;
    };
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
          {name = "luasnip";}
        ];
        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';

        mapping.__raw = ''
          cmp.mapping.preset.insert({
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<Tab>'] = cmp.mapping(
              function(fallback)
                local luasnip = require("luasnip")

                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expandable() then
                  luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                -- elseif check_backspace() then
                --   fallback()
                else
                  fallback()
                end
              end,
            { "i", "s" })
          })
        '';
      };
    };

    noice.enable = true;
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
    treesitter = {
      enable = true;
      indent = true;
      incrementalSelection.enable = true;
    };
    telescope = {
      enable = true;
      enabledExtensions = ["ast_grep"];
    };
    which-key.enable = true;
    cmp-vim-lsp.enable = false;
    lsp-format = {
      enable = true;
      lspServersToEnable = "all";
    };
    lsp = {
      enable = true;
      servers = {
        jsonls.enable = true;
        nil_ls = {
          enable = true;
          settings.formatting.command = ["${pkgs.alejandra}/bin/alejandra"];
        };
        lua-ls.enable = true;
        pyright.enable = true;
        rust-analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
      };
    };
  };
  extraPlugins = with pkgs.vimPlugins; [
    # playground # treesitter playground
    nvim-lspconfig
    plenary-nvim
    (pkgs.vimUtils.buildVimPlugin
      {
        name = "agda.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "Isti115";
          repo = "agda.nvim";
          rev = "4dbd441";
          hash = "sha256-FBC8+Pr/CkgXLDjzg8TJyp1bkJYaACSd/ORZn+L5DPk=";
        };
      })
    firenvim
    # (pkgs.vimUtils.buildVimPlugin
    #   {
    #     name = "navigator.lua";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "ray-x";
    #       repo = "navigator.lua";
    #       rev = "c597965";
    #       hash = "sha256-1Teqs8IGwr/4r6ryCiozAjW7Fm52QIwtX/n78E6IibY=";
    #     };
    #   })
    # (pkgs.vimUtils.buildVimPlugin
    #   {
    #     name = "guihua.lua";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "ray-x";
    #       repo = "guihua.lua";
    #       rev = "f8ef84d";
    #       hash = "sha256-fKljvoExSf1Y+3yOfYoS1+4nyDTmGRKIs+vwkK69VZM=";
    #     };
    #     postInstall = ''
    #       cd $target/lua/fzy
    #       make
    #     '';
    #   })
    telescope-sg
    (pkgs.vimUtils.buildVimPlugin
      {
        name = "nvim-treehopper";
        src = pkgs.fetchFromGitHub {
          owner = "mfussenegger";
          repo = "nvim-treehopper";
          rev = "5a28bff";
          hash = "sha256-9sokUVcWLllSV+KomKZJ0UvydLoZA3sGjGVkbDLzKcY=";
        };
      })
    (pkgs.vimUtils.buildVimPlugin
      {
        name = "tree-climber.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "drybalka";
          repo = "tree-climber.nvim";
          rev = "9b0c8c8";
          hash = "sha256-iivP8g8aSeEnS/dBcb0sg583ijzhWFA7w430xWPmjF0=";
        };
      })
    (pkgs.vimUtils.buildVimPlugin
      {
        name = "hydra.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "nvimtools";
          repo = "hydra.nvim";
          rev = "8578056";
          hash = "sha256-Qxp2FigXlupAw/ZwZRVJ+hRKzVRtupV6L4a6jOslwI0=";
        };
      })
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
    timeoutlen = 50;
    scrolloff = 10;
  };
  extraFiles = let
    nvfs = pkgs.fetchFromGitHub {
      owner = "LunarVim";
      repo = "Neovim-from-scratch";
      rev = "96fca52";
      hash = "sha256-D9d+nlwe4qZn8cXqA1WaaRu8/q2yoYATrx1Nj6Gokak=";
    };
  in {
    "lua/nvfs-keymaps.lua" = builtins.readFile "${nvfs}/lua/user/keymaps.lua";
  };
  extraConfigLua = with builtins;
    replaceStrings [
      "@openscad-lsp@"
    ]
    [
      "${pkgs.openscad-lsp}/bin/openscad-lsp"
    ]
    (readFile ./lua/extraconfig.lua);
  keymaps = let
    leaderkm =
      map (km: km // {key = "<leader>" + km.key;})
      [
        {
          key = "nt";
          action = "<cmd>Neotree focus toggle=true<CR>";
        }
        {
          key = "cf";
          action = ''
            function()
              vim.lsp.buf.format { async = true }
            end
          '';
          lua = true;
        }
        {
          key = "ca";
          action = ''vim.lsp.buf.code_action'';
          lua = true;
        }
        {
          key = " ";
          action = ''<cmd>Telescope find_files<CR>'';
        }
        {
          key = ",";
          action = ''<cmd>Telescope buffers<CR>'';
        }
        {
          key = "f";
          action = ''<cmd>Telescope live_grep<CR>'';
        }
        {
          key = "s";
          action = ''require 'tsht'.nodes'';
          lua = true;
        }
        {
          key = ":";
          action = ''<cmd>Telescope commands<CR>'';
        }
        {
          key = "qq";
          action = ''<cmd>qa<CR>'';
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
