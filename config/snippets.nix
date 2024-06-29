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
          local ua = require 'ultimate-autopair'
          ua.setup(ua.extend_default {
            {"=", ";", ft={"nix"}},
            tabout = {
              enable = true,
              hopout = true
            }
          })
        EOF
      '';
    }
  ];
}
