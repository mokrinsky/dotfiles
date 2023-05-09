-- bootstrap from github
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup {
  spec = {
    { 'mokrinsky/nvim-config', import = 'yumivim.plugins' },
    { import = 'plugins' },
  },
  defaults = { lazy = true },
  lockfile = vim.fn.stdpath 'data' .. '/lazy-lock.json',
  dev = { path = '~/git/nvim-plugins/' },
  install = { missing = true, colorscheme = { 'catppuccin' } },
  checker = { enabled = true, notify = false },
  ui = { border = 'rounded' },
  performance = {
    rtp = {
      disabled_plugins = {
        '2html_plugin',
        'bugreport',
        'compiler',
        'ftplugin',
        'fzf',
        'getscript',
        'getscriptPlugin',
        'gzip',
        'logipat',
        'matchit',
        'matchparen',
        'netrw',
        'netrwFileHandlers',
        'netrwPlugin',
        'netrwSettings',
        'optwin',
        'rplugin',
        'rrhelper',
        'spellfile_plugin',
        'synmenu',
        'syntax',
        'tar',
        'tarPlugin',
        'tohtml',
        'tutor',
        'vimball',
        'vimballPlugin',
        'zip',
        'zipPlugin',
      },
    },
  },
  debug = false,
}
