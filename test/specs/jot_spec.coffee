describe "Jot", ->
  it "should register template properly", ->
    Jot("simple", "p Hello")
    expect(typeof Jot.simple).toBe('function')
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
      content: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Vivamus vitae risus vitae lorem iaculis placerat."
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
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Vivamus vitae risus vitae lorem iaculis placerat.
          </div>
          <div class="comments">
            No comment yet!
          </div>
        </div>
      </div>
    """)
