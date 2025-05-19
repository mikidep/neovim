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
}
