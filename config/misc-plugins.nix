{
  pkgs,
  inputs,
  ...
}: {
  plugins = {
    aerial.enable = true;
    auto-session.enable = true;
    auto-save = {
      enable = true;
      settings.condition.__raw = ''
        function(buf)
          local filetype = vim.fn.getbufvar(buf, "&filetype")
          return not vim.list_contains({ "oil" }, filetype)
        end
      '';
    };
    lualine = {
      enable = true;
      settings = {
        options.globalstatus = true;
        sections.lualine_x = ["encoding" "fileformat" "filetype" {__raw = "function () return tostring(vim.fn.wordcount().words)..' words' end";}];
      };
    };
    fugitive.enable = true;

    trouble.enable = true;
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
          lua require 'scrollEOF'.setup({})
        '';
      }
      (buildVimPlugin {
        name = "guihua.lua";
        src = inputs.guihua-lua;
        postInstall = ''
          cd $target/lua/fzy && make
        '';
      })
    ]
    ++ (with vimPlugins; [
      vim-visual-multi
      nvim-luapad
      unicode-vim
      vim-easy-align
      winshift-nvim
    ]);
  files."ftplugin/markdown.lua".plugins.markdown-preview = {
    enable = true;
    settings = {
      browserfunc = "OpenMarkdownPreview";
      page_title = "\${name}";
      theme = "light";
    };
  };
  extraPackages = with pkgs; [fd delta sad fzf];
  extraConfigVim = ''
    function OpenMarkdownPreview (url)
      execute "silent ! firefox --new-window " . a:url
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
