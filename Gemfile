source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in rss.gemspec
gemspec

rexml_path = ENV["RSS_REXML_PATH"]
if rexml_path
  gem "rexml", path: rexml_path
end

group :development do
  gem "bundler"
  gem "rake"
  gem "test-unit"
end
