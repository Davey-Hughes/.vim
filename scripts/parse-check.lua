-- Parse (but do not run) the Lua file passed as the first argument.
-- Exits non-zero with the parse error on stderr. Used by lua-syntax-check.sh.

local chunk, err = loadfile(arg[1])
if not chunk then
  io.stderr:write(tostring(err), "\n")
  os.exit(1)
end
