{
  pkgs,
  lib,
  config,
  ...
}: {
  keymaps = let
    leaderkm = map (km: km // {key = "<leader>" + km.key;}) [
      {
        options.desc = "Close all";
        key = "qq";
        action = ''<cmd>qa<CR>'';
      }
      {
        options.desc = "Open Yazi";
        key = "y";
        action = assert config.plugins.yazi.enable; ''<cmd>Yazi<CR>'';
      }
      {
        options.desc = "Paste GitHub URL as a flake URL";
        key = "mg";
        action = ''vt"pT"dtgf.cf/:<Esc>'';
      }
      {
        key = "cs";
        action = "<cmd>AerialOpen<cr>";
      }
      {
        key = "t";
        action = "<cmd>ToggleTerm<cr>";
        mode = "n";
      }
      {
        options.desc = "Open LazyGit";
        key = "g";
        action.__raw = ''
          function()
            require('toggleterm.terminal').Terminal:new({
              cmd = "lazygit",
              direction = "float",
              on_open = function(term) end
            }):toggle()
          end
        '';
      }
    ];
  in
    leaderkm
    ++ [
      # c, d and v_p don't cut the removed text,
      # C, D and v_P do instead
      {
        key = "c";
        action = ''"_c'';
        mode = [
          "n"
          "x"
        ];
      }
      {
        key = "C";
        action = ''c'';
        mode = [
          "n"
          "x"
        ];
      }
      {
        key = "d";
        action = ''"_d'';
        mode = [
          "n"
          "x"
        ];
      }
      {
        key = "D";
        action = ''d'';
        mode = [
          "n"
          "x"
        ];
      }
      {
        key = "p";
        action = ''P'';
        mode = ["x"];
      }
      {
        key = "P";
        action = ''p'';
        mode = ["x"];
      }
      {
        # move to the end of region after yanking
        key = "y";
        action = assert config.plugins.yanky.enable; ''<Plug>(YankyYank)'';
        mode = [
          "n"
          "x"
        ];
      }
      {
        # v$ does not include eol
        key = "v$";
        action = "v$h";
        mode = "n";
      }
      {
        # j and k move by virtual lines when wrap is enabled
        key = "j";
        action = "gj";
        mode = "n";
      }
      {
        # see above
        key = "k";
        action = "gk";
        mode = "n";
      }
      {
        # kj escape
        key = "kj";
        action = "<esc>";
        mode = "i";
      }
      {
        # u in visual mode undoes
        key = "u";
        action = "<Undo>";
        mode = ["x"];
      }
      {
        key = "H";
        action = "<cmd>bprev<cr>";
        mode = "n";
      }
      {
        key = "L";
        action = "<cmd>bnext<cr>";
        mode = "n";
      }
      {
        key = "<S-Left>";
        action = "<cmd>bprev<cr>";
        mode = "n";
      }
      {
        key = "<S-Right>";
        action = "<cmd>bnext<cr>";
        mode = "n";
      }
      {
        key = "<C-h>";
        action = "zH";
        mode = "x";
      }
      {
        key = "<C-l>";
        action = "zL";
        mode = "x";
      }
      {
        key = "ga";
        action = "<Plug>(EasyAlign)";
        mode = "x";
      }
    ];
}
