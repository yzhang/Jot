describe 'Helper', ->
  Helper = Jet.Helper
  it "should convert number to space properly", ->
    expect(Helper.space(2)).toBe('  ')
    expect(Helper.space(0)).toBe('')
  
  it "should interpolate string properly", ->
    expect(Helper.interpolate("{{action}}, {{name}}!", {action: "Welcome", name:"Tom"})).toBe("Welcome, Tom!")
    expect(Helper.interpolate("{{action}}, {{person}}!", {action: "Welcome", name:"Tom"})).toBe("Welcome, !")
    
  it "should compact array properly", ->
    a = Helper.compact([1, null, 2])
    expect(a.length).toBe(2)
    expect(a.indexOf(undefined)).toBe(-1)