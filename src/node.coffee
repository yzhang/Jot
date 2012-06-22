Jet.Node = class Node
  @hooks = 
    doctype: -> "<!DOCTYPE html>\n"

  constructor: (@tag, @indention, @id='', @classes='', @content='', @attrs='') ->
    @children = []
    @parent   = null
    @hooks = Jet.Node.hooks
  
  addChild: (child) ->
    @children.push(child)
    child.parent = @

  render: (obj) ->
    return @hooks[@tag](obj) if @hooks[@tag]
    
    indention = '' 
    (indention += ' ' for i in [0..@indention-1]) if @indention > 0

    html =  ""
    html += "#{indention}<#{@tag}"
    html += " id=\"#{@id}\"" if @id != ''
    html += " class=\"#{@classes}\"" if @classes != ''
    html += " " + @attrs if @attrs != ''
    html += ">"
    html += @content if @content
    html += "\n" if @children.length > 0
    for child in @children
      html += child.render(obj)
    html += indention if @children.length > 0
    html += "</#{@tag}>\n"
