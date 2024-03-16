return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v2.x",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- LSP Support
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    {
      "mrcjkb/rustaceanvim",
      ft = "rust",
      version = "^3",
    },
    {
      "lvimuser/lsp-inlayhints.nvim",
      config = function()
        vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
        vim.api.nvim_create_autocmd("LspAttach", {
          group = "LspAttach_inlayhints",
          callback = function(args)
            if not (args.data and args.data.client_id) then
              return
            end

            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            require("lsp-inlayhints").on_attach(client, bufnr)
          end,
        })
      end,
    },
    {
      "kosayoda/nvim-lightbulb",
      cond = not vim.g.vscode,

      config = function()
        require("nvim-lightbulb").setup({
          autocmd = { enabled = true },
        })
      end,
    },

    -- Autocompletion
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
      },
    },
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
    },
    { "onsails/lspkind.nvim" },
    { "windwp/nvim-autopairs" },
    {
      "smjonas/inc-rename.nvim",
      config = function()
        require("inc_rename").setup()
      end,
    },
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

      event = "CmdlineEnter",
      ft = { "go", "gomod" },
      build = ':lua require("go.install").update_all_sync()',
    },
    {
      "pest-parser/pest.vim",
      ft = "pest",
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

    -- show which LSP server triggered the message
    vim.diagnostic.config({
      virtual_text = {
        source = "always",
      },
      float = {
        source = "always",
      },
    })

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
        source = "always",
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

      vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition({ reuse_win = true })
      end, { buffer = bufnr, remap = false, desc = "Goto definition" })

      vim.keymap.set("n", "<leader>ws", function()
        vim.lsp.buf.workspace_symbol()
      end, { buffer = bufnr, remap = false, desc = "Workspace symbol" })

      vim.keymap.set("n", "<leader>ca", function()
        vim.lsp.buf.code_action()
      end, { buffer = bufnr, remap = false, desc = "Code action" })

      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>") .. "<C-f>"
      end, { buffer = bufnr, remap = false, expr = true, desc = "Increname" })

      vim.keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help()
      end, { buffer = bufnr, remap = false, desc = "Signature help" })

      vim.keymap.set("n", "<leader>cf", function()
        vim.lsp.buf.format()
      end, { buffer = bufnr, remap = false, desc = "Buffer format" })

      vim.keymap.set("n", "<leader>lr", function()
        vim.lsp.buf.references()
      end, { buffer = bufnr, remap = false, desc = "Buffer format" })

      if client.server_capabilities.codeLensProvider then
        vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
          group = "LSPConfig",
          buffer = bufnr,
          callback = vim.lsp.codelens.refresh,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
          group = "LSPConfig",
          buffer = bufnr,
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
        "biome",
        "clangd",
        "eslint",
        "gopls",
        "graphql",
        "html",
        "jqls",
        "jsonls",
        "lemminx",
        "lua_ls",
        "ltex",
        "marksman",
        "pest_ls",
        "pyright",
        "ruff_lsp",
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
    local compare = require("cmp.config.compare")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.offsetEncoding = "utf-8"

    local has_words_before = function()
      unpack = unpack or table.unpack
      if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
      end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
    end

    cmp.setup({
      sorting = {
        priority_weight = 2,
        comparators = {
          compare.exact,
        },
      },
      completion = {
        completopt = "menu,menuone,noinsert,noselect",
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      preselect = cmp.PreselectMode.None,
      sources = {
        { name = "path", group_index = 1 },
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
      Rule("<", ">", { "rust" }):with_pair(cond.before_regex("[%a<:]+")):with_move(function(opts)
        return opts.char == ">"
      end),
    })

    -- setup format for LSP servers
    local enable_lsp_format = function(client, bufnr)
      local lsp_format = vim.api.nvim_create_augroup("LspFormat" .. client.name .. "," .. bufnr, {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          local v = vim.fn.winsaveview()
          vim.lsp.buf.format()
          vim.fn.winrestview(v)
        end,
        group = lsp_format,
      })
    end

    -- LSP specific setup
    require("lspconfig").kotlin_language_server.setup({})
    require("lspconfig").flow.setup({})
    require("lspconfig").solargraph.setup({})
    require("lspconfig").pyright.setup({})

    require("lspconfig").ruff_lsp.setup({
      on_attach = function(client, bufnr)
        enable_lsp_format(client, bufnr)
      end,
    })

    require("lspconfig").biome.setup({
      on_attach = function(client, bufnr)
        enable_lsp_format(client, bufnr)
      end,
    })

    require("lspconfig").ltex.setup({
      enabled = false,
      filetypes = { "bib", "plaintex", "rst", "rnoweb", "tex", "pandoc", "quarto", "rmd" },
    })

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
      capabilities = capabilities,
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

    local cfg = require("go.lsp").config()
    cfg.settings.gopls.hints = {
      assignVariableTypes = false,
      compositeLiteralFields = false,
      compositeLiteralTypes = false,
      constantValues = false,
      functionTypeParameters = false,
      parameterNames = false,
      rangeVariableTypes = false,
    }
    require("lspconfig").gopls.setup(cfg)

    require("lspconfig").uiua.setup({
      on_attach = function(client, bufnr)
        enable_lsp_format(client, bufnr)
      end,
    })

    require("pest-vim").setup({
      on_attach = function(client, bufnr)
        enable_lsp_format(client, bufnr)
      end,
    })

    vim.g.rustaceanvim = {
      tools = {},
      server = {
        on_attach = function(client, bufnr) end,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
              -- stylua: ignore
              extraArgs = {
                "--",
                "-W", "clippy::pedantic",
                "-W", "clippy::nursery",
                -- "-W", "clippy::unwrap_used",
                -- "-W", "clippy::expect_used",
              },
            },
          },
        },
      },
    }
  end,
}
