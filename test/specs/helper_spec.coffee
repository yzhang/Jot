describe 'Helper', ->
  Helper = Jot.Helper
  it "should convert number to space properly", ->
    expect(Helper.space(2)).toBe('  ')
    expect(Helper.space(0)).toBe('')
  
  it "should return true for blank var", ->
    expect(Helper.isBlank('')).toBe(true)
    expect(Helper.isBlank(undefined)).toBe(true)
    expect(Helper.isBlank([])).toBe(true)
    expect(Helper.isBlank([''])).not.toBe(true)

  it "should interpolate string properly", ->
    expect(Helper.interpolate("{{action}}, {{name}}!", {action: "Welcome", name:"Tom"})).toBe("Welcome, Tom!")
    expect(Helper.interpolate("{{action}}, {{person}}!", {action: "Welcome", name:"Tom"})).toBe("Welcome, !")
    expect(Helper.interpolate("{{action}}, {{person.name}}!", {action: "Welcome", person:{name:"Tom"}})).toBe("Welcome, Tom!")
    
  it "should compact array properly", ->
    a = Helper.compact([1, null, 2])
    expect(a.length).toBe(2)
    expect(a.indexOf(undefined)).toBe(-1)
  
  it "should eval attr recursively", ->
    post = 
      title:  'test post'
      author:
        name: 'Tom'
      comments: []
      closed: false
    
    expect(Helper.eval(post, 'title')).toBe('test post')
    expect(Helper.eval(post, 'closed', true)).toBe(true)
    expect(Helper.eval(post, 'author.name')).toBe('Tom')
    expect(Helper.eval(post, 'comments', true)).toBe(true)
    expect(-> Helper.eval(post, '.author')).toThrow()
    expect(-> Helper.eval(post, 'author.')).toThrow()
    expect(Helper.eval(post, 'author.age')).toBe(undefined)
    expect(Helper.eval('Jot', '$')).toBe('Jot')