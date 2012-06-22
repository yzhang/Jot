TAGS      = ['a', 'abbr', 'address', 'area', 'article', 'aside', 'audio',
             'b', 'base', 'bdi', 'bdo', 'blockquote', 'body', 'br', 'button',
             'canvas', 'caption', 'cite', 'code', 'col', 'colgroup', 'command',
             'datalist', 'dd', 'del', 'details', 'dfn', 'div', 'dl', 'dt', 'doctype'
             'em', 'embed', 'fieldset', 'figcaption', 'figure', 'footer', 'form',
             'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'header', 'hgroup', 'hr', 'html',
             'i', 'iframe', 'img', 'input', 'ins',
             'keygen', 'kbd', 
             'label', 'legend', 'li', 'link',
             'map', 'mark', 'menu', 'meta', 'meter', 
             'nav', 'noscript', 'object', 'ol', 'optgroup', 'option', 'output',
             'p', 'param', 'pre', 'progress',
             'q',
             'rp', 'rt', 'ruby',
             's', 'samp', 'script', 'section', 'select', 'small', 'source', 'span', 'strong', 'style', 
             'sub', 'summary', 'sup',
             'table', 'tbody', 'td', 'textarea', 'tfoot', 'th', 'thead', 'time', 'title', 'tr', 'track',
             'u', 'ul', 'var', 'video', 'wbr']

Jet = window.Jet = (name, obj) ->
  if typeof obj == 'string'
    Jet.register(name, obj)
  else
    Jet.render(name, obj)

Jet.templates = []

Jet.register = (name, template) ->
  template  = template.replace(/(\r\n|\r)/, '\n')
  lines = template.split('\n')

  nodes = []
  last  = null

  for line in lines
    node = Jet.parse(line)

    if !last
      nodes.push node
    else if node.indention > last.indention
      last.addChild(node)
    else
      while(last.parent)
        break if last.indention == node.indention
        last = last.parent
      
      if last.parent
        last.parent.addChild(node) 
      else
        nodes.push node

    last = node
  
  @templates[name] = nodes

  return nodes

Jet.parse = (line) ->
  regex = new RegExp("^(\\s*)(([\\.#]?[a-zA-Z][a-zA-Z0-9-_]*)+)(\\((.*)\\))?($|\\s+(.*)$)")
  result = line.match(regex)
  
  if !result
    console.error "SyntaxError in line: " + line
    return null

  indention = result[1].replace('\t', '  ').length
  node  = result[2]
  attrs = result[5]
  text  = result[7]
  
  tag = (node.match(/^[a-zA-Z][a-zA-Z0-9-_]*/) || ['div'])[0]
  if TAGS.indexOf(tag) == -1
    console.error "SyntaxError: Illegel tag name " + tag
    return null
  
  id = (node.match(/#[a-zA-Z][a-zA-Z0-9-_]*/g) || [''])
  if id instanceof Array && id.length > 1
    console.error "SyntaxError: One tag should only have one id"
    return null
  id = id[0].slice(1)

  classes = (node.match(/\.[a-zA-Z][a-zA-Z0-9-_]*/g) || [''])
  classes = classes.join(' ').replace(/\./g, '')

  return new @Node(tag, indention, id, classes, text, attrs)

Jet.render = (name, obj) ->
  html = ''
  
  for node in @templates[name]
    html += node.render(obj)
  
  html
  
  
