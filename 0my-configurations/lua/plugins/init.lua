local my_configurations_dir = debug.getinfo(1, 'S').source:sub(2)
for _ = 1, 3 do
    my_configurations_dir = vim.fs.dirname(my_configurations_dir)
end
local plugins = {
    {dir = my_configurations_dir, priority=60},
}
vim.list_extend(plugins, require'plugins/all_plugins')
return plugins
