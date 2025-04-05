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

      npairs.add_rules({
        rule("<", ">", {
            "-html",
            "-javascriptreact",
            "-typescriptreact",
          })
          :with_pair(cond.before_regex("%a+:?:?<*", 20))
          :with_move(function(opts) return opts.char == ">" end),

        rule("|", "|", { "rust" }):with_move(cond.after_regex("|")),
      })
    end,
  },
  {
    "saghen/blink.cmp",
    enabled = true,
    dependencies = {
      { "rafamadriz/friendly-snippets" },
      { "Kaiser-Yang/blink-cmp-git", dependencies = { "nvim-lua/plenary.nvim" } },
      { "moyiz/blink-emoji.nvim" },
      {
        "saghen/blink.compat",
        version = "*",
        lazy = true,
        opts = {},
      },
      {
        "echasnovski/mini.icons",
        version = false,
        opts = {
          lsp = {
            supermaven = { glyph = "" },
            ollama = { glyph = "󰳆" },
          },
        },
      },
      { "xzbdmw/colorful-menu.nvim", opts = {} },
    },

    build = "cargo build --release",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "enter",

        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      cmdline = {
        completion = {
          menu = {
            auto_show = false,
          },
        },
      },

      completion = {
        list = { selection = { preselect = false, auto_insert = false } },
        documentation = { auto_show = true, window = { border = "rounded" } },
        accept = { auto_brackets = { enabled = true } },
        ghost_text = { enabled = false },
        menu = {
          border = "rounded",
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
            components = {
              label = {
                text = function(ctx) return require("colorful-menu").blink_components_text(ctx) end,
                highlight = function(ctx) return require("colorful-menu").blink_components_highlight(ctx) end,
              },
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
        default = { "lsp", "path", "snippets", "buffer", "supermaven", "git", "lazydev", "emoji" },
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
            opts = {
              commit = {
                triggers = { ":" },
              },
            },
          },
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 100,
            opts = { insert = true },
          },
          supermaven = {
            name = "supermaven",
            module = "blink.compat.source",
            score_offset = 110,
            async = true,
            transform_items = function(ctx, items)
              for _, item in ipairs(items) do
                item.kind_name = "supermaven"
              end
              return items
            end,
            override = {
              get_trigger_characters = function(self)
                local trigger_characters = self:get_trigger_characters()
                vim.list_extend(trigger_characters, { "(", ")", '"', "'", "{", "}", "<", ">", "!", "?", ",", ".", "/" })
                return trigger_characters
              end,
            },
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

  {
    "milanglacier/minuet-ai.nvim",
    enabled = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("minuet").setup({
        provider = "openai_fim_compatible",
        n_completions = 1,
        context_window = 512,
        provider_options = {
          openai_fim_compatible = {
            api_key = "TERM",
            name = "Ollama",
            end_point = "http://localhost:11434/v1/completions",
            model = "qwen2.5-coder:7b",
            optional = {
              max_tokens = 56,
              top_p = 0.9,
            },
          },
        },
      })
    end,
  },
}
