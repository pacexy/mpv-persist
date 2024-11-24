-- mpv-persist.lua
local mp = require 'mp'
local options = require 'mp.options'

-- Define default options
local opts = {
  props = { "volume", "sid" }
}

-- Read options from the config file
options.read_options(opts)

-- Function to write options to a file-specific config
local function write_options()
  local path = mp.get_property("path")
  if not path then return end

  local conf_path = path .. ".conf"
  local file = io.open(conf_path, "w")
  if not file then
    mp.msg.error("Could not open file for writing: " .. conf_path)
    return
  end

  for _, prop in ipairs(opts.props) do
    local value = mp.get_property(prop)
    if value then
      file:write(prop .. "=" .. value .. "\n")
    end
  end

  file:close()
  mp.msg.info("Options saved to " .. conf_path)
end

-- Observe property changes
for _, prop in ipairs(opts.props) do
  mp.observe_property(prop, "number", write_options)
end

-- Save options on shutdown
mp.register_event("shutdown", write_options)
