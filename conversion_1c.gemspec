# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'conversion_1c/version'

Gem::Specification.new do |spec|
  spec.name          = "conversion_1c"
  spec.version       = Conversion1C::VERSION
  spec.authors       = ["Alexandr Prokopenko"]
  spec.email         = ["prokopenko@igc.ru"]
  spec.summary       = %q{Гем для парсинга файлов обмена 1С:Конвертация Данных}
  spec.description   = %q{Гем для парсинга файлов обмена 1С:Конвертация Данных}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib/conversion_1c"]

  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-autotest"
end
