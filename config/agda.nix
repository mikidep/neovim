{
  pkgs,
  inputs',
  inputs,
  lib,
  ...
}: {
  plugins.cmp.filetype.agda.sources = [
    {
      name = "buffer";
      option = {
        get_bufnrs.__raw = ''
          function()
            return vim.api.nvim_list_bufs()
          end
        '';
        keyword_pattern.__raw = ''[[[^ \n\t(){};:]\+]]'';
      };
    }
    {name = "agda-symbols";}
    {name = "luasnip";}
  ];

  plugins.cmp.filetype.agda.mapping = {
    "<Space>".__raw = ''
      function(fallback)
        local entry = cmp.get_entries()[1]
        if entry and entry.source.name == "agda-symbols" then
          cmp.confirm({ select = true })
        else
          fallback()
        end
      end
    '';
  };

  extraPlugins = with pkgs; [
    inputs'.cornelis.packages.cornelis-vim
    (
      let
        name = "cmp-agda-symbols";
      in
        vimUtils.buildVimPlugin
        {
          inherit name;
          src = inputs.${name};
        }
    )
  ];

  globals = {
    cornelis_use_global_binary = true;
    cornelis_max_size = 15;
    cornelis_no_agda_input = true;
  };

  extraPackages = [inputs'.cornelis.packages.cornelis];

  autoCmd = [
    {
      event = ["BufRead" "BufNewFile"];
      pattern = ["*.agda"];
      callback.__raw = let
        agdaLeader = "<F6>";
        keymaps = lib.concatStringsSep "\n" [
          (
            lib.concatMapStringsSep "\n" ({
              key,
              action,
            }: ''
              vim.keymap.set('n', '${key}', '${action}', { buffer = true })
              vim.keymap.set('i', '${key}', '<C-o>${action}', { buffer = true })
            '') [
              {
                key = "${agdaLeader}l";
                action = "<Cmd>CornelisLoad<CR><Esc>";
              }
              {
                key = "${agdaLeader}h";
                action = "<Cmd>CornelisQuestionToMeta<CR>";
              }
              {
                key = "${agdaLeader}r";
                action = "<Cmd>CornelisRefine<CR>";
              }
              {
                key = "${agdaLeader}m";
                action = "<Cmd>CornelisElaborate<CR>";
              }
              {
                key = "${agdaLeader}F";
                action = "<Cmd>CornelisPrevGoal<CR>";
              }
              {
                key = "${agdaLeader}f";
                action = "<Cmd>CornelisNextGoal<CR>";
              }
              {
                key = "${agdaLeader},";
                action = "<Cmd>CornelisTypeContext Instantiated<CR>";
              }
              {
                key = "${agdaLeader}c";
                action = "<Cmd>CornelisMakeCase<CR>";
              }
              {
                key = "${agdaLeader}.";
                action = "<Cmd>CornelisTypeContextInfer Simplified<CR>";
              }
              {
                key = "${agdaLeader}y.";
                action = "<Cmd>CornelisTypeContextInfer Normalised<CR>";
              }

              {
                key = "${agdaLeader}a";
                action = "<Cmd>CornelisAuto<CR>";
              }
              {
                key = "${agdaLeader}<space>";
                action = "<Cmd>CornelisGive<CR>";
              }
              {
                key = "<C-A>";
                action = "<Cmd>CornelisInc<CR>";
              }
              {
                key = "<C-X>";
                action = "<Cmd>CornelisDec<CR>";
              }
            ]
          )
          (
            lib.concatMapStringsSep "\n" ({
              key,
              action,
            }: ''
              vim.keymap.set('n', '${key}', '${action}', { buffer = true })
            '') [
              {
                key = "gd";
                action = "<Cmd>CornelisGoToDefinition<CR>";
              }
            ]
          )
          (
            lib.concatMapStringsSep "\n" (lt: let
              key = builtins.elemAt lt 0;
              action = builtins.elemAt lt 1;
            in ''
              vim.keymap.set({'i', 'c'}, [=[${key}]=], '${action}', { buffer = true })
            '') [
              ["==" "≡"]
              [";;" ";"]
              [";;h" ";ₕ"]
              [";;v" ";ᵥ"]
              ["'" "′"]
              ["''" "″"]
              ["[[" "⟦"]
              ["]]" "⟧"]
              ["::" "∷"]
              ["~~" "≈"]
              ["=_k" "＝ₖ"]
              ["=_v" "＝ᵥ"]
              ["|=" "⊨"]
              ["|=>" "⤇"]
              ["||" "‖"]
            ]
          )
        ];
      in ''
        function ()
          ${keymaps}
        end
      '';
    }
  ];
  keymaps = [
    {
      options.desc = "Name parameter (Agda)";
      key = "<leader>mn";
      action = ''<leader>ba : <Esc>F(a'';
      options.remap = true;
    }
    {
      options.desc = "Define declaration";
      key = "<leader>md";
      action = ''yypElc$ = ?<Esc>'';
      options.remap = true;
    }
    {
      options.desc = "Search the stdlib";
      key = "<leader>z";
      action = ''<cmd>FloatermNew agda-search-cubical<CR>'';
      options.remap = true;
    }
  ];
}
