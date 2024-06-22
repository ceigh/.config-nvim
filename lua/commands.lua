---@param cmd string
local function make_cmd_caseins(cmd)
  ---@param name string
  local function create_cmd(name)
    vim.api.nvim_create_user_command(name, cmd, { bang = true })
  end

  create_cmd(cmd:upper())                         -- all
  create_cmd(cmd:sub(1, 1):upper() .. cmd:sub(2)) -- first
  -- TODO: every char
end

for _, c in ipairs({
  "q",
  "qa",
  "wq",
  "wqa",
}) do make_cmd_caseins(c) end
