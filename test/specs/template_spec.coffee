describe "Template", ->
  Template = Jet.Template

  it "should compile source to an array of nodes", ->
    t = new Template("""
      ul
        li Item1
        li Item2
        li Item3
      h1
    """)
    expect(t.roots.length).toBe(2)
    expect(t.roots[0].children.length).toBe(3)
  
  it "should compile plain text properly", ->
    t = new Template("""
      p:
        li Item1
        li Item2
        li Item3
    """)
    expect(t.render()).toBe("""
      <p>
        li Item1
        li Item2
        li Item3
      </p>
    """)
  
  it "should compile loop properly", ->
    t = new Template("""
      ul
        - items
          li {{name}}
    """)
    obj = 
      items: [
        {name:"Item1"},
        {name:"Item2"},
        {name:"Item3"},
      ]
      
    expect(t.render(obj)).toBe("""
      <ul>
        <li>Item1</li>
        <li>Item2</li>
        <li>Item3</li>
      </ul>
    """)
  
  it "should expand object properly", ->
    t = new Template("""
      .book
        p {{title}}
        - author
          p {{name}}
          p
            a test
    """)
    
    book = 
      title: "Awesome Book"
      author:
        name: "Yuanyi"
    
    expect(t.render(book)).toBe("""
      <div class="book">
        <p>Awesome Book</p>
        <p>Yuanyi</p>
        <p>
          <a>test</a>
        </p>
      </div>
    """)
  
  it "should render placeholder properly", ->
    t = new Template("""
      #comments
        - comments
          .comment
            p {{content}}
        - !comments
          p No comments yet!
    """)
    
    post = 
      comments: []

    expect(t.render(post)).toBe("""
      <div id="comments">
        <p>No comments yet!</p>
      </div>
    """)