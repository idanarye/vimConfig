local moonicipal = require'moonicipal'

return function()
    local cfg = {
    }

    local T = moonicipal.tasks_lib()

    function T:ci_step_to_run()
        local cc = self:cached_choice {
            key = 'name',
            format = 'name',
            preview = function(step)
                return step.code
            end,
        }
        local workflows_dir = '.github/workflows'
        for workflow_file in vim.fs.dir(workflows_dir) do
            if vim.endswith(workflow_file, '.yml') or vim.endswith(workflow_file, '.yaml') then
                local yaml_lines = vim.fn.readfile(vim.fs.joinpath(workflows_dir, workflow_file))
                local workflow_data = require'ryaml'.load(table.concat(yaml_lines, '\n'))
                for job_name, job_data in pairs(workflow_data.jobs) do
                    for step_idx, step in ipairs(job_data.steps) do
                        if step.name and step.run then
                            cc {
                                workflow_file = workflow_file,
                                job_name = job_name,
                                step_idx = step_idx,
                                step_name = step.name,
                                name = table.concat({
                                    workflow_file,
                                    job_name,
                                    'step-' .. step_idx,
                                    step.name
                                }, ':'),
                                code = step.run,
                            }
                        end
                    end
                end
            end
        end
        return cc:select()
    end

    function T:run_step_from_ci()
        local step = T:ci_step_to_run() or moonicipal.abort()
        require'channelot'.windowed_terminal_job{'bash', '-ce', step.code}
    end

    return T, cfg
end
