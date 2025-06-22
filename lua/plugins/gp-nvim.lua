-- lazy.nvim
return {
    "robitx/gp.nvim",
    config = function()
        local conf = {
            providers = {
                copilot = {
                    endpoint = "https://api.githubcopilot.com/chat/completions",
                    secret = {
                        "bash",
                        "-c",
                        "cat ~/.config/github-copilot/apps.json | sed -e 's/.*oauth_token...//;s/\".*//'",
                    },
                },
            },
            agents = { 
                {
                    name = "ChatGPT-o3-mini", -- standard agent name to disable
                    disable = true,
                },
                { 
                    provider = "copilot", 
                    name = "CodeCopilot", 
                    chat = false, 
                    command = true, 
                    -- string with model name or table with model name and parameters 
                    model = { model = "gpt-4o", temperature = 0.8, top_p = 1, n = 1 }, 
                    -- system prompt (use this to specify the persona/role of the AI) 
                    system_prompt = require("gp.defaults").code_system_prompt, 
                }, 
            }, 
            hooks = {
                UnitTests = function(gp, params)
                    local template = "I have the following c from {{filename}}:\n\n"
                    .. "```{{filetype}}\n{{selection}}\n```\n\n"
                    .. "Please respond by writing table driven unit tests for the code above."
                    -- local agent = gp.get_command_agent()
                    local agent = gp.get_command_agent("CodeCopilot")
                    gp.Prompt(params, gp.Target.vnew, agent, template)
                end,
            },
        }
        require("gp").setup(conf)

        vim.keymap.set("v", "<leader>gt", ":<C-u>'<,'>GpUnitTests<cr>", {desc="Generate unit tests for selection"})
    end,
}
