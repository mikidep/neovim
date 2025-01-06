{
  pkgs,
  inputs,
  lib,
  ...
}: {
  plugins = {
    auto-session.enable = true;
    auto-save.enable = true;
    fugitive.enable = true;
    markdown-preview = {
      enable = true;
      settings = {
        browserfunc = "OpenMarkdownPreview";
        page_title = "\${name}";
        theme = "light";
      };
    };
    # noice.enable = true;
    trouble.enable = true;
    # neoscroll = {
    #   enable = true;
    #   settings = {
    #     respect_scrolloff = true;
    #     step_eof = false;
    #   };
    # };
    neo-tree = {
      enable = true;
      openFilesInLastWindow = false;
      window.width = 30;
      eventHandlers.file_opened = ''
        function(file_path)
          --auto close
          require("neo-tree").close_all()
        end
      '';
    };
    oil.enable = true;
    which-key.enable = true;
    floaterm.enable = true;
    openscad.enable = true;
    web-devicons.enable = true;
    repeat.enable = true;
    yanky = {
      enable = true;
      enableTelescope = true;
      settings = {
        highlight.on_put = true;
        highlight.on_yank = true;
      };
    };
  };
  extraPlugins = with pkgs;
  with vimUtils;
    [
      (buildVimPlugin {
        name = "midnight.nvim";
        src = inputs.midnight-nvim;
      })
      {
        plugin = buildVimPlugin {
          name = "scrollEOF.nvim";
          src = inputs.scrolleof-nvim;
        };
        config = ''
          lua << EOF
            require 'scrollEOF'.setup({})
          EOF
        '';
      }
      (buildVimPlugin {
        name = "guihua.lua";
        src = inputs.guihua-lua;
        postInstall = ''
          cd $target/lua/fzy && make
        '';
      })

      {
        plugin = buildVimPlugin {
          name = "floating-help.nvim";
          src = inputs.floating-help-nvim;
        };
        config = ''
          lua << EOF
            require 'floating-help'.setup({})
          EOF
        '';
      }
    ]
    ++ (with vimPlugins; [
      vim-visual-multi
      neorepl-nvim
      unicode-vim
      vim-easy-align
      winshift-nvim
      vim-dasht
    ]);

  extraPackages = with pkgs; [fd delta sad fzf];
  extraConfigVim = ''
    function OpenMarkdownPreview (url)
      execute "silent ! ${lib.getExe pkgs.firefox} --new-window " . a:url
    endfunction
  '';

  keymaps = [
    {
      key = "ga";
      action = "<Plug>(EasyAlign)";
      mode = ["x"];
    }
  ];
}
