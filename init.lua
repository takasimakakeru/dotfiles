-- ==========================================
-- 1. 基本設定 (エディタの挙動・日本語化)
-- ==========================================
vim.opt.helplang = "ja"
vim.env.LANG = "ja_JP.UTF-8"
vim.cmd('language ja_JP.UTF-8')

vim.g.mapleader = " "         -- Leaderキーをスペースに
vim.opt.number = true         -- 行番号表示
vim.opt.cursorline = true     -- カーソル行を強調
vim.opt.scrolloff = 8         -- スクロール時の余白
vim.opt.termguicolors = true  -- 真色対応
vim.opt.fileencoding = "utf-8"
vim.scriptencoding = "utf-8"

-- ==========================================
-- 2. lazy.nvim の本体インストール
-- ==========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================
-- 3. プラグインのインストール設定
-- ==========================================
require("lazy").setup({
  "mattn/emmet-vim",
  "folke/tokyonight.nvim",
  "nvim-treesitter/nvim-treesitter",
  "windwp/nvim-autopairs",
  "windwp/nvim-ts-autotag",

  -- Telescope を 0.1.8 に固定（0.9.5対応）
  { "nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = { "nvim-lua/plenary.nvim" } },
  
  { "nvim-tree/nvim-tree.lua", dependencies = "nvim-tree/nvim-web-devicons" },

  -- LSP関連も固定
  { "neovim/nvim-lspconfig", tag = "v0.1.8" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim", version = "1.3.0" },
  
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
})

-- ==========================================
-- 4. 各プラグインの詳細設定
-- ==========================================

-- --- カラースキーム ---
vim.cmd("colorscheme tokyonight")

-- --- nvim-autopairs ---
require("nvim-autopairs").setup {}

-- --- Telescope (ファイル検索) ---
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

-- --- nvim-tree (ファイルツリー) ---
-- 3つあった setup を1つに統合しました
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
    side = "left",
  },
  renderer = {
    group_empty = true,
    icons = {
      glyphs = {
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  filters = {
    dotfiles = false,
  },
  git = {
    enable = true,
    ignore = true,
    show_on_dirs = true,
    timeout = 400,
  },
})
-- キーバインド設定
vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<leader>', ':NvimTreeToggle<CR>', { silent = true })

-- --- LSP / Mason 設定 ---
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "html" }
})

-- nvim-lspconfig を使った標準的な書き方
require('lspconfig').html.setup({
    capabilities = require('cmp_nvim_lsp').default_capabilities()
})

-- --- nvim-cmp (補完) ---
local cmp = require('cmp')
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim-lsp' },
  })
})