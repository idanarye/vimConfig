if executable("rg")
    set grepprg=rg\ --vimgrep
    set grepformat=%f:%l:%c:%m,%f:%l:%m,%f
endif
