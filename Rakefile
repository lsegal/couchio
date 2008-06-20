require 'rubygems'
require 'rake/gempackagetask'
require 'spec'
require 'spec/rake/spectask'

WINDOWS = (PLATFORM =~ /win32|cygwin/ ? true : false) rescue false
SUDO = WINDOWS ? '' : 'sudo'

task :default => :specs

load 'couchio.gemspec'
Rake::GemPackageTask.new(SPEC) do |pkg|
  pkg.gem_spec = SPEC
  pkg.need_zip = true
  pkg.need_tar = true
end

desc "Install the gem locally"
task :install => :package do 
  sh "#{SUDO} gem install pkg/#{SPEC.name}-#{SPEC.version}.gem --local"
end

desc "Run all specs"
Spec::Rake::SpecTask.new("specs") do |t|
  $DEBUG = true if ENV['DEBUG']
  t.spec_opts = ["--format", "specdoc", "--colour"]
  t.spec_files = Dir["spec/**/*_spec.rb"].sort
end

YARD::Rake::YardocTask.new