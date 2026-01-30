; SystemRDL highlight queries

; Comments
(comment) @comment

; Strings
(string_literal) @string

; Numbers
(number) @number

; Booleans
(boolean_literal) @boolean

; Component types (addrmap, reg, field, regfile, etc.)
(component_primary_type) @keyword

; Identifiers - general
(id) @variable

; Component/type definition names
(component_named_def
  type: (component_type)
  id: (id) @type.definition)

; Anonymous component instance names
(component_inst
  (id) @type)

; Property assignment left-hand side (name, desc, sw, hw, etc.)
(prop_assignment_lhs
  (id) @property)

; Enum definitions
(enum_def
  (id) @type.definition)

; Enum entries
(enum_entry
  (id) @constant)

; Struct definitions
(struct_def
  (id) @type.definition)

; Operators
[
  "="
  "@"
] @operator

; Punctuation
[
  ";"
  ","
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket
