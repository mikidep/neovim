{pkgs, ...}: {
  plugins.telescope.enable = true;

  extraPackages = [pkgs.ripgrep];
  extraPlugins = [
    pkgs.vimPlugins.telescope-undo-nvim
  ];
  keymaps =
    (map (km: km // {key = "<leader>" + km.key;})
      [
        {
          key = "nt";
          action = "<cmd>Neotree focus toggle=true<CR>";
        }
        {
          key = " ";
          action = ''<cmd>Telescope find_files<CR>'';
        }
        {
          key = ",";
          action = ''<cmd>Telescope buffers<CR>'';
        }
        {
          key = "f";
          action = ''<cmd>Telescope live_grep<CR>'';
        }
        {
          key = ":";
          action = ''<cmd>Telescope commands<CR>'';
        }
        {
          options.desc = "Open undo tree";
          key = "u";
          action = ''<cmd>Telescope undo<CR>'';
        }
      ])
    ++ [
    ];
}
