(typed_binding
  ("(" @delimiter)
  (")" @delimiter @sentinel)) @container

(typed_binding
  ("{" @delimiter)
  ("}" @delimiter @sentinel)) @container

(atom
  ("(" @delimiter)
  (")" @delimiter @sentinel)) @container

(atom
  ("{" @delimiter)
  ("}" @delimiter @sentinel)) @container
