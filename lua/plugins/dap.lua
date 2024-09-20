return {
  -- /Users/davey/.vscode/extensions/ms-vscode.cpptools-1.21.6-darwin-arm64/debugAdapters/bin
  {
    -- enabled = false,
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          require("dapui").setup()
        end,
      },
      { "nvim-neotest/nvim-nio" },
      { "williamboman/mason.nvim" },
    },

    config = function()
      local dap, dapui = require("dap"), require("dapui")
      local mason_path = vim.fn.stdpath("data") .. "/mason"

      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = mason_path .. "/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
      }

      dap.adapters.lldb = {
        id = "lldb",
        type = "executable",
        command = "/opt/homebrew/opt/llvm/bin/lldb-dap",
      }

      dap.configurations.rust = {
        {
          name = "launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          miDebuggerPath = mason_path .. "/packages/cpptools/extension/debugAdapters/lldb-mi/bin/lldb-mi",
          MIMode = "lldb",
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.rust

      local function set_ui_keymaps()
        vim.keymap.set("n", "<leader>n", function()
          dap.step_over()
        end)

        vim.keymap.set("n", "<leader>i", function()
          dap.step_into()
        end)

        vim.keymap.set("n", "<leader>o", function()
          dap.step_out()
        end)

        vim.keymap.set("n", "<leader>c", function()
          dap.continue()
        end)

        vim.keymap.set("n", "<leader>b", function()
          dap.toggle_breakpoint()
        end)

        vim.keymap.set("n", "<leader>r", function()
          dap.restart()
        end)
        vim.keymap.set("n", "<leader>l", function()
          dap.run_last()
        end)
      end

      local function unset_ui_keymaps()
        vim.keymap.del("n", "<leader>n")
        vim.keymap.del("n", "<leader>i")
        vim.keymap.del("n", "<leader>o")
        vim.keymap.del("n", "<leader>c")
        vim.keymap.del("n", "<leader>b")
        vim.keymap.del("n", "<leader>r")
      end

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
        set_ui_keymaps()
      end

      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
        set_ui_keymaps()
      end

      vim.keymap.set("n", "<leader>db", function()
        dap.toggle_breakpoint()
      end)

      vim.keymap.set("n", "<leader>dr", "<cmd>DapNew<cr>")

      vim.keymap.set("n", "<leader>do", function()
        dapui.open()
        set_ui_keymaps()
      end)

      vim.keymap.set("n", "<leader>dc", function()
        dapui.close()
        unset_ui_keymaps()
      end)
    end,
  },
}
