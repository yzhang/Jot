(function() {
  var Jet, Node, tags, templates;

  templates = [];

  tags = ['a', 'abbr', 'address', 'area', 'article', 'aside', 'audio', 'b', 'base', 'bdi', 'bdo', 'blockquote', 'body', 'br', 'button', 'canvas', 'caption', 'cite', 'code', 'col', 'colgroup', 'command', 'datalist', 'dd', 'del', 'details', 'dfn', 'div', 'dl', 'dt', 'em', 'embed', 'fieldset', 'figcaption', 'figure', 'footer', 'form', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'header', 'hgroup', 'hr', 'html', 'i', 'iframe', 'img', 'input', 'ins', 'keygen', 'kbd', 'label', 'legend', 'li', 'link', 'map', 'mark', 'menu', 'meta', 'meter', 'nav', 'noscript', 'object', 'ol', 'optgroup', 'option', 'output', 'p', 'param', 'pre', 'progress', 'q', 'rp', 'rt', 'ruby', 's', 'samp', 'script', 'section', 'select', 'small', 'source', 'span', 'strong', 'style', 'sub', 'summary', 'sup', 'table', 'tbody', 'td', 'textarea', 'tfoot', 'th', 'thead', 'time', 'title', 'tr', 'track', 'u', 'ul', 'var', 'video', 'wbr'];

  Jet = window.Jet = function(name, obj) {
    if (typeof obj === 'string') {
      return Jet.register(name, obj);
    } else {
      return Jet.render(name, obj);
    }
  };

  Jet.Node = Node = (function() {

    function Node(tag, indention, id, classes, attrs, content) {
      this.tag = tag;
      this.indention = indention;
      this.id = id;
      this.classes = classes != null ? classes : [];
      this.attrs = attrs != null ? attrs : {};
      this.content = content != null ? content : [];
      this.children = [];
      this.parent = null;
    }

    Node.prototype.render = function(obj) {
      return '';
    };

    return Node;

  })();

  Jet.register = function(name, template) {
    var last, line, lines, node, nodes, _i, _len;
    template = template.replace(/(\r\n|\r)/, '\n');
    lines = template.split('\n');
    nodes = [];
    last = null;
    for (_i = 0, _len = lines.length; _i < _len; _i++) {
      line = lines[_i];
      node = Jet.parse(line);
      while (last && last.parent) {
        if (last.indention === node.indention) break;
        last = last.parent;
      }
      if (last && last.parent) {
        last.parent.addChild(node);
      } else {
        nodes.push(node);
      }
      last = node;
    }
    return nodes;
  };

  Jet.parse = function(line) {
    var classes, id, indention, node, regex, result, tag, text;
    regex = new RegExp("(\\s*)([\\.#]?[a-zA-Z][a-zA-Z0-9-_#\\.}]*)($|\\s+(.*)$)");
    result = line.match(regex);
    if (!result) {
      console.error("SyntaxError in line: " + line);
      return null;
    }
    indention = result[1].replace('\t', '  ').length;
    node = result[2];
    text = result[4];
    tag = (node.match(/^[a-zA-Z][a-zA-Z0-9-_]*/) || ['div'])[0];
    id = node.match(/#[a-zA-Z][a-zA-Z0-9-_]*/g) || [''];
    if (id instanceof Array && id.length > 1) {
      console.error("SyntaxError: One tag should only have one id");
      return null;
    }
    id = id[0].slice(1);
    classes = node.match(/\.[a-zA-Z][a-zA-Z0-9-_]*/g);
    return new Node(tag, indention, id, classes);
  };

  Jet.render = function(name, obj) {
    return '';
  };

}).call(this);
