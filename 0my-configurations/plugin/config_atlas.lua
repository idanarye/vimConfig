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
                        name = 'My PRs',
                        key = '1',
                        search = 'author:@me sort:updated-desc',
                    },
                    {
                        name = 'Needs my review',
                        key = '2',
                        search = 'is:open is:pr review-requested:@me ',
                    },
                    {
                        name = 'Already reviewed',
                        key = '3',
                        search = 'is:open is:pr reviewed-by:@me -review:approved',
                    },
                },
            },
        },
    },
}
