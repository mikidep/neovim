{
  plugins.lz-n = {
    enable = true;
  };
  performance = {
    byteCompileLua = {
      enable = true;
      initLua = true;
      nvimRuntime = true;
      plugins = true;
    };
    combinePlugins = {
      enable = true;
      standalonePlugins = [
        "oil.nvim"
        "nvim-treesitter"
        "openscad-grammar"
        "blink.cmp"
      ];
    };
  };
}
