{...}: {
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "enter";
          "<S-Tab>" = ["select_prev" "fallback"];
          "<Tab>" = ["select_next" "fallback"];
        };
        completion = {
          accept.create_undo_point = false;
          list.selection.preselect = false;
        };
        fuzzy.implementation = "rust";
        fuzzy.prebuilt_binaries.download = false;
        sources = {
          providers = {
            emoji = {
              module = "blink-emoji";
              name = "Emoji";
              score_offset = 15;
              # Optional configurations
              opts = {
                insert = true;
              };
            };
          };
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "emoji"
          ];
        };
      };
    };
    blink-emoji.enable = true;
    blink-compat = {
      enable = true;
      settings = {
        impersonate_nvim_cmp = true;
      };
    };
  };
}
