{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  # Cornelis version in Nixpkgs is two years old
  # This fixes an error of the kind:
  # Unexpected "cannot read: IOCTM [...]", expecting JSON value
  nixpkgs.overlays = [inputs.cornelis.overlays.cornelis];
  plugins.cornelis = {
    enable = true;
    settings = {
      use_global_binary = 1;
      max_size = 10;
      no_agda_input = 1;
    };
  };
  extraFiles."data/agda-symbols.json".source =
    pkgs.runCommand "agda-symbols.json" {
      buildInputs = [pkgs.jq];
    } ''
      jq -c '[
        to_entries[]
        | {value: if (.value | type) == "array"
            then .value[]
            else .value end,
          key}
        | [.value, .key]
      ]' ${inputs.agda-symbols}/symbols.json > $out
    '';
  files."ftplugin/agda.lua" = {
    extraConfigLuaPre = builtins.readFile ../lua/agda_input.lua;
    keymaps =
      [
        {
          options.desc = "Define declaration";
          key = "<leader>md";
          action = ''yyvip<Esc>pf:c$= ?<Esc>'';
        }
        {
          options.desc = "Search local agda library";
          key = "<leader>z";
          action = assert config.plugins.toggleterm.enable; ''<cmd>ToggleTerm dir=float cmd="agda-search"<cr>'';
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
          key = "\\";
          action.__raw = ''picksym'';
          mode = ["i"];
          options.buffer = true;
        }
        {
          key = "gd";
          action = "<Cmd>CornelisGoToDefinition<CR>";
          options.remap = true;
        }
        {
          key = "<F6>";
          action = "<nop>";
          mode = "i";
        }
        {
          key = "à";
          action = "<F6>";
          mode = ["n" "i"];
          options.remap = true;
        }
      ]
      ++ (
        builtins.map
        (ka: let
          key = builtins.elemAt ka 0;
          action = builtins.elemAt ka 1;
        in {
          inherit key action;
          mode = ["i" "c"];
          options.buffer = true;
        })
        [
          ["==" "≡"]
          [";;" ";"]
          [";;h" ";ₕ"]
          [";;v" ";ᵥ"]
          ["'" "′"]
          ["''" "″"]
          ["[[" "⟦"]
          ["]]" "⟧"]
          ["~~" "≈"]
          ["||" "‖"]
        ]
      );
  };
  plugins.mini-pick = {enable = true;};
  plugins.nvim-autopairs.exclude_filetypes = {"'" = ["agda"];};
}
