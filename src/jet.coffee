_T = []

# Usage:
# Jet "hello", ->
#    p "Hello, {{name}}!"
Jet = window.Jet = (name, fn) ->
  _T[name] = fn


