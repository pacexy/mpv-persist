-- mpv-persist.lua
local mp = require 'mp'
local options = require 'mp.options'
local utils = require 'mp.utils'

local opts = {
  props = { "volume", "sid" }
}

options.read_options(opts)

local suppress_write = false

local function get_conf_path()
  local path = mp.get_property("path")
  -- path is nil during loading file
  if not path then return end

  local dir_path = utils.split_path(path)
  return utils.join_path(dir_path, "mpv.conf")
end

-- Function to write options to a directory-specific config
local function write_options()
  if suppress_write then return end
  local conf_path = get_conf_path()
  if not conf_path then return end
  mp.msg.info("Saving options to " .. conf_path)

  -- Initialize options table
  local options_table = {}

  -- Check if the config file exists
  local file = io.open(conf_path, "r")
  if file then
    -- Read existing options
    for line in file:lines() do
      local key, value = line:match("([^=]+)=([^=]+)")
      if key and value then
        options_table[key] = value
      end
    end
    file:close()
  end

  -- Update options with current properties
  for _, prop in ipairs(opts.props) do
    local value = mp.get_property(prop)
    if value then
      options_table[prop] = value
    end
  end

  -- Write updated options back to the file
  file = io.open(conf_path, "w")
  if not file then
    mp.msg.error("Could not open file for writing: " .. conf_path)
    return
  end

  for key, value in pairs(options_table) do
    file:write(key .. "=" .. value .. "\n")
  end

  file:close()
end

-- Function to load options from a directory-specific config
local function load_options()
  local conf_path = get_conf_path()
  if not conf_path then return end
  mp.msg.info("Loading options from " .. conf_path)

  local file = io.open(conf_path, "r")
  if not file then
    mp.msg.warn("Could not open file for reading: " .. conf_path)
    return
  end

  for line in file:lines() do
    local key, value = line:match("([^=]+)=([^=]+)")
    if key and value then
      mp.set_property(key, value)
    end
  end

  file:close()
  mp.msg.info("Options loaded from " .. conf_path)
end

for _, prop in ipairs(opts.props) do
  mp.observe_property(prop, "native", write_options)
end

mp.register_event("start-file", function()
  suppress_write = true
end)

mp.register_event("file-loaded", function()
  suppress_write = false
  load_options()
end)

mp.register_event("shutdown", write_options)
