require'neorg'.setup {
    load = {
        ['core.defaults'] = {};
        ['core.norg.dirman'] = {
            config = {
                workspaces = {
                    work = '~/.neorg/work',
                    home = '~/.neorg/home',
                };
            };
        };
        ["core.norg.journal"] = {
        };
        ['core.gtd.base'] = {
            config = {
                workspace = 'work';
            }
        };
        ['core.norg.concealer'] = {};
        ['core.norg.completion'] = {
            config = {
                engine = 'nvim-cmp';
            };
        };
        ['core.norg.qol.toc'] = {};
        ['core.norg.manoeuvre'] = {};
    }
}

local mkcmd = function(args)
    return function()
        vim.cmd('Neorg ' .. args)
    end
end

vim.keymap.set('n', '<M-r><M-r>', mkcmd(''))
vim.keymap.set('n', '<M-r>j', mkcmd('journal'))

vim.keymap.set('n', '<M-r>w', function()
    local dirman = require'neorg'.modules.get_module('core.norg.dirman')
    if dirman == nil then
        return
    end
    require'fzf-lua'.fzf_exec(dirman.get_workspace_names(), {
        actions = {
            ['default'] = function(selected)
                local workspace = selected[1]
                vim.cmd('Neorg workspace ' .. workspace)
            end;
        };
        fzf_opts = {
            ["--no-multi"]  = '';
        };
    })
end)
