{
  pkgs,
  inputs,
  ...
}: {
  extraPlugins = with pkgs; [
    {
      plugin = vimUtils.buildVimPlugin {
        name = "marp";
        src = inputs.marp-nvim;
      };
      config = ''
        lua << EOF
          require 'marp'.setup({

          })
        EOF
      '';
    }
  ];
  extraPackages = with pkgs; [marp-cli];
}
