{inputs, ...}: {
  clipboard = {
    providers.wl-copy.enable = true;
    register = "unnamedplus";
  };
  globals.mapleader = " ";
  opts = {
    completeopt = ["menuone" "noselect" "fuzzy"];
    mouse = "";
    expandtab = true;
    shiftwidth = 2;
    tabstop = 2;
    smartindent = true;
    number = true;
    relativenumber = true;
    wrap = false;
    winborder = "rounded";
    scrolloff = 5;
    linebreak = true;
    sessionoptions = [
      "blank"
      "curdir"
      "folds"
      "tabpages"
      "winsize"
      "winpos"
    ];
    undofile = true;
    wildmode = "longest:full,full";
    wildignorecase = true;
    wildoptions = ["pum" "tagfile" "fuzzy"];
    swapfile = false;
    ignorecase = true;
    splitbelow = true;
    splitright = true;
  };
  # diagnostic.settings = {
  #   virtual_text = true;
  # };
  autoCmd = [
    {
      event = ["TextChanged"];
      callback.__raw = ''
        function(_)

        end
      '';
    }
  ];
  extraFiles = {
    "lua/nvfs-keymaps.lua".source = "${inputs.nvfs}/lua/user/keymaps.lua";
  };
}
