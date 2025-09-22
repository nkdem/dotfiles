-- debug.lua
--
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
	-- NOTE: Yes, you can install new plugins here!
	"mfussenegger/nvim-dap",
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		-- Creates a beautiful debugger UI
		"rcarriga/nvim-dap-ui",

		-- Required dependency for nvim-dap-ui
		"nvim-neotest/nvim-nio",

		-- Installs the debug adapters for you
		"mason-org/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		-- Add your own debuggers here
		"leoluz/nvim-dap-go",
		"mfussenegger/nvim-dap-python",
	},
	keys = {
		-- Basic debugging keymaps, feel free to change to your liking!
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Start/Continue",
		},
		{
			"<F1>",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
		},
		{
			"<F2>",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
		},
		{
			"<F3>",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
		},
		{
			"<leader>b",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle Breakpoint",
		},
		{
			"<leader>B",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Set Breakpoint",
		},
		-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
		{
			"<F7>",
			function()
				require("dapui").toggle()
			end,
			desc = "Debug: See last session result.",
		},
		-- Python-specific keymaps
		{
			"<leader>dpr",
			function()
				require("dap-python").test_method()
			end,
			desc = "Debug: Python test method",
		},
		{
			"<leader>dpc",
			function()
				require("dap-python").test_class()
			end,
			desc = "Debug: Python test class",
		},
		{
			"<leader>ds",
			function()
				require("dap-python").debug_selection()
			end,
			desc = "Debug: Python selection",
			mode = "v",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("mason-nvim-dap").setup({
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				"delve",
				"debugpy", -- Python debugger
			},
		})

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup({
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})

		-- Change breakpoint icons
		-- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
		-- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
		-- local breakpoint_icons = vim.g.have_nerd_font
		--     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
		--   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
		-- for type, icon in pairs(breakpoint_icons) do
		--   local tp = 'Dap' .. type
		--   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
		--   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
		-- end

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- Install golang specific config
		require("dap-go").setup({
			delve = {
				-- On Windows delve must be run attached or it crashes.
				-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
				detached = vim.fn.has("win32") == 0,
			},
		})

		-- Python debugger setup
		-- Use the debugpy-adapter executable installed by uv tool
		local debugpy_adapter = vim.fn.system("which debugpy-adapter"):gsub("\n", "")

		if vim.fn.executable(debugpy_adapter) == 1 then
			-- Configure the adapter manually to use uv's debugpy
			require("dap").adapters.python = {
				type = "executable",
				command = debugpy_adapter,
				args = {},
			}

			-- Set up basic configurations since we're not using the setup() function
			require("dap").configurations.python = require("dap").configurations.python or {}
		else
			-- Fallback: install debugpy in system python and use normal setup
			print("debugpy-adapter not found. Install with: pip3 install debugpy")
			require("dap-python").setup("python3")
		end

		-- Optional: Configure Python debugging for different scenarios
		table.insert(dap.configurations.python, {
			type = "python",
			request = "launch",
			name = "Launch file (uv venv)",
			program = "${file}",
			python = vim.fn.getcwd() .. "/.venv/bin/python", -- Use project's virtual env
			console = "integratedTerminal",
		})

		table.insert(dap.configurations.python, {
			type = "python",
			request = "launch",
			name = "Launch file with arguments",
			program = "${file}",
			args = function()
				local args_string = vim.fn.input("Arguments: ")
				return vim.split(args_string, " ")
			end,
			console = "integratedTerminal",
		})

		-- Configuration for debugging Flask apps
		table.insert(dap.configurations.python, {
			type = "python",
			request = "launch",
			name = "Flask",
			module = "flask",
			args = {
				"run",
				"--no-debugger",
				"--no-reload",
			},
			jinja = true,
			console = "integratedTerminal",
		})

		-- Configuration for debugging Django apps
		table.insert(dap.configurations.python, {
			type = "python",
			request = "launch",
			name = "Django",
			program = "${workspaceFolder}/manage.py",
			args = {
				"runserver",
				"--noreload",
			},
			django = true,
			console = "integratedTerminal",
		})
	end,
}
