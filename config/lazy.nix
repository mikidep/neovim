{
  plugins.lz-n = {
    enable = true;
  };
  performance = {
    byteCompileLua = {
      enable = false;
      initLua = true;
      nvimRuntime = true;
    };
    combinePlugins = {
      enable = false; # breaks agda symbols
      standalonePlugins = [
        "oil.nvim"
        "nvim-treesitter"
        "openscad-grammar"
        "blink.cmp"
        "blink-agda-symbols"
      ];
    };
  };
}
