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
        }: "  nnoremap <buffer> ${key} ${action}") [
          {
            key = "<leader>cl";
            action = ":CornelisLoad<CR>";
          }
          {
            key = "<leader>ch";
            action = ":CornelisQuestionToMeta<CR>";
          }
          {
            key = "<leader>cr";
            action = ":CornelisRefine<CR>";
          }
          {
            key = "<leader>cF";
            action = ":CornelisPrevGoal<CR>";
          }
          {
            key = "<leader>cf";
            action = ":CornelisNextGoal<CR>";
          }
          {
            key = "<leader>c,";
            action = ":CornelisTypeContext<CR>";
          }
          {
            key = "<leader>cc";
            action = ":CornelisMakeCase<CR>";
          }
          {
            key = "<leader>c.";
            action = ":CornelisTypeContextInfer<CR>";
          }
          {
            key = "<leader>y.";
            action = ":CornelisTypeContextInfer Normalised<CR>";
          }
          {
            key = "<leader>cn";
            action = ":CornelisSolve<CR>";
          }
          {
            key = "<leader>ca";
            action = ":CornelisAuto<CR>";
          }
          {
            key = "<leader>c<space>";
            action = ":CornelisGive<CR>";
          }
          {
            key = "gd";
            action = ":CornelisGoToDefinition<CR>";
          }
          {
            key = "[/";
            action = ":CornelisPrevGoal<CR>";
          }
          {
            key = "]/";
            action = ":CornelisNextGoal<CR>";
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
            key = "alpha";
            action = "α";
          }
          {
            key = "beta";
            action = "β";
          }
          {
            key = "lambda";
            action = "λ";
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
