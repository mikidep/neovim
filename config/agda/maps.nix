{config, ...}: {
  files."ftplugin/agda/maps.lua" = {
    # make these into plugins
    extraConfigLuaPre =
      builtins.readFile ./agda_input.lua;
    keymaps = let
      inputMaps = [
        {
          key = "\\";
          action.__raw = ''picksym_cb("")'';
          mode = ["i"];
          options.buffer = true;
        }
        {
          key = "_";
          action.__raw = ''picksym_cb("_")'';
          mode = ["i"];
          options.buffer = true;
        }
        {
          key = "^";
          action.__raw = ''picksym_cb("^")'';
          mode = ["i"];
          options.buffer = true;
        }
      ];
    in
      [
        {
          options.desc = "Define declaration";
          key = "<leader>md";
          action = ''yyvip<Esc>pf:c$= ?<Esc>'';
        }
        {
          options.desc = "Search local agda library";
          key = "<leader>z";
          action = assert config.plugins.toggleterm.enable; {
            __raw = ''
              function()
                require('toggleterm.terminal').Terminal:new({
                  cmd = "agda-search",
                  direction = "float",
                  on_open = function(term)
                    vim.keymap.set("t", "\\", picksym_cb(""),
                      { buffer = term.bufnr })
                    vim.keymap.set("t", "_", picksym_cb("_"),
                      { buffer = term.bufnr })
                    vim.keymap.set("t", "^", picksym_cb("^"),
                      { buffer = term.bufnr })
                  end
                }):toggle()
              end
            '';
          };
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
            key = "${agdaLeader}ym";
            action = "<Cmd>CornelisElaborate Normalised<CR>";
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
      ++ inputMaps
      ++ (
        map (ka: let
          key = builtins.elemAt ka 0;
          action = builtins.elemAt ka 1;
        in {
          inherit key action;
          mode = ["i"];
          options.buffer = true;
        })
        [
          ["==" "≡"]
          [";;" ";"]
          [";;h" ";ₕ"]
          [";;v" ";ᵥ"]
          ["[[" "⟦"]
          ["]]" "⟧"]
          ["~~" "≈"]
          ["||" "‖"]
        ]
      );
  };
}
