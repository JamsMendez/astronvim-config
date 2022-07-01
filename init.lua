-- ~/.config/nvim/lua/user/init.lua
local config = {

  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "main", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    -- remotes = { -- easily add new remotes to track
    --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
    --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
    --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    -- },
  },

  -- Set colorscheme
  colorscheme = "onedark",

  -- set vim options here (vim.<first_key>.<second_key> =  value)
  options = {
    opt = {
      relativenumber = true, -- sets vim.opt.relativenumber
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader

      -- neovide
      neovide_transparency = 0.90,
      neovide_cursor_vfx_mode = "railgun",
      neovide_remember_window_size = true,
    },
    o = {
      -- Linux Desktop
      -- guifont = "VictorMono Nerd Font:h10"
      -- neovide.exe --wsl
      guifont = "VictorMono NF:h10.5",
    },
  },

  -- Default theme configuration
  default_theme = {
    diagnostics_style = { italic = true },
    -- Modify the color table
    colors = {
      fg = "#abb2bf",
    },
    -- Modify the highlight groups
    highlights = function(highlights)
      local C = require "default_theme.colors"

      highlights.Normal = { fg = C.fg, bg = C.bg }
      return highlights
    end,
    plugins = { -- enable or disable extra plugin highlighting
      aerial = true,
      beacon = false,
      bufferline = true,
      dashboard = true,
      highlighturl = true,
      hop = false,
      indent_blankline = true,
      lightspeed = false,
      ["neo-tree"] = true,
      notify = true,
      ["nvim-tree"] = false,
      ["nvim-web-devicons"] = true,
      rainbow = false,
      symbols_outline = false,
      telescope = true,
      vimwiki = false,
      ["which-key"] = true,
    },
  },

  -- Disable AstroNvim ui features
  ui = {
    nui_input = true,
    telescope_select = true,
  },

  -- Configure plugins
  plugins = {
    -- Add plugins, the packer syntax without the "use"
    init = {
      ["p00f/nvim-ts-rainbow"] = { disable = true },
      ["declancm/cinnamon.nvim"] = { disable = true },
      {
        "navarasu/onedark.nvim",
        config = function()
          require("onedark").setup {
            style = "deep",
            transparent = true,
            colors = {
              purple = "#bf68d9",
              red = "#e06c75",
            },
            highlights = {
              TSOperator = { fg = "$purple" },
              TSField = { fg = "$red" },
              TSParameter = { fg = "$red" },
              TSConstMacro = { fg = "$red" },
            },
          }
          require("onedark").load()
        end,
      },
      { "simrat39/rust-tools.nvim" },
      -- { "andweeb/presence.nvim" },
      -- {
      --   "ray-x/lsp_signature.nvim",
      --   event = "BufRead",
      --   config = function()
      --     require("lsp_signature").setup()
      --   end,
      -- },
    },
    -- null-ls configuration
    ["null-ls"] = function(config)
      -- Formatting and linting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim
      local status_ok, null_ls = pcall(require, "null-ls")
      if not status_ok then
        return
      end

      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics

      config.sources = {
        -- Set a formatter
        formatting.prettier.with {
          extra_args = { "--no-semi", "--single-quote", "--trailing-comma none", "--jsx-single-quote" },
        },
        formatting.stylua,
        -- Set a linter
        diagnostics.eslint,
      }

      -- set up null-ls's on_attach function
      config.on_attach = function(client)
        -- NOTE: You can remove this on attach function to disable format on save
        --[[ if client.resolved_capabilities.document_formatting then
          vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Auto format before save",
            pattern = "<buffer>",
            callback = vim.lsp.buf.formatting_sync,
          })
        end ]]
      end
      return config -- return final config table
    end,
    -- All other entries override the setup() call for default plugins
    treesitter = {
      ensure_installed = { "lua", "go", "rust", "javascript" },
    },
    ["nvim-lsp-installer"] = {
      ensure_installed = { "sumneko_lua", "tsserver", "gopls", "rust_analyzer" },
    },
    packer = {
      compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
    },
    -- ["neo-tree"] = {
    --   window = {
    --     position = "right",
    --   },
    -- },
  },

  -- LuaSnip Options
  luasnip = {
    -- Add paths for including more VS Code style snippets in luasnip
    vscode_snippet_paths = {},
    -- Extend filetypes
    filetype_extend = {
      javascript = { "javascriptreact" },
    },
  },

  -- Modify which-key registration
  ["which-key"] = {
    -- Add bindings
    register_mappings = {
      -- first key is the mode, n == normal mode
      n = {
        -- second key is the prefix, <leader> prefixes
        ["<leader>"] = {
          ["fc"] = { "<cmd>e ~/.config/nvim/init.lua<cr>", "Open Configuration" },
          -- which-key registration table for normal mode, leader prefix
          -- ["N"] = { "<cmd>tabnew<cr>", "New Buffer" },
          -- ["e"] = { "<cmd>Neotree filesystem reveal right<cr>", "Toggle Explorer" },
        },
      },
    },
  },

  -- CMP Source Priorities
  -- modify here the priorities of default cmp sources
  -- higher value == higher priority
  -- The value can also be set to a boolean for disabling default sources:
  -- false == disabled
  -- true == 1000
  cmp = {
    source_priority = {
      nvim_lsp = 1000,
      luasnip = 750,
      buffer = 500,
      path = 250,
    },
  },

  -- Extend LSP configuration
  lsp = {
    -- enable servers that you already have installed without lsp-installer
    servers = {
      -- "pyright"
    },
    -- easily add or disable built in mappings added during LSP attaching
    mappings = {
      n = {
        -- ["<leader>lf"] = false -- disable formatting keymap
      },
    },
    -- add to the server on_attach function
    -- on_attach = function(client, bufnr)
    -- end,

    -- override the lsp installer server-registration function
    server_registration = function(server, opts)
      if server == "rust_analyzer" then
        require("rust-tools").setup {
          tools = {
            on_initialized = function()
              vim.cmd [[
            autocmd BufEnter,CursorHold,InsertLeave,BufWritePost *.rs silent! lua vim.lsp.codelens.refresh()
          ]]
            end,
          },
          server = {
            settings = {
              ["rust-analyzer"] = {
                lens = {
                  enable = true,
                },
                checkOnSave = {
                  command = "clippy",
                },
              },
            },
          },
        }
        goto continue
      end
      require("lspconfig")[server].setup(opts)
      ::continue::
    end,

    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = {
      -- example for addings schemas to yamlls
      -- yamlls = {
      --   settings = {
      --     yaml = {
      --       schemas = {
      --         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
      --         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      --         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      --       },
      --     },
      --   },
      -- },
    },
  },

  -- Diagnostics configuration (for vim.diagnostics.config({}))
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  -- This function is run last
  -- good place to configure mappings and vim options
  polish = function()
    local map = vim.keymap.set
    local set = vim.opt
    -- Set options
    set.relativenumber = true

    -- Set key bindings
    map("n", "<C-s>", ":w!<CR>")

    -- Set autocommands
    vim.api.nvim_create_augroup("packer_conf", {})
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "plugins.lua",
      command = "source <afile> | PackerSync",
    })

    vim.cmd [[
      let g:clipboard = {
        \   'name': 'win32yank-wsl',
        \   'copy': {
        \      '+': 'win32yank.exe -i --crlf',
        \      '*': 'win32yank.exe -i --crlf',
        \    },
        \   'paste': {
        \      '+': 'win32yank.exe -o --lf',
        \      '*': 'win32yank.exe -o --lf',
        \   },
        \   'cache_enabled': 0,
        \ }
    ]]

    -- vim.cmd [[
    --   let g:clipboard = {
    --     \   'name': 'xclip-os',
    --     \   'copy': {
    --     \      '+': 'xclip -selection clipboard',
    --     \      '*': 'xclip -selection clipboard',
    --     \    },
    --     \   'paste': {
    --     \      '+': 'xclip -selection clipboard -o',
    --     \      '*': 'xclip -selection clipboard -o',
    --     \   },
    --     \   'cache_enabled': 1,
    --     \ }
    --   ]]

    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}

return config
