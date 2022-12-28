local vim_config_path = vim.fs.dirname(debug.getinfo(1, 'S').short_src)
vim.env.MYVIMRC = vim_config_path .. '/_vimrc'
vim.api.nvim_command('source $MYVIMRC')

local localcfg_fn = loadfile(vim.fs.dirname(vim_config_path) .. '/localcfg.lua')
local localcfg
if localcfg_fn then
  localcfg = localcfg_fn()
else
  localcfg = {}
end

local lazy_dev_patterns = {}
do
    local f = io.open('.git/config')
    if f then
      local pattern = vim.regex[=[\V\^\s\*url = git@github.com:\zsidanarye/\.\+.git\$]=]
      for line in f:lines() do
        local s, e = pattern:match_str(line)
        if s then
          table.insert(lazy_dev_patterns, line:sub(s + 1, e))
        end
      end
      f:close()
    end
end


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)
require'lazy'.setup(require'plugins', {
  dev = {
    path = '/files/oss',
    patterns = lazy_dev_patterns,
  },
  install = {
    colorscheme = {'torte'},
  },
  performance = {
    rtp = {
      paths = {
         vim_config_path .. '/0my-configurations',
         unpack(localcfg.runtime_paths or {}),
      },
    },
  }
})

vim.cmd.colorscheme('tortus')
