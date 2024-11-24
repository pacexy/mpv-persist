-- mpv-persist.lua
local mp = require 'mp'
local options = require 'mp.options'
local utils = require 'mp.utils'

local opts = {
  props = {
    "volume",
    "sid",
    "sub-delay",
    "secondary-sid",
    "secondary-sub-delay"
  }
}

options.read_options(opts)

local suppress_write = false

local function get_dir_conf_path()
  local path = mp.get_property("path")
  -- path is nil during loading file
  if not path then return end

  local dir_path = utils.split_path(path)
  return utils.join_path(dir_path, "mpv.conf")
end

local function parse_properties_from_file(conf_path)
  local properties_table = {}
  local file = io.open(conf_path, "r")
  if file then
    for line in file:lines() do
      local key, value = line:match("([^=]+)=([^=]+)")
      if key and value then
        properties_table[key] = value
      end
    end
    file:close()
  end
  return properties_table
end

local function write_properties_to_file(conf_path, properties_table)
  local file = io.open(conf_path, "w")
  if not file then
    mp.msg.error("Could not open file for writing: " .. conf_path)
    return
  end
  for key, value in pairs(properties_table) do
    file:write(key .. "=" .. value .. "\n")
  end
  file:close()
end


local function save_properties()
  if suppress_write then return end
  local conf_path = get_dir_conf_path()
  if not conf_path then return end
  mp.msg.info("Saving options to " .. conf_path)

  local properties_table = parse_properties_from_file(conf_path)

  -- merge the properties
  for _, prop in ipairs(opts.props) do
    local value = mp.get_property(prop)
    if value then
      properties_table[prop] = value
    end
  end

  write_properties_to_file(conf_path, properties_table)
end

local function load_properties()
  local conf_path = get_dir_conf_path()
  if not conf_path then return end
  mp.msg.info("Loading options from " .. conf_path)

  local properties_table = parse_properties_from_file(conf_path)

  -- set the properties
  for key, value in pairs(properties_table) do
    mp.set_property(key, value)
  end

  mp.msg.info("Options loaded from " .. conf_path)
end

for _, prop in ipairs(opts.props) do
  mp.observe_property(prop, "native", save_properties)
end

mp.register_event("start-file", function()
  suppress_write = true
end)

mp.register_event("file-loaded", function()
  suppress_write = false
  load_properties()
end)

mp.register_event("shutdown", save_properties)
