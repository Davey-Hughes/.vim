return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v2.x",
  dependencies = {
    -- LSP Support
    {
      "neovim/nvim-lspconfig",
      --
      -- vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float)
      -- vim.keymap.set("n", "<leader>l[", vim.diagnostic.goto_prev)
      -- vim.keymap.set("n", "<leader>l]", vim.diagnostic.goto_next)
      -- vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist)
    },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "simrat39/rust-tools.nvim" },
    { "lvimuser/lsp-inlayhints.nvim" },

    -- Autocompletion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "L3MON4D3/LuaSnip" },

    { "windwp/nvim-autopairs" },
  },
  config = function()
    local ih = require "lsp-inlayhints"
    ih.setup()

    local lsp = require("lsp-zero").preset {}

    lsp.on_attach(function(client, bufnr)
      lsp.default_keymaps { buffer = bufnr }
    end)

    lsp.skip_server_setup { "rust_analyzer" }
    lsp.setup()

    require("mason-lspconfig").setup {
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
        "pyright",
        "solargraph",
        "sqlls",
        "taplo",
        "tsserver",
        "vimls",
        "yamlls",
        "zls",
      },
    }

    local rust_tools = require "rust-tools"

    rust_tools.setup {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>ca", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
        end,
      },
    }

    rust_tools.inlay_hints.enable()

    require("lspconfig").lua_ls.setup {
      on_attach = function(client, bufnr)
        ih.on_attach(client, bufnr)
      end,
      settings = {
        Lua = {
          diagnostics = {
            globals = {"vim"}
          },
          hint = {
            enable = true,
          },
        },
      },
    }

    require("lspconfig").pyright.setup {}

    -- nvim-cmp setup
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    local cmp_action = require("lsp-zero").cmp_action()

    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
    end

    cmp.setup {
      mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<CR>"] = cmp.mapping.confirm { select = false },
      },
    }

    -- autopairs setup
    local npairs = require "nvim-autopairs"
    local Rule = require "nvim-autopairs.rule"

    npairs.setup {
      check_ts = true,
      ts_config = {},
    }

    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    local ts_utils = require "nvim-treesitter.ts_utils"

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

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done {})

    local cond = require "nvim-autopairs.conds"
    local ts_conds = require "nvim-autopairs.ts-conds"

    npairs.add_rules {
      Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node { "string", "comment" }),
      Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node { "function" }),
      Rule("<", ">"):with_pair(cond.before_regex "%a+:?"):with_move(function(opts)
        return opts.char == ">"
      end),
    }
  end,
}
