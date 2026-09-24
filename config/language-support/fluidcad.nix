{
  inputs,
  pkgs,
  ...
}: {
  files."ftplugins/javascript.lua" = {
    extraPlugins = with pkgs;
    with vimUtils; [
      {
        plugin = buildVimPlugin {
          name = "FluidCAD";
          src = inputs.fluidcad;
          # doCheck = false;
        };
        config = ''
          lua require "fluidcad".setup {}
        '';
      }
    ];
  };
}
