{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  plugins.blink-cmp.settings = {
    sources = {
      per_filetype.agda =
        config.plugins.blink-cmp.settings.sources.default
        ++ [
          "agda-symbols"
        ];
      min_keyword_length = 1;
      providers.agda-symbols = {
        enabled = true;
        name = "agda-symbols";
        module = "blink.compat.source";
        should_show_items.__raw = ''function(ctx) return ctx.trigger.initial_kind == "trigger_character" end'';
      };
    };
    keymap."<Space>" = [
      {
        __raw = ''
          function(cmp)
            local item = cmp.get_items()[1]
            if cmp.is_visible() and item and item.source_name == "agda-symbols" then
              cmp.select_and_accept({
                -- callback = function() vim.api.nvim_feedkeys(" ", "i", true) end
              })
              return true
            else
              return false
            end
          end
        '';
      }
      "fallback"
    ];
  };

  extraPlugins = with pkgs; [
    # inputs'.cornelis.packages.cornelis-vim
    vimPlugins.cornelis
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

  # extraPackages = [inputs'.cornelis.packages.cornelis];
  extraPackages = [pkgs.cornelis];

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
  plugins.nvim-autopairs.exclude_filetypes = {
    "'" = ["agda"];
  };
  keymaps = [
    {
      options.desc = "Define declaration";
      key = "<leader>md";
      action = ''yyvip<Esc>pf:c$= ?<Esc>'';
      options.remap = true;
    }
    {
      options.desc = "Search local agda library";
      key = "<leader>z";
      action = ''<cmd>FloatermNew agda-search<CR>'';
      options.remap = true;
    }
  ];
}
