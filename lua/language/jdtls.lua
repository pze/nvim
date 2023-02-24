local ok, jdtls = pcall(require, "jdtls")
if not ok then
  vim.notify "Could not load jdtls"
  return
end

local ok, mason = pcall(require, "mason-registry")
if not ok then
  vim.notify "Could not load mason-registry"
  return
end

local default = require "language.default"

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = { mason.get_package("jdtls"):get_install_path() .. "/bin/jdtls" },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew" },

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {},
  },

  capabilities = default.capabilities,

  on_attach = default.on_attach,

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {},
  },
}

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "java",
  callback = function()
    -- This starts a new client & server,
    -- or attaches to an existing client & server depending on the `root_dir`.
    jdtls.start_or_attach(config)
  end,
})
