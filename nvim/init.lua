--------------------------------------------------------------
--
-- Lazy Neovim -----------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- LSP
local on_attach = function(_, bufnr)
  local map = function(keys, func)
    vim.keymap.set('n', keys, func, { buffer = bufnr })
  end

  map('gd', vim.lsp.buf.definition)
  map('K', vim.lsp.buf.hover)
  map('gr', vim.lsp.buf.references)
  map('<leader>rn', vim.lsp.buf.rename)
  map('<leader>dl', '<cmd>Telescope diagnostics<cr>')
end

-- Plugins
local opts = {}
local plugins = {
  { "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000 },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    tag = "v0.9.2", -- <- stable version before the breaking change
    build = ":TSUpdate",
    config = function ()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
        ensure_installed = {
          "python",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "javascript",
          "html",
          "markdown",
          "markdown_inline",
          "bash",
          "git_config",
          "json",
          "yaml",
          "toml"
        },
        highlight = { enable = true },
        indent = { enable = true },
    })
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    }
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup(
        {
	      ensure_installed = { "lua_ls" }
        }
      )
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
    local lspconfig = require("lspconfig")
    local servers = { "lua_ls" }

    for _, server in ipairs(servers) do
        lspconfig[server].setup({
          on_attach = on_attach
        })
      end
    end
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  },
}

require("lazy").setup(plugins, opts)

-- Display
vim.cmd.colorscheme 'catppuccin'
vim.opt.number = true
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Usability
vim.cmd('set expandtab')
vim.cmd('set tabstop=2')
vim.cmd('set softtabstop=2')
vim.cmd('set shiftwidth=2')

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keymap
vim.g.mapleader = " "

local builtin = require("telescope.builtin")

vim.keymap.set('n', '<leader>p', builtin.find_files, {})
vim.keymap.set('n', '<leader>q', builtin.live_grep, {})
vim.keymap.set('n', '<C-r>', ':Neotree filesystem reveal left<CR>', {})
vim.keymap.set('n', '<C-e>', ':Neotree close<CR>', {})
