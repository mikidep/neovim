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
        cmdline = {
          keymap = {
            preset = "cmdline";
            "<Tab>" = ["select_next" "fallback"];
            "<CR>" = ["accept_and_enter" "fallback"];
          };
          completion = {
            menu.auto_show = true;
            list.selection = {
              preselect = false;
              auto_insert = true;
            };
          };
        };
        completion = {
          accept.create_undo_point = false;
          list.selection.preselect = false;
          trigger.show_on_insert_on_trigger_character = false;
          trigger.show_on_blocked_trigger_characters = ["-" "_"];
        };
        fuzzy.implementation = "rust";
        fuzzy.prebuilt_binaries.download = false;
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "omni"
          ];
        };
        snippets.preset = "luasnip";
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
