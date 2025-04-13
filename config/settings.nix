{
  pkgs,
  lib,
  inputs,
  ...
}: {
  clipboard = {
    providers.wl-copy.enable = true;
    register = "unnamedplus";
  };
  globals.mapleader = " ";
  opts = {
    expandtab = true;
    shiftwidth = 2;
    tabstop = 2;
    smartindent = true;
    number = true;
    relativenumber = true;
    wrap = false;
    scrolloff = 10;
    linebreak = true;
    sessionoptions = [
      "blank"
      "buffers"
      "curdir"
      "folds"
      "tabpages"
      "winsize"
      "winpos"
    ];
    undofile = true;
    wildmode = "longest:full,full";
    wildignorecase = true;
    swapfile = false;
    ignorecase = true;
    splitbelow = true;
    splitright = true;
  };
  extraFiles = {
    "lua/nvfs-keymaps.lua".source = "${inputs.nvfs}/lua/user/keymaps.lua";
  };
  keymaps = let
    leaderkm =
      map (km: km // {key = "<leader>" + km.key;})
      [
        {
          options.desc = "Open NeoTree";
          key = "nt";
          action = "<cmd>Neotree focus toggle=true<CR>";
        }
        {
          options.desc = "Format code";
          key = "cf";
          action.__raw = ''
            function()
              vim.lsp.buf.format { async = true }
            end
          '';
        }
        {
          options.desc = "Close all";
          key = "qq";
          action = ''<cmd>qa<CR>'';
        }
        {
          options.desc = "Save all and close";
          key = "wq";
          action = ''<cmd>wqa<CR>'';
        }
        {
          options.desc = "Open LazyGit";
          key = "g";
          action = ''<cmd>FloatermNew ${lib.getExe pkgs.lazygit}<CR>'';
        }
        {
          options.desc = "Open floating terminal";
          key = "t";
          action = ''<cmd>FloatermNew<CR>'';
        }
        {
          options.desc = "Open Yazi";
          key = "y";
          action = ''<cmd>FloatermNew ${lib.getExe pkgs.yazi}<CR>'';
        }
        {
          options.desc = "Paste GitHub URL as a flake URL";
          key = "mg";
          action = ''vt"pT"dtgf.cf/:<Esc>'';
        }
      ];
  in
    leaderkm
    ++ [
      # c and d don't cut the removed text
      {
        key = "c";
        action = ''"_c'';
        mode = ["n" "x"];
      }
      {
        key = "d";
        action = ''"_d'';
        mode = ["n" "x"];
      }
      {
        # move to the end of region after yanking
        key = "y";
        action = ''ygv<Esc>'';
        mode = "x";
      }
      # {
      #   # pasting to replace selection does not eat
      #   # whitespace or overwrite the unnamed register.
      #   key = "p";
      #   action = "P";
      #   mode = "x";
      # }
      {
        # v$ does not include EOL
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
        # terminal mode escape
        key = "<Esc>";
        action = "<C-\\><C-n>";
        mode = "t";
      }
    ];
  extraConfigLuaPre = ''
    require("nvfs-keymaps")
    vim.keymap.del("i", "jk")
  '';
}
