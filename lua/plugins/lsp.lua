return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v2.x",
  dependencies = {
    -- LSP Support
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "simrat39/rust-tools.nvim" },
    { "lvimuser/lsp-inlayhints.nvim" },

    -- Autocompletion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    {
      "L3MON4D3/LuaSnip",
      version = "2.*",
      build = "make install_jsregexp",
    },
    { "onsails/lspkind.nvim" },

    { "windwp/nvim-autopairs" },
    {
      "ray-x/go.nvim",
      dependencies = {
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
      },

      config = function()
        require("go").setup({
          lsp_cfg = false,
          lsp_keymaps = false,
        })

        local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = "*.go",
          callback = function()
            require("go.format").goimport()
          end,
          group = format_sync_grp,
        })
      end,

      event = { "CmdlineEnter" },
      ft = { "go", "gomod" },
      build = ':lua require("go.install").update_all_sync()',
    },
  },

  config = function()
    local ih = require("lsp-inlayhints")
    ih.setup()

    local lsp = require("lsp-zero").preset({})

    local function on_list(options)
      vim.api.nvim_command("Tabdrop")
    end

    vim.opt.updatetime = 300

    -- Function to check if a floating dialog exists and if not
    -- then check for diagnostics under the cursor
    function OpenDiagnosticIfNoFloat()
      for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(winid).zindex then
          return
        end
      end

      -- THIS IS FOR BUILTIN LSP
      vim.diagnostic.open_float(0, {
        scope = "cursor",
        focusable = false,
        close_events = {
          "CursorMoved",
          "CursorMovedI",
          "BufHidden",
          "InsertCharPre",
          "WinLeave",
        },
      })
    end
    -- Show diagnostics under the cursor when holding position
    vim.api.nvim_create_augroup("LSPConfig", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
      group = "LSPConfig",
      pattern = "*",
      callback = OpenDiagnosticIfNoFloat,
      desc = "Show diagnostic information when holding cursor if no other floating window",
    })

    lsp.on_attach(function(client, bufnr)
      lsp.default_keymaps({ buffer = bufnr })
      local opts = { buffer = bufnr, remap = false }

      vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition({ reuse_win = true })
      end, opts)

      vim.keymap.set("n", "<leader>ws", function()
        vim.lsp.buf.workspace_symbol()
      end, opts)
      vim.keymap.set("n", "<leader>ca", function()
        vim.lsp.buf.code_action()
      end, opts)
      vim.keymap.set("n", "<leader>rn", function()
        vim.lsp.buf.rename()
      end, opts)
      vim.keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help()
      end, opts)

      if client.server_capabilities.codeLensProvider then
        vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
          group = "LSPConfig",
          pattern = "*",
          callback = vim.lsp.codelens.refresh,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
          group = "LSPConfig",
          callback = function(opt)
            vim.lsp.codelens.clear(opt.data.client_id, opt.buf)
          end,
        })
      end
    end)

    lsp.set_preferences({
      suggest_lsp_servers = false,
      sign_icons = {
        error = "E",
        warn = "W",
        hint = "H",
        info = "I",
      },
    })

    lsp.skip_server_setup({ "rust_analyzer" })

    lsp.setup()

    require("mason-lspconfig").setup({
      ensure_installed = {
        "asm_lsp",
        "bashls",
        "clangd",
        "eslint",
        "gopls",
        "graphql",
        "html",
        "jqls",
        "jsonls",
        "lemminx",
        "lua_ls",
        "marksman",
        "pylyzer",
        "solargraph",
        "sqlls",
        "taplo",
        "tsserver",
        "vimls",
        "yamlls",
        "zls",
      },
    })

    vim.cmd([[
      highlight! link DiagnosticVirtualTextError DiagnosticError
      highlight! link DiagnosticVirtualTextWarn DiagnosticWarn
      highlight! link DiagnosticVirtualTextInfo DiagnosticInfo
      highlight! link DiagnosticVirtualTextHint DiagnosticHint
      highlight! link LspInlayHint DiagnosticHint
    ]])

    -- nvim-cmp setup
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    local has_words_before = function()
      unpack = unpack or table.unpack
      if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
      end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
    end

    cmp.setup({
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      preselect = cmp.PreselectMode.None,
      sources = {
        { name = "nvim_lsp", group_index = 2 },
        { name = "copilot", group_index = 2 },
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol",
          maxwidth = 50,
          ellipsis_char = "...",
          symbol_map = { Copilot = "" },
        }),
      },
      mapping = {
        ["<Tab>"] = vim.schedule_wrap(function(fallback)
          if cmp.visible() and has_words_before() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      },
    })

    -- autopairs setup
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")

    npairs.setup({
      check_ts = true,
      ts_config = {},
      fast_wrap = {},
    })

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local ts_utils = require("nvim-treesitter.ts_utils")

    local ts_node_func_parens_disabled = {
      -- ecma
      named_imports = true,
      -- rust
      use_declaration = true,
    }

    local default_handler = cmp_autopairs.filetypes["*"]["("].handler
    cmp_autopairs.filetypes["*"]["("].handler = function(char, item, bufnr, rules, commit_character)
      local node_type = ts_utils.get_node_at_cursor():type()
      if ts_node_func_parens_disabled[node_type] then
        if item.data then
          item.data.funcParensDisabled = true
        else
          char = ""
        end
      end
      default_handler(char, item, bufnr, rules, commit_character)
    end

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({}))

    local cond = require("nvim-autopairs.conds")

    npairs.add_rules({
      Rule("<", ">"):with_pair(cond.before_regex("%a+")):with_move(function(opts)
        return opts.char == ">"
      end),
    })

    -- LSP specific setup
    require("lspconfig").lua_ls.setup({
      on_attach = function(client, bufnr)
        ih.on_attach(client, bufnr)
      end,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          hint = {
            enable = true,
          },
        },
      },
    })

    require("lspconfig").clangd.setup({
      on_attach = function(client, bufnr)
        ih.on_attach(client, bufnr)
      end,
      settings = {
        c = {
          hint = {
            enable = true,
          },
        },
        cpp = {
          hint = {
            enable = true,
          },
        },
      },
    })

    require("lspconfig").tsserver.setup({
      enabled = false,
      on_attach = function(client, bufnr)
        ih.on_attach(client, bufnr)
      end,
      filetypes = {
        "javascript",
        "typescript",
      },
      settings = {
        typescript = {
          hint = {
            enable = true,
          },
        },
        javascript = {
          hint = {
            enable = true,
          },
        },
      },
    })

    require("lspconfig").eslint.setup({
      enabled = false,
      filetypes = {
        "javascript",
      },
    })

    -- require("lspconfig").pyright.setup({
    --   on_attach = function(client, bufnr)
    --     ih.on_attach(client, bufnr)
    --   end,
    --   settings = {
    --     python = {
    --       hint = {
    --         enable = true,
    --       },
    --     },
    --   },
    -- })

    require("lspconfig").pylyzer.setup({
      on_attach = function(client, bufnr)
        ih.on_attach(client, bufnr)
      end,
      settings = {
        python = {
          hint = {
            enable = true,
          },
        },
      },
    })

    local cfg = require("go.lsp").config()
    require("lspconfig").gopls.setup(cfg)

    require("lspconfig").kotlin_language_server.setup({})
    require("lspconfig").flow.setup({})
    require("lspconfig").solargraph.setup({})

    local rust_tools = require("rust-tools")
    rust_tools.setup({
      server = {
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "<leader>ca", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
          ih.on_attach(client, bufnr)
        end,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
      tools = {
        inlay_hints = {
          auto = false,
        },
      },
    })
  end,
}
