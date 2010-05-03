desc "Clear caches"
task :clear do
  base = File.expand_path("#{__FILE__}/../../../")
  Dir["#{base}/public/javascripts/cache/*"].each { |filename| rm filename }
end