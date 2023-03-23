local M = {}

function M.jq_cargo_metadata(query)
    local output = vim.fn.system('cargo metadata --no-deps --offline --format-version=1 | jq ' .. vim.fn.shellescape(query))
    return vim.json.decode(output)
end

function M.jq_all_bin_targets()
    return M.jq_cargo_metadata'.packages | map(.targets[] | select(.crate_types[] == "bin" and .kind[] != "test"))'
end

function M.flags_to_run_target(target)
    if vim.tbl_contains(target.kind, 'bin') then
        return {'--bin', target.name}
    elseif vim.tbl_contains(target.kind, 'example') then
        return {'--example', target.name}
    else
        error('Does not know how to run target of kind ' .. vim.inspect(target.kind))
    end
end

function M.get_rustup_lib_path()
    local rustup_home = vim.fn.systemlist{'rustup', 'show', 'home'}[1]
    local toolchain = vim.split(vim.fn.system{'rustup', 'show', 'active-toolchain'}, ' ')[1]
    return ('%s/toolchains/%s/lib'):format(rustup_home, toolchain)
end

return M
