return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "windwp/nvim-autopairs",
      "onsails/lspkind.nvim",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
      },
    },
    config = function()
      local cmp = require("cmp")
      local compare = require("cmp.config.compare")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      local has_words_before = function()
        unpack = unpack or table.unpack
        if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
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
          { name = "path", group_index = 0 },
          { name = "nvim_lsp", group_index = 1 },
          { name = "copilot", group_index = 1 },
        },
        formatting = {
          expandable_indicator = true,
          fields = { "abbr", "kind" },
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

          ["<C-Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() then
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

      npairs.add_rule(Rule("<", ">", {
        "-html",
        "-javascriptreact",
        "-typescriptreact",
      }):with_pair(cond.before_regex("%a+:?:?$", 3)):with_move(function(opts)
        return opts.char == ">"
      end))
    end,

    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    dependencies = {
      { "zbirenbaum/copilot-cmp", opts = {} },
    },
    opts = {
      suggestion = { enabled = true, auto_trigger = false },
      panel = { enabled = false },
    },
  },
}
