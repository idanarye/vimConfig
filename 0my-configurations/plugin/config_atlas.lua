require'atlas'.setup {
    providers = (function()
        local result = {
            github = {
                hostname = "github.com",
            },
        }
        if IdanLocalCfg.configure_atlas_providers then
            IdanLocalCfg.configure_atlas_providers(result)
        end
        return result
    end)(),
    pulls = {
        github = {
            views = {
                {
                    name = 'My PRs',
                    key = '1',
                    search = 'author:@me sort:updated-desc',
                    current_repo = true,
                },
                {
                    name = 'Needs my review',
                    key = '2',
                    search = 'is:open is:pr review-requested:@me ',
                    current_repo = true,
                },
                {
                    name = 'Already reviewed',
                    key = '3',
                    search = 'is:open is:pr reviewed-by:@me -review:approved',
                    current_repo = true,
                },
                {
                    name = 'All open PRs',
                    key = '4',
                    search = 'is:open is:pr',
                    current_repo = true,
                },
            },
        },
    },
    issues = {
        github = {
            views = {
                {
                    name = "Assigned",
                    key = "1",
                    layout = "plain",
                    current_repo = true,
                    search = "assignee:@me is:open",
                },
                {
                    name = "Created",
                    key = "2",
                    layout = "compact",
                    current_repo = true,
                    search = "author:@me is:open",
                },
                {
                    name = "All open",
                    key = "3",
                    layout = "compact",
                    current_repo = true,
                    search = "is:open",
                },
            },
        },
    },
}
