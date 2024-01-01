local tinyyaml = require("tinyyaml")
local config = require("config")
local io = require("io")

local data_yml_handle = io.open(config.data_yml, "r")
if not data_yml_handle then
  print("data.yml not found: " .. config.data_yml)
  return
end
local data_yml_raw = data_yml_handle:read("*a")
data_yml_handle:close()

---@class DataYML
---@field globals table<string, string>
---@field classes table<string, DataYMLClass>

---@class DataYMLClass
-- Nullable of "ea" and "pointer"
---@field instances DataYMLClassInstance[]?

---@class DataYMLClassInstance
---@field ea number
---@field pointer number?

---@type DataYML
local data_yml = tinyyaml.parse(data_yml_raw)

local class_instances = {}

for name, data in pairs(data_yml.classes) do
  if data.instances and #data.instances > 0 then
    -- Just take the first instance for now
    class_instances[name] = data.instances[1]
  end
end

local rva = 0x140000000
local module = "ffxiv_dx11.exe"

---@return Process?, ProcessModule?
local function get_ffxiv()
  local process = regenny:process()
  if not process then
    return nil, nil
  end

  local ffxiv = process:get_module(module)
  if not ffxiv then
    return nil, nil
  end

  return process, ffxiv
end

---@param bang string
---@param str string
---@return string?
local function read_bang(bang, str)
  local prefix = bang .. "!"
  if str:sub(1, #prefix) == prefix then
    return str:sub(#prefix + 1)
  end
end

regenny:add_address_resolver(function(str)
  local instance_bang = read_bang("instance", str)
  if instance_bang then
    local instance = class_instances[instance_bang]

    if instance then
      local offset = instance.ea - rva
      local process, module = get_ffxiv()

      if process and module then
        local addr = module.start + offset

        if instance.pointer then
          return process:read_uint64(addr)
        else
          return addr
        end
      end
    end
  end
end)
