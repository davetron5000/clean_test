require 'bundler'
require 'rake/clean'
require 'rake/testtask'
require 'sdoc'

include Rake::DSL

Bundler::GemHelper.install_tasks

desc 'run tests'
Rake::TestTask.new do |t|
  t.libs << "lib"
  t.libs << "test"
  t.ruby_opts << "-rrubygems"
  t.test_files = FileList['test/bootstrap.rb','test/test_*.rb']
end

desc 'build rdoc'
task :rdoc => [:build_rdoc, :hack_css]

RDoc::Task.new(:build_rdoc) do |rd|
  rd.main = "README.rdoc"
  rd.options << '-f' << 'sdoc'
  rd.template = 'direct'
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
  rd.title = 'Clean Test - make your Test::Unit test cases clean and readable'
  rd.markup = 'tomdoc'
end
CLOBBER << 'html'

FONT_FIX = {
  "0.82em" => "16px",
  "0.833em" => "16px",
  "0.85em" => "16px",
  "1.15em" => "20px",
  "1.1em" => "20px",
  "1.2em" => "20px",
  "1.4em" => "24px",
  "1.5em" => "24px",
  "1.6em" => "32px",
  "1em" => "16px",
  "2.1em" => "38px",
}


task :hack_css do
  maincss = File.open('html/css/main.css').readlines
  File.open('html/css/main.css','w') do |file|
    file.puts '@import url(https://fonts.googleapis.com/css?family=Lato:300italic,700italic,300,700);'
    maincss.each do |line|
      if line.strip == 'font-family: "Helvetica Neue", Arial, sans-serif;'
        file.puts 'font-family: Lato, "Helvetica Neue", Arial, sans-serif;'
      elsif line.strip == 'font-family: monospace;'
        file.puts 'font-family: Monaco, monospace;'
      elsif line =~ /^pre\s*$/
        file.puts "pre {
          font-family: Monaco, monospace;
          margin-bottom: 1em;
        }
        pre.original"
      elsif line =~ /^\s*font-size:\s*(.*)\s*;/
        if FONT_FIX[$1]
          file.puts "font-size: #{FONT_FIX[$1]};"
        else
          file.puts line.chomp
        end
      else
        file.puts line.chomp
      end
    end
  end
end
CLOBBER << 'coverage'

task :default => :test
