{pkgs, ...}: {
  plugins.cmp-omni.enable = true;
  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      sources = [
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "buffer";}
        {name = "luasnip";}
        # {
        #   name = "omni";
        #   option = {
        #     disable_omnifuncs = ["v:lua.vim.lsp.omnifunc"];
        #   };
        # }
      ];
      snippet.expand = ''
        function(args)
          require('luasnip').lsp_expand(args.body)
        end
      '';

      mapping.__raw = ''
        cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(
            function(fallback)
              local luasnip = require("luasnip")

              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expandable() then
                luasnip.expand()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              -- elseif check_backspace() then
              --   fallback()
              else
                fallback()
              end
            end,
          { "i", "s" })
        })
      '';
    };
  };
}
