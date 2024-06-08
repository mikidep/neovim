{
  pkgs,
  inputs,
  ...
}: {
  plugins.vimtex = {
    enable = true;
    texlivePackage = null;
    settings.view_method = "zathura";
  };
  globals.latex_view_general_viewer = "zathura";
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "cmp-vimtex";
      src = inputs.cmp-vimtex;
    })
  ];
  plugins.cmp.settings.sources = [{name = "vimtex";}];
  plugins.lsp.servers.ltex.enable = true;
}
