{config, ...}: {
  files."ftplugin/agda/maps.lua" = {
    # make these into plugins
    extraConfigLuaPre =
      builtins.readFile ./maps.lua;
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
          options.desc = "Reassoc substitutions";
          key = "<leader>mr";
          action = ''<cmd>'<,'>s/∙/◆/g <bar> '<,'>s/refl/refl′/g<cr>'';
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
            options.silent = false;
          }
          {
            inherit key;
            action = "<C-o>${action}<Esc>";
            mode = "i";
            options.buffer = true;
            options.silent = false;
          }
        ]) (builtins.concatMap (ka: let
            key = builtins.elemAt ka 0;
            action = builtins.elemAt ka 1;
          in [
            {
              key = "${agdaLeader}${key}";
              action = "<Cmd>${action}<CR>";
            }
            {
              key = "${agdaLeader}y${key}";
              action = "<Cmd>${action} Normalised<CR>";
            }
          ]) [
            ["l" "CornelisLoad"]
            ["h" "CornelisQuestionToMeta"]
            ["r" "CornelisRefine"]
            ["m" "CornelisElaborate"]
            ["F" "CornelisPrevGoal"]
            ["f" "CornelisNextGoal"]
            ["," "CornelisTypeContext"]
            ["c" "CornelisMakeCase"]
            ["." "CornelisTypeContextInfer"]
            ["a" "CornelisAuto"]
            ["<space>" "CornelisGive"]
          ]))
      ++ [
        {
          key = "<C-A>";
          action = "<Cmd>CornelisInc<CR>";
          options.buffer = true;
        }
        {
          key = "<C-X>";
          action = "<Cmd>CornelisDec<CR>";
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
          options.buffer = true;
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
          ["::" "∷"]
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
