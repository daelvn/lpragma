getmetatable('').__index = function(str, i)
  return string.sub(str, i, i)
end
hi()
getmetatable('').__call = function(str, i, j)
  return string.sub
end
