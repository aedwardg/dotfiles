--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = false

lvim.colorscheme = "nordbones_custom"
vim.g.nordbones_custom = { lighten_comments = 25 }
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.cmdheight = 1
lvim.transparent_window = true

-- fold options
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.wo.relativenumber = true

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- make yank highlight BLAZINGLY FAST
-- ##############################################

local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

-- #############################################
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- Insert --
keymap("i", "jj", "<ESC>", opts)
-- Make Shift+tab do reverse tab
keymap("i", "<S-tab>", "<C-d>", opts)

-- Visual --
-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
-- keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- greatest remap ever
keymap("x", "<space>p", "\"_dP", opts)

-- YOLO deletes
keymap("n", "<space>d", "\"_d", opts)
keymap("v", "<space>d", "\"_d", opts)
keymap("x", "<space>d", "\"_d", opts)

-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }


-- Telescope Settings
-- Set lvim telescope defaults to utilize screen width and show preview
lvim.builtin.telescope.defaults.path_display = { shorten = { len = 4, exclude = { 1, -1 } } }
lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
lvim.builtin.telescope.defaults.layout_config = {
  width = 0.9,
  height = 0.9,
  prompt_position = "bottom",
}

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "live_grep_args")
end

-- Change theme settings
-- lvim.builtin.theme.options.dim_inactive = true
-- lvim.builtin.theme.options.style = "storm"

-- show registers with which-key on "
lvim.builtin.which_key.setup.plugins.registers = true
-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["#"] = { ":set invrelativenumber<cr>", "Toggle relative line numbers" }
lvim.builtin.which_key.mappings["p"] = {}

-- make the important telescope searches show preivew
lvim.builtin.which_key.mappings["f"] = {
  require("lvim.core.telescope.custom-finders").find_project_files,
  "Find File"
}

-- timeout override for formatters
lvim.builtin.which_key.mappings["l"]["f"] = {
  function()
    require("lvim.lsp.utils").format { timeout_ms = 2000 }
  end,
  "Format",
}

lvim.builtin.which_key.mappings["g"]["v"] = { "<cmd>Telescope git_status<cr>", "Status" }
lvim.builtin.which_key.mappings["s"]["a"] = { "<cmd>Telescope live_grep_args<cr>", "Text (with args)" }
lvim.builtin.which_key.mappings["s"]["u"] = { "<cmd>Telescope resume<cr>", "Resume search" }

-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.dap.active = false
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.breadcrumbs.active = false

lvim.builtin.autopairs.on_config_done = function()
  local npairs = require("nvim-autopairs")
  local Rule = require("nvim-autopairs.rule")
  npairs.add_rules({
    Rule("<%", "%>", { "elixir", "eelixir", "heex" }),
    Rule("<>", "</>", { "elixir", "eelixir", "heex", "html", "typescriptreact" }),
  })
end

-- Lualine Config --
local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.options.theme = "nord"

lvim.builtin.lualine.sections.lualine_x = {
  components.diagnostics,
  components.lsp,
  components.filetype,
}

-- Bufferline Config --
lvim.builtin.bufferline.options.show_buffer_close_icons = false

-- remove visible separator/indicator lines
lvim.builtin.bufferline.options.indicator = { icon = nil }
lvim.builtin.bufferline.options.separator_style = { '', '' }

lvim.builtin.bufferline.highlights = {
  background = {
    italic = true,
  },
  buffer_selected = {
    bg = "NONE",
    bold = true,
  },
  fill = {
    bg = {
      attribute = "bg",
      highlight = "Normal"
    }
  },
}

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true


-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--     "sumneko_lua",
--     "jsonls",
-- }
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- changed when upgrading to v1.3
-- lvim.lsp.diagnostics.virtual_text = false
vim.diagnostic.config({ virtual_text = false })
-- ---@usage disable automatic installation of servers
lvim.lsp.installer.setup.automatic_installation = true

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- ####################################################

-- use local Solargraph instead of Mason download
-- elixirls
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "solargraph", "elixirls" })
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "solargraph", "gleam" })

lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "lexical"
end, lvim.lsp.automatic_configuration.skipped_servers)

local common_opts = require("lvim/lsp").get_common_opts()
local util = require("lspconfig/util")

local opts = {
  cmd = { "solargraph", "stdio" },
  filetypes = { "ruby" },
  root_dir = util.root_pattern("Gemfile", ".git"),
  settings = {
    solargraph = {
      diagnostics = true
    }
  },
}
require("lspconfig")["solargraph"].setup(vim.tbl_extend("force", opts, common_opts))

-- ####################################################

-- use Lexical LSP
local lspconfig = require("lspconfig")
-- local configs = require("lspconfig.configs")

-- local lexical_config = {
--   filetypes = { "elixir", "eelixir", "heex" },
--   cmd = { "/Users/anthony.garcia/oss/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
--   settings = {},
-- }

-- if not configs.lexical then
--   configs.lexical = {
--     default_config = {
--       filetypes = lexical_config.filetypes,
--       cmd = lexical_config.cmd,
--       root_dir = function(fname)
--         return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
--       end,
--       -- optional settings
--       settings = lexical_config.settings,
--     },
--   }
-- end

-- lspconfig.lexical.setup(common_opts)

-- ####################################################
local gleam_opts = {
  cmd = { 'gleam', 'lsp' },
  filetypes = { 'gleam' },
  root_dir = util.root_pattern('gleam.toml', '.git'),
}

lspconfig.gleam.setup(vim.tbl_extend("force", gleam_opts, common_opts))

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  --   { command = "black", filetypes = { "python" } },
  --   { command = "isort", filetypes = { "python" } },
  { command = "prettierd" },
  --   {
  --     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  --     command = "prettier",
  --     ---@usage arguments to pass to the formatter
  --     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
  --     extra_args = { "--print-with", "100" },
  --     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --     filetypes = { "typescript", "typescriptreact" },
  --   },
}

-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "eslint_d", extra_args = { "--rulesdir", "linters/eslint" } }, -- use eslint_d for faster eslint! Example of using an extra rulesdir.
  {
    command = "rubocop",
    condition = function(utils)
      return utils.root_has_file({ ".rubocop.yml" }) and not utils.root_has_file({ ".standard.yml" })
    end,
  },
  {
    command = "standardrb",
    condition = function(utils)
      return utils.root_has_file({ ".standard.yml" })
    end,
  },
  {
    command = "haml-lint",
    env = {
      RUBYOPT = "-W0"
    }
  },
  -- {
  --   name = "credo"
  -- },
  --   { command = "flake8", filetypes = { "python" } },
  --   {
  --     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  --     command = "shellcheck",
  --     ---@usage arguments to pass to the formatter
  --     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
  --     extra_args = { "--severity", "warning" },
  --   },
  --   {
  --     command = "codespell",
  --     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --     filetypes = { "javascript", "python" },
  --   },
}

-- Additional Plugins
lvim.plugins = {
  -- some other interesting colorschemes I'll probably never use
  { "folke/tokyonight.nvim" },
  { "shaunsingh/nord.nvim" },
  { "lunarvim/colorschemes" },
  { "olivercederborg/poimandres.nvim" },
  { "sainnhe/everforest" },
  { "owickstrom/vim-colors-paramount" },
  { "ChristianChiarulli/nvcode-color-schemes.vim" },
  -- { "RRethy/nvim-base16" },
  { "EdenEast/nightfox.nvim" },
  {
    "mcchrish/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim"
  },
  { "nvim-telescope/telescope-live-grep-args.nvim" },
  { "lewis6991/fileline.nvim" },
  -- ###############################
  -- NEORG SETUP
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require('neorg').setup {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                work = "~/notes/work"
              },
              default_workspace = "work"
            }
          }
        }
      }
    end
  },
  -- ###############################
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async"
  },
  {
    "phaazon/hop.nvim",
    branch = "v2",
    event = "BufRead",
    config = function()
      require("hop").setup()
    end,
  },
  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup {
        nextls = { enable = false },
        credo = { enable = true },
        elixirls = {
          enable = true,
          -- enable = true,
          settings = elixirls.settings {
            dialyzerEnabled = false,
            enableTestLenses = false,
          },
        }
      }
    end
  }
}

-- ###############################
-- HOP SETUP
keymap("n", "s", ":HopChar2<cr>", { silent = true })
keymap("n", "S", ":HopWord<cr>", { silent = true })
keymap("n", "s/", ":HopPattern<cr>", { silent = true })
-- ###############################

-- ################################
-- UFO SETUP
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

require("ufo").setup({
  open_fold_hl_timeout = 0,
  provider_selector = function(bufnr, filetype, buftype)
    return { "treesitter", "indent" }
  end,
})
-- ################################

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
