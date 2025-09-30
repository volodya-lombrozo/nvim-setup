-- lazy.nvim
return {
  "robitx/gp.nvim",
  config = function()
    local text_selection = function(params)
      local file_contents = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
      local selection = ""
      if params.range ~= 0 then
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")
        local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
        selection = table.concat(lines, "\n")
      end
      local code_to_test = (selection ~= "") and selection or file_contents
      return code_to_test
    end

    local agent = function(gp)
      local res = gp.get_command_agent("CodeCopilot")
      return res
    end

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
          name = "ChatGPT-o3-mini",           -- standard agent name to disable
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
          local code_to_test = text_selection(params)
          local template
          local filetype = vim.bo.filetype
          if filetype == "go" then
            template = ""
                .. "I have the following Go code from {{filename}}:\n\n"
                .. "```go\n"
                .. code_to_test .. "\n"
                .. "```\n"
                ..
                "Please write a comprehensive set of unit tests for this code using the Go testing package and the testify library (use 'assert' and 'require').\n\n"
                ..
                "Focus on achieving high code coverage by testing all significant code paths, including edge cases and branching logic.\n"
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
          gp.Prompt(params, gp.Target.vnew, agent(gp), template)
        end,

        Implement = function(gp, params)
          local file_full = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
          local template  = "Here's code from {{filename}}:\n\n"
              .. "```{{filetype}}\n{{selection}}\n```\n\n"
              .. "Implement the missing parts as described in the comments.\n"
              .. "Do not repeat existing code — respond only with the new code."
              .. "Here's the full file content:\n\n"
              .. "```\n"
              .. file_full
              .. "\n```\n\n"
          gp.logger.info("Implementing selection with agent: " .. agent.name)
          gp.Prompt(
            params,
            gp.Target.vnew,
            agent(gp),
            template,
            nil,
            nil
          )
        end,

        Proofread = function(gp, params)
          local selection = text_selection(params)
          template = "Please review the following text for grammar, spelling, and fluency.\n"
              .. "Make improvements where necessary so it sounds natural and clear.\n"
              .. "Ensure the style is appropriate for technical writing.\n"
              .. "Respond only with the improved version.\n\n"
              .. "Text:\n\n"
              .. selection
              .. "\n"
          gp.Prompt(params, gp.Target.vnew, agent(gp), template)
        end,

        Explain = function(gp, params)
          local template = "Please explain the following code in detail.\n"
              .. "Focus on the purpose of each function and how they interact.\n"
              .. "Respond with a clear and concise explanation.\n\n"
              .. "Use 80 characters per line.\n\n"
              .. "Code:\n\n"
              .. "{{selection}}\n"
          gp.Prompt(params, gp.Target.vnew, agent(gp), template)
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

          -- Extract code to fix
          -- local file_contents = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
          local file_contents
          if params.range ~= 0 then
            local start_line = vim.fn.line("'<")
            local end_line = vim.fn.line("'>")
            local selected_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
            file_contents = table.concat(selected_lines, "\n")
          else
            file_contents = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
          end

          local template = "Please help me fix lint issues in this file.\n\n"
              .. "File content:\n"
              .. "```{{filetype}}\n" .. file_contents .. "\n```\n\n"
              .. "Linter output:\n"
              .. "```\n" .. diag_output .. "\n```"
          gp.Prompt(params, gp.Target.vnew, agent(gp), template)
        end,

        FixTests = function(gp, params)
          -- 1. Collect test output from Neotest (assumes output is in virtual text or messages)
          local neotest_ns = vim.api.nvim_get_namespaces()["neotest"]
          local bufnr = vim.api.nvim_get_current_buf()
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          local diags = vim.diagnostic.get(bufnr, { namespace = ns })
          local errors = {}
          for lnum = 0, #lines - 1 do
            local virt_text = vim.api.nvim_buf_get_extmarks(bufnr, neotest_ns, { lnum, 0 }, { lnum, -1 },
              { details = true, type = "virt_text" })
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
          gp.Prompt(params, gp.Target.vnew, agent(), template)
        end,

      },
    }
    require("gp").setup(conf)

    vim.keymap.set("v", "<leader>gt", ":<C-u>'<,'>GpUnitTests<cr>", { desc = "Generate unit tests for selection" })
    vim.keymap.set("n", "<leader>gt", ":<C-u>GpUnitTests<cr>", { desc = "Generate unit tests" })
    vim.keymap.set("v", "<leader>gi", ":<C-u>'<,'>GpImplement<cr>", { desc = "Generate implementation" })
    vim.keymap.set("v", "<leader>gp", ":<C-u>'<,'>GpProofread<cr>", { desc = "Find and correct mistakes in text" })
    vim.keymap.set("n", "<leader>gp", ":<C-u>GpProofread<cr>",
      { desc = "Find and correct mistakes in the entire text" })
    vim.keymap.set("n", "<leader>gf", ":GpFixTests<cr>", { desc = "Fix failing tests using AI" })
    vim.keymap.set("v", "<leader>gl", ":<C-u>'<,'>GpFixLints<cr>",
      { desc = "Send lint output to AI to fix selected text" })
    vim.keymap.set("n", "<leader>gl", ":GpFixLints<cr>", { desc = "Send lint output to AI and fix the entire file" })

    vim.keymap.set("v", "<leader>ge", ":<C-u>'<,'>GpExplain<cr>", { desc = "Explain selected code" })
    vim.keymap.set("n", "<leader>ge", ":GpExplain<cr>", { desc = "Explain the entire file" })
  end,
}
