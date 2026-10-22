# frozen_string_literal: false
require_relative "rss-testcase"

module RSS
  class TestAutoload < TestCase
    def test_maker_loaded_on_first_use
      lib_dir = File.expand_path("../lib", __dir__)
      script = <<~SCRIPT
        require "rss"
        maker_loaded = -> { $LOADED_FEATURES.any? { |path| path.end_with?("/rss/maker.rb") } }
        print maker_loaded.call, " "
        RSS::Maker
        print maker_loaded.call
      SCRIPT
      output = IO.popen([RbConfig.ruby, "-I", lib_dir, "-e", script], &:read)
      assert_equal("false true", output)
    end
  end
end
