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
                        .. "Do not test inner methods of structs, only the public methods.\n"
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

                FixLints = function(gp, params)
                    local diagnostics = vim.diagnostic.get(0)
                    if #diagnostics == 0 then
                        print("No diagnostics found.")
                        return
                    end

                    local lines = {}
                    for _, d in ipairs(diagnostics) do
                        local msg = string.format("Line %d, Col %d: %s", d.lnum + 1, d.col + 1, d.message)
                        table.insert(lines, msg)
                    end

                    local diag_output = table.concat(lines, "\n")
                    local file_contents = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

                    local template = "Please help me fix lint issues in this file.\n\n"
                    .. "File content:\n"
                    .. "```{{filetype}}\n" .. file_contents .. "\n```\n\n"
                    .. "Linter output:\n"
                    .. "```\n" .. diag_output .. "\n```"

                    local agent = gp.get_command_agent("CodeCopilot")
                    gp.Prompt(params, gp.Target.vnew, agent, template)
                end,

                FixTests = function(gp, params)
                    -- 1. Collect test output from Neotest (assumes output is in virtual text or messages)
                    local neotest_ns = vim.api.nvim_get_namespaces()["neotest"]
                    local bufnr = vim.api.nvim_get_current_buf()
                    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

                    -- local neotest = require("neotest")
                    -- results = neotest.run.get_last_results()
                    local diags = vim.diagnostic.get(bufnr, { namespace = ns })
                    print("Neotest diagnostics: " .. vim.inspect(diags))

                    print("Neotest namespace ID: " .. tostring(neotest_ns))
                    print("Current buffer number: " .. tostring(bufnr))
                    print("Total lines in buffer: " .. tostring(#lines))
                    -- print("Neotest results: " .. vim.inspect(results))
                    -- Collect virtual text diagnostics that Neotest overlays
                    local errors = {}
                    for lnum = 0, #lines - 1 do
                        local virt_text = vim.api.nvim_buf_get_extmarks(bufnr, neotest_ns, {lnum, 0}, {lnum, -1}, { details = true, type = "virt_text" })
                        for _, mark in ipairs(virt_text) do
                            local chunks = mark[4].virt_text or {}
                            for _, chunk in ipairs(chunks) do
                                table.insert(errors, string.format("Line %d: %s", lnum + 1, chunk[1]))
                            end
                        end
                    end

                    if #errors == 0 then
                        print("No test errors found from Neotest.")
                        return
                    end

                    local diagnostics_str = table.concat(errors, "\n")
                    local file_contents = table.concat(lines, "\n")

                    local template = "I have the following test code from {{filename}}:\n\n"
                    .. "```\n" .. file_contents .. "\n```\n\n"
                    .. "The following are the test errors reported by my test runner:\n"
                    .. "```\n" .. diagnostics_str .. "\n```\n\n"
                    .. "Please adjust the tests to make them pass.\n"
                    .. "Fix only the test functions, not the implementation.\n"
                    .. "Respond with the modified test code only."

                    local agent = gp.get_command_agent("CodeCopilot")
                    gp.Prompt(params, gp.Target.vnew, agent, template)
                end,

            },
        }
        require("gp").setup(conf)

        vim.keymap.set("v", "<leader>gt", ":<C-u>'<,'>GpUnitTests<cr>", {desc="Generate unit tests for selection"})
        vim.keymap.set("v", "<leader>gi", ":<C-u>'<,'>GpImplement<cr>", {desc="Generate implementation"})
        vim.keymap.set("v", "<leader>gp", ":<C-u>'<,'>GpProofread<cr>", {desc="Find and correct mistakes in text before it is printed"})
        vim.keymap.set("n", "<leader>gf", ":GpFixTests<cr>", { desc = "Fix failing tests using AI" })
        vim.keymap.set("n", "<leader>gl", ":GpFixLints<cr>", { desc = "Send lint output to AI" }) 
    end,
}
