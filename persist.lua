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

  local properties_table = parse_properties_from_file(conf_path)
  local properties_changed = false

  for _, prop in ipairs(opts.props) do
    local value = mp.get_property(prop)
    if value and properties_table[prop] ~= value then
      mp.msg.debug(prop .. ": " .. (properties_table[prop] or "nil") .. " -> " .. value)
      properties_table[prop] = value
      properties_changed = true
    end
  end

  if not properties_changed then
    mp.msg.debug("No properties changed")
    return
  end

  write_properties_to_file(conf_path, properties_table)
end

local function load_properties()
  local conf_path = get_dir_conf_path()
  if not conf_path then return end

  local properties_table = parse_properties_from_file(conf_path)

  -- set the properties
  for key, value in pairs(properties_table) do
    mp.set_property(key, value)
  end

  mp.msg.info("Properties loaded")
end

for _, prop in ipairs(opts.props) do
  mp.observe_property(prop, "native", save_properties)
end

mp.register_event("start-file", function()
  -- MPV resets video/audio/sub track selection when:
  -- 1. Playing the next file on the playlist, and
  -- 2. The new file has a different track layout.
  -- To prevent writing these reset track selections to the configuration file, we suppress writing.
  -- References:
  -- https://mpv.io/manual/stable/#options-reset-on-next-file
  -- https://github.com/mpv-player/mpv/issues/13670
  -- https://github.com/mpv-player/mpv/blob/1bf821ebdc5c4775fe4bdbba994259c53463fc69/player/loadfile.c#L643
  suppress_write = true
end)

mp.register_event("file-loaded", function()
  suppress_write = false
  load_properties()
end)

mp.register_event("shutdown", save_properties)
