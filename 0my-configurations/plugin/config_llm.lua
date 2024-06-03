for _, prompt in pairs(require'ollama.prompts') do
    local change_action_to = ({
        replace = 'display_replace',
        insert = 'display_insert',
    })[prompt.action or false]
    if change_action_to then
        prompt.action = change_action_to
    end
end

local ollama = require'ollama'
ollama.setup {
    model = 'codegemma',
}

local ck = require'caskey'
ck.setup {
    mode = {'n', 'v'},
    name = 'LLM',
    ['<M-a>'] = {
        -- Ollama
        ['<M-a>'] = {
            act = ollama.prompt,
            desc = 'Ollama.nvim Choose action',
        },
        ['a'] = {
            act = ':<C-u>lua require"ollama".prompt("Ask_About_Code")<Cr>',
            desc = 'Ollama.nvim Ask_About_Code',
        },
        ['g'] = {
            act = ':<C-u>lua require"ollama".prompt("Generate_Code")<Cr>',
            desc = 'Ollama.nvim Generate_Code',
        },
        ['m'] = {
            act = ':<C-u>lua require"ollama".prompt("Modify_Code")<Cr>',
            desc = 'Ollama.nvim Modify_Code',
        },
        ['e'] = {
            act = ':<C-u>lua require"ollama".prompt("Explain_Code")<Cr>',
            desc = 'Ollama.nvim Explain_Code',
        },
        ['s'] = {
            act = ':<C-u>lua require"ollama".prompt("Simplify_Code")<Cr>',
            desc = 'Ollama.nvim Simplify_Code',
        },

        -- Oatmeal
        ['o'] = {
            act = require'oatmeal'.start,
            desc = 'Start Oatmeal session',
        },

        -- GPTModels
        ['c'] = {
            act = ck.cmd'GPTModelsCode',
            desc = 'Run GPTModelsCode',
        },
        ['h'] = {
            act = ck.cmd'GPTModelsChat',
            desc = 'Run GPTModelsChat',
        },
    },
}
