Jot.Helper = 
  space:   (n) -> new Array(n+1).join(' ');
  isBlank: (value) ->
    return true unless value
    return false for key of value
    true

  eval: (obj, exp, invert) ->
    return obj.toString() if exp == '$'

    attrs = exp.split('.')
    val = obj
    i = 0;

    while i<attrs.length
      attr  = attrs[i]
      throw "Syntax error: " + exp if Jot.Helper.isBlank(attr)
      val ||= {}
      val = if typeof val[attr] == 'function' then val[attr]() else val[attr]
      i++
      
    if invert
      if val instanceof Array then !val.length else !val
    else
      val

  interpolate: (str, obj) ->
    return str unless obj
    str.replace /{{([$_a-zA-Z][$_a-zA-Z0-9\.]*)}}/g, -> Jot.Helper.eval(obj, arguments[1], false)||''

  compact: (array) ->
    for i in [0..array.length]
      array.splice(i, 1) unless array[i]
    array
