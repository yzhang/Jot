#!/usr/bin/env rake

desc "Run tests"
task :test do
  system("phantomjs test/runner.coffee jot helper node template")
end

desc "Compile and concatenate coffee to js."
task :compile do
  sources = ['jot', 'helper', 'node', 'template']
  dst     = 'lib/jot.coffee'
  system("rm #{dst}") if File.exist?(dst)
  system("touch #{dst}")

  sources.each do |source|
    src = File.join('src', source + ".coffee")
    system("cat #{src} >> #{dst}")
  end
  
  system("coffee -c #{dst}")
  system("rm #{dst}")
end

task :default => [:test]