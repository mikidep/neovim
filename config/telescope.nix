{
  pkgs,
  inputs,
  ...
}: {
  plugins.telescope = {
    enable = true;
    enabledExtensions = ["git_file_history"];
    settings = {
      defaults = {
        mappings.n = {
          "jk".__raw = "require('telescope.actions').close";
          "kj".__raw = "require('telescope.actions').close";
        };
        file_ignore_patterns = [
          "^.git/"
        ];
      };
      pickers = {
        find_files.hidden = true;
        live_grep.glob_pattern = ["!flake.lock"];
      };
    };
  };

  extraPackages = [pkgs.ripgrep];
  extraPlugins = [
    pkgs.vimPlugins.telescope-undo-nvim
    (pkgs.vimUtils.buildVimPlugin {
      name = "telescope-git-file-history.nvim";
      src = inputs.telescope-git-file-history-nvim;
    })
  ];
  keymaps =
    (map (km: km // {key = "<leader>" + km.key;})
      [
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
