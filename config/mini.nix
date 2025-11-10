{lib, ...}: {
  plugins.mini-clue = {
    enable = true;
    settings.clues = [
      (lib.nixvim.mkRaw ''require("mini.clue").gen_clues.windows()'')
    ];
    settings.triggers = [
      {
        keys = "<Leader>";
        mode = "n";
      }
      {
        keys = "<C-w>";
        mode = "n";
      }
    ];
  };
}
