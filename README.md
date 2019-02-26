# lpragma
Pragmas implemented for MoonScript.

## What are pragmas?
Pragmas (from "pragmatic", dealing with things sensibly and realistically in a way that is based on practical rather than theoretical 
onsiderations.), or Directives, are rules that tell the compiler how the input should be processed. In MoonScript, this is implemented
through [transformers](https://github.com/leafo/moonscript/blob/master/docs/command_line.md#syntax-transformer).

## Installing
```
$ luarocks install lpragma
```

## Usage
```moon
import Pragma from require "lpragma"
```

## List of pragmas
### Pragma.IndexableStrings
Makes string variables be indexable.
```moon
Pragma.IndexableStrings
str     = "hai"
str[2] == "a"
```

### Pragma.Substrings
Makes string variables have a special substring syntax.
```moon
Pragma.Substrings
str        = "hai"
str (1,2) == "ha"
```

### Pragma.Curriable
[Curriable](https://github.com/planttheidea/curriable) library in Lua, availiable as the `curry` function.
```moon
Pragma.Curriable
f = (a, b, c) -> a + b + c
c = curry f
c _, 5, _
c 1, _, 3     == 9
```

### Pragma.FunctionalStd
All functions in `_G` modules are turned into top-level functions (coroutine.resume -> coResume)
```moon
Pragma.FunctionalStd
a = readIO!
```

### Pragma.FunctionalExtra
Provides extra functions like `map`, `foldl` or others.
```moon
Pragma.FunctionalExtra
map f, t
```

### Pragma.Export
Automatically exports all top-scope variables.
```moon
Pragma.Export
CONST = 5
f     = -> 3
-- Generates
CONST = 5
f     = -> 3
{ :CONST, :f }
```

### Pragma.DestructureImport
Doing `import all from t` in a table `t` generated without side effects will produce the following result:
```
-- (input.moon)
Pragma.DestructureImport
import all from require "library"
-- (library.moon)
{
  f: -> 3
}
-- (generated.moon)
{ :f } = require "library"
```
It can, indeed, be run on libraries with side effects. However, to obtain the indexes to do the destructuring, the library has to be
imported from the transformer (therefore, has to be run and also has to be in its path) as to iterate the resulting table.

### Pragma.PowerMetatables

> Conflicts with Pragma.HideDebug

Makes debug get/setmetatable functions be the default ones, so that they can be set to nil, booleans and numbers.
```moon
Pragma.PowerMetatables
setmetatable 4, __type: "number"
getmetatable 5
  == {__type: "number"}
```

### Pragma.Fenv51
Brings back setfenv and getfenv from Lua 5.1.
```moon
Pragma.Fenv51
getfenv f
setfenv f, {}
```

### Pragma.Bit52
Brings the bit32 library from Lua 5.2.
```moon
Pragma.Bit52
bit32.band 1, 1
```

### Pragma.RubySymbols
Ruby-like symbols for the top scope by abusing MoonScript's @-syntax.
```moon
Pragma.TopScopeSymbols
str = @hai
```

### Pragma.RubySemantics

> Depends on Pragma.PowerMetatables

Ruby-like semantics for MoonScript. Based in the [MakingLuaLikeRuby hack](http://lua-users.org/wiki/MakingLuaLikeRuby).
```moon
Pragma.RubySemantics
hash = Hash {x: 1, y: 2, z: 3}
hash\delete_if (k, v) -> k == "y"
hash\each      (k, v) -> print k, v
```

### Pragma.SilenceStdout
Redirects stdout so that nothing can't be printed.
```moon
Pragma.SilenceStdout
print 5 --
```

### Pragma.UnmutableGlobals
Makes `_G` not mutable.
```
Pragma.UnmutableGlobals
export x = 5 -- ERROR!
```

### Pragma.ContainGlobals
All new globals are redirected to `_C` instead of `_G` (proxy table).
```moon
Pragma.ContainGlobals
export   x = 5
print    x -- 5
print _G.x -- false
print _C.x -- 5
```

### Pragma.CompileTimeChecking
Complex, unspecified type checking by analizing the AST.

### Pragma.TransformMacros
Another unspecified pragma that would allow macros to be defined and inserted from the code itself (self-modifying).

### Pragma.LocalProxy
As specified in the [LuaHacks page](http://lua-users.org/wiki/LuaHacks), you can check all visible locals in a table `_L`.
```
Pragma.LocalProxy
x           = 5
print _L.x -- 5
```

### Pragma.Hide.\*
Hide any library from `_G`.
```moon
Pragma.Hide.String
string.sub "s", 1, 1 -- ERROR! Attempt to index nil
```
