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
