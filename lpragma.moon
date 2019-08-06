--> # lpragma
--> Pragmas implemented for MoonScript. This transformer provides the necessary tools for implementing pragmas.
-- By daelvn
-- 26.02.2019
ts                    = require "tableshape"
inspect               = require "inspect"
{string: parseString} = require "moonscript.parse"
import
  Length, Chain, Ref, Call
  LengthT, ChainT, RefT, CallT, DotT
  removePositions
  replaceShape, checkShape, deleteShape
from require "lpragma.ast"

-- Shortcuts
_Str = ts.types.string
S    = ts.types.shape

--> # pragma_S
--> The shape for a pragma declaration.
pragma_S = Length Chain (Ref "Pragma"), (Call S{ Ref _Str\tag "pragma"})

--> # Pragma
--> Pragma generator
Pragma = (pragma) -> Length Chain (Ref "Pragma"), (Call S{ Ref pragma })

--> # Pragmas
--> List of pragmas.
--> ## IndexableStrings
-- IndexableStrings = {
--   "assign"
--   {{ "chain"
--       Ref  "getmetatable"
--       Call {{ "string", "'", "" }}
--       Dot  "__index" }}
--   {{
--     "fndef"
--     {{ "str" }, { "i" }}
--     {}
--     "slim"
--     {{ "chain"
--       Ref "string"
--       Dot "sub"
--       Call {
--           Ref "str"
--           Ref "i"
--           Ref "i" }}}}}}
IndexableStrings = parseString [[getmetatable''.__index = (str, i) -> string.sub str, i, i]]
--> ## Substrings
--Substrings = {
--  "assign"
--  {{ "chain"
--      Ref  "getmetatable"
--      Call {{ "string", "'", "" }}
--      Dot "__call" }}
--  {{
--    "fndef"
--    {{ "str" }, { "i" }, { "j" }}
--    {}
--    "slim"
--    {{ "chain"
--      Ref "string"
--      Dot "sub"}}}}}
Substrings = parseString [[getmetatable''.__call = string.sub]]
--> ## PowerMetatables
--PowerMetatables = {
--  {
--    "assign"
--    {{ "chain"
--       Ref "getmetatable" }}
--    {{ "chain"
--       Ref "debug"
--       Dot "getmetatable" }}
--  }
--  {
--    "assign"
--    {{ "chain"
--       Ref "setmetatable" }}
--    {{ "chain"
--       Ref "debug"
--       Dot "setmetatable" }}
--  }
--}
PowerMetatables = parseString [[--
getmetatable = debug.getmetatable
setmetatable = debug.setmetatable
]]

--> # Transformer
--> The AST transformer.
(ast) ->
  actorReplace = replaceShape ast
  --
  (actorReplace Pragma "IndexableStrings") IndexableStrings
  (actorReplace Pragma "Substrings")       Substrings
  (actorReplace Pragma "PowerMetatables")  PowerMetatables
  --
  ast
