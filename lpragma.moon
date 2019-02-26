--> # lpragma
--> Pragmas implemented for MoonScript. This transformer provides the necessary tools for implementing pragmas.
-- By daelvn
-- 26.02.2019
ts      = require "tableshape"
inspect = require "inspect"
import
  Length, Chain, Ref, Call
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
IndexableStrings = {
  "assign"
  {{ "chain"
      { "ref", "getmetatable" }
      { "call", {{ "string", "'", "" }}}
      { "dot", "__index" }}}
  {{
    "fndef"
    {{ "str" }, { "i" }}
    {}
    "slim"
    {{ "chain"
      { "ref", "string" }
      { "dot", "sub" }
      { "call", {
          { "ref", "str" }
          { "ref", "i" }
          { "ref", "i" }}}}}}}}
--> ## Substrings
Substrings = {
  "assign"
  {{ "chain"
      { "ref", "getmetatable" }
      { "call", {{ "string", "'", "" }}}
      { "dot", "__call" }}}
  {{
    "fndef"
    {{ "str" }, { "i" }, { "j" }}
    {}
    "slim"
    {{ "chain"
      { "ref", "string" }
      { "dot", "sub" }}}}}}

--> # Transformer
--> The AST transformer.
(ast) ->
  actorReplace = replaceShape ast
  --
  (actorReplace Pragma "IndexableStrings") IndexableStrings
  (actorReplace Pragma "Substrings")       Substrings
  --
  ast
