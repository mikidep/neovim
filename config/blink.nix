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
            "<CR>" = ["accept" "fallback"];
          };
          completion = {
            trigger.show_on_backspace = true;
            menu.auto_show = true;
            list.selection = {
              preselect = false;
            };
          };
        };
        completion = {
          accept.create_undo_point = false;
          list.selection.preselect = false;
          trigger = {
            show_on_insert_on_trigger_character = false;
            show_on_blocked_trigger_characters = [" "];
          };
          documentation.auto_show = true;
          documentation.auto_show_delay_ms = 0;
          menu.draw.columns = [["kind_icon"] ["label" "label_description"] ["source_name"]];
        };
        fuzzy.implementation = "rust";
        fuzzy.prebuilt_binaries.download = false;
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
        };
        snippets.preset = "luasnip";
      };
    };
    blink-emoji.enable = true;
    # blink-compat = {
    #   enable = true;
    #   settings = {
    #     impersonate_nvim_cmp = true;
    #   };
    # };
  };
}
