require_relative "lib/rss/version"

Gem::Specification.new do |spec|
  spec.name          = "rss"
  spec.version       = RSS::VERSION
  spec.authors       = ["Kouhei Sutou"]
  spec.email         = ["kou@cozmixng.org"]

  spec.summary       = %q{Family of libraries that support various formats of XML "feeds".}
  spec.description   = %q{Family of libraries that support various formats of XML "feeds".}
  spec.homepage      = "https://github.com/ruby/rss"
  spec.license       = "BSD-2-Clause"

  spec.files = [
    "LICENSE.txt",
    "NEWS.md",
    "README.md",
  ]
  spec.files += Dir.glob("lib/**/*.rb")
  spec.require_paths = ["lib"]

  spec.add_dependency "rexml"
end
