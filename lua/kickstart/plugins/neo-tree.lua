-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

-- vim.api.nvim_create_autocmd('BufEnter', {
--   nested = true,
--   callback = function()
--     local wins = vim.api.nvim_list_wins()
--     local non_tree = 0
--     for _, w in ipairs(wins) do
--       local buf = vim.api.nvim_win_get_buf(w)
--       if vim.bo[buf].filetype ~= 'neo-tree' and vim.api.nvim_win_get_config(w).relative == '' then non_tree = non_tree + 1 end
--     end
--     if non_tree == 0 then vim.cmd.quit() end
--   end,
-- })

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  init = function()
    vim.api.nvim_create_autocmd('QuitPre', {
      callback = function()
        local tree_wins = {}
        local floating_wins = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(w)
          if vim.bo[buf].filetype == 'neo-tree' then table.insert(tree_wins, w) end
          if vim.api.nvim_win_get_config(w).relative ~= '' then table.insert(floating_wins, w) end
        end
        if #wins - #floating_wins - #tree_wins == 1 then
          for _, w in ipairs(tree_wins) do
            vim.api.nvim_win_close(w, true)
          end
        end
      end,
    })
    vim.cmd [[cabbrev bd bprevious <bar> bdelete #]]
  end,
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
