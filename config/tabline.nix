{
  plugins.barbar = {
    enable = true;
    settings = {
      maximum_padding = 0;
      minimum_padding = 0;
    };
  };
  keymaps = [
    {
      key = "H";
      action = "<cmd>BufferPrevious<cr>";
      mode = "n";
    }
    {
      key = "L";
      action = "<cmd>BufferNext<cr>";
      mode = "n";
    }
    {
      key = "<S-Left>";
      action = "<cmd>BufferPrevious<cr>";
      mode = "n";
    }
    {
      key = "<S-Right>";
      action = "<cmd>BufferNext<cr>";
      mode = "n";
    }
  ];
}
