(function() {
  var Jet, _T;

  _T = [];

  window.Jet = Jet = function(name, fn) {
    return _T[name] = fn;
  };

  Jet.version = '0.0.1';

}).call(this);
