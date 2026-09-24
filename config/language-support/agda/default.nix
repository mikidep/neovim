{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./maps.nix
  ];
  # Cornelis version in Nixpkgs is two years old
  # This fixes an error of the kind:
  # Unexpected "cannot read: IOCTM [...]", expecting JSON value
  nixpkgs.overlays = [inputs.cornelis.overlays.cornelis];
  plugins.cornelis = {
    enable = true;
    settings = {
      use_global_binary = 1;
      max_size = 10;
      max_width = 50;
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

  extraFiles."ftplugin/agda/comp.lua".source = ./lua/comp.lua;
  # This is so stupid
  extraFiles."after/ftplugin/agda.lua".text = ''
    local cornsynt = vim.api.nvim_get_runtime_file("syntax/agda.vim", false)[1]
    vim.cmd('source ' .. cornsynt)
    pcall(vim.treesitter.start)
  '';
  extraFiles."queries/agda/agda-comp.scm".source = ./queries/agda-comp.scm;

  extraConfigVim = ''
    function SubReassoc()
      s/refl/refl′/eg
      s/∙/∙′/eg
      s/◃/◃′/eg
      s/▹/▹′/eg
    endfunction
  '';

  plugins.mini-pick = {enable = true;};
  plugins.nvim-autopairs = {
    exclude_filetypes = {"'" = ["agda"];};
    luaConfig.post = ''
      local Rule = require('nvim-autopairs.rule')
      local npairs = require('nvim-autopairs')

      npairs.add_rule(Rule("⟨", "⟩", "agda"))
    '';
  };
  extraFiles."lua/agda-utils/null-ls.lua".source = ./lua/null-ls.lua;
  plugins.none-ls = {
    luaConfig.post = ''
      local cmp_source = require "agda-utils.null-ls".cmp_source;
      require"null-ls".register { cmp_source }
    '';
  };
}
