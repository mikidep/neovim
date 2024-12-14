{pkgs, ...}: {
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
    enable = false;
    settings = {
      color_overrides.mocha = let
        bg = "#111111";
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
