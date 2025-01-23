{pkgs, ...}: {
  plugins.cmp-omni.enable = true;
  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    cmdline = {
      "/" = {
        mapping = {
          __raw = "cmp.mapping.preset.cmdline()";
        };
        sources = [
          {
            name = "buffer";
          }
        ];
      };
      ":" = {
        mapping = {
          __raw = ''
            cmp.mapping.preset.cmdline()
          '';
        };
        matching = {
          disallow_partial_matching = false;
          disallow_partial_fuzzy_matching = false;
        };
        sources = [
          {
            name = "path";
          }
          {
            name = "cmdline";
            option = {
              ignore_cmds = [
                "Man"
                "!"
              ];
            };
          }
        ];
      };
    };
    settings = {
      matching.disallow_partial_fuzzy_matching = false;
      sources = [
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "buffer";}
        {name = "luasnip";}
      ];
      snippet.expand = ''
        function(args)
          require('luasnip').lsp_expand(args.body)
        end
      '';

      mapping = {
        "<CR>" = "cmp.mapping.confirm()";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        "<Esc>" = "cmp.mapping.close()";
      };
    };
  };
}
