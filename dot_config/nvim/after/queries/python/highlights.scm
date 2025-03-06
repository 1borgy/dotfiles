;; extends

; Raw strings
(assignment
  left: (identifier) @variable_name
  right: (string (string_content) @injection.content)
  (#any-of? @variable_name "pattern" "regex_pattern")
  (#set! injection.language "regex"))

; Module docstring
(module . (expression_statement (string) @comment))

; Class docstring
(class_definition
  body: (block . (expression_statement (string) @comment)))

; Function/method docstring
(function_definition
  body: (block . (expression_statement (string) @comment)))

; Attribute docstring
((expression_statement (assignment)) . (expression_statement (string) @comment))

; Type Alias docstring
((type_alias_statement) . (expression_statement (string) @comment))

(import_from_statement module_name:(dotted_name (identifier) @module))
(import_statement name:(dotted_name (identifier) @module))
