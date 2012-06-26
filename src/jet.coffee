Jet = @Jet = (name, str) ->
  Jet[name] = (obj = {}) ->
    obj = if obj instanceof Array then obj else [obj]
    t = arguments.callee.t
    (t.render(o) for o in obj).join("\n")
  Jet[name]['t'] = new Jet.Template(str)
