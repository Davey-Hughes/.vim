return {
  {
    enabled = false,
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      {
        "rcarriga/nvim-dap-ui",
        config = function() require("dapui").setup() end,
      },
      { "nvim-neotest/nvim-nio" },
      { "williamboman/mason.nvim" },
    },

    config = function()
      local dap, dapui = require("dap"), require("dapui")
      local mason_path = vim.fn.stdpath("data") .. "/mason"

      vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "red", bg = "" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "yellow", bg = "" })
      vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "green", bg = "" })

      vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "R", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "S", texthl = "DapStopped", linehl = "", numhl = "" })

      dap.adapters.lldb = {
        id = "lldb",
        type = "server",
        port = "${port}",
        executable = {
          command = mason_path .. "/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.c = {
        {
          name = "launch file",
          type = "lldb",
          request = "launch",
          program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
          cwd = "${workspaceFolder}",
          stopOnEntry = true,
        },
      }

      dap.configurations.cpp = dap.configurations.c

      local function set_ui_keymaps()
        vim.keymap.set("n", "<down>", dap.step_over)
        vim.keymap.set("n", "<left>", dap.step_out)
        vim.keymap.set("n", "<right>", dap.step_into)

        vim.keymap.set("n", "<leader>n", dap.step_over)
        vim.keymap.set("n", "<leader>i", dap.step_into)
        vim.keymap.set("n", "<leader>o", dap.step_out)
        vim.keymap.set("n", "<leader>c", dap.continue)
        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
        vim.keymap.set("n", "<leader>r", dap.restart)
        vim.keymap.set("n", "<leader>l", dap.run_last)
        vim.keymap.set("n", "<leader>q", dap.close)
      end

      local function unset_ui_keymaps()
        pcall(vim.keymap.del, "n", "<down>")
        pcall(vim.keymap.del, "n", "<left>")
        pcall(vim.keymap.del, "n", "<right>")

        pcall(vim.keymap.del, "n", "<leader>n")
        pcall(vim.keymap.del, "n", "<leader>i")
        pcall(vim.keymap.del, "n", "<leader>o")
        pcall(vim.keymap.del, "n", "<leader>c")
        pcall(vim.keymap.del, "n", "<leader>b")
        pcall(vim.keymap.del, "n", "<leader>r")

        vim.keymap.set("n", "<down>", "<nop>")
        vim.keymap.set("n", "<up>", "<nop>")
        vim.keymap.set("n", "<left>", "<nop>")
        vim.keymap.set("n", "<right>", "<nop>")
      end

      dap.listeners.after.event_initialized["dap.keys"] = set_ui_keymaps
      -- dap.listeners.after.event_terminated["dap.keys"] = unset_ui_keymaps
      -- dap.listeners.after.disconnect["dap.keys"] = unset_ui_keymaps

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
        set_ui_keymaps()
      end

      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
        set_ui_keymaps()
      end

      vim.api.nvim_create_autocmd({ "QuitPre" }, {
        callback = dapui.close,
      })

      vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end)

      if vim.bo.filetype ~= "rust" then vim.keymap.set("n", "<leader>dr", "<cmd>DapNew<cr>") end

      vim.keymap.set("n", "<leader>do", function()
        dapui.open()
        -- set_ui_keymaps()
      end)

      vim.keymap.set("n", "<leader>dc", function()
        dapui.close()
        unset_ui_keymaps()
      end)
    end,
  },
}
