local ts = require("tableshape")
local inspect = require("inspect")
local Length, Chain, Ref, Call, removePositions, replaceShape, checkShape, deleteShape
do
  local _obj_0 = require("lpragma.ast")
  Length, Chain, Ref, Call, removePositions, replaceShape, checkShape, deleteShape = _obj_0.Length, _obj_0.Chain, _obj_0.Ref, _obj_0.Call, _obj_0.removePositions, _obj_0.replaceShape, _obj_0.checkShape, _obj_0.deleteShape
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
local IndexableStrings = {
  "assign",
  {
    {
      "chain",
      {
        "ref",
        "getmetatable"
      },
      {
        "call",
        {
          {
            "string",
            "'",
            ""
          }
        }
      },
      {
        "dot",
        "__index"
      }
    }
  },
  {
    {
      "fndef",
      {
        {
          "str"
        },
        {
          "i"
        }
      },
      { },
      "slim",
      {
        {
          "chain",
          {
            "ref",
            "string"
          },
          {
            "dot",
            "sub"
          },
          {
            "call",
            {
              {
                "ref",
                "str"
              },
              {
                "ref",
                "i"
              },
              {
                "ref",
                "i"
              }
            }
          }
        }
      }
    }
  }
}
local Substrings = {
  "assign",
  {
    {
      "chain",
      {
        "ref",
        "getmetatable"
      },
      {
        "call",
        {
          {
            "string",
            "'",
            ""
          }
        }
      },
      {
        "dot",
        "__call"
      }
    }
  },
  {
    {
      "fndef",
      {
        {
          "str"
        },
        {
          "i"
        },
        {
          "j"
        }
      },
      { },
      "slim",
      {
        {
          "chain",
          {
            "ref",
            "string"
          },
          {
            "dot",
            "sub"
          }
        }
      }
    }
  }
}
return function(ast)
  local actorReplace = replaceShape(ast);
  (actorReplace(Pragma("IndexableStrings")))(IndexableStrings);
  (actorReplace(Pragma("Substrings")))(Substrings)
  return ast
end
