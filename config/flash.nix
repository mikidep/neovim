{
  plugins.flash = {
    enable = true;
    label.rainbow.enabled = true;
    jump.autojump = true;
    modes = {
      char = {
        enabled = true;
        multiLine = true;
      };
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
      key = "S";
      action = ''function() require("flash").treesitter_search() end'';
      lua = true;
    }
  ];
}
