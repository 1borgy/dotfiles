local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local t = ls.text_node
local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

return {
  s("cm", {
    t({
      "def __enter__(self) -> Self:",
      -- TODO: insert node
      "    self._obj.__enter__()",
      "    return self",
      "",
      "def __exit__(",
      "    self,",
      "    exc_type: type[BaseException] | None,",
      "    exc_val: BaseException | None,",
      "    exc_tb: TracebackType | None,",
      "    /,",
      ") -> None:",
      "    self._obj.__exit__(exc_type, exc_val, exc_tb)",
    }),
  }),
  s("main", {
    t({
      'if __name__ == "__main__":',
      "    ",
    }),
  }),
}
