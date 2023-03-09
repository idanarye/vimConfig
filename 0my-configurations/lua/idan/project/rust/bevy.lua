---@class IdanProjectRustBevyCfg : IdanProjectRustCfg

---@param cfg? IdanProjectRustBevyCfg
---@param cfg? IdanProjectRustBevyCfg
return function(T, cfg)
    cfg = cfg or {}
    if not cfg.extra_features_for_build_and_run then
        cfg.extra_features_for_build_and_run = {}
    end
    table.insert(cfg.extra_features_for_build_and_run, 'bevy/dynamic_linking')
    return require'idan.project.rust'(T, cfg)
end
