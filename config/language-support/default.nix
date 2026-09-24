{
  pkgs,
  lib,
  ...
}: rec {
  imports = [
    ./agda
    ./tex.nix
    ./marp.nix
    ./fluidcad.nix
  ];
  plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = {
        timeout_ms = 500;
        lsp_format = "fallback";
      };
    };
  };
  plugins.lsp = {
    enable = true;
    preConfig = ''
      vim.lsp.log.set_level('WARN')
      require('vim.lsp.log').set_format_func(vim.inspect)
    '';
    keymaps = {
      # could be registered on client/registerCapability
      lspBuf = {
        K = "hover";
        gD = "references";
        gd = "definition";
        gi = "implementation";
        gt = "type_definition";
        gr = "rename";
        gh = "hover";
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
      ts_ls = {
        enable = true;
      };
    };
  };
  plugins.actions-preview = {
    enable = true;
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
      plugins.markdown-preview = {
        enable = true;
        settings = {
          browserfunc = "OpenMarkdownPreview";
          page_title = "\${name}";
          theme = "light";
        };
      };
    };
  };
  extraPlugins = with pkgs.vimPlugins; [
    nvim-luadev
  ];
  keymaps = [
    (
      assert plugins.actions-preview.enable; {
        key = "gf";
        action.__raw = ''
          require("actions-preview").code_actions
        '';
        mode = [
          "v"
          "n"
        ];
        options.desc = "LSP code actions";
      }
    )
  ];
}
