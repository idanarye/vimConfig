local moonicipal = require'moonicipal'

return function()
    local P, cfg = require'idan.project.rust'()
    table.insert(cfg.extra_features_for_build_and_run, 'bevy/dynamic_linking')
    ---@type string?
    cfg.pkv_app_name = nil

    local T = moonicipal.tasks_lib()

    function cfg.setup_level_editor()
        local idan_rust = require'idan.rust'

        local function get_game_executable_name()
            return idan_rust.jq_cargo_metadata('.packages[].name')
        end

        function T:go()
            P:_simple_target_runner()(get_game_executable_name(), '--editor')
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
            P:_simple_target_runner()(get_game_executable_name(), '--level', level)
        end
    end

    function cfg.setup_pkv(pkv_app_name)
        function T:erase_save()
            vim.cmd('!rm -Rf ~/.local/share/' .. vim.fn.tolower(pkv_app_name))
        end
    end

    return moonicipal.merge_libs(T, P), cfg
end
