local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
	return
end

require("ibl").setup({

  -- use_treesitter = true,
  -- show_current_context = true,

  -- not working as expected
  --
  -- use_treesitter_scope = true,

  indent = {
  	char = "▏",
  },

  -- show_trailing_blankline_indent = false,
  --
  whitespace = {
	  remove_blankline_trail = true,
  },


  exclude = {
     filetypes = {
    	"help",
    	"startify",
    	"dashboard",
    	"packer",
    	"neogitstatus",
    	"NvimTree",
    	"Trouble",
    	"lspinfo",
    	"checkhealth",
    	"man",
    	"text",
    	"-",
  	},
  },

  -- context_patterns = {
  --   "class",
  --   "return",
  --   "function",
  --   "method",
  --   "^if",
  --   "^while",
  --   "jsx_element",
  --   "^for",
  --   "^object",
  --   "^table",
  --   "block",
  --   "arguments",
  --   "if_statement",
  --   "else_clause",
  --   "jsx_element",
  --   "jsx_self_closing_element",
  --   "try_statement",
  --   "catch_clause",
  --   "import_statement",
  --   "operation_type",
  -- },
})
