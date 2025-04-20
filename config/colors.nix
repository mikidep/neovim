{pkgs, ...}: {
  colorscheme = "vscode";
  colorschemes.vscode = {
    enable = true;
    settings.group_overrides = {
      CornelisUnsolvedMeta = {
        bg = "#70700A";
      };
      CornelisUnsolvedConstraint = {
        bg = "#700A0A";
      };
    };
  };
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      color_overrides.mocha = let
        bg = "#000000";
      in {
        base = bg;
        mantle = bg;
        crust = bg;
        text = "#ffffff";
      };
      custom_highlights.__raw = ''
        function(colors)
          return {
            CornelisUnsolvedMeta = {
              bg = "#70700A"
            },
            CornelisUnsolvedConstraint = {
              bg = "#700A0A"
            }
          }
        end
      '';
    };
  };
}
