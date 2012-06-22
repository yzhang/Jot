describe "Jet", ->
  it "contains spec with an expectation", ->
    expect(typeof Jet).toBe("function")
  
describe "Line parse", ->
  it "should parse line into a node object", ->
    node = Jet.parse("p hello")
    expect(node instanceof Jet.Node).toBe(true)
  
  it "should return null if there's parse error", ->
    node = Jet.parse("$p")
    expect(node).toBe(null)
    
    # illegal tag
    node = Jet.parse("1p")
    expect(node).toBe(null)
    
    # illegal class
    node = Jet.parse("p.$123")
    expect(node).toBe(null)
    
    # illegal id
    node = Jet.parse("p#-123")
    expect(node).toBe(null)
    node = Jet.parse("p#.123")
    expect(node).toBe(null)
  
  it "should parse attributes properly", ->
    node = Jet.parse('html(lang="en")')
    expect(node.attrs).toBe('lang="en"')

  it "should parse indention properly", ->
    node = Jet.parse("  p hello")
    expect(node.indention).toBe(2)
    
    node = Jet.parse("  \tp hello")
    expect(node.indention).toBe(4)
  
  it "should parse text properly", ->
    node = Jet.parse("  p hello")
    expect(node.content).toBe('hello')
    
    node = Jet.parse("p Hello @name!")
    expect(node.content).toBe("Hello @name!")

  it "should parse tag name properly", ->
    node = Jet.parse('p')
    expect(node.tag).toBe('p')
    
    node = Jet.parse('input.class')
    expect(node.tag).toBe('input')
    
    node = Jet.parse('#id')
    expect(node.tag).toBe('div')
    
    node = Jet.parse('form#user')
    expect(node.tag).toBe('form')

    node = Jet.parse('newtag#user')
    expect(node).toBe(null)
    
  it "should parse id properly", ->
    node = Jet.parse('p')
    expect(node.id).toBe('')
    
    node = Jet.parse('input.class')
    expect(node.id).toBe('')
    
    node = Jet.parse('#id')
    expect(node.id).toBe('id')
    
    node = Jet.parse('#id-with-minus')
    expect(node.id).toBe('id-with-minus')

    node = Jet.parse('#id_with_underscore')
    expect(node.id).toBe('id_with_underscore')
    
    node = Jet.parse('form#user')
    expect(node.id).toBe('user')
    
    node = Jet.parse('#user#people')
    expect(node).toBe(null)
  
  it "should parse classes properly", ->
    node = Jet.parse('p')
    expect(node.classes).toBe('')
    
    node = Jet.parse('input.class')
    expect(node.classes).toBe('class')
    
    node = Jet.parse('#id')
    expect(node.classes).toBe('')
    
    node = Jet.parse('form.user.class1')
    expect(node.classes).toBe('user class1')

describe "Compile", ->
  it "should compile source to an array of nodes", ->
    nodes = Jet.register('template', """
      ul
        li Item1
        li Item2
        li Item3
      h1
    """)
    expect(nodes.length).toBe(2)
    expect(nodes[0].children.length).toBe(3)

describe "render", ->
  it "should render templates properly", ->
    Jet.register('test', """
      doctype html
      html(lang="en")
        head
          title pageTitle
        body
          h1 Jade - node template engine
          #container
            p You are amazing
    """
    )
    
    html = Jet.render('test')
    expect(html).toBe("""
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <title>Jade</title>
        </head>
        <body>
          <h1>Jade - node template engine</h1>
          <div id="container">
            <p>You are amazing</p>
          </div>
        </body>
      </html>

    """)
