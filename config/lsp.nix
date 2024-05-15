{pkgs, ...}: {
  plugins.lsp-format = {
    enable = true;
    lspServersToEnable = "all";
  };
  plugins.lsp = {
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
      hls.enable = true;
    };
  };

  extraConfigLua = ''
    require 'lspconfig'.openscad_lsp.setup {
      cmd = { "${pkgs.openscad-lsp}/bin/openscad-lsp", "--stdio" }
    }
  '';
}
