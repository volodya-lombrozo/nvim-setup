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
                    local filetype = vim.bo.filetype
                    local template 
                    if filetype == "go" then
                        template = ""
                        .. "I have the following Go code from {{filename}}:\n\n"
                        .. "```go\n"
                        .. "{{selection}}\n"
                        .. "```\n"
                        .. "Please write a comprehensive set of unit tests for this code using the Go testing package and the testify library (use 'assert' and 'require').\n\n"
                        .. "Focus on achieving high code coverage by testing all significant code paths, including edge cases and branching logic.\n"
                        .. "Use clear and descriptive test function names that indicate the behavior being tested.\n"
                        .. "Import \"github.com/stretchr/testify/require\".\n"
                        .. "Import \"github.com/stretchr/testify/assert\".\n"
                        .. "Assume the tests are written in the same package (do not use the '_test' package suffix).\n"
                        .. "Use single word names for variables in tests.\n"
                        .. "Use 't.TempDir()' to create temporary directories.\n"
                    else
                        template = "I have the following c from {{filename}}:\n\n"
                        .. "```{{filetype}}\n{{selection}}\n```\n\n"
                        .. "Please respond by writing table driven unit tests for the code above."
                    end
                    -- local agent = gp.get_command_agent()
                    local agent = gp.get_command_agent("CodeCopilot")
                    gp.Prompt(params, gp.Target.vnew, agent, template)
                end,

                Implement = function(gp, params) 
                    local template = "Here's code from {{filename}}:\n\n"
                    .. "```{{filetype}}\n{{selection}}\n```\n\n"
                    .. "Implement the missing parts as described in the comments.\n"
                    .. "Do not repeat existing code — respond only with the new code."

                    -- local agent = gp.get_command_agent() 
                    local agent = gp.get_command_agent("CodeCopilot")
                    gp.logger.info("Implementing selection with agent: " .. agent.name) 

                    gp.Prompt( 
                        params, 
                        gp.Target.vnew, 
                        agent, 
                        template, 
                        nil,
                        nil -- no predefined instructions (e.g. speech-to-text from Whisper) 
                    ) 
                end, 

                Proofread = function(gp, params)
                    template = "Please review the following text for grammar, spelling, and fluency.\n"
                    .. "Make improvements where necessary so it sounds natural and clear.\n"
                    .. "Ensure the style is appropriate for technical writing.\n" 
                    .. "Respond only with the improved version.\n\n"
                    .. "Text:\n\n"
                    .. "{{selection}}\n"
                    local agent = gp.get_command_agent("CodeCopilot")
                    gp.Prompt(params, gp.Target.vnew, agent, template)
                end,

            },
        }
        require("gp").setup(conf)

        vim.keymap.set("v", "<leader>gt", ":<C-u>'<,'>GpUnitTests<cr>", {desc="Generate unit tests for selection"})
        vim.keymap.set("v", "<leader>gi", ":<C-u>'<,'>GpImplement<cr>", {desc="Generate implementation"})
        vim.keymap.set("v", "<leader>gp", ":<C-u>'<,'>GpProofread<cr>", {desc="Find and correct mistakes in text before it is printed"})
    end,
}
