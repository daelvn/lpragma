--> # lpragma
--> AST navigation utils
-- By daelvn
-- 26.02.2019
ts = require "tableshape"

-- Shortcuts
S       = ts.types.shape
_Num    = ts.types.number
_NumOpt = _Num\is_optional!

--> # removePositions
--> Removes all -1 indexes from the AST.
removePositions = (ast) ->
  for node in *ast
    continue if (type node) != "table"
    node[-1] = nil
    if (type node) == "table"
      removePositions node
  --
  return ast

--> # checkShape
--> Checks a shape with all tables and returns all correct results in a table.
checkShape = (ast) -> (shape) ->
  results = {}
  for node in *ast
    continue if (type node) != "table"
    res, err = shape node
    table.insert results, res if res else print err
  --
  return results

--> # deleteShape
--> Deletes a shape in an AST
deleteShape = (ast) -> (shape) ->
  newast = {}
  for i, node in pairs ast
    continue if (type node) != "table"
    res, err = shape node
    table.insert newast, node unless res
  --
  return newast

--> # replaceShape
--> Replaces the shape with a table
replaceShape = (ast) -> (shape) -> (new) ->
  for i, node in pairs ast
    continue if (type node) != "table"
    res, err = shape node
    ast[i] = new if res else print err
  --
  return ast

--> # AST Table builders
RefT     = (x) -> { "ref",    x }
DotT     = (x) -> { "dot",    x }
LengthT  = (x) -> { "length", x }
CallT    = (x) -> { "call",   x }
ChainT   = (...) ->
  chain = { "chain" }
  args  = {...}
  for arg in *args
    table.insert chain, arg
  --
  chain

--> # AST Shape builders
Ref    = (shape) -> S { [-1]: _NumOpt, "ref",    shape }
Dot    = (shape) -> S { [-1]: _NumOpt, "dot",    shape }
Length = (shape) -> S { [-1]: _NumOpt, "length", shape }
Call   = (shape) -> S { [-1]: _NumOpt, "call",   shape }
Chain  = (...)   ->
  chain  = { [-1]: _NumOpt, "chain" }
  shapes = {...}
  for shape in *shapes do table.insert chain, shape
  --
  S chain

-- Return
{
  :removePositions
  :checkShape, :deleteShape, :replaceShape
  :Ref, :Length, :Call, :Chain, :Dot
  :RefT, :LengthT, :CallT, :ChainT, :DotT
}
