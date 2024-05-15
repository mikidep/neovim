{
  inputs',
  lib,
  ...
}: {
  extraPlugins = [
    inputs'.cornelis.packages.cornelis-vim
  ];
  globals.cornelis_use_global_binary = 1;
  globals.cornelis_split_location = "bottom";
  globals.cornelis_agda_prefix = "<C-u>";
  extraPackages = [inputs'.cornelis.packages.cornelis];

  extraConfigLua = let
    extraConfigVim = lib.concatStringsSep "\n" [
      ''
        au BufRead,BufNewFile *.agda call AgdaFiletype()
        au QuitPre *.agda :CornelisCloseInfoWindows
        function! AgdaFiletype()
          call cornelis#bind_input("ul", "↖")
          call cornelis#bind_input("ur", "↗")
      ''
      (
        lib.concatMapStringsSep "\n" ({
          key,
          action,
        }: ''
          nnoremap <buffer> ${key} ${action}
          inoremap <buffer> ${key} <C-o>${action}
        '') [
          {
            key = "<leader><leader>l";
            action = ":CornelisLoad<CR>";
          }
          {
            key = "<leader><leader>h";
            action = ":CornelisQuestionToMeta<CR>";
          }
          {
            key = "<leader><leader>r";
            action = ":CornelisRefine<CR>";
          }
          {
            key = "<leader><leader>F";
            action = ":CornelisPrevGoal<CR>";
          }
          {
            key = "<leader><leader>f";
            action = ":CornelisNextGoal<CR>";
          }
          {
            key = "<leader><leader>,";
            action = ":CornelisTypeContext<CR>";
          }
          {
            key = "<leader><leader>c";
            action = ":CornelisMakeCase<CR>";
          }
          {
            key = "<leader><leader>.";
            action = ":CornelisTypeContextInfer<CR>";
          }
          {
            key = "<leader>y.";
            action = ":CornelisTypeContextInfer Normalised<CR>";
          }

          {
            key = "<leader><leader>a";
            action = ":CornelisAuto<CR>";
          }
          {
            key = "<leader><leader><space>";
            action = ":CornelisGive<CR>";
          }
          {
            key = "<C-A>";
            action = ":CornelisInc<CR>";
          }
          {
            key = "<C-X>";
            action = ":CornelisDec<CR>";
          }
        ]
      )
      (
        lib.concatMapStringsSep "\n" ({
          key,
          action,
        }: ''
          nnoremap <buffer> ${key} ${action}
        '') [
          {
            key = "gd";
            action = ":CornelisGoToDefinition<CR>";
          }
        ]
      )
      (
        lib.concatMapStringsSep "\n" ({
          key,
          action,
        }: "  inoremap <buffer> ${key} ${action}") [
          {
            key = "->";
            action = "→";
          }
          {
            key = "=>";
            action = "⇒";
          }
          {
            key = "forall";
            action = "∀";
          }
          {
            key = "==";
            action = "≡";
          }
          {
            key = ";;";
            action = ";";
          }
          {
            key = ";;h";
            action = ";ₕ";
          }
          {
            key = ";;v";
            action = ";ᵥ";
          }
          {
            key = "'";
            action = "′";
          }
          {
            key = "''";
            action = "″";
          }
          {
            key = "[[";
            action = "⟦";
          }
          {
            key = "]]";
            action = "⟧";
          }
          {
            key = "=eqv";
            action = "≃";
          }

          {
            key = "Alpha";
            action = "Α";
          }
          {
            key = "alpha";
            action = "α";
          }
          {
            key = "Beta";
            action = "Β";
          }
          {
            key = "beta";
            action = "β";
          }
          {
            key = "Gamma";
            action = "Γ";
          }
          {
            key = "gamma";
            action = "γ";
          }
          {
            key = "Delta";
            action = "Δ";
          }
          {
            key = "delta";
            action = "δ";
          }
          {
            key = "Epsilon";
            action = "Ε";
          }
          {
            key = "epsil";
            action = "ε";
          }
          {
            key = "Zeta";
            action = "Ζ";
          }
          {
            key = "zeta";
            action = "ζ";
          }
          {
            key = "Eta";
            action = "Η";
          }
          {
            key = "eta";
            action = "η";
          }
          {
            key = "Theta";
            action = "Θ";
          }
          {
            key = "theta";
            action = "θ";
          }
          {
            key = "Iota";
            action = "Ι";
          }
          {
            key = "iota";
            action = "ι";
          }
          {
            key = "Kappa";
            action = "Κ";
          }
          {
            key = "kappa";
            action = "κ";
          }
          {
            key = "Lambda";
            action = "Λ";
          }
          {
            key = "lambda";
            action = "λ";
          }
          {
            key = "Mu";
            action = "Μ";
          }
          {
            key = "mu";
            action = "μ";
          }
          {
            key = "Nu";
            action = "Ν";
          }
          {
            key = "nu";
            action = "ν";
          }
          {
            key = "Xi";
            action = "Ξ";
          }
          {
            key = "xi";
            action = "ξ";
          }
          {
            key = "Omicron";
            action = "Ο";
          }
          {
            key = "omicron";
            action = "ο";
          }
          {
            key = "Pi";
            action = "Π";
          }
          {
            key = "pi";
            action = "π";
          }
          {
            key = "Rho";
            action = "Ρ";
          }
          {
            key = "rho";
            action = "ρ";
          }
          {
            key = "Sigma";
            action = "Σ";
          }
          {
            key = "sigma";
            action = "σ";
          }
          {
            key = "Tau";
            action = "Τ";
          }
          {
            key = "tau";
            action = "τ";
          }
          {
            key = "Upsilon";
            action = "Υ";
          }
          {
            key = "upsil";
            action = "υ";
          }
          {
            key = "Phi";
            action = "Φ";
          }
          {
            key = "phi";
            action = "φ";
          }
          {
            key = "Chi";
            action = "Χ";
          }
          {
            key = "chi";
            action = "χ";
          }
          {
            key = "Psi";
            action = "Ψ";
          }
          {
            key = "psi";
            action = "ψ";
          }
          {
            key = "Omega";
            action = "Ω";
          }
          {
            key = "omega";
            action = "ω";
          }
          {
            key = "_0";
            action = "₀";
          }
          {
            key = "_1";
            action = "₁";
          }
          {
            key = "_2";
            action = "₂";
          }
          {
            key = "_3";
            action = "₃";
          }
          {
            key = "_4";
            action = "₄";
          }
          {
            key = "_5";
            action = "₅";
          }
          {
            key = "_6";
            action = "₆";
          }
          {
            key = "_7";
            action = "₇";
          }
          {
            key = "_8";
            action = "₈";
          }
          {
            key = "_9";
            action = "₉";
          }
        ]
      )
      "endfunction"
    ];
  in ''
    vim.cmd[=[
      ${extraConfigVim}
    ]=]
  '';
}
