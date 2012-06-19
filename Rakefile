#!/usr/bin/env rake

desc "Run tests"
task :test do
  system("phantomjs test/specs/jet_spec.coffee")
end

desc "Compile and concatenate coffee to js."
task :compile do
  Dir.entries('src').each do |entry|
    path = File.join('src', entry)
    compile(path) if File.file?(path)
  end
end

def compile(path)
  filename = File.basename(path, ".coffee")
  coffee   = File.join('src', filename + '.coffee')
  system("coffee -c #{coffee}")

  src      = File.join('src', filename + '.js')
  dst      = File.join('lib', filename + '.js')
  File.delete(dst) if File.exist?(dst)
  system("mv #{src} #{dst}")
end

task :default => [:test]