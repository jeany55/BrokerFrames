-- Addon namespace
local _, private = ...

-- Generate a short 8 digit UUID
private.generateUuid = function() return format("%04x%04x", random(0, 0xFFFF), random(0, 0xFFFF)) end

-- Deep copy a table
private.copy = function(obj, seen)
  if type(obj) ~= 'table' then
    return obj
  end
  if seen and seen[obj] then
    return seen[obj]
  end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do
    res[private.copy(k, s)] = private.copy(v, s)
  end
  return res
end
