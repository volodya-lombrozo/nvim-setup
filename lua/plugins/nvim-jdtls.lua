return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local jdtls = require("jdtls")
      local root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1])
      local config = {
        cmd = { "/Users/lombrozo/Workspace/OpenSource/eclipse.jdt.ls/jdt/bin/jdtls" },
        root_dir = root_dir,
      }
      jdtls.start_or_attach(config)
    end,

  },
}
