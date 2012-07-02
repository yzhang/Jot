describe "Node", ->
  Node = Jot.Node

  it "contains spec with an expectation", ->
    expect(typeof Jot.Node).toBe("function")
  
  it "should parse line into a node object", ->
    node = new Node(0, "p hello")
    expect(node instanceof Jot.Node).toBe(true)

  it "should return null if there's parse error", ->
    expect(-> new Node(0, "$p")).toThrow()
    expect(-> new Node(0, "1p")).toThrow()
    expect(-> new Node(0, "p.$123")).toThrow()
    expect(-> new Node(0, "p#-123")).toThrow()
    expect(-> new Node(0, "p#.123")).toThrow()
  
  it "should parse mod properly", ->
    expect(new Node(0, "p:").mode).toBe("plain")

  it "should parse attributes properly", ->
    node = new Node(0, 'html(lang="en")')
    expect(node.render()).toBe('<html lang="en"></html>')

    node = new Node(0, 'title Jot')
    expect(node.render()).toBe('<title>Jot</title>')

  it "should parse text properly", ->
    node = new Node(2, "p hello")
    expect(node.content).toBe('hello')
  
    node = new Node(0, "p Hello @name!")
    expect(node.content).toBe("Hello @name!")
  
  it "should parse tag name properly", ->
    node = new Node(0, 'p')
    expect(node.tag).toBe('p')
  
    node = new Node(0, 'input.class')
    expect(node.tag).toBe('input')
  
    node = new Node(0, '#id')
    expect(node.tag).toBe('div')
  
    node = new Node(0, 'form#user')
    expect(node.tag).toBe('form')
  
    expect(-> new Node(0, 'newtag#user')).toThrow()
  
  it "should parse id properly", ->
    node = new Node(0, 'p')
    expect(node.id).toBe('')
  
    node = new Node(0, 'input.class')
    expect(node.id).toBe('')
  
    node = new Node(0, '#id')
    expect(node.id).toBe('id')
  
    node = new Node(0, '#id-with-minus')
    expect(node.id).toBe('id-with-minus')
  
    node = new Node(0, '#id_with_underscore')
    expect(node.id).toBe('id_with_underscore')
  
    node = new Node(0, 'form#user')
    expect(node.id).toBe('user')
  
    expect(-> new Node(0, '#user#people')).toThrow
  
  it "should parse classes properly", ->
    node = new Node(0, 'p')
    expect(node.classes).toBe('')
  
    node = new Node(0, 'input.class')
    expect(node.classes).toBe('class')
  
    node = new Node(0, '#id')
    expect(node.classes).toBe('')
  
    node = new Node(0, 'form.user.class1')
    expect(node.classes).toBe('user class1')
  
  it "should parse node properly", ->
    node = new Node(0, 'p:')
    expect(node.mode).toBe('plain')

    node = new Node(0, 'p.test:')
    expect(node.mode).toBe('plain')
    
    node = new Node(0, 'p.test(style="display:none"):')
    expect(node.mode).toBe('plain')
    
  it "should render void node properly", ->
    node = new Node(0, 'br')
    expect(node.render()).toBe('<br>')
    expect(-> node.addChild('')).toThrow()
    expect(-> new Node(0, 'br 123')).toThrow()
  
  it "should parse variable properly", ->
    node = new Node(0, 'p {{name}}')
    expect(node.render({name: 'Paul'})).toBe('<p>Paul</p>')
    
    node = new Node(0, 'p.{{name}}')
    expect(node.render({name: 'content'})).toBe('<p class="content"></p>')
      
    expect(-> new Node(0, '{{name}}')).toThrow()
    
    node = new Node(0, '#{{name}}')
    expect(node.render({name: 'content'})).toBe('<div id="content"></div>')
    node = new Node(0, '#{{invalid}}')
    expect(node.render({name: 'content'})).toBe('<div id=""></div>')
    node = new Node(0, '#prefix_{{id}}_postfix')
    expect(node.render({id: 'content'})).toBe('<div id="prefix_content_postfix"></div>')
    expect(-> new Node(0, '#prefix_{id}}_postfix')).toThrow()
    
    node = new Node(0, 'a(title="{{name}}!")  {{name}}  Bang!')
    expect(node.render({name: 'Hi, Paul'})).toBe('<a title="Hi, Paul!">Hi, Paul  Bang!</a>')
  
  it "should compile markups at first", ->
    node = new Node(0, 'p#id.class')
    expect(node.head).toBe('<p id="id" class="class">')
    expect(node.tail).toBe('</p>')
  
    node = new Node(0, 'img(src="test.png")')
    expect(node.head).toBe('<img src="test.png">')
    expect(node.tail).toBe('')
    
    node = new Node(0, 'p hello {{name}}')
    expect(node.head).toBe('<p>hello {{name}}')
    expect(node.tail).toBe('</p>')

  it "should parse self properly", ->
    node = new Node(0, '#node{{$}}')
    expect(node.render('jot')).toBe('<div id="nodejot"></div>')
      
describe "plain", ->
  Plain = Jot.Plain
  it "should render plain text properly", ->
    plain = new Plain(2, 'plain text', '')
    expect(plain.render()).toBe("  plain text")
    plain = new Plain(0, 'plain text', '')
    expect(plain.render()).toBe("plain text")
  
  it "should parse variable properly", ->
    node = new Plain(0, 'Hello, {{name}}!')
    expect(node.render({name: 'Paul'})).toBe('Hello, Paul!')
  
  it "should parse self properly", ->
    node = new Plain(0, 'Hello, {{$}}!')
    expect(node.render('Jot')).toBe('Hello, Jot!')

describe "partial", ->
  Partial = Jot.Partial
  it "should render partial properly", ->
    Jot('partial', """
      ul
        li item1
        li item2
        li item3
    """)
    partial = new Partial(2, 'partial')
    expect(partial.render()).toBe("""
    \ \ <ul>
    \ \   <li>item1</li>
    \ \   <li>item2</li>
    \ \   <li>item3</li>
    \ \ </ul>
    """)

describe "expression", ->
  Expression = Jot.Expression
  Node       = Jot.Node
  it "should evaluate expression properly", ->
    node = new Expression(0, " test? ")
    node.addChild(new Node(2, "p hello"))
    expect(node.render({test:'123'})).toBe("<p>hello</p>")
    expect(node.render({test:false})).toBe(null)
    
    node = new Expression(0, " !test? ")
    node.addChild(new Node(2, "p hello"))
    expect(node.render({test:false})).toBe("<p>hello</p>")
    expect(node.render({test:true})).toBe(null)
  
  it "should expand expression properly", ->
    node = new Expression(0, "test")
    node.addChild(new Node(2, "p Hello, {{name}}"))
    expect(node.render({test:[{name:'Tom'}, {name:'Bob'}]})).toBe("<p>Hello, Tom</p>\n<p>Hello, Bob</p>")
    expect(node.render({test: -> [{name:'Tom'}, {name:'Bob'}]})).toBe("<p>Hello, Tom</p>\n<p>Hello, Bob</p>")
  
  it "should eval func properly", ->
    node = new Expression(0, " test? ")
    node.addChild(new Node(2, "p hello"))
    expect(node.render({test: -> true})).toBe("<p>hello</p>")
    
    node = new Expression(0, " !test")
    node.addChild(new Node(2, "p hello"))
    expect(node.render({test: -> []})).toBe("<p>hello</p>")