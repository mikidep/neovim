{pkgs, ...}: {
  plugins.luasnip = {
    enable = true;
    extraConfig = {
      enable_autosnippets = true;
    };
  };
  extraPlugins = with pkgs; [
    {
      plugin = vimPlugins.ultimate-autopair-nvim;
      config = ''
        lua << EOF
          require 'ultimate-autopair'.setup({})
        EOF
      '';
    }
  ];
}
