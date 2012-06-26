(function() {
  var Expression, Jet, Module, Node, Plain, Template,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Jet = this.Jet = function(name, str) {
    Jet[name] = function(obj) {
      var o, t;
      if (obj == null) obj = {};
      obj = obj instanceof Array ? obj : [obj];
      t = arguments.callee.t;
      return ((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = obj.length; _i < _len; _i++) {
          o = obj[_i];
          _results.push(t.render(o));
        }
        return _results;
      })()).join("\n");
    };
    return Jet[name]['t'] = new Jet.Template(str);
  };

  Jet.Helper = {
    space: function(n) {
      return new Array(n + 1).join(' ');
    },
    isBlank: function(o) {
      return !o || o === '';
    },
    interpolate: function(str, obj) {
      if (!obj) return str;
      return str.replace(/{{([$_a-zA-Z][$_a-zA-Z0-9]*)}}/g, function() {
        return obj[arguments[1]] || '';
      });
    }
  };

  Jet.Module = Module = (function() {

    function Module() {}

    Module.moduleKeywords = ['included', 'extended'];

    Module.include = function(obj) {
      var key, value, _ref;
      if (!obj) throw new Error('include(obj) requires obj');
      for (key in obj) {
        value = obj[key];
        if (__indexOf.call(this.moduleKeywords, key) < 0) {
          this.prototype[key] = value;
        }
      }
      if ((_ref = obj.included) != null) _ref.apply(this);
      return this;
    };

    return Module;

  })();

  Jet.Node = Node = (function(_super) {

    __extends(Node, _super);

    Node.include(Jet.Helper);

    Node.hooks = {
      doctype: function() {
        return "<!DOCTYPE html>";
      }
    };

    Node.Tags = ['a', 'abbr', 'address', 'area', 'article', 'aside', 'audio', 'b', 'base', 'bdi', 'bdo', 'blockquote', 'body', 'br', 'button', 'canvas', 'caption', 'cite', 'code', 'col', 'colgroup', 'command', 'datalist', 'dd', 'del', 'details', 'dfn', 'div', 'dl', 'dt', 'doctype', 'em', 'embed', 'fieldset', 'figcaption', 'figure', 'footer', 'form', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'header', 'hgroup', 'hr', 'html', 'i', 'iframe', 'img', 'input', 'ins', 'keygen', 'kbd', 'label', 'legend', 'li', 'link', 'map', 'mark', 'menu', 'meta', 'meter', 'nav', 'noscript', 'object', 'ol', 'optgroup', 'option', 'output', 'p', 'param', 'pre', 'progress', 'q', 'rp', 'rt', 'ruby', 's', 'samp', 'script', 'section', 'select', 'small', 'source', 'span', 'strong', 'style', 'sub', 'summary', 'sup', 'table', 'tbody', 'td', 'textarea', 'tfoot', 'th', 'thead', 'time', 'title', 'tr', 'track', 'u', 'ul', 'var', 'video', 'wbr'];

    Node.VoidTags = ['area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'input', 'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr'];

    function Node(indention, src) {
      var ids, result, selector;
      this.indention = indention;
      if (src == null) src = '';
      this.children = [];
      result = src.match(/^(([\.#]?([a-zA-Z]|\{\{[^\{]*\}\})(([a-zA-Z0-9-_]|\{\{[^\{]*\}\})*))+)(\((.*)\))?(:?$|\s+(.*)$)/);
      if (!result) throw "SyntaxError in line: " + src;
      selector = result[1];
      this.attrs = result[7];
      this.mode = result[8] === ':' ? 'plain' : 'node';
      this.content = result[9];
      this.tag = (selector.match(/^[a-zA-Z\{\}][\{\}a-zA-Z0-9-_]*/) || ['div'])[0];
      if (Node.Tags.indexOf(this.tag) === -1) {
        throw "SyntaxError: Illegel tag name " + this.tag;
      }
      if (Node.VoidTags.indexOf(this.tag) !== -1) this.voidElement = true;
      if (!this.isBlank(this.content) && this.voidElement) {
        throw "SyntaxError: void element can't contain content";
      }
      ids = selector.match(/#[a-zA-Z\{\}][\{\}a-zA-Z0-9-_]*/g) || [''];
      if (ids instanceof Array && ids.length > 1) {
        throw "SyntaxError: One tag should only have one id";
      }
      this.id = ids[0].slice(1);
      this.classes = selector.match(/\.[a-zA-Z\{\}][\{\}a-zA-Z0-9-_]*/g) || [''];
      this.classes = this.classes.join(' ').replace(/\./g, '');
      this.compile();
    }

    Node.prototype.addChild = function(child) {
      if (this.voidElement) {
        throw "SyntaxError: void element can't contain child element";
      }
      this.children.push(child);
      return child.parent = this;
    };

    Node.prototype.compile = function() {
      if (Jet.Node.hooks[this.tag]) return Jet.Node.hooks[this.tag](obj);
      this.head = "";
      this.tail = "";
      this.head += "" + (this.space(this.indention)) + "<" + this.tag;
      if (this.id !== '') this.head += " id=\"" + this.id + "\"";
      if (this.classes !== '') this.head += " class=\"" + this.classes + "\"";
      if (this.attrs && this.attrs !== '') this.head += " " + this.attrs;
      this.head += ">";
      if (!this.voidElement) {
        if (this.content) this.head += this.content;
        if (this.children.length > 0) this.tail += this.space(this.indention);
        return this.tail += "</" + this.tag + ">";
      }
    };

    Node.prototype.render = function(obj) {
      var child;
      this.html = this.head;
      if (this.children.length > 0) {
        return this.interpolate(this.head, obj) + "\n" + ((function() {
          var _i, _len, _ref, _results;
          _ref = this.children;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            child = _ref[_i];
            _results.push(child.render());
          }
          return _results;
        }).call(this)).join("\n") + "\n" + this.interpolate(this.tail, obj);
      } else {
        return this.interpolate(this.head + this.tail, obj);
      }
    };

    return Node;

  })(Jet.Module);

  Jet.Plain = Plain = (function(_super) {

    __extends(Plain, _super);

    Plain.include(Jet.Helper);

    function Plain(indention, content) {
      this.indention = indention;
      this.content = content != null ? content : '';
      this.mode = 'plain';
      this.compile();
    }

    Plain.prototype.compile = function() {
      return this.html = this.space(this.indention) + this.content;
    };

    Plain.prototype.render = function(obj) {
      return this.interpolate(this.html, obj);
    };

    return Plain;

  })(Jet.Module);

  Jet.Partial = Plain = (function(_super) {

    __extends(Plain, _super);

    Plain.include(Jet.Helper);

    function Plain(indention, name) {
      this.indention = indention;
      this.name = name;
      this.mode = 'partial';
      this.name = this.name.match(/^\s*[a-zA-Z][a-zA-Z0-9-_]*\s*$/);
      if (!this.name) throw "Illegal partial name";
    }

    Plain.prototype.render = function(obj) {
      var line, partial;
      partial = Jet[this.name](obj);
      if (!this.indention) return partial;
      return ((function() {
        var _i, _len, _ref, _results;
        _ref = partial.split("\n");
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          line = _ref[_i];
          _results.push(line = this.space(this.indention) + line);
        }
        return _results;
      }).call(this)).join("\n");
    };

    return Plain;

  })(Jet.Module);

  Jet.Expression = Expression = (function(_super) {

    __extends(Expression, _super);

    Expression.include(Jet.Helper);

    function Expression(indention, content) {
      var result;
      this.indention = indention;
      if (content == null) content = '';
      this.children = [];
      this.mode = 'node';
      result = content.match(/(\!)?([a-zA-Z$_][a-zA-Z0-9_$]+)(\?)?/);
      this.excal = result[1];
      this.attr = result[2];
      this.q = result[3];
    }

    Expression.prototype.addChild = function(child) {
      this.children.push(child);
      return child.parent = this;
    };

    Expression.prototype.eval = function(obj, attr) {
      var val;
      val = typeof obj[attr] === 'function' ? obj[attr]() : obj[attr];
      if (this.excal) {
        return !val;
      } else {
        return val;
      }
    };

    Expression.prototype.render = function(obj) {
      var o, val;
      val = this.eval(obj, this.attr);
      if (this.q) {
        if (val) {
          return this.renderChildren(obj);
        } else {
          return null;
        }
      } else if (val instanceof Array) {
        return ((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = val.length; _i < _len; _i++) {
            o = val[_i];
            _results.push(this.renderChildren(o));
          }
          return _results;
        }).call(this)).join('\n');
      } else {
        return this.renderChildren(val);
      }
    };

    Expression.prototype.renderChildren = function(obj) {
      var child;
      return ((function() {
        var _i, _len, _ref, _results;
        _ref = this.children;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          child = _ref[_i];
          _results.push(child.render(obj));
        }
        return _results;
      }).call(this)).join('\n');
    };

    return Expression;

  })(Jet.Module);

  Jet.Template = Template = (function() {

    function Template(src) {
      this.roots = [];
      this.parse(src);
    }

    Template.prototype.parse = function(src) {
      var content, indention, line, lines, node, parent, prefix, result, _i, _len, _results;
      src = src.replace(/(\r\n|\r)/, '\n');
      lines = src.split('\n');
      this.nodes = [];
      _results = [];
      for (_i = 0, _len = lines.length; _i < _len; _i++) {
        line = lines[_i];
        result = line.match(/^(\s*)([:=-])?(.*)$/);
        indention = result[1].replace('\t', '  ').length;
        prefix = result[2];
        content = result[3];
        parent = this.nodes[indention - 2];
        if (parent && parent.mode === 'plain' || prefix === ':') {
          node = new Jet.Plain(indention, content);
        } else if (prefix === '=') {
          node = new Jet.Partial(indention, content);
        } else if (prefix === '-') {
          node = new Jet.Expression(indention, content);
        } else {
          node = new Jet.Node(indention, content);
        }
        if (parent) {
          parent.addChild(node);
        } else {
          this.roots.push(node);
        }
        _results.push(this.nodes[indention] = node);
      }
      return _results;
    };

    Template.prototype.render = function(obj) {
      var root;
      return ((function() {
        var _i, _len, _ref, _results;
        _ref = this.roots;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          root = _ref[_i];
          _results.push(root.render(obj));
        }
        return _results;
      }).call(this)).join('\n');
    };

    return Template;

  })();

}).call(this);
