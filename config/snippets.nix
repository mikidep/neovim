{
  pkgs,
  inputs,
  ...
}: {
  plugins.luasnip = {
    enable = true;
    extraConfig = {
      enable_autosnippets = true;
    };
  };
  extraPlugins = with pkgs; [
    vimPlugins.ultimate-autopair-nvim
  ];
}
