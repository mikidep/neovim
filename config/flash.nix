{
  plugins.flash = {
    enable = true;
    settings = {
      label.rainbow.enabled = true;
      modes.char.enabled = false;
    };
  };

  keymaps = [
    {
      key = "s";
      action.__raw = ''function() require("flash").jump() end'';
    }
  ];
}
