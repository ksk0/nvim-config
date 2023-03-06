local MODULES = {
  "user.initialize",

  "user.options",                -- done
  "user.keymaps",                -- done
  "user.completion",             -- done
  "user.project",                -- done

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
  "user.impatient",              -- done
  "user.indentline",             -- done
  "user.alpha",                  -- done
  "user.whichkey",               -- done (left for later)
  "user.autocommands",           -- done
  "user.debug",

  "user.options",                -- done
  "user.keymaps",                -- done
  "user.completion",             -- done
}

local timer = require("user.timer")
local pass  = timer.pass()
local total = timer.total()

pass()
total()

for _,module in ipairs(MODULES) do
  require(module)
end

total("Total load time")
