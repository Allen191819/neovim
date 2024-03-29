vim.api.nvim_set_keymap("n", "RR", ":call CompileRunGccH()<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "Rf", ":call CompileRunGccF()<CR>", { silent = true, noremap = true })
vim.cmd([[
func! CompileRunGccH()
	exec "w"
	if &filetype == 'c'
		exec "!gcc % -o %< -g"
		:FloatermNew --position=bottom --wintype=split --height=0.35 time ./%<
	elseif &filetype == 'cpp'
		exec "!g++ -std=c++11 % -Wall -o %< -g"
		:FloatermNew --position=bottom --wintype=split --height=0.35 time ./%<
	elseif &filetype == 'rust'
		:RustRunnable
	elseif &filetype == 'java'
		:FloatermNew --position=bottom --wintype=split --height=0.35 javac % && java %<
	elseif &filetype == 'haskell'
		:FloatermNew --position=bottom --wintype=split --height=0.35 runhaskell %
    elseif &filetype == 'lua'
		:FloatermNew --position=bottom --wintype=split --height=0.35 lua %
	elseif &filetype == 'sh'
		:FloatermNew --position=bottom --wintype=split --height=0.35 bash %
	elseif &filetype == 'python'
		:FloatermNew --position=bottom --wintype=split --height=0.35 python3 %
	elseif &filetype == 'r'
		:FloatermNew --position=bottom --wintype=split --height=0.35 Rscript %
	elseif &filetype == 'markdown'
		:MarkdownPreviewToggle
	elseif &filetype == 'tex'
		:KnapToggle
	elseif &filetype == 'html'
		:KnapToggle
	elseif &filetype == 'javascript'
		:FloatermNew --position=bottom --wintype=split --height=0.35 export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
	elseif &filetype == 'go'
		:FloatermNew --position=bottom --wintype=split --height=0.35 go run %
	endif
endfunc
]])

vim.cmd([[
func! CompileRunGccF()
	exec "w"
	if &filetype == 'c'
		exec "!gcc % -o %< -g"
		:FloatermNew time ./%<
	elseif &filetype == 'cpp'
		exec "!g++ -std=c++11 % -Wall -o %< -g"
		:FloatermNew time ./%<
	elseif &filetype == 'rust'
		:FloatermNew cargo run
	elseif &filetype == 'java'
		:FloatermNew javac % && java %<
    elseif &filetype == 'lua'
		:FloatermNew lua %
	elseif &filetype == 'haskell'
		:FloatermNew runhaskell %
	elseif &filetype == 'sh'
		:FloatermNew bash %
	elseif &filetype == 'python'
		:FloatermNew python3 %
	elseif &filetype == 'r'
		:FloatermNew Rscript %
	elseif &filetype == 'markdown'
		:KnapToggle
	elseif &filetype == 'html'
		:KnapToggle
	elseif &filetype == 'tex'
		:KnapToggle
	elseif &filetype == 'javascript'
		:FloatermNew export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
	elseif &filetype == 'go'
		:FloatermNew go run %
	endif
endfunc

]])
