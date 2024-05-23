{
  plugins.hop = {
    enable = true;
  };
  keymaps =
    map (km: km // {key = "<leader>h" + km.key;})
    [
      {
        options.desc = "Hop to word";
        key = "w";
        action = "<cmd>HopWord<CR>";
      }
      {
        options.desc = "Hop to node";
        key = "n";
        action = "<cmd>HopNode<CR>";
      }
      {
        options.desc = "Hop to pattern";
        key = "p";
        action = "<cmd>HopNode<CR>";
      }
    ];
}
