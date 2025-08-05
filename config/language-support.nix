{
  pkgs,
  lib,
  inputs',
  ...
}: {
  # plugins.lsp-format = {
  #   enable = true;
  #   lspServersToEnable = "all";
  #   settings.openscad.exclude = ["openscad_lsp"];
  # };
  plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = {
        timeout_ms = 500;
        lsp_format = "fallback";
      };
      formatters = {
        scadformat.command = lib.getExe inputs'.scadformat.packages.default;
      };
      formatters_by_ft = {
        openscad = ["scadformat"];
      };
    };
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
        settings.nix.flake.autoArchive = false;
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
          indent = "  ";
          ignore-default = true;
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
