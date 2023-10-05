local lib_status_ok, litee_lib = pcall(require, "litee.lib")
if not lib_status_ok then
	return
end

local call_status_ok, litee_calltree = pcall(require, "litee.calltree")
if not call_status_ok then
	return
end

-- configure the litee.nvim library
litee_lib.setup({})
-- configure litee-calltree.nvim
litee_calltree.setup({})
