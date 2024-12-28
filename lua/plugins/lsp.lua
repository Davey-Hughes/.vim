return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v4.x",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- LSP Support
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    -- { "hrsh7th/cmp-nvim-lsp" },
    { "saghen/blink.cmp" },
    { "mrcjkb/rustaceanvim", ft = "rust" },
    { "pest-parser/pest.vim", ft = "pest" },
    { "smjonas/inc-rename.nvim", opts = {} },
    { "Bilal2453/luvit-meta", lazy = true },
    {
      "kosayoda/nvim-lightbulb",
      cond = not vim.g.vscode,
      opts = { autocmd = { enabled = true } },
    },
    {
      "chrisgrieser/nvim-lsp-endhints",
      event = "LspAttach",
      opts = {}, -- required, even if empty
    },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "luvit-meta/library", words = { "vim%.uv" } },
          { plugins = { "nvim-dap-ui" }, types = true },
        },
      },
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
  },

  config = function()
    local lsp_zero = require("lsp-zero")

    lsp_zero.extend_lspconfig({
      suggest_lsp_servers = false,
      sign_icons = {
        error = "E",
        warn = "W",
        hint = "H",
        info = "I",
      },
    })

    local function on_list(options)
      vim.api.nvim_command("Tabdrop")
    end

    vim.opt.updatetime = 300

    -- show which LSP server triggered the message
    vim.diagnostic.config({
      virtual_text = {
        source = true,
      },
      float = {
        source = true,
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
      vim.diagnostic.open_float({
        source = true,
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

    lsp_zero.on_attach(function(client, bufnr)
      lsp_zero.default_keymaps({ buffer = bufnr })

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
        return ":IncRename " .. vim.fn.expand("<cword>")
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

    lsp_zero.setup()

    require("mason").setup({})
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
        "ruff",
        "rust_analyzer",
        "sqlls",
        "taplo",
        "vimls",
        "yamlls",
        "zls",
      },

      handlers = {
        rust_analyzer = lsp_zero.noop,
      },
    })

    vim.cmd([[
      highlight! link DiagnosticVirtualTextError DiagnosticError
      highlight! link DiagnosticVirtualTextWarn DiagnosticWarn
      highlight! link DiagnosticVirtualTextInfo DiagnosticInfo
      highlight! link DiagnosticVirtualTextHint DiagnosticHint
      highlight! link LspInlayHint DiagnosticHint
    ]])

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

    require("lspconfig").ruff.setup({
      on_attach = function(client, bufnr)
        enable_lsp_format(client, bufnr)
      end,
    })

    require("lspconfig").biome.setup({
      on_attach = function(client, bufnr)
        enable_lsp_format(client, bufnr)
      end,
    })

    require("lspconfig").ts_ls.setup({
      on_attach = function(client, bufnr) end,
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

    require("lspconfig").ltex.setup({
      enabled = false,
      filetypes = { "bib", "plaintex", "rst", "rnoweb", "tex", "pandoc", "quarto", "rmd" },
    })

    require("lspconfig").lua_ls.setup({
      on_attach = function(client, bufnr) end,
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

    -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- capabilities.offsetEncoding = "utf-8"

    local capabilities = require("blink.cmp").get_lsp_capabilities()
    require("lspconfig").clangd.setup({
      on_attach = function(client, bufnr) end,
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

    require("lspconfig").eslint.setup({
      enabled = false,
      filetypes = {
        "javascript",
      },
    })

    local cfg = require("go.lsp").config()
    if cfg then
      cfg.settings.gopls.hints = {
        assignVariableTypes = false,
        compositeLiteralFields = false,
        compositeLiteralTypes = false,
        constantValues = false,
        functionTypeParameters = false,
        parameterNames = false,
        rangeVariableTypes = false,
      }
    end

    require("lspconfig").gopls.setup(cfg)

    require("lspconfig").uiua.setup({
      on_attach = function(client, bufnr)
        enable_lsp_format(client, bufnr)
      end,
    })

    require("lspconfig").zls.setup({})

    require("pest-vim").setup({
      on_attach = function(client, bufnr)
        enable_lsp_format(client, bufnr)
      end,
    })

    vim.g.rustaceanvim = {
      tools = {},
      server = {
        on_attach = function(client, bufnr)
          if client.server_capabilities.inlayHintProvider then
            vim.keymap.set("n", "<space>ih", function()
              local current_setting = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
              vim.lsp.inlay_hint.enable(not current_setting)
            end)
          end
        end,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
              -- stylua: ignore
              extraArgs = {
                "--",
                "-W", "clippy::pedantic",
                -- "-W", "clippy::nursery",
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
