{
  plugins.flash = {
    enable = true;
    settings = {
      label.rainbow.enabled = true;
      modes = {
        char = {
          enabled = true;
          multiLine = true;
        };
        search.enabled = true;
      };
    };
  };

  keymaps = [
    {
      key = "s";
      action.__raw = ''function() require("flash").jump() end'';
    }
  ];
}
