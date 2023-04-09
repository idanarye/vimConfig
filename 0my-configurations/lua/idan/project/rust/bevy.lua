---@class IdanProjectRustBevyCfg : IdanProjectRustCfg
---@field level_editor? boolean
---@field pkv_app_name? string

---@param cfg? IdanProjectRustBevyCfg
return function(T, cfg)
    cfg = cfg or {}
    if not cfg.extra_features_for_build_and_run then
        cfg.extra_features_for_build_and_run = {}
    end
    table.insert(cfg.extra_features_for_build_and_run, 'bevy/dynamic_linking')
    T = require'idan.project.rust'(T, cfg)

    if cfg.level_editor then
        local idan_rust = require'idan.rust'

        local function get_game_executable_name()
            return idan_rust.jq_cargo_metadata('.packages[].name')
        end

        function T:go()
            T:_simple_target_runner()(get_game_executable_name(), '--editor')
        end
        
        T{alias = ':3'}
        function T:pick_level()
            local cc = self:cached_choice {
                key = function(level) return level end,
            }
            for filename in vim.fs.dir('assets/levels') do
                if vim.endswith(filename, '.yol') then
                    cc(filename:sub(1, -5))
                end
            end
            return cc:select()
        end

        function T:execute()
            local level = T:pick_level() or require'moonicipal'.abort()
            T:_simple_target_runner()(get_game_executable_name(), '--level', level)
        end
    end

    if cfg.pkv_app_name then
        function T:erase_save()
            vim.cmd('!rm -Rf ~/.local/share/' .. vim.fn.tolower(cfg.pkv_app_name))
        end
    end

    return T
end
