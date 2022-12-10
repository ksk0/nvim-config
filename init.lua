require "user.initialise"

require "user.bricks"                 -- done
require "user.options"                -- done
require "user.plugins"                -- done

require "user.notify"                 -- done
require "user.keymaps"                -- done
require "user.colorscheme"            -- done
require "user.completion"             -- done

-- require "user.illuminate"             -- done (maybe later)
require "user.lsp"                    -- done
require "user.dap"                    -- done
require "user.telescope"              -- done
require "user.treesitter"             -- done
require "user.autopairs"              -- done
require "user.comment"                -- done
require "user.gitsigns"               -- done
require "user.nvim-tree"              -- done
require "user.bufferline"             -- done
require "user.lualine"                -- done
require "user.toggleterm"             -- done
require "user.project"                -- not in use
require "user.impatient"              -- done
require "user.indentline"             -- done
require "user.alpha"                  -- done
require "user.whichkey"               -- done (left for later)
require "user.autocommands"           -- done
require "user.runner".setup()         -- done

-- require "user.neo-tree"
-- require "user.flexy-files"

vim.cmd [[command! -nargs=+ HH :vert help <args>]]
