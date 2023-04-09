" Jaxon Haws
" Vim: set fdm=marker fmr={{{,}}} fdl=0 fdls=-1:

"  Colors {{{
syntax on                       " turn on syntax processing
set background=dark             " darkmode
" }}}

" Lang and Encoding {{{
set encoding=utf-8                  " set encoding to utf-8
let $LANG='en'                      " set LANG var to english
set langmenu=en                     " set language to english
set autoread                        " update vim when file is changed from outside
" }}}

" UI Layout {{{
set ruler 
set cursorline
set relativenumber
" Use Bash-esque file completion.
set wildmode=longest:full,full
set wildmenu
set lazyredraw
set showmatch
set showcmd
set cmdheight=1
" }}}

" Searching {{{
set ignorecase
set smartcase
set incsearch
set hlsearch
set magic
" }}}

" Spaces, Tabs, and Indents {{{
set tabstop=3
set softtabstop=3
set expandtab smarttab
set shiftwidth=3
set autoindent smartindent
set fileformat=unix
" ...except with Python since it's not C-like and comments get messed up...
autocmd FileType python
               \ setlocal nosmartindent indentexpr=GetPythonIndent(v:lnum)
" ...and, of course, we need tabs in Makefiles.
autocmd Filetype make setlocal noexpandtab
" Use two-space indents for CSS, HTML, JavaScript.
autocmd FileType css,html,javascript setlocal ts=2 sts=2 sw=2
" Allow backspacing over autoindents, newlines, and start of insert.
set backspace=indent,eol,start
" }}}

" Line Shoftcuts {{{
" Apparently some other people don't keep their lines under 80 chars.
inoremap <Up> <C-o>g<Up>
nnoremap <Up> g<Up>
nnoremap j gj
vnoremap <Up> g<Up>
vnoremap j gj
inoremap <Down> <C-o>g<Down>
nnoremap <Down> g<Down>
nnoremap k gk
vnoremap <Down> g<Down>
vnoremap k gk
" }}}

" Shortcuts/Disableds {{{
" Disabled {{{
" Turn off Shift+U; it's too easy to hit accidentally.
nmap U <Nop>
" noremap <Up> <nop>
" noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
"}}}
"}}}

"  Folding {{{  
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent
set modeline
set modelines=2

nnoremap <space> za

" au BufWinLeave * mkview " Breaks telescope for some reason
au BufWinEnter * silent! loadview
" }}} 

" Persistent History {{{
" Persist undo history across sessions.
if has('persistent_undo')
    let undo_dir = expand('$HOME/.config/nvim/undo_dir')
    if !isdirectory(undo_dir)
        call mkdir(undo_dir, "", 0700)
    endif
    set undodir=$HOME/.config/nvim/undo_dir
    set undofile
endif
" }}}

" Vim Plug {{{
call plug#begin(expand('~/.vim/pluged'))
Plug 'arcticicestudio/nord-vim'
Plug 'EdenEast/nightfox.nvim'
Plug 'neoclide/coc.nvim', { 'branch': 'master', 'do': 'yarn install --frozen-lockfile' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
call plug#end() 
colorscheme nordfox
" }}}

" Coc.nvim {{{
 "if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" }}}

" Telescope keybinds {{{
" Find files using Telescope command-line sugar.
nnoremap <c-f> <cmd>Telescope find_files<cr>
nnoremap <c-g> <cmd>Telescope live_grep<cr>
nnoremap <c-b> <cmd>Telescope buffers<cr>
nnoremap <c-s> <cmd>Telescope git_status<cr>
nnoremap <silent> gh :call CocActionAsync('doHover')<CR>

" }}}

" Treesitter Inline Lua {{{
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = { "c", "cpp", "java", "latex", "python", "go" },

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  -- ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = { "latex" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
" }}}
