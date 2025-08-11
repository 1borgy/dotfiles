-- vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
--
-- vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "exit terminal mode" })
--
--
-- vim.keymap.set("n", "<leader>us", function()
--   vim.o.signcolumn = vim.o.signcolumn == "yes" and "no" or "yes"
-- end, { desc = "ui: toggle sign column" })

-- local map = vim.keymap.set
local function map(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", {
    silent = true,
  }, opts or {})

  vim.keymap.set(mode, lhs, rhs, opts)
end

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "down", expr = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "down", expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "up", expr = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "up", expr = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "move up" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "prev search result" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "switch to other buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "switch to other buffer" })
-- map("n", "<leader>bd", function(...)
-- end, { desc = "delete buffer" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "delete buffer and window" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "redraw / clear hlsearch / diff update" }
)

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "keywordprg" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "add comment below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "add comment above" })

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "new file" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "location list" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "quickfix list" })

map("n", "[q", vim.cmd.cprev, { desc = "previous quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "next quickfix" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "line diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "next diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "prev diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "next error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "prev error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "next warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "prev warning" })

-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "enter normal mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "go to right window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "hide terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
map("n", "<leader>w", "<c-w>", { desc = "windows", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "split window right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "delete window", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "last tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "close other tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "first tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "new tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "next tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "close tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "previous tab" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "quit all" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "inspect pos" })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "inspect tree" })

-- repeat last macro with ,
map("n", ",", "@@", { desc = "repeat macro" })

map("n", "<space>xr", "", {
  noremap = true,
  callback = function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
    end
  end,
})

map("n", "<leader>ta", ":$tabnew<CR>", { noremap = true })
map("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
map("n", "<leader>to", ":tabonly<CR>", { noremap = true })
map("n", "<leader>tn", ":tabn<CR>", { noremap = true })
map("n", "<leader>tp", ":tabp<CR>", { noremap = true })
map("n", "<leader>tn", ":tabn<CR>", { noremap = true })
map("n", "<S-l>", ":tabn<CR>", { noremap = true })
map("n", "<S-h>", ":tabp<CR>", { noremap = true })
map("n", "<S-h>", ":tabp<CR>", { noremap = true })
map("n", "<leader>tmp", ":-tabmove<CR>", { noremap = true })
map("n", "<leader>tmn", ":+tabmove<CR>", { noremap = true })

-- map("n", "<C-S-tab>", ":tabp<CR>", { noremap = true })
-- map("n", "<C-tab>", ":tabn<CR>", { noremap = true })
-- map("n", "<C-S-t>", ":tab terminal<CR>", { noremap = true })
-- map("n", "<C-S-w>", ":tabclose<CR>", { noremap = true })

map("n", "<leader>ca", vim.lsp.buf.code_action)
map("n", "<leader>cr", vim.lsp.buf.rename)

map("n", "<leader>yy", function()
  vim.cmd(':let @+=expand("%:p")')
end)
