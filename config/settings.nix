{pkgs, ...}: {
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
    # Don't retain files that were not "touched"
    {
      event = ["BufRead"];
      callback.__raw = ''
        function(_)
          vim.bo.bh = 'delete'
        end
      '';
    }
    {
      event = ["TextChanged" "ModeChanged" "TextYankPost"];
      callback.__raw = ''
        function(_)
          vim.bo.bh = 'hide'
        end
      '';
    }
  ];

  extraFiles."plugin/kwbdi.vim".source = pkgs.fetchurl {
    url = "https://www.vim.org/scripts/download_script.php?src_id=8068";
    name = "kwbdi.vim";
    hash = "sha256-uf5gB4b+D+xmV7VSGa6G77DMnLhudl90Gdk68c8giW0=";
  };

}
