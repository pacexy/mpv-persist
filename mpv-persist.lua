-- mpv-persist.lua
local mp = require 'mp'
local options = require 'mp.options'

-- Define default options
local opts = {
  volume = 100,
  brightness = 0,
  contrast = 0,
  saturation = 0,
  gamma = 0
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

  file:write("volume=" .. mp.get_property("volume") .. "\n")
  file:write("brightness=" .. mp.get_property("brightness") .. "\n")
  file:write("contrast=" .. mp.get_property("contrast") .. "\n")
  file:write("saturation=" .. mp.get_property("saturation") .. "\n")
  file:write("gamma=" .. mp.get_property("gamma") .. "\n")

  file:close()
  mp.msg.info("Options saved to " .. conf_path)
end

-- Observe property changes
mp.observe_property("volume", "number", write_options)
mp.observe_property("brightness", "number", write_options)
mp.observe_property("contrast", "number", write_options)
mp.observe_property("saturation", "number", write_options)
mp.observe_property("gamma", "number", write_options)

-- Save options on shutdown
mp.register_event("shutdown", write_options)
