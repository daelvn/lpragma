--> # lpragma
--> This transformer prints the inspected version of the AST.
-- By daelvn
-- 26.02.2019
import removePositions from require "lpragma.ast"
inspect = require "inspect"

(ast) ->
  print inspect removePositions ast
  return ast
