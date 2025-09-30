function send_lint_to_copilot()
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

  require("gp").chat({
    prompt = "Help me fix the issues in this file based on linter output.\n\nFile contents:\n"
        .. file_contents .. "\n\nLinter output:\n" .. diag_output
  })
end
