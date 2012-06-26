Jet.Helper = 
  space:   (n) -> new Array(n+1).join(' ');
  isBlank: (o) -> !o || o == ''
  interpolate: (str, obj) ->
    return str unless obj
    str.replace /{{([$_a-zA-Z][$_a-zA-Z0-9]*)}}/g, -> obj[arguments[1]]||''
  compact: (array) ->
    for i in [0..array.length]
      array.splice(i, 1) unless array[i]
    array
