local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  return
end

gitsigns.setup {
  signs = {
    -- add = { text = "", },
    -- add = { text = "", },
    add = { text = "", },
    -- add = { text = "", },
    change = { text = "", },
    delete = { text = "✗", },
    topdelete = { text = "", },
    changedelete = { text = "", },
  },
}

-- ============================================================================
-- Old "signs" configuration
--
-- add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
-- change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
-- delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
-- topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
-- changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },

-- add = { hl = "GitSignsAdd", text = "", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
-- change = { hl = "GitSignsChange", text = "", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
-- change = { hl = "GitSignsChange", text = "北", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
-- change = { hl = "GitSignsChange", text = "勞", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
-- delete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
-- delete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
