-- ty https://github.com/amarakon/nvim-unfocused-cursor for the sauce
local function unfocus_cursor()
  local old_guicursor, old_cursorline, old_cursorcolumn

  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      old_guicursor = vim.opt.guicursor
      old_cursorline = vim.opt.cursorline
      old_cursorcolumn = vim.opt.cursorcolumn
    end,
  })

  vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
    callback = function()
      vim.opt.guicursor = "a:noCursor"
      vim.opt.cursorline = false
      vim.opt.cursorcolumn = false
    end,
  })

  vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
    callback = function()
      vim.opt.guicursor = old_guicursor
      vim.opt.cursorline = old_cursorline
      vim.opt.cursorcolumn = old_cursorcolumn
    end,
  })
end

unfocus_cursor()
