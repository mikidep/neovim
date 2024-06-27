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
      action.__raw = ''function() require("flash").jump() end'';
    }
    {
      key = "S";
      action.__raw = ''function() require("flash").treesitter_search() end'';
    }
  ];
}
