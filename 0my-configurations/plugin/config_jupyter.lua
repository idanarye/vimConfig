require'nvim_jupyter'.setup {
    render_html_as_image = false,
    keymaps = {
        run_current_cell = '<LocalLeader>rc',
        run_all = '<LocalLeader>ra',
        cancel_current_cell = '<LocalLeader>kc',
        interrupt_execution = '<LocalLeader>ka',
        run_cells_above = '<LocalLeader>ru',
        run_cells_below = '<LocalLeader>rd',
        add_cell_below = '<LocalLeader>bt',
        toggle_variable_explorer = '<LocalLeader>ve',
        toggle_local_variables = '<LocalLeader>lv',
        toggle_undo_tree = '<LocalLeader>ut',
        toggle_local_undo = '<LocalLeader>lu',
    },
}

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup('NvimJupyterMode', {clear = false}),
    pattern = "python",
    callback = function(args)
        if not vim.b[args.buf].is_jupyter then return end

        vim.keymap.set({'n', 'i'}, '<C-Cr>', require'nvim_jupyter.core'.run_current_cell, { buffer = args.buf, desc = "Run Jupyter cell" })
    end,
})
