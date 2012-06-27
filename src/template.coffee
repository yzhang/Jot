Jot.Template = class Template extends Jot.Module
  @include Jot.Helper
  constructor: (src) ->
    @roots = []
    @parse(src)

  parse: (src) ->
    src    = src.replace(/(\r\n|\r)/, '\n')
    lines  = src.split('\n')
    @nodes = []

    for line in lines
      result    = line.match /^(\s*)([:=-])?(.*)$/
      indention = result[1].replace('\t', '  ').length
      prefix    = result[2]
      content   = result[3]
      parent    = @nodes[indention-2]

      if parent && parent.mode == 'plain' || prefix == ':'
        node = new Jot.Plain(indention, content)
      else if prefix == '='
        node = new Jot.Partial(indention, content)
      else if prefix == '-'
        node = new Jot.Expression(indention, content)
      else
        node = new Jot.Node(indention, content)
    
      if parent
        parent.addChild(node)
      else
        @roots.push(node)
      
      @nodes[indention] = node
  
  render: (obj) ->
    @compact(root.render(obj) for root in @roots).join('\n')
