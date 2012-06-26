describe "Jet", ->
  it "contains spec with an expectation", ->
    expect(typeof Jet).toBe("function")

describe "render", ->
  it "should render templates properly", ->
    Jet('test', """
      doctype html
      html(lang="en")
        head
          title Jet
          script(type="text/javascript"):
            var a = "test"
        body
          h1 Jet - simplest javascript template engine
          img("logo.png", title="title" aaa="title")
          #container
            - remain?
              = price
            - !remain
              :Sold out
            - products
              = product
            {{price}}
            p You are amazing
            p
              :line 1
                :line 2
              a test
            p:
              a test line
              another test line
          footer
    """
    )
    
    html = Jet.test()
    expect(html).toBe("""
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <title>Jet</title>
          <script type="text/javascript">
            var a = "test"
          </script>
        </head>
        <body>
          <h1>Jet - simplest javascript template engine</h1>
          <div id="container">
            <p>You are amazing</p>
            <p>
              line 1
                line 2
              <a>test</a>
            </p>
            <p>
              a test line
              another test line
            </p>
          </div>
          <footer></footer>
        </body>
      </html>
    """)
