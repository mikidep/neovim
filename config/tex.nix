{
  plugins.lsp.servers.texlab = {
    enable = true;
    settings = {
      texlab.build.onSave = true;
    };
  };
  plugins.vimtex = {
    enable = true;
    texlivePackage = null;
  };
}
