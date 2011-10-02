require 'fileutils'
require 'grancher/task'

#
# Rake Tasks
#

task :default => :help

task :help do
  puts "\n"
  system "rake -T"
  puts "\nTo publish this repo to Github pages, run 'rake publish'\nand then push the 'gh-pages' branch to Github."
end

desc "Install all required files."
task :install do
  puts "Starting installation …"
  
  commands = [
    "sudo gem update --system",
    "sudo gem install bundler",
    "bundle install"
  ]
  
  system commands.join(";")
  
  puts "Installation successful!"
end



desc "Build Public HTML"
task :build do
  system "middleman build"
end



desc "Run local development server"
task :server do
  system "open http://0.0.0.0:4567"
  system "middleman server"
end



Grancher::Task.new do |g|
  g.branch = 'gh-pages'
  g.keep '.gitignore'
  # Can't actually push automatically because we're working
  # in a Github organization repo.
  # g.push_to = 'origin' # automatically push too
  
  g.directory 'build'
end
