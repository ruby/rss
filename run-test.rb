#!/usr/bin/env ruby

$LOAD_PATH.unshift("test")
$LOAD_PATH.unshift("lib")

Dir.glob("test/rss/**/*test_*.rb") do |test_rb|
  require File.expand_path(test_rb)
end
