describe "Jot", ->
  it "should register template properly", ->
    Jot("simple", "p Hello")
    expect(typeof Jot.simple).toBe('function')
    expect(Jot.toString()).toBe('Jot')
    expect(Jot['simple'].t instanceof Jot.Template)
  
  it "should render example correctly", ->
    Jot('posts', """
      #posts
        - posts
          .post
            .title {{title}}
            .meta
              .timestamp {{published_at}}
              - author
                .author {{name}}
            .content
              :{{content}}
            .comments
              - comments
                .comment {{content}}
              - !comments
                :No comment yet!
    """)
    
    posts = [
      title: "Sample Post"
      published_at: '2012-06-28'
      content: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
      author:
        name: "Tom"
      comments: []
    ]
    
    expect(Jot.posts(posts:posts)).toBe("""
      <div id="posts">
        <div class="post">
          <div class="title">Sample Post</div>
          <div class="meta">
            <div class="timestamp">2012-06-28</div>
            <div class="author">Tom</div>
          </div>
          <div class="content">
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
          </div>
          <div class="comments">
            No comment yet!
          </div>
        </div>
      </div>
    """)
  
  it "should render sample correctly", ->
    Jot('sample', 'p Hello, {{name}}!')
    expect(Jot.sample({name: "Jot"})).toBe("<p>Hello, Jot!</p>")
    
    Jot('sample', 'p Hello, {{person.name}}!')
    expect(Jot.sample({person: {name:"Jot"}})).toBe("<p>Hello, Jot!</p>")
    
    Jot('sample', 'p Hello, {{name}}!')
    expect(Jot.sample({name: -> "Jot"})).toBe("<p>Hello, Jot!</p>")
    
    Jot('sample', """
      p
        - person
          :name: {{name}}
          :age:  {{age}}
    """)
    expect(Jot.sample({person:{name:'Jot', age:'1'}})).toBe("""
      <p>
        name: Jot
        age:  1
      </p>
    """)
    
    Jot('list', """
      ul
        - items
          li {{item}}
    """)
    expect(Jot.list({
      items:[
        {item:'Item 1'}, 
        {item:'Item 2'},
        {item:'Item 3'}
      ]
    })).toBe("""
      <ul>
        <li>Item 1</li>
        <li>Item 2</li>
        <li>Item 3</li>
      </ul>
    """)
    
    Jot('account', """
      .account
        - expired?
          :We're sorry, but your account is expired.
        - !expired
          p ...
    """)
    expect(Jot.account({expired:true})).toBe("""
      <div class="account">
        We're sorry, but your account is expired.
      </div>
    """)
    
    Jot('account', """
      - comments
        p {{comment}}
      - !comments
        p No comments yet.
    """)
    expect(Jot.account({comments:[]})).toBe("""
      <p>No comments yet.</p>
    """)
    
    Jot('comments', """
      - comments
        = comment
    """)
    Jot('comment', 'p {{content}}')

    comments = [
      {content: 'comment 1'},
      {content: 'comment 2'},
    ]
    expect(Jot.comments(comments:comments)).toBe("""
      <p>comment 1</p>
      <p>comment 2</p>
    """)
    
    Jot('array', """
      p {{$}}
    """)
    
    expect(Jot.array(['Hi, Tom,', 'Thanks!'])).toBe("""
      <p>Hi, Tom,</p>
      <p>Thanks!</p>
    """)
