{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  globals = {
    cornelis_use_global_binary = true;
    cornelis_max_size = 15;
    cornelis_no_agda_input = 1;
  };
  plugins.blink-cmp.settings = {
    sources = {
      default = ["agda-symbols"];
      min_keyword_length = 0;
      providers.agda-symbols = {
        enabled = true;
        name = "agda-symbols";
        module = "blink-agda-symbols";
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
  extraPackages = [pkgs.cornelis];

  files."ftplugin/agda.lua" = {
    extraPlugins = with pkgs; [
      vimPlugins.cornelis
      (
        let
          name = "blink-cmp-agda-symbols";
        in
          vimUtils.buildVimPlugin
          {
            inherit name;
            src = inputs.${name};
          }
      )
    ];

    keymaps =
      [
        {
          options.desc = "Define declaration";
          key = "<leader>md";
          action = ''yyvip<Esc>pf:c$= ?<Esc>'';
          # options.remap = true;
        }
        {
          options.desc = "Search local agda library";
          key = "<leader>z";
          action = ''<cmd>FloatermNew agda-search<CR>'';
          # options.remap = true;
        }
      ]
      ++ (let
        agdaLeader = "<F6>";
      in
        builtins.concatMap ({
          key,
          action,
        }: [
          {
            inherit key action;
            mode = "n";
            options.buffer = true;
          }
          {
            inherit key;
            action = "<C-o>${action}";
            mode = "i";
            options.buffer = true;
          }
        ]) [
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
        ])
      ++ [
        {
          key = "gd";
          action = "<Cmd>CornelisGoToDefinition<CR>";
          options.remap = true;
        }
      ]
      ++ (builtins.map (ka: let
          key = builtins.elemAt ka 0;
          action = builtins.elemAt ka 1;
        in {
          inherit key action;
          mode = ["i" "c"];
          options.buffer = true;
        }) [
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
        ]);
  };

  plugins.nvim-autopairs.exclude_filetypes = {
    "'" = ["agda"];
  };
}
