{
  plugins.flash = {
    enable = true;
    jump.autojump = true;
    modes = {
      char.enabled = true;
      search.enabled = true;
    };
  };

  keymaps = [
    {
      key = "s";
      action = ''function() require("flash").jump() end'';
      lua = true;
    }
    {
      key = "<leader>s";
      action = ''function() require("flash").treesitter_search() end'';
      lua = true;
    }
  ];
}
