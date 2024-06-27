{pkgs, ...}: {
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
      nil-ls = {
        enable = true;
        settings.formatting.command = ["${pkgs.alejandra}/bin/alejandra"];
      };
      lua-ls.enable = true;
      ruff.enable = true;
      rust-analyzer = {
        enable = true;
        installCargo = true;
        installRustc = true;
        settings.rustfmt.overrideCommand = ["${pkgs.rustfmt}/bin/rustfmt"];
      };
      hls.enable = true;
      cssls.enable = true;
    };
  };

  extraConfigLua = ''
    require 'lspconfig'.openscad_lsp.setup {
      cmd = { "${pkgs.openscad-lsp}/bin/openscad-lsp", "--stdio" }
    }
  '';
}
