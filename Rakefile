require 'fileutils'

#
# Config
#
USER = 'interact'
SRC = './build/'
SERVER = {
  :production => {
    :url  => 'interactivethings.com',
    :path => '/home/interact/www/interactivethings.com'
  },
  :staging => {
    :url  => 'staging.interactivethings.com',
    :path => '/home/interact/www/staging.interactivethings.com'
  }
}

#
# Rake Tasks
#

task :default => :help

task :help do
  puts "\n"
  system "rake -T"
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
  system "middleman server"
  system "open http://0.0.0.0:4567"
end



namespace(:deploy) do
  desc "Deploy to production server"
  task :production => :build do
    system rsync(SERVER[:production])
    rm_rf(SRC)
  end  

  desc "Deploy to staging server"
  task :staging => :build do
    system rsync(SERVER[:staging])
    rm_rf(SRC)
  end

  desc "Dry run, test what would happen."
  task :dry => :build do
    system rsync(SERVER[:production], :dry_run => true)
    rm_rf(SRC)
  end
end



#
# Helpers
#
def rsync(remote, options = {:dry_run => false})
  "rsync -avz #{options[:dry_run] ? '--dry-run' : ''} #{SRC} #{USER}@#{remote[:url]}:#{remote[:path]}"
end
