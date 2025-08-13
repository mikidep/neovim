{
  pkgs,
  inputs,
  ...
}: rec {
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

        tabline = {
          lualine_c = [
            {
              __unkeyed-1 = "buffers";
              max_length.__raw = ''vim.o.columns'';
              section_separators.left = "";
              component_separators.left = "";
            }
          ];
        };
      };
    };
    fugitive.enable = true;

    trouble.enable = true;
    oil.enable = true;
    # which-key.enable = true;
    toggleterm.enable = true;

    floaterm.enable = true;
    web-devicons.enable = true;
    repeat.enable = true;
    spectre.enable = true;
    yanky = {
      enable = true;
      enableTelescope = true;
      settings = {
        highlight.on_put = true;
        highlight.on_yank = true;
        preserve_cursor_position.enabled = true;
      };
    };
    yazi = {
      enable = true;
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
      # vim-visual-multi
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
      mode = "x";
    }
    {
      key = "<leader>cs";
      action = "<cmd>AerialOpen<cr>";
    }
    {
      key = "<leader>t";
      action = assert plugins.toggleterm.enable; "<cmd>ToggleTerm<cr>";
      mode = "n";
    }
  ];
}
