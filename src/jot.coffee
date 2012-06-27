Jot = @Jot = (name, str) ->
  Jot[name] = (obj = {}) ->
    obj = if obj instanceof Array then obj else [obj]
    t = arguments.callee.t
    (t.render(o) for o in obj).join("\n")
  Jot[name]['t'] = new Jot.Template(str)
  
# substracted from Spine
Jot.Module = class Module
  @moduleKeywords = ['included', 'extended']
  @include: (obj) ->
    throw new Error('include(obj) requires obj') unless obj
    for key, value of obj when key not in @moduleKeywords
      @::[key] = value
    obj.included?.apply(this)
    this

  # @extend: (obj) ->
  #   throw new Error('extend(obj) requires obj') unless obj
  #   for key, value of obj when key not in moduleKeywords
  #     @[key] = value
  #   obj.extended?.apply(this)
  #   this
