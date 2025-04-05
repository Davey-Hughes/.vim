return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "saghen/blink.cmp" },
    {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup({})
        require("mason-lspconfig").setup({
          automatic_installation = {},
          ensure_installed = {
            "asm_lsp",
            "basedpyright",
            "biome",
            "clangd",
            "gopls",
            "harper_ls",
            "html",
            "jqls",
            "lua_ls",
            "ltex",
            "marksman",
            "pest_ls",
            "ruff",
            "rust_analyzer",
            "sqlls",
            "taplo",
            "vimls",
            "yamlls",
            "zls",
          },

          handlers = {},
        })
      end,
    },

    { "williamboman/mason-lspconfig.nvim" },
    { "mrcjkb/rustaceanvim", ft = "rust" },
    { "pest-parser/pest.vim", ft = "pest" },
    { "smjonas/inc-rename.nvim", opts = {} },
    { "Bilal2453/luvit-meta", lazy = true },
    { "artemave/workspace-diagnostics.nvim", opts = {} },
    { "pmizio/typescript-tools.nvim", enabled = false, opts = {} },
    { "chrisgrieser/nvim-lsp-endhints", event = "LspAttach", opts = {} },

    {
      "folke/lazydev.nvim",
      opts = {
        library = {
          { path = "uvit-meta/library", words = { "vim%.uv" } },
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
          callback = function() require("go.format").goimport() end,
          group = format_sync_grp,
        })
      end,

      event = "CmdlineEnter",
      ft = { "go", "gomod" },
      build = ':lua require("go.install").update_all_sync()',
    },

    {
      "cordx56/rustowl",
      build = "cd rustowl && cargo install --path . --locked",
      lazy = false, -- This plugin is already lazy
      opts = {},
    },
  },

  opts = {
    servers = {
      basedpyright = {},
      biome = {},
      fish_lsp = {},
      flow = {},
      kotlin_language_server = {},
      pest_ls = {},
      ruff = {},
      solargraph = {},
      uiua = {},
      zls = {},

      clangd = {
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
      },

      eslint = {
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      },

      gopls = {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = false,
              compositeLiteralFields = false,
              compositeLiteralTypes = false,
              constantValues = false,
              functionTypeParameters = false,
              parameterNames = false,
              rangeVariableTypes = false,
            },
          },
        },
      },

      harper_ls = {
        filetypes = {
          "gitcommit",
          "markdown",
          "text",
        },
      },

      ltex = {
        enabled = false,
        filetypes = { "bib", "plaintex", "rst", "rnoweb", "tex", "pandoc", "quarto", "rmd" },
      },

      lua_ls = {
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
      },

      ts_ls = {
        filetypes = {
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
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
      },
    },
  },

  config = function(_, opts)
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
        if vim.api.nvim_win_get_config(winid).zindex then return end
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

    local lspconfig = require("lspconfig")

    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        vim.keymap.set(
          "n",
          "K",
          function() vim.lsp.buf.hover() end,
          { buffer = event.buf, remap = false, desc = "Hover" }
        )

        vim.keymap.set(
          "n",
          "gd",
          function() vim.lsp.buf.definition({ reuse_win = true }) end,
          { buffer = event.buf, remap = false, desc = "Goto definition" }
        )

        vim.keymap.set(
          "n",
          "gi",
          function() vim.lsp.buf.implementation() end,
          { buffer = event.buf, remap = false, desc = "Goto implementation" }
        )

        vim.keymap.set(
          "n",
          "go",
          function() vim.lsp.buf.type_definition() end,
          { buffer = event.buf, remap = false, desc = "Goto type definition" }
        )

        vim.keymap.set(
          "n",
          "gD",
          function() vim.lsp.buf.declaration() end,
          { buffer = event.buf, remap = false, desc = "Goto declaration" }
        )

        vim.keymap.set(
          "n",
          "<leader>ws",
          function() vim.lsp.buf.workspace_symbol() end,
          { buffer = event.buf, remap = false, desc = "Workspace symbol" }
        )

        vim.keymap.set(
          "n",
          "<leader>ca",
          function() vim.lsp.buf.code_action() end,
          { buffer = event.buf, remap = false, desc = "Code action" }
        )

        vim.keymap.set(
          "n",
          "<leader>rn",
          function() return ":IncRename " .. vim.fn.expand("<cword>") end,
          { buffer = event.buf, remap = false, expr = true, desc = "Increname" }
        )

        vim.keymap.set(
          "i",
          "<C-h>",
          function() vim.lsp.buf.signature_help() end,
          { buffer = event.buf, remap = false, desc = "Signature help" }
        )

        vim.keymap.set(
          "n",
          "<leader>cf",
          function() vim.lsp.buf.format() end,
          { buffer = event.buf, remap = false, desc = "Buffer format" }
        )

        vim.keymap.set(
          "n",
          "<leader>lr",
          function() vim.lsp.buf.references() end,
          { buffer = event.buf, remap = false, desc = "Buffer format" }
        )
      end,
    })

    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticWarn" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticInfo" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "DiagnosticHint" })
    vim.api.nvim_set_hl(0, "LspInlayHint", { link = "DiagnosticHint" })

    -- setup format for LSP servers that don't do it properly
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

    -- LSP setup
    for server, config in pairs(opts.servers) do
      -- TODO: remove when this is merged https://cmp.saghen.dev/installation#lsp-capabilities
      config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
      if config.enable_lsp_format then
        config.on_attach = function(client, bufnr) enable_lsp_format(client, bufnr) end
      end
      lspconfig[server].setup(config)
    end

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
            cargo = {
              allFeatures = true,
            },
            checkOnSave = {
              command = "clippy",
              -- stylua: ignore
              extraArgs = {
                "--",
                "-W", "clippy::pedantic",
                "--allow", "clippy::uninlined_format_args",
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
