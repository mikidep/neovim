{
  pkgs,
  lib,
  ...
}: {
  plugins.lsp-format = {
    enable = true;
    lspServersToEnable = "all";
  };
  plugins.lsp = {
    enable = true;
    preConfig = ''
      vim.lsp.set_log_level('INFO')
      require('vim.lsp.log').set_format_func(vim.inspect)
    '';
    keymaps = {
      lspBuf = {
        K = "hover";
        gD = "references";
        gd = "definition";
        gi = "implementation";
        gt = "type_definition";
        gr = "rename";
      };
    };
    servers = {
      clangd.enable = true;
      jsonls.enable = true;
      nil_ls = {
        enable = true;
        settings.formatting.command = [(lib.getExe pkgs.alejandra)];
      };
      nixd = {
        enable = true;
      };
      lua_ls.enable = true;
      ruff.enable = true;
      openscad_lsp = {
        enable = true;
        settings = {
          stdio = true;
          fmt_style = let
            clang-format = (pkgs.formats.yaml {}).generate "clang-format.yaml" {
              IndentWidth = 2;
              ColumnLimit = 80;
            };
          in "file:${clang-format}";
        };
      };
      pyright.enable = true;
      rust_analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
        settings.rustfmt.overrideCommand = [(lib.getExe pkgs.rustfmt)];
      };
      hls = {
        enable = true;
        package = null;
        installGhc = false;
      };
      cssls.enable = true;
      tinymist = {
        enable = true;
      };
    };
  };
  plugins.openscad = {
    enable = true;
    package = with pkgs;
      vimPlugins.openscad-nvim.overrideAttrs {
        buildInputs = [
          htop
          fzf
        ];
        # dependencies = [
        #   vimPlugins.fzf-vim
        # ];
        patches = [
        ];
      };
  };
  files = {
    "ftplugin/openscad.lua" = {
      localOpts = {
        comments = "://";
        commentstring = "// %s";
      };

      extraPackages = [
        pkgs.clang-tools
      ];
    };
    "ftplugin/typst.lua" = {
      localOpts = {
        wrap = true;
        comments = "://";
        commentstring = "// %s";
      };
    };
    "ftplugin/markdown.lua" = {
      localOpts = {
        wrap = true;
      };
    };
  };
}
