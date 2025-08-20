require("lazy").setup({
	{ import = "plugins" },
{
   -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
},

},{
	dev = {
		-- reuse files from pkgs.vimPlugins.*
		path = "@lazy-plugins-store-path@",
		patterns = { "." },
		-- fallback to download
		fallback = true,
	},
})
