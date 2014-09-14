require "conversion_1c/version"
require "conversion_1c/conversion_object"

module Conversion1C
	class Conversion
		include Enumerable

		def initialize(data)
			@data = data
		end

		def each
			@data.xpath('//ФайлОбмена/Объект').each do |object|
				yield ConversionObject.new(object)
			end
		end
	end
end