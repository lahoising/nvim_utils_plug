local deb = {}

local vimspectorPython = [[
{
  "configurations": {
    "<name>: Launch": {
      "adapter": "debugpy",
      "configuration": {
        "name": "Python: Launch",
        "type": "python",
        "request": "launch",
        "python": "%s",
        "stopOnEntry": true,
        "console": "externalTerminal",
        "debugOptions": [],
        "program": "${file}"
      }
    }
  }
}
]]

local vimspectorCpp = [[
{
	"configurations": {
		"Launch": {
			"adapter": "vscode-cpptools",
			"filetypes": [ "cpp", "c", "objc", "rust" ],
			"configuration": {
				"request": "launch",
				"program": "${workspaceRoot}/build/app",
				"cwd": "${workspaceRoot}/build",
				"externalConsole": true,
				"MIMode": "gdb"
			}
		}
}
}
]]

function deb.generateDebugProfile()
    -- Get current file type
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(buf, "filetype")

	local generate_file = function (debugProfile)
        -- Generate debug profile in a new window
        vim.api.nvim_exec('vsp', true)
        local win = vim.api.nvim_get_current_win()
        local bufNew = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_buf_set_name(bufNew, ".vimspector.json")
        vim.api.nvim_win_set_buf(win, bufNew)

        lines = {}
        for s in debugProfile:gmatch("[^\r\n]+") do
            table.insert(lines, s)
        end
        vim.api.nvim_buf_set_lines(bufNew, 0, -1, false, lines)
	end

    if ft == "python" then
        -- Get Python path
        local python3 = vim.fn.exepath("python")
        local debugProfile = string.format(vimspectorPython, python3)
		generate_file(debugProfile)

	elseif ft == "cpp" then
		local debugProfile = string.format(vimspectorCpp)
		generate_file(debugProfile)
    else
        print("Unsupported language!")
    end

end

return deb
