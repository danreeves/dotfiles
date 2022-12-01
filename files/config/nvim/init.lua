require("packer").startup(function()
	use("wbthomason/packer.nvim")
	use("axvr/photon.vim")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("neovim/nvim-lspconfig")
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
	})
	use("editorconfig/editorconfig-vim")
	use("airblade/vim-gitgutter")
	use("tpope/vim-surround")
	use("tpope/vim-fugitive")
	use("tpope/vim-rhubarb")
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
	})
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/nvim-cmp")
	use("L3MON4D3/LuaSnip")
	use("wesQ3/vim-windowswap")
	use("jose-elias-alvarez/null-ls.nvim")
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("j-hui/fidget.nvim")
end)

vim.o.background = "light"

vim.cmd([[
set termguicolors
" Turn on syntax
syntax on
" Turn on filetype plugins
filetype plugin on

colorscheme antiphoton

" Set the cursor back to a vertical bar on exit
autocmd VimLeave * set guicursor=a:ver1-blinkon1

" Try to autoload files that have changed on the file system
autocmd BufEnter,FocusGained * checktime

" FixWhitespace function taken from bronson/vim-trailing-whitespace
function! s:FixWhitespace(line1,line2)
let l:save_cursor = getpos(".")
silent! execute ':' . a:line1 . ',' . a:line2 . 's/\\\@<!\s\+$//'
call setpos('.', l:save_cursor)
endfunction

" Run :FixWhitespace to remove end of line white space
command! -range=% FixWhitespace call <SID>FixWhitespace(<line1>,<line2>)

" Fix whitespace on save
au BufWritePre * :FixWhitespace
]])

vim.opt.updatetime = 100
-- vim.opt.colorcolumn = "80"
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.backspace = "2"
vim.opt.backupcopy = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf-8"
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.laststatus = 2
vim.opt.list = true
vim.opt.listchars = {
	tab = "  ", -- two characters
	trail = "·",
	nbsp = "·",
}
vim.opt.ruler = true
vim.opt.scrolloff = 5
vim.opt.showcmd = true
vim.opt.smartcase = true
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.cursorline = false
vim.opt.mouse = "a"

-- lsp status widget
require"fidget".setup{}

require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	ignore_install = { "phpdoc" },
	sync_install = false,
	highlight = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
	},
})

require("Comment").setup({
	sticky = false,
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})

local opts = { noremap = true, silent = true }

vim.cmd([[
" Tabs
noremap <Leader>e :tabnew<CR>
noremap <Leader>w :tabclose<CR>
noremap <Leader>1 1gt
noremap <Leader>2 2gt
noremap <Leader>3 3gt
noremap <Leader>4 4gt
noremap <Leader>5 5gt
noremap <Leader>6 6gt
noremap <Leader>7 7gt
noremap <Leader>8 8gt
noremap <Leader>9 9gt
]])

vim.cmd([[
" Alias :gh to :GBrowse
cnoreabbrev gh GBrowse
]])

vim.keymap.set("n", "<C-\\>", "<Plug>(comment_toggle_linewise_current)")
vim.keymap.set("v", "<C-\\>", "<Plug>(comment_toggle_linewise_visual)")

vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>Telescope find_files<cr>", opts)
vim.api.nvim_set_keymap("n", "<C-f>", "<cmd>Telescope live_grep<cr>", opts)

vim.api.nvim_set_keymap("n", "<C-n>", "<cmd>Neotree toggle<cr>", opts)

vim.api.nvim_set_keymap("n", "g<bs>", "<cmd>noh<cr>", opts)

vim.api.nvim_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gtD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gtd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gtr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	if client.server_capabilities.document_highlight then
		vim.cmd([[
		hi! LspReferenceRead cterm=underline gui=underline
		hi! LspReferenceText cterm=underline gui=underline
		hi! LspReferenceWrite cterm=underline gui=underline
		augroup lsp_document_highlight
		autocmd! * <buffer>
		autocmd! CursorHold <buffer> lua vim.lsp.buf.document_highlight()
		autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		augroup END
		]])
	end
end

vim.cmd([[autocmd! ColorScheme * highlight NormalFloat]])
vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=white]])

local border = {
	{ "🭽", "FloatBorder" },
	{ "▔", "FloatBorder" },
	{ "🭾", "FloatBorder" },
	{ "▕", "FloatBorder" },
	{ "🭿", "FloatBorder" },
	{ "▁", "FloatBorder" },
	{ "🭼", "FloatBorder" },
	{ "▏", "FloatBorder" },
}

-- LSP settings (for overriding per client)
local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

local lspc = require("lspconfig")
lspc.eslint.setup({
	on_attach = on_attach,
	handlers = handlers,
	root_dir = lspc.util.root_pattern("package.json"),
})
lspc.tsserver.setup({
	on_attach = on_attach,
	handlers = handlers,
	root_dir = lspc.util.root_pattern("tsconfig.json"),
})
lspc.denols.setup({
	on_attach = on_attach,
	handlers = handlers,
	root_dir = lspc.util.root_pattern("deno.json"),
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")
null_ls.setup({
	-- add deno.json to root dir file matching so i can have subfolders be deno projects in advent of code
	root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git", "deno.json"),
	sources = {
		null_ls.builtins.formatting.deno_fmt.with({
			condition = function(utils)
				return utils.root_has_file({ "deno.json" })
			end,
		}),
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.eslint_d.with({
			condition = function(utils)
				return not utils.root_has_file({ "deno.json" })
			end,
		}),
		null_ls.builtins.formatting.prettier.with({
			condition = function(utils)
				return not utils.root_has_file({ "deno.json" })
			end,
		}),
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.crystal_format,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						bufnr = bufnr,
						filter = function(client)
							-- Prefer deno_fmt over denols
							return client.name ~= "denols"
						end,
					})
				end,
			})
		end
	end,
})

require("telescope").load_extension("fzf")
local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<esc>"] = actions.close,
			},
		},
	},
})

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[
let g:neo_tree_remove_legacy_commands = 1
]])

require("neo-tree").setup({
	close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = false,
	use_popups_for_input = false,
	default_component_configs = {
		indent = {
			indent_size = 2,
			padding = 0, -- extra padding on left hand side
			-- indent guides
			with_markers = true,
			indent_marker = "│",
			last_indent_marker = "└",
			highlight = "NeoTreeIndentMarker",
			-- expander config, needed for nesting files
			with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
			expander_collapsed = "",
			expander_expanded = "",
			expander_highlight = "NeoTreeExpander",
		},
		icon = {
			folder_closed = "▶",
			folder_open = "▼",
			folder_empty = "▼ [empty]",
			default = " ",
		},
		modified = {
			symbol = "+",
			-- highlight = "NeoTreeModified",
		},
		name = {
			trailing_slash = true,
			use_git_status_colors = false,
		},
		git_status = {
			symbols = {
				-- Change type
				added = "+",
				modified = "~",
				deleted = "-",
				renamed = "~",
				-- Status type
				untracked = "",
				ignored = "",
				unstaged = "",
				staged = "",
				conflict = "",
			},
		},
	},
	window = {
		position = "left",
		width = 40,
		mappings = {
			["<space>"] = "none",
			["<space>"] = "open",
			["S"] = "open_split",
			["s"] = "open_vsplit",
			["t"] = "open_tabnew",
			["C"] = "close_node",
			["a"] = "add",
			["A"] = "add_directory",
			["d"] = "delete",
			["r"] = "rename",
			["y"] = "copy_to_clipboard",
			["x"] = "cut_to_clipboard",
			["p"] = "paste_from_clipboard",
			["c"] = "copy", -- takes text input for destination
			["m"] = "move", -- takes text input for destination
			["q"] = "close_window",
			["R"] = "refresh",
		},
	},
	nesting_rules = {},
	filesystem = {
		filtered_items = {
			visible = false, -- when true, they will just be displayed differently than normal items
			hide_dotfiles = true,
			hide_gitignored = true,
			hide_by_name = {},
			never_show = {},
		},
		async_directory_scan = false,
		follow_current_file = true,
		hijack_netrw_behavior = "disabled",
		use_libuv_file_watcher = false,
		window = {
			mappings = {
				["<bs>"] = "navigate_up",
				["."] = "set_root",
				["H"] = "toggle_hidden",
				["/"] = "",
				["f"] = "",
				["<c-x>"] = "",
			},
		},
	},
})

local cmp = require("cmp")
local luasnip = require("luasnip")

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})

vim.cmd([[
set statusline=
set statusline+=%f
set statusline+=%{&modified?\"\ +\":\"\"}
set statusline+=%{&readonly?\"\ [Read\ Only]\":\"\"}
set statusline+=%=
set statusline+=%{FugitiveHead()}

hi TabLineFill guifg=White guibg=White
hi TabLine guifg=DarkGrey guibg=None
hi TabLineSel guifg=Default guibg=None

set fillchars+=vert:\ 

function! Tabline()
let s = ''
for i in range(tabpagenr('$'))
	let tab = i + 1
	let winnr = tabpagewinnr(tab)
	let buflist = tabpagebuflist(tab)
	let bufnr = buflist[winnr - 1]
	let bufname = bufname(bufnr)
	let bufmodified = getbufvar(bufnr, "&mod")

	let s .= '%' . tab . 'T'
	let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
	let s .= (bufname != '' ? '[ ' . tab .': ' . fnamemodify(bufname, ':t') : '[ ' . tab .': No Name')

	if bufmodified
		let s .= ' + ]'
	else
		let s .= ' ]'
		endif
		endfor

		let s .= '%#TabLineFill#'
		if (exists("g:tablineclosebutton"))
			let s .= '%=%999XX'
			endif
			return s
			endfunction
			set tabline=%!Tabline()
			]])

vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.showmode = false
vim.opt.secure = true
