local my_plugins_dir = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))
local my_configurations_dir = vim.fn.fnamemodify(my_plugins_dir, ':h:h')
local plugins = {
    {dir = my_configurations_dir, priority=60},
}
for filename, inodetype in vim.fs.dir(my_plugins_dir) do
    if inodetype == 'file' and filename ~= 'init.lua' and vim.endswith(filename, '.lua') then
        local submodule_name = 'plugins.' .. vim.fn.fnamemodify(filename, ':r')
        vim.list_extend(plugins, require(submodule_name))
    end
end
return plugins
