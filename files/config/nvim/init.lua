require("packer").startup(function()
	use("wbthomason/packer.nvim")
	use({
		"kdheepak/monochrome.nvim",
		config = function()
			vim.g.monochrome_style = "photon"
			vim.cmd("colorscheme monochrome")
		end,
	})
	use({ "nvim-treesitter/nvim-treesitter", config = "vim.cmd[[TSUpdate]]" })
	use("neovim/nvim-lspconfig")
	use("mhartington/formatter.nvim")
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("editorconfig/editorconfig-vim")
	use("airblade/vim-gitgutter")
	use("scrooloose/nerdcommenter")
	use("tpope/vim-surround")
	use("tpope/vim-fugitive")
	use("tpope/vim-rhubarb")
	use("valloric/matchtagalways")
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
end)

vim.g.monochrome_style = "photon"
vim.cmd("colorscheme monochrome")

vim.cmd([[
" Turn on syntax
syntax on
" Turn on filetype plugins
filetype plugin on

" Eslint fix on save
autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll

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
vim.opt.colorcolumn = "80"
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
vim.opt.cursorline = true
vim.opt.mouse = "a"

require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	sync_install = false,
	highlight = {
		enable = true,
	},
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

vim.g.mta_filetypes = {
	["javascript.jsx"] = 1,
	javascript = 1,
	typescript = 1,
	typescriptreact = 1,
	html = 1,
	xhtml = 1,
	xml = 1,
	jinja = 1,
	lua = 1,
}

vim.cmd([[
map <C-_> <leader>c<space>
map <C-\> <leader>c<space>
]])
vim.g.NERDSpaceDelims = 1
vim.g.NERDDefaultAlign = "left"
vim.g.NERDCommentEmptyLines = 1
vim.g.NERDTrimTrailingWhitespace = 1

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
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
	"eslint",
	"tsserver",
}
for _, lsp in pairs(servers) do
	require("lspconfig")[lsp].setup({
		on_attach = on_attach,
		flags = {
			-- This will be the default in neovim 0.7+
			debounce_text_changes = 150,
		},
	})
end

require("telescope").load_extension("fzf")

require("formatter").setup({
	filetype = {
		javascript = {
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
		},
		typescript = {
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
		},
		typescriptreact = {
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
		},
		rust = {
			function()
				return {
					exe = "rustfmt",
					args = { "--emit=stdout", "--edition=2021" },
					stdin = true,
				}
			end,
		},
		json = {
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
		},
		lua = {
			-- sytlua
			function()
				return {
					exe = "stylua",
					stdin = false,
				}
			end,
		},
	},
})

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require("neo-tree").setup({
	close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
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
			folder_empty = "[empty]",
			default = "",
		},
		modified = {
			symbol = "+",
			highlight = "NeoTreeModified",
		},
		name = {
			trailing_slash = false,
			use_git_status_colors = true,
		},
		git_status = {
			symbols = {
				-- Change type
				added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
				modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
				deleted = "", -- this can only be used in the git_status source
				renamed = "", -- this can only be used in the git_status source
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
			hide_by_name = {
				".DS_Store",
				"thumbs.db",
				--"node_modules"
			},
			never_show = { -- remains hidden even if visible is toggled to true
				--".DS_Store",
				--"thumbs.db"
			},
		},
		follow_current_file = true, -- This will find and focus the file in the active buffer every
		-- time the current file is changed while the tree is open.
		hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
		-- in whatever position is specified in window.position
		-- "open_current",  -- netrw disabled, opening a directory opens within the
		-- window like netrw would, regardless of window.position
		-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
		use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
		-- instead of relying on nvim autocmd events.
		window = {
			mappings = {
				["<bs>"] = "navigate_up",
				["."] = "set_root",
				["H"] = "toggle_hidden",
				["/"] = "fuzzy_finder",
				["f"] = "filter_on_submit",
				["<c-x>"] = "clear_filter",
			},
		},
	},
	buffers = {
		show_unloaded = true,
		window = {
			mappings = {
				["bd"] = "buffer_delete",
				["<bs>"] = "navigate_up",
				["."] = "set_root",
			},
		},
	},
	git_status = {
		window = {
			position = "float",
			mappings = {
				["A"] = "git_add_all",
				["gu"] = "git_unstage_file",
				["ga"] = "git_add_file",
				["gr"] = "git_revert_file",
				["gc"] = "git_commit",
				["gp"] = "git_push",
				["gg"] = "git_commit_and_push",
			},
		},
	},
})

vim.cmd([[nnoremap \ :Neotree reveal<cr>]])

vim.api.nvim_exec(
	[[
augroup FormatAutogroup
autocmd!
autocmd BufWritePost *.js,*.ts,*.tsx,*.rs,*.lua FormatWrite
augroup END
]],
	true
)

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

hi StatusLine guibg=#262626
hi VertSplit guibg=#262626
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
