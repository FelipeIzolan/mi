-- LAZY
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ 
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out,                            'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require 'lazy'.setup({
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require 'nvim-treesitter'.setup {
        auto_install = true,
        highlight = {
          enable = true
        }
      }
    end
  },
  {
    'nvim-tree/nvim-tree.lua',
    opts = {
      hijack_cursor = true,
      filters = { enable = false },
      update_focused_file = { enable = true, update_root = true },
      renderer = {
        root_folder_label = function()
          return '  ..'
        end,
      },
      view = {
        signcolumn = 'no'
      }
    }
  }
}, {
  defaults = {
    lazy = true
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'editorconfig',
        'gzip',
        'man',
        'matchit',
        'matchparen',
        'net',
        'netrwPlugin',
        'osc52',
        'rplugin',
        'shada',
        'spellfile',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin'
      }
    }
  }
})

-- NEOVIM
local g = vim.g
local o = vim.opt
local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

g.mapleader = ' '
local term = {
  buf = nil,
  win = nil
}

o.mouse = 'a'
o.signcolumn = 'yes:1'
o.laststatus = 3
o.timeoutlen = 800
o.updatetime = 400
o.number = true
o.numberwidth = 1
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.ignorecase = true
o.smartcase = true
o.termguicolors = true
o.clipboard = 'unnamedplus'

vim.cmd.colorscheme('retrobox')
vim.api.nvim_set_hl(0, 'Normal', { bg = nil })
vim.api.nvim_set_hl(0, 'StatusLine', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'SignColumn', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'WinSeparator', { link = 'LineNr' })

vim.filetype.add({
  pattern = {
    ['.*'] = function(p, b)
      local s = vim.fn.getfsize(p)
      if s > 1048576 then -- 1 MB
        return 'bigfile'
      end
      if s / vim.api.nvim_buf_line_count(b) > 1000 then -- minified files
        return 'bigfile'
      end
    end
  }
})

keymap('v', '<C-w>', ':m \'<-2<CR>gv=gv', {})
keymap('v', '<C-s>', ':m \'>+1<CR>gv=gv', {})
keymap('n', '<Leader>q', ':q<CR>', {})
keymap('n', '<Leader>T', ':NvimTreeClose<CR>', {})
keymap('n', '<Leader>t', '', {
  callback = function()
    local t = require 'nvim-tree.api'.tree
    if t.is_visible() then
      t.focus()
    else
      t.open()
    end
  end
})
keymap('', '<Leader>c', '', {
  callback = function()
    local cs = vim.bo.commentstring
    local mcs = vim.pesc(cs):gsub('%%%%s', '(.*)')
    local s, e = vim.fn.line('v'), vim.fn.line('.')
    if s > e then
      s, e = e, s
    end
    local function comment(line)
      return cs:format(line)
    end
    local function uncomment(line)
      return line:find(mcs) ~= nil and line:gsub(mcs, line:match(mcs)) or nil
    end
    local lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false), s, e
    for i, line in ipairs(lines) do
      lines[i] = uncomment(line) or comment(line)
    end
    vim.api.nvim_buf_set_lines(0, s - 1, e, true, lines)
  end
})
keymap({ 'n', 't' }, '<Leader><Tab>', '', {
  callback = function()
    if term.buf == nil or not vim.api.nvim_buf_is_valid(term.buf) then
      term.buf = vim.api.nvim_create_buf(false, true)
    end
    if term.win == nil or not vim.api.nvim_win_is_valid(term.win) then
      term.win = vim.api.nvim_open_win(term.buf, true, {
        width = vim.o.columns,
        height = math.ceil(vim.o.lines * 0.35),
        split = 'below'
      })
      if vim.bo[term.buf].buftype ~= 'terminal' then
        vim.cmd.terminal()
      end
      vim.cmd.startinsert()
    else
      vim.api.nvim_win_hide(term.win)
    end
  end
})

function Statusline()
  local m = {
    ['n'] = 'NORMAL',
    ['no'] = 'NORMAL',
    ['v'] = 'VISUAL',
    ['V'] = 'VISUAL LINE',
    [''] = 'VISUAL BLOCK',
    ['s'] = 'SELECT',
    ['S'] = 'SELECT LINE',
    [''] = 'SELECT BLOCK',
    ['i'] = 'INSERT',
    ['ic'] = 'INSERT',
    ['R'] = 'REPLACE',
    ['Rv'] = 'VISUAL REPLACE',
    ['c'] = 'COMMAND',
    ['cv'] = 'VIM EX',
    ['ce'] = 'EX',
    ['r'] = 'PROMPT',
    ['rm'] = 'MOAR',
    ['r?'] = 'CONFIRM',
    ['!'] = 'SHELL',
    ['t'] = 'TERMINAL',
    ['nt'] = 'TERMINAL',
  }

  local function col(hi, str)
    return string.format('%%#%s#%s%% ', hi, str)
  end

  return
    ' ' ..
    col('Keyword', m[vim.api.nvim_get_mode().mode]) ..
    '%=' ..
    col('Directory', '%t') ..
    '%=' ..
    col('SpecialKeys', '%l:%c ') ..
    col('Keyword', vim.loop.os_uname().sysname) ..
    ' '
end

autocmd({ 'BufEnter', 'WinEnter' }, {
  callback = function()
    vim.cmd.setlocal('statusline=%!v:lua.Statusline()')
  end
})
autocmd('FileType', {
  pattern = 'bigfile',
  callback = function(ev)
    vim.treesitter.stop(ev.buf)
    vim.bo[ev.buf].syntax = 'off'
  end
})
