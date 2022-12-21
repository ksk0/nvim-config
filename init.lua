local modules = {
  "user.initialize",

  "user.options",                -- done
  "user.keymaps",                -- done
  "user.completion",             -- done

  "user.lsp",                    -- done
  "user.dap",                    -- done
  "user.telescope",              -- done
  "user.treesitter",             -- done
  "user.autopairs",              -- done
  "user.comment",                -- done
  "user.gitsigns",               -- done
  "user.nvim-tree",              -- done
  "user.bufferline",             -- done
  "user.lualine",                -- done
  "user.toggleterm",             -- done
  "user.project",                -- not in use
  "user.impatient",              -- done
  "user.indentline",             -- done
  "user.alpha",                  -- done
  "user.whichkey",               -- done (left for later)
  "user.autocommands",           -- done
  "user.testing",
  "user.runner",                 -- done
  "user.initialize",

  "user.options",                -- done
  "user.keymaps",                -- done
  "user.completion",             -- done

  -- "user.illuminate",          -- done (maybe later)
  -- "user.neo-tree",
  -- "user.flexy-files",
}

local timer = require("user.timer")
local pass  = timer.pass()
local total = timer.total()

pass()
total()


for _,module in ipairs(modules) do
  require(module)
end


vim.cmd [[command! -nargs=+ HH :vert help <args>]]

total("Total load time")
