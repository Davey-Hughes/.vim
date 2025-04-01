return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      local rule = require("nvim-autopairs.rule")

      npairs.setup({
        check_ts = true,
        ts_config = {},
        fast_wrap = {},
      })

      local cond = require("nvim-autopairs.conds")

      npairs.add_rule(rule("<", ">", {
          "-html",
          "-javascriptreact",
          "-typescriptreact",
        })
        :with_pair(cond.before_regex("%a+:?:?$", 3))
        :with_move(function(opts) return opts.char == ">" end))
    end,
  },
  {
    "saghen/blink.cmp",
    enabled = true,
    dependencies = {
      { "rafamadriz/friendly-snippets" },
      { "Kaiser-Yang/blink-cmp-git", dependencies = { "nvim-lua/plenary.nvim" } },
      {
        "saghen/blink.compat",
        version = "*",
        lazy = true,
        opts = {},
      },
      { "echasnovski/mini.icons", version = false },
    },
    build = "cargo build --release",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "default",

        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "select_and_accept", "fallback" },
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        documentation = { auto_show = true },
        accept = { auto_brackets = { enabled = true } },
        menu = {
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
      },
      sources = {
        default = { "supermaven", "git", "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          path = { score_offset = 100 },
          lsp = { score_offset = 90 },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          git = {
            module = "blink-cmp-git",
            name = "Git",
            opts = {},
          },
          supermaven = {
            name = "supermaven",
            module = "blink.compat.source",
            score_offset = 90,
            async = true,
            transform_items = function(ctx, items)
              for _, item in ipairs(items) do
                item.kind_icon = ""
                item.kind_name = "Supermaven"
              end
              return items
            end,
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      { "zbirenbaum/copilot-cmp", opts = {} },
    },
    opts = {
      suggestion = { enabled = true, auto_trigger = false },
      panel = { enabled = false },
    },
  },

  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        ignore_filetypes = {},
        log_level = "off",
        disable_inline_completion = true,
        disable_keymaps = true,
      })
    end,
  },
}
