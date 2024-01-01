---@meta

---@class ProcessModule
---@field name string
---@field start string
---@field end string
---@field size string

---@class Process
local Process = {}

---@param name string
---@return ProcessModule?
function Process:get_module(name) end

---@param addr number
---@return number
function Process:read_uint64(addr) end

---@class regenny
regenny = {}

---@param func fun(str: string): number | nil
---@return number
function regenny:add_address_resolver(func) end

---@param id number
function regenny:remove_address_resolver(id) end

---@return Process?
function regenny:process() end
