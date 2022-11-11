local M = {}

-- =======================================================================
-- Setup of LSP diagnostic (called by "setup" function)
--
local function diagnostic_setup()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- floating_text = true,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = false,
    underline = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)
end


-- =======================================================================
-- If particular language server supports "document_highlight"
-- capabilitie, activate the "service" with autocommands:
--
--     CursorHold    (after a while highlight document)
--     CursorMoved   (when cursor moves, clear highlights)
--
local function lsp_highlight_document(client)
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end


-- =======================================================================
-- keymap definition for LSP capabilites, we attach them to the particular
-- buffer, to avoid attaching it to "non editing" bufffers (like nvim-tree).
--
local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  keymap(bufnr, "n", "gR", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
  keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
  keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts)
  keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
  keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
  keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
end

-- =======================================================================
-- This is common setup for all LSP servers. It should be called only once.
--
M.setup = function()

  diagnostic_setup()

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end


-- =======================================================================
-- Setup function which will be run when client/server is attached to
-- buffer.
--
M.on_attach = function(client, bufnr)

  -- if there is custom configuration for given client/server
  -- then execute server specific "on_attach" function (if it
  -- exists)
  --
	local custom_config, server_config = pcall(require, "user.lsp.settings." .. client.name)

	if custom_config and server_config.on_attach then
     server_config.on_attach (client)
	end

  lsp_keymaps(bufnr)

  -- configuration of highlighting has been transfared to "illuminate" plugin
  --
  lsp_highlight_document(client)
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

-- =======================================================================
-- If "cmn-nvim-lsp" plugin is present than also "cmp-nvim" is present
-- (plugin providing comletion). We have to to advertise completition
-- capabilitie to every LSP server, thus we have to extend list of
-- capabilities.
--
-- This is done by simply calling "update_capabilities" function
-- of "cmp-nvim-lsp" plugin.
--
local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return M
end

-- M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

return M
