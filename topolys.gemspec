
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "topolys/version"

Gem::Specification.new do |spec|
  spec.name          = "topolys"
  spec.version       = Topolys::VERSION
  spec.authors       = ["Dan Macumber & Denis Bourgeois"]
  spec.email         = ["dan@automaticmagic.com"]

  spec.summary       = ""
  spec.description   = ""
  spec.homepage      = "https://github.com/macumber/topolys.git"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the " \
  # 'allowed_push_host'to allow pushing to a single host or delete this section " \
  # to allow pushing to any host.
  #if spec.respond_to?(:metadata)
   # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/macumber/topolys/tree/v#{spec.version}"
    #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  #else
    #raise "RubyGems 2.0 or newer is required to protect against " \
    #  "public gem pushes."
  #end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if /^2.2/.match(RUBY_VERSION)
    spec.required_ruby_version = "~> 2.2.0"

    spec.add_development_dependency "public_suffix", "~> 3.1.1"
    spec.add_development_dependency "json-schema", "~> 2.7.0"
    spec.add_development_dependency "bundler", "~> 1.17.1"
    spec.add_development_dependency "rake",    "~> 12.3"
    spec.add_development_dependency "rspec",   "~> 3.7.0"
    spec.add_development_dependency "rubocop", "~> 0.54.0"
    spec.add_development_dependency "yard",    "~> 0.9"
    spec.add_development_dependency "parallel","~> 1.19.2"

  else
    spec.add_development_dependency "public_suffix", "~> 3.1.1"
    spec.add_development_dependency "json-schema", "~> 2.7.0"
    spec.add_development_dependency "bundler", "~> 2.1"
    spec.add_development_dependency "rake",    "~> 13.0"
    spec.add_development_dependency "rspec",   "~> 3.9"
    spec.add_development_dependency "rubocop", "~> 0.54.0"
    spec.add_development_dependency "yard",    "~> 0.9"
  end
end
