_f = require('fs')
_p = phantom
_p.injectJs(_f.workingDirectory + '/test/lib/jasmine.js')
_p.injectJs(_f.workingDirectory + '/test/lib/console-runner.js')
_p.injectJs(_f.workingDirectory + '/src/jet.coffee')
_p.injectJs(_f.workingDirectory + '/src/template.coffee')
_p.injectJs(_f.workingDirectory + '/src/helper.coffee')
_p.injectJs(_f.workingDirectory + '/src/node.coffee')

if phantom.args.length == 0
  console.log "Need a spec to run"
  phantom.exit 1
  
for spec in phantom.args
  _p.injectJs(_f.workingDirectory + '/test/specs/' + spec + '_spec.coffee')

console_reporter = new jasmine.ConsoleReporter ->
  _p.exit()
jasmine.getEnv().addReporter(console_reporter);
jasmine.getEnv().execute();
