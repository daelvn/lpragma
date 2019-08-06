local ts = require("tableshape")
local inspect = require("inspect")
local parseString
parseString = require("moonscript.parse").string
local Length, Chain, Ref, Call, LengthT, ChainT, RefT, CallT, DotT, removePositions, replaceShape, checkShape, deleteShape
do
  local _obj_0 = require("lpragma.ast")
  Length, Chain, Ref, Call, LengthT, ChainT, RefT, CallT, DotT, removePositions, replaceShape, checkShape, deleteShape = _obj_0.Length, _obj_0.Chain, _obj_0.Ref, _obj_0.Call, _obj_0.LengthT, _obj_0.ChainT, _obj_0.RefT, _obj_0.CallT, _obj_0.DotT, _obj_0.removePositions, _obj_0.replaceShape, _obj_0.checkShape, _obj_0.deleteShape
end
local _Str = ts.types.string
local S = ts.types.shape
local pragma_S = Length(Chain((Ref("Pragma")), (Call(S({
  Ref(_Str:tag("pragma"))
})))))
local Pragma
Pragma = function(pragma)
  return Length(Chain((Ref("Pragma")), (Call(S({
    Ref(pragma)
  })))))
end
local IndexableStrings = parseString([[getmetatable''.__index = (str, i) -> string.sub str, i, i]])
local Substrings = parseString([[getmetatable''.__call = string.sub]])
local PowerMetatables = parseString([[--
getmetatable = debug.getmetatable
setmetatable = debug.setmetatable
]])
return function(ast)
  local actorReplace = replaceShape(ast);
  (actorReplace(Pragma("IndexableStrings")))(IndexableStrings);
  (actorReplace(Pragma("Substrings")))(Substrings);
  (actorReplace(Pragma("PowerMetatables")))(PowerMetatables)
  return ast
end
