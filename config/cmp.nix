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

      mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        "<Esc>" = "cmp.mapping.close()";
      };
    };
  };
}
