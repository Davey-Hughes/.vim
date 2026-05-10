---@module "vectorcode"

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      {
        "echasnovski/mini.diff",
        config = function()
          local diff = require("mini.diff")
          diff.setup({
            -- Disabled by default
            source = diff.gen_source.none(),
          })
        end,
      },
      { "j-hui/fidget.nvim" },
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
          },
        },
        keys = { { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" } },
      },
      {
        "ravitemer/mcphub.nvim",
        enabled = false,
        build = "bundled_build.lua",
        opts = {
          use_bundled_binary = true,
        },
      },
      {
        "Davey-Hughes/scrollEOF.nvim",
        event = { "CursorMoved", "WinScrolled" },
        opts = {
          disabled_filetypes = { "codecompanion" },
          enabled_filetypes = { "codecompanion" },
        },
      },
    },

    keys = {
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = "n", desc = "Toggle CodeCompanion Chat" },
      { "<leader>cs", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add visual selection to chat buffer" },
      { "<leader>cC", "<cmd>CodeCompanionActions<cr>", desc = "Open CodeCompanion Actions" },
      { "<leader>ci", "<cmd>CodeCompanion<cr>", mode = "n", desc = "Open CodeCompanion Inline" },
      { "<leader>ci", ":CodeCompanion ", mode = "v", desc = "Open CodeCompanion Inline" },
      { "<leader>cm", ":CodeCompanionCmd ", mode = "n", desc = "Open CodeCompanion Cmd" },
    },

    init = function() require("util.fidget-spinner"):init() end,

    opts = {
      log_level = "DEBUG",

      display = {
        diff = {
          enabled = false,
        },
      },

      adapters = {
        acp = {
          claude_code = function()
            return require("codecompanion.adapters").extend(
              "claude_code",
              (function()
                local config = {
                  defaults = {
                    mcpServers = "inherit_from_config",
                  },
                }

                if vim.uv.os_uname().sysname == "Linux" then
                  config.commands = {
                    default = {
                      "claude-code-acp",
                    },
                  }
                end

                return config
              end)()
            )
          end,

          gemini_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              commands = {
                default = {
                  "gemini",
                  "--experimental-acp",
                },
              },
              env = {
                GEMINI_API_KEY = "GEMINI_API_KEY",
              },
            })
          end,
        },

        http = {
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                api_key = "CLAUDE_API_KEY",
              },
            })
          end,

          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = "GEMINI_API_KEY",
              },
            })
          end,

          qwen2_5_coder = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "qwen2.5-coder",
              schema = {
                model = {
                  default = "qwen2.5-coder:7b",
                },
                num_ctx = {
                  default = 16384,
                },
                think = {
                  default = false,
                },
                keep_alive = {
                  default = "5m",
                },
              },
            })
          end,
        },
      },

      memory = {
        opts = {
          chat = {
            ---Function to determine if memory should be added to a chat buffer
            ---This requires `enabled` to be true
            ---@param chat CodeCompanion.Chat
            ---@return boolean
            condition = function(chat) return chat.adapter.type ~= "acp" end,
          },
        },

        claude = {
          description = "Memory files for Claude Code users",
          parser = "claude",
          files = {
            { path = "CLAUDE.md", parser = "claude" },
            { path = "CLAUDE.local.md", parser = "claude" },
            { path = "~/.claude/CLAUDE.md", parser = "claude" },
          },
        },
      },

      interactions = {
        chat = {
          adapter = "claude_code",
        },
        inline = {
          adapter = "gemini",
        },
        cmd = {
          adapter = "claude_code",
        },
      },

      extensions = {
        -- mcphub = {
        --   callback = "mcphub.extensions.codecompanion",
        --   opts = {
        --     make_tools = true,
        --     show_server_tools_in_chat = true,
        --     add_mcp_prefix_to_tool_names = false,
        --     show_result_in_chat = true,
        --     format_tool = nil,
        --     make_vars = true,
        --     make_slash_commands = true,
        --   },
        -- },
      },
    },
  },

  {
    "milanglacier/minuet-ai.nvim",
    enabled = false,
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("vectorcode").setup({
        -- number of retrieved documents
        n_query = 1,
      })

      local has_vc, vectorcode_config = pcall(require, "vectorcode.config")
      local vectorcode_cacher = nil
      if has_vc then vectorcode_cacher = vectorcode_config.get_cacher_backend() end

      -- roughly equate to 2000 tokens for LLM
      local RAG_Context_Window_Size = 8000

      require("minuet").setup({
        -- config = {
        --   notify = debug,
        -- },
        provider = "openai_fim_compatible",
        n_completions = 1,
        context_window = 1024,
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
            template = {
              prompt = function(pref, suff, _)
                local prompt_message = ""
                if has_vc and vectorcode_cacher then
                  for _, file in ipairs(vectorcode_cacher.query_from_cache(0)) do
                    prompt_message = prompt_message .. "<|file_sep|>" .. file.path .. "\n" .. file.document
                  end
                end

                prompt_message = vim.fn.strcharpart(prompt_message, 0, RAG_Context_Window_Size)
                print(prompt_message)

                return prompt_message .. "<|fim_prefix|>" .. pref .. "<|fim_suffix|>" .. suff .. "<|fim_middle|>"
              end,
              suffix = false,
            },
          },
        },

        -- provider = "claude",
        -- provider_options = {
        --   claude = {
        --     model = "claude-3-5-haiku-latest"
        --   }
        -- },
      })
    end,
  },

  {
    "supermaven-inc/supermaven-nvim",
    enabled = true,
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
    "coder/claudecode.nvim",
    config = true,

    opts = {
      terminal = {
        provider = "snacks",
      },
    },

    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree" },
      },
    },
  },

  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    opts = function()
      local function conceal_tag(icon, hl_group)
        return {
          on_node = { hl_group = hl_group },
          on_closing_tag = { conceal = "" },
          on_opening_tag = {
            conceal = "",
            virt_text_pos = "inline",
            virt_text = { { icon .. " ", hl_group } },
          },
        }
      end

      return {
        html = {
          container_elements = {
            ["^buf$"] = conceal_tag("", "CodeCompanionChatVariable"),
            ["^file$"] = conceal_tag("", "CodeCompanionChatVariable"),
            ["^help$"] = conceal_tag("󰘥", "CodeCompanionChatVariable"),
            ["^image$"] = conceal_tag("", "CodeCompanionChatVariable"),
            ["^symbols$"] = conceal_tag("", "CodeCompanionChatVariable"),
            ["^url$"] = conceal_tag("󰖟", "CodeCompanionChatVariable"),
            ["^var$"] = conceal_tag("", "CodeCompanionChatVariable"),
            ["^tool$"] = conceal_tag("", "CodeCompanionChatTool"),
            ["^user_prompt$"] = conceal_tag("", "CodeCompanionChatTool"),
            ["^group$"] = conceal_tag("", "CodeCompanionChatToolGroup"),
          },
        },

        preview = {
          filetypes = { "markdown", "typst", "html", "latex", "codecompanion" },
          -- ignore_buftypes = {},
        },
      }
    end,
  },
}
