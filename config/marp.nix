{
  pkgs,
  inputs,
  ...
}: {
  files."ftplugin/markdown.lua".extraPlugins = with pkgs; [
    {
      plugin = vimUtils.buildVimPlugin {
        name = "marp";
        src = inputs.marp-nvim;
      };
      config = ''
        lua require 'marp'.setup({})
      '';
    }
  ];
  extraPackages = with pkgs; [marp-cli];
}
