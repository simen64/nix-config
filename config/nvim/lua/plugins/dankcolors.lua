return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#121412',
				base01 = '#1f201f',
				base02 = '#343534',
				base03 = '#464745',
				base04 = '#c7c6c4',
				base05 = '#e3e2e0',
				base06 = '#e3e2e0',
				base07 = '#30312f',
				base08 = '#ffb4ab',
				base09 = '#b5ccbb',
				base0A = '#c7c6c4',
				base0B = '#bacbbe',
				base0C = '#c0c9c0',
				base0D = '#bacbbe',
				base0E = '#c0c9c0',
				base0F = '#ffb4ab',
			})

			local function set_hl_mutliple(groups, value)
				for _, v in pairs(groups) do vim.api.nvim_set_hl(0, v, value) end
			end

			vim.api.nvim_set_hl(0, 'Visual',
				{ bg = '#3c4a40', fg = '#d6e7d9', bold = true })
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#464745' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#bacbbe', bold = true })

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"

			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()

				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)

					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("󰂖 Matugen: Colors reloaded!")
					end
				end))
			end
		end
	}
}
