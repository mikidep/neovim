{
  inputs',
  lib,
  ...
}: {
  extraPlugins = [
    inputs'.cornelis.packages.cornelis-vim
  ];
  globals = {
    cornelis_use_global_binary = true;
    cornelis_split_location = "bottom";
    cornelis_max_size = 15;
    cornelis_no_agda_input = true;
  };
  extraPackages = [inputs'.cornelis.packages.cornelis];
  autoCmd = [
    {
      event = ["BufRead" "BufNewFile"];
      pattern = ["*.agda"];
      callback.__raw = let
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
                key = "<leader><leader>l";
                action = "<Cmd>CornelisLoad<CR><Esc>";
              }
              {
                key = "<leader><leader>h";
                action = "<Cmd>CornelisQuestionToMeta<CR>";
              }
              {
                key = "<leader><leader>r";
                action = "<Cmd>CornelisRefine<CR>";
              }
              {
                key = "<leader><leader>F";
                action = "<Cmd>CornelisPrevGoal<CR>";
              }
              {
                key = "<leader><leader>f";
                action = "<Cmd>CornelisNextGoal<CR>";
              }
              {
                key = "<leader><leader>,";
                action = "<Cmd>CornelisTypeContext Instantiated<CR>";
              }
              {
                key = "<leader><leader>c";
                action = "<Cmd>CornelisMakeCase<CR>";
              }
              {
                key = "<leader><leader>.";
                action = "<Cmd>CornelisTypeContextInfer Instantiated<CR>";
              }
              {
                key = "<leader>y.";
                action = "<Cmd>CornelisTypeContextInfer Normalised<CR>";
              }

              {
                key = "<leader><leader>a";
                action = "<Cmd>CornelisAuto<CR>";
              }
              {
                key = "<leader><leader><space>";
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
              vim.keymap.set('i', [=[${key}]=], '${action}', { buffer = true })
              vim.keymap.set('c', [=[${key}]=], '${action}', { buffer = true })
            '') ([
                ["->" "→"]
                ["=>" "⇒"]
                ["forall" "∀"]
                ["==" "≡"]
                [";;" ";"]
                [";;h" ";ₕ"]
                [";;v" ";ᵥ"]
                ["'" "′"]
                ["''" "″"]
                ["[[" "⟦"]
                ["]]" "⟧"]
                ["=eqv" "≃"]
                ["=?" "≟"]
                ["Nat" "ℕ"]
                ["::" "∷"]
                ["lambda" "λ"]
                ["~~" "≈"]
                ["=_k" "＝ₖ"]
                ["=_v" "＝ᵥ"]
                ["|=" "⊨"]
              ]
              ++ [
                ["gAlpha" "Α"]
                ["galpha" "α"]
                ["gBeta" "Β"]
                ["gbeta" "β"]
                ["gGamma" "Γ"]
                ["ggamma" "γ"]
                ["gDelta" "Δ"]
                ["gdelta" "δ"]
                ["gEpsilon" "Ε"]
                ["gepsil" "ε"]
                ["gZeta" "Ζ"]
                ["gzeta" "ζ"]
                ["gEta" "Η"]
                ["geta" "η"]
                ["gTheta" "Θ"]
                ["gtheta" "θ"]
                ["gIota" "Ι"]
                ["giota" "ι"]
                ["gKappa" "Κ"]
                ["gkappa" "κ"]
                ["gLambda" "Λ"]
                ["glambda" "λ"]
                ["gMu" "Μ"]
                ["gmu" "μ"]
                ["gNu" "Ν"]
                ["gnu" "ν"]
                ["gXi" "Ξ"]
                ["gxi" "ξ"]
                ["gOmicron" "Ο"]
                ["gomicron" "ο"]
                ["gPi" "Π"]
                ["gpi" "π"]
                ["gRho" "Ρ"]
                ["grho" "ρ"]
                ["gSigma" "Σ"]
                ["gsigma" "σ"]
                ["gTau" "Τ"]
                ["gtau" "τ"]
                ["gUpsilon" "Υ"]
                ["gupsil" "υ"]
                ["gPhi" "Φ"]
                ["gphi" "φ"]
                ["gChi" "Χ"]
                ["gchi" "χ"]
                ["gPsi" "Ψ"]
                ["gpsi" "ψ"]
                ["gOmega" "Ω"]
                ["gomega" "ω"]
              ]
              ++ [
                ["_0" "₀"]
                ["_1" "₁"]
                ["_2" "₂"]
                ["_3" "₃"]
                ["_4" "₄"]
                ["_5" "₅"]
                ["_6" "₆"]
                ["_7" "₇"]
                ["_8" "₈"]
                ["_9" "₉"]
                ["^l" "ˡ"]
                ["^r" "ʳ"]
                ["\\up" "↑"]
                ["\\u+" "⊎"]
              ])
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
      action = ''<leader>b)a : <Esc>F(a'';
      options.remap = true;
    }
  ];
}
