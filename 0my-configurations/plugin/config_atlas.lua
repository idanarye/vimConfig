require'atlas'.setup {
    issues = {
        providers = (function()
            local result = {}
            if IdanLocalCfg.configure_atlas_providers then
                IdanLocalCfg.configure_atlas_providers(result)
            end
            return result
        end)(),
    },
    pulls = {
        providers = {
            github = {
                views = {
                    {
                        name = "My PRs",
                        key = "1",
                        search = "author:@me sort:updated-desc",
                    },
                },
            },
        },
    },
}
