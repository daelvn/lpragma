local ts = require("tableshape")
local S = ts.types.shape
local _Num = ts.types.number
local _NumOpt = _Num:is_optional()
local removePositions
removePositions = function(ast)
  for _index_0 = 1, #ast do
    local _continue_0 = false
    repeat
      local node = ast[_index_0]
      if (type(node)) ~= "table" then
        _continue_0 = true
        break
      end
      node[-1] = nil
      if (type(node)) == "table" then
        removePositions(node)
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  return ast
end
local checkShape
checkShape = function(ast)
  return function(shape)
    local results = { }
    for _index_0 = 1, #ast do
      local _continue_0 = false
      repeat
        local node = ast[_index_0]
        if (type(node)) ~= "table" then
          _continue_0 = true
          break
        end
        local res, err = shape(node)
        if res then
          table.insert(results, res)
        else
          print(err)
        end
        _continue_0 = true
      until true
      if not _continue_0 then
        break
      end
    end
    return results
  end
end
local deleteShape
deleteShape = function(ast)
  return function(shape)
    local newast = { }
    for i, node in pairs(ast) do
      local _continue_0 = false
      repeat
        if (type(node)) ~= "table" then
          _continue_0 = true
          break
        end
        local res, err = shape(node)
        if not (res) then
          table.insert(newast, node)
        end
        _continue_0 = true
      until true
      if not _continue_0 then
        break
      end
    end
    return newast
  end
end
local replaceShape
replaceShape = function(ast)
  return function(shape)
    return function(new)
      for i, node in pairs(ast) do
        local _continue_0 = false
        repeat
          if (type(node)) ~= "table" then
            _continue_0 = true
            break
          end
          local res, err = shape(node)
          if res then
            ast[i] = new
          else
            print(err)
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      return ast
    end
  end
end
local Ref
Ref = function(shape)
  return S({
    [-1] = _NumOpt,
    "ref",
    shape
  })
end
local Dot
Dot = function(shape)
  return S({
    [-1] = _NumOpt,
    "dot",
    shape
  })
end
local Length
Length = function(shape)
  return S({
    [-1] = _NumOpt,
    "length",
    shape
  })
end
local Call
Call = function(shape)
  return S({
    [-1] = _NumOpt,
    "call",
    shape
  })
end
local Chain
Chain = function(...)
  local chain = {
    [-1] = _NumOpt,
    "chain"
  }
  local shapes = {
    ...
  }
  for _index_0 = 1, #shapes do
    local shape = shapes[_index_0]
    table.insert(chain, shape)
  end
  return S(chain)
end
return {
  removePositions = removePositions,
  checkShape = checkShape,
  deleteShape = deleteShape,
  replaceShape = replaceShape,
  Ref = Ref,
  Length = Length,
  Call = Call,
  Chain = Chain,
  Dot = Dot
}
