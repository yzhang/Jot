describe "Node", ->
  Node = Jet.Node

  it "contains spec with an expectation", ->
    expect(typeof Jet.Node).toBe("function")
  
  it "should render node properly", ->
    node = new Node('p', 0)
    expect(node.render()).toBe("<p></p>\n")

    node = new Node('p', 2)
    expect(node.render()).toBe("  <p></p>\n")
    
    node = new Node('p', 0, 'id', 'class1 class2')
    expect(node.render()).toBe('<p id="id" class="class1 class2"></p>\n')

    node = new Node('html', 0, '', '', '', 'lang="en"')
    expect(node.render()).toBe('<html lang="en"></html>\n')
    
    node = new Node('p', 0, 'id', 'class1 class2', 'some text 123....')
    expect(node.render()).toBe('<p id="id" class="class1 class2">some text 123....</p>\n')
  
  it "should render doctype properly", ->
    node = new Node('doctype', 0, '', '', 'html')
    expect(node.render()).toBe("<!DOCTYPE html>\n")
  
  it "should render child node properly", ->
    node = new Node('ul', 0)
    li   = new Node('li', 2, '', 'item', 'item 1')
    li.addChild(new Node('a', 4, '', '', 'test', 'href="#"'))
    node.addChild(li)
    node.addChild(new Node('li', 2, '', 'item current', 'item 2'))
    node.addChild(new Node('li', 2, '', 'item', 'item 3'))
    
    expect(node.render()).toBe("""
      <ul>
        <li class="item">item 1
          <a href="#">test</a>
        </li>
        <li class="item current">item 2</li>
        <li class="item">item 3</li>
      </ul>

    """)