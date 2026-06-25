-- stylua: ignore
return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    keys = {
      { "<leader>oo", desc = "Open OpenCode TUI" },
      { "<leader>oa", function() require("opencode").ask("@this: ") end, mode = { "n", "x" }, desc = "Ask OpenCode…" },
      { "<leader>os", function() require("opencode").select() end, mode = { "n", "x" }, desc = "Select OpenCode…" },
      { "<leader>oc", function() require("opencode").command("session.compact") end, desc = "Compact Session" },
      { "<leader>on", function() require("opencode").command("session.new") end, desc = "New Session" },
      { "<leader>oi", function() require("opencode").command("session.interrupt") end, desc = "Interrupt Session" },
      { "<leader>om", function() require("opencode").command("agent.cycle") end, desc = "Cycle Agent/Mode" },
      { "<PageUp>", function() require("opencode").command("session.half.page.up") end, desc = "Scroll OpenCode up" },
      { "<PageDown>", function() require("opencode").command("session.half.page.down") end, desc = "Scroll OpenCode down" },
      { "go", function() return require("opencode").operator("@this ") end, mode = { "n", "x" }, desc = "Append range to OpenCode", expr = true },
      { "goo", function() return require("opencode").operator("@this ") .. "_" end, desc = "Append line to OpenCode", expr = true },
    },
    config = function()
      vim.o.autoread = true

      local opencode_cmd = "opencode --port"
      local opencode_buf = nil

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function()
            vim.cmd("vsplit term://" .. opencode_cmd .. " | wincmd p")
          end,
        },
      }

      vim.keymap.set("n", "<leader>oo", function()
        if opencode_buf and vim.api.nvim_buf_is_valid(opencode_buf) then
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == opencode_buf then
              vim.api.nvim_win_close(win, true)
              return
            end
          end
          vim.cmd("vsplit")
          vim.api.nvim_win_set_buf(0, opencode_buf)
          vim.cmd("startinsert")
          return
        end
        vim.cmd("vsplit term://" .. opencode_cmd)
        opencode_buf = vim.api.nvim_get_current_buf()
        vim.cmd("startinsert")
      end, { desc = "Open OpenCode TUI" })

      require("which-key").add({
        { "<leader>o", group = "opencode" },
      })
    end,
  },
}
