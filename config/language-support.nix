{
  pkgs,
  lib,
  ...
}: {
  plugins.aerial.enable = true;
  plugins.lsp-format = {
    enable = true;
    lspServersToEnable = "all";
  };
  plugins.lsp = {
    enable = true;
    preConfig = ''
      vim.lsp.set_log_level('debug')
      require('vim.lsp.log').set_format_func(vim.inspect)
    '';
    servers = {
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
        dependencies = [
          vimPlugins.fzf-vim
        ];
        patches = [
        ];
      };
  };
  extraPlugins = with pkgs.vimPlugins; [
    fzf-vim
  ];

  keymaps = [
    {
      options.desc = "LSP code actions";
      key = "<leader>ca";
      action.__raw = ''vim.lsp.buf.code_action'';
      mode = "n";
    }
    {
      options.desc = "LSP hover";
      key = "<leader>ch";
      action.__raw = ''vim.lsp.buf.hover'';
      mode = "n";
    }
  ];

  extraConfigLua = ''
    require 'lspconfig'.openscad_lsp.setup {
      cmd = { "${lib.getExe pkgs.openscad-lsp}", "--stdio" }
    }
  '';
}
