{
  pkgs,
  inputs,
  ...
}: {
  colorschemes.vscode.enable = true;
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
    sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";
    undofile = true;
    wildmode = "longest:full,full";
    wildignorecase = true;
    swapfile = false;
    ignorecase = true;
    splitbelow = true;
    splitright = true;
  };
  extraFiles = {
    "lua/nvfs-keymaps.lua" = builtins.readFile "${inputs.nvfs}/lua/user/keymaps.lua";
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
          action = ''<cmd>FloatermNew ${pkgs.lazygit}/bin/lazygit<CR>'';
        }
        {
          options.desc = "Open floating terminal";
          key = "t";
          action = ''<cmd>FloatermNew<CR>'';
        }
        {
          options.desc = "Open nnn";
          key = "nn";
          action = ''<cmd>FloatermNew ${pkgs.nnn}/bin/nnn<CR>'';
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
        mode = "x";
      }
      {
        key = "d";
        action = ''"_d'';
        mode = "x";
      }
      {
        # move to the end of region after yanking
        key = "y";
        action = ''ygv<Esc>'';
        mode = "x";
      }
    ];
  extraConfigLua = ''
    require("nvfs-keymaps")

  '';
}
