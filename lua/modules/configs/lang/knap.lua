return function()
	local gknapsettings = {
		-- html
		htmloutputext = "html",
		htmltohtml = "none",
		htmltohtmlviewerlaunch = "live-server --quiet --browser=chromium --open=%outputfile% --watch=%outputfile% --wait=800",
		htmltohtmlviewerrefresh = "none",
		-- markdown
		mdoutputext = "pdf",
		mdtopdf = "pandoc --pdf-engine=xelatex --highlight-style ~/.config/nvim/color/adam.theme --template ~/.config/nvim/color/eisvogel.tex -H ~/.config/nvim/color/head.tex -V CJKmainfont='Noto Serif CJK SC' %docroot% -o %outputfile%",
		mdtopdfviewerlaunch = "zathura %outputfile%",
		mdtopdfviewerrefresh = "kill -HUP %pid%",
		markdownoutputext = "pdf",
		markdowntopdf = "pandoc --pdf-engine=xelatex --highlight-style ~/.config/nvim/color/adam.theme --template ~/.config/nvim/color/eisvogel.tex -H ~/.config/nvim/color/head.tex -V CJKmainfont='Noto Serif CJK SC' %docroot% -o %outputfile%",
		markdowntopdfviewerlaunch = "zathura %outputfile%",
		markdowntopdfviewerrefresh = "kill -HUP %pid%",
		-- latex
		texoutputext = "pdf",
		textopdf = "xelatex -interaction=batchmode -halt-on-error -synctex=1 %docroot%",
		textopdfviewerlaunch = "zathura --synctex-editor-command 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%{input}'\"'\"',%{line},0)\"' %outputfile%",
		textopdfviewerrefresh = "none",
		textopdfforwardjump = "zathura --synctex-forward=%line%:%column%:%srcfile% %outputfile%",
		textopdfshorterror = 'A=%outputfile% ; LOGFILE="${A%.pdf}.log" ; rubber-info "$LOGFILE" 2>&1 | head -n 1',
		delay = 250,
	}
	vim.g.knap_settings = gknapsettings
	vim.api.nvim_create_user_command("KnapOpen", require("knap").process_once, {})
	vim.api.nvim_create_user_command("KnapClose", require("knap").close_viewer, {})
	vim.api.nvim_create_user_command("KnapToggle", require("knap").toggle_autopreviewing, {})
	vim.api.nvim_create_user_command("KnapJump", require("knap").forward_jump, {})
end
