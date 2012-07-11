Jot.Node = class Node extends Jot.Module
  @include Jot.Helper
  @hooks = 
    doctype: -> "<!DOCTYPE html>"
  
  @Tags = ['a', 'abbr', 'address', 'area', 'article', 'aside', 'audio', 'b', 'base', 'bdi', 'bdo', 'blockquote', 'body', 'br', 'button', 'canvas', 'caption', 'cite', 'code', 'col', 'colgroup', 'command', 'datalist', 'dd', 'del', 'details', 'dfn', 'div', 'dl', 'dt', 'doctype', 'em', 'embed', 'fieldset', 'figcaption', 'figure', 'footer', 'form', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'header', 'hgroup', 'hr', 'html', 'i', 'iframe', 'img', 'input', 'ins', 'keygen', 'kbd', 'label', 'legend', 'li', 'link', 'map', 'mark', 'menu', 'meta', 'meter', 'nav', 'noscript', 'object', 'ol', 'optgroup', 'option', 'output', 'p', 'param', 'pre', 'progress', 'q', 'rp', 'rt', 'ruby', 's', 'samp', 'script', 'section', 'select', 'small', 'source', 'span', 'strong', 'style', 'sub', 'summary', 'sup', 'table', 'tbody', 'td', 'textarea', 'tfoot', 'th', 'thead', 'time', 'title', 'tr', 'track', 'u', 'ul', 'var', 'video', 'wbr']
  @VoidTags = ['area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'input', 'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr']

  constructor: (@indention, src='') ->
    @children = []

    result = src.match(/^(([\.#]?([a-zA-Z]|\{\{[^\{]*\}\})(([a-zA-Z0-9-_]|\{\{[^\{]*\}\})*))+)(\((.*)\))?(:?$|\s+(.*)$)/)
    throw "SyntaxError in line: " + src if !result

    selector = result[1]
    @attrs   = result[7]
    @mode    = if result[8] == ':' then 'plain' else 'node'
    @content = result[9]
    
    @tag = (selector.match(/^[a-zA-Z\{\}][\{\}a-zA-Z0-9-_]*/) || ['div'])[0]
    throw "SyntaxError: Illegel tag name " + @tag if Node.Tags.indexOf(@tag) == -1    
    
    @voidElement = true if Node.VoidTags.indexOf(@tag) != -1
    throw "SyntaxError: void element can't contain content" if !@isBlank(@content) && @voidElement

    ids = (selector.match(/#[a-zA-Z\{\}][\{\}a-zA-Z0-9-$_]*/g) || [''])
    if ids instanceof Array && ids.length > 1
      throw "SyntaxError: One tag should only have one id"
    
    @id = ids[0].slice(1)
    
    @classes = (selector.match(/\.[a-zA-Z\{\}][\{\}a-zA-Z0-9-$_]*/g) || [''])
    @classes = @classes.join(' ').replace(/\./g, '')
    
    @compile()

  addChild: (child) ->
    throw "SyntaxError: void element can't contain child element" if @voidElement
    @children.push(child)
    child.parent = @

  compile: ->
    return Jot.Node.hooks[@tag](obj) if Jot.Node.hooks[@tag]

    @head =  ""
    @tail =  ""
    @head += "#{@space(@indention)}<#{@tag}"
    @head += " id=\"#{@id}\"" if @id != ''
    @head += " class=\"#{@classes}\"" if @classes != ''
    @head += " " + @attrs if @attrs && @attrs != ''
    @head += ">"
    
    if !@voidElement
      @head += @content if @content
      @tail += "</#{@tag}>"
  
  render: (obj) ->
    @html = @head
    if @children.length > 0
      @interpolate(@head, obj) + "\n" + @compact(child.render(obj) for child in @children).join("\n") + "\n" + @space(@indention) + @interpolate(@tail, obj)
    else
      @interpolate(@head + @tail, obj)

Jot.Plain = class Plain extends Jot.Module
  @include Jot.Helper
  constructor: (@indention, @content='') ->
    @mode = 'plain'
    @compile()

  compile: ->
    @html = @space(@indention) + @content

  render: (obj) ->
    return @interpolate(@html, obj)

Jot.Partial = class Partial extends Jot.Module
  @include Jot.Helper
  constructor: (@indention, @name) ->
    @mode = 'partial'
    @name = @name.match(/^\s*([a-zA-Z\{][\{\}a-zA-Z0-9-_]*)\s*$/)[1]
    throw "Illegal partial name" unless @name

  render: (obj) ->
    partialName = @interpolate(@name, obj)
    partial = Jot[partialName](obj)
    return partial unless @indention
    (line = @space(@indention) + line for line in partial.split("\n")).join("\n")

Jot.Expression = class Expression extends Jot.Module
  @include Jot.Helper
  constructor: (@indention, content='') ->
    @children = []
    @mode   = 'node'
    result  = content.match /(\!)?([a-zA-Z$_][a-zA-Z0-9_$\.]+)(\?)?/
    @invert = (result[1] == '!')
    @attr   = result[2]
    @q      = result[3]
    
  addChild: (child) ->
    @children.push(child)
    child.parent = @

  render: (obj) ->
    val = @eval(obj, @attr, @invert)
    if @q || @invert
      if val then @renderChildren(obj) else null
    else if val instanceof Array
      @compact(@renderChildren(o) for o in val).join('\n')
    else
      @renderChildren(val)

  renderChildren: (obj) ->
    html = (child.render(obj) for child in @children).join('\n')
    (line.slice(2, line.length) for line in html.split('\n')).join('\n')
