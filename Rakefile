require "bundler/gem_helper"

helper = Bundler::GemHelper.new(__dir__)
def helper.version_tag
  version
end

helper.install

desc "Run test"
task :test do
  ruby("test/run-test.rb")
end

task :default => :test

release_task = Rake.application["release"]
# We use Trusted Publishing.
release_task.prerequisites.delete("build")
release_task.prerequisites.delete("release:rubygem_push")
release_task_comment = release_task.comment
if release_task_comment
  release_task.clear_comments
  release_task.comment = release_task_comment.gsub(/ and build.*$/, "")
end
