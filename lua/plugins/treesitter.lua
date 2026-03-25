return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",

    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("tree-sitter-enable", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then return end

          if vim.treesitter.query.get(lang, "highlights") then vim.treesitter.start(args.buf) end

          if vim.treesitter.query.get(lang, "indents") then
            vim.opt_local.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
          end
        end,
      })
    end,
  },

  {
    "RRethy/nvim-treesitter-endwise",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function() vim.g.no_plugin_maps = true end,

    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
        },
      })

      local select_textobject = require("nvim-treesitter-textobjects.select").select_textobject
      local goto_next_start = require("nvim-treesitter-textobjects.move").goto_next_start
      local goto_next_end = require("nvim-treesitter-textobjects.move").goto_next_end
      local goto_previous_start = require("nvim-treesitter-textobjects.move").goto_previous_start
      local goto_previous_end = require("nvim-treesitter-textobjects.move").goto_previous_end

      vim.keymap.set({ "x", "o" }, "af", function() select_textobject("@function.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "if", function() select_textobject("@function.inner", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "aC", function() select_textobject("@class.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "iC", function() select_textobject("@class.inner", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "ae", function() select_textobject("@conditional.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "ie", function() select_textobject("@conditional.inner", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "al", function() select_textobject("@loop.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "il", function() select_textobject("@loop.inner", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "as", function() select_textobject("@statement.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "is", function() select_textobject("@statement.inner", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "am", function() select_textobject("@call.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "im", function() select_textobject("@call.inner", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "ad", function() select_textobject("@comment.outer", "textobjects") end)

      vim.keymap.set({ "n", "x", "o" }, "]m", function() goto_next_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]]", function() goto_next_start("@class.outer", "textobjects") end)

      vim.keymap.set({ "n", "x", "o" }, "]M", function() goto_next_end("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "][", function() goto_next_end("@class.outer", "textobjects") end)

      vim.keymap.set({ "n", "x", "o" }, "[m", function() goto_previous_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[[", function() goto_previous_start("@class.outer", "textobjects") end)

      vim.keymap.set({ "n", "x", "o" }, "[M", function() goto_previous_end("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[]", function() goto_previous_end("@class.outer", "textobjects") end)
    end,
  },
}
