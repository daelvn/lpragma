local removePositions
removePositions = require("lpragma.ast").removePositions
local inspect = require("inspect")
return function(ast)
  print(inspect(removePositions(ast)))
  return ast
end
