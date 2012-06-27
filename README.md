#Jot - Simplest HTML template solution for JavaScript#

Jot tries to be the simplest HTML template solution for Javascript, it borrowed HAML's dead-simple markup syntax and Mastache's awesome logic-less template convention, but mixed them together with a simpler way, let's start from an example.

```coffee
Jot('posts', """
  #posts
    - posts
      .post
        .title {{title}}
        .meta
          span.timestamp {{published_at}}
          span.author {{author.name}}
        .content
          :{{content}}
        .comments
          - comments
            p.comment {{content}}
          - !comments
            :No comment yet!
""")
```

Compile it:

```coffee
posts = [
  title: "Sample Post"
  published_at: '2012-06-28'
  content: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
  author:
    name: "Tom"
  comments: []
]
Jot.posts({posts:posts})
```

This will produce:

```html
<div id="posts">
  <div class="post">
    <div class="title">Sample Post</div>
    <div class="meta">
      <span class="timestamp">2012-06-28</div>
      <span class="author">Tom</div>
    </div>
    <div class="content">
      Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
    </div>
    <div class="comments">
      No comment yet!
    </div>
  </div>
</div>
```

##Markups##

Below is the standard markup syntax:

```jot
tag#id.class(attr="value") content
```

You can also put content on another line:

```jot
p
  :an exciting paragraph
```

If you need multi content:

```jot
p:
  first sentence
  second sentence
```

##Variables##

All variables put in {{*}} will be evaluated based on the object you privided:

```coffee
Jot('sample', 'p Hello, {{name}}!')
Jot.sample({name: "Jot"})
```

Will produce:

```html
<p>Hello, Jot!</p>
```

###Recurrence###

Variable also support recurrence:

```coffee
Jot('sample', 'p Hello, {{person.name}}!')
Jot.sample({person: {name:"Jot"}})
```
Same results:

```html
<p>Hello, Jot!</p>
```

###Function###

Function will be executed automatically:

```coffee
Jot('sample', 'p Hello, {{name}}!')
Jot.sample({name: -> "Jot"})
```

Still same:

```html
<p>Hello, Jot!</p>
```

###Scope###

You can also specify a scope:

```coffee
Jot('sample', """
  p
    - person
      :name: {{name}}
      :age:  {{age}}
""")
Jot.sample({person:{name:'Jot', age:'1'}})
```

This will produce:

```html
<p>
  name: Jot
  age:  1
</p>
```

##Array##

We've seen the power of '-' notation, if the result is an Array, it'll be auto expanded:

```coffee
Jot('list', """
  ul
    - items
      li {{item}}
""")
Jot.list({
  items:[
    {item:'Item 1'}, 
    {item:'Item 2'},
    {item:'Item 3'}
  ]
})
```

This will produce:
```html
<ul>
  <li>Item 1</li>
  <li>Item 2</li>
  <li>Item 3</li>
</ul>
```

##Conditionals##

If you're missing the if statement, here it is, but in a simpler way:

```coffee
Jot('account', """
  .account
    - expired?
      :We're sorry, but your account is expired.
    - !expired
      p ...
""")
Jot.account({expired:true})
```

Will produce:

```html
<div class="account">
  We're sorry, but your account is expired.
</div>
```

You can also apply this to an array:

```coffee
Jot('account', """
  - comments
    p {{comment}}
  - !comments
    p No comments yet.
""")
Jot.account({comments:[]})
```

This will produce:

```html
<p>No comments yet.</p>
```

#Development#

If you want to contribute, you need install [PhantomJS](http://phantomjs.org/) to run the tests, and [Rake](http://rake.rubyforge.org/) and [CoffeeScript](http://coffeescript.org) to compile the final JS.

Run Tests:

```sh
rake test
```

Compile:

```sh
rake compile
```

Jot also used [Jasmine](http://pivotal.github.com/jasmine/) and [Phantom-Jasmine](https://github.com/jcarver989/phantom-jasmine)'s consoler runner.

#License#
(The MIT License)

Copyright (c) 2012 Yuanyi Zhang <zhangyuanyi@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.