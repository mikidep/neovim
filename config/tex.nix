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
    settings.view_method = "zathura";
  };
  globals.latex_view_general_viewer = "zathura";
}
