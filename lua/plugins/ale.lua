return {
  {
    "dense-analysis/ale",
    enabled = false,
    config = function()
      -- change error format
      vim.g.ale_echo_msg_error_str = "E"
      vim.g.ale_echo_msg_warning_str = "W"
      vim.g.ale_echo_msg_format = "[%linter%] %s [%severity%]"
    end,
  },
}
