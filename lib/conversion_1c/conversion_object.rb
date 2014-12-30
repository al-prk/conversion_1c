require 'time'
require 'pry'

module Conversion1C
	class ConversionObject
		attr_reader :nth
		attr_reader :class_name
		attr_reader :rule_name


		def initialize(data)
			object = data
			@nth = object.attr('Нпп').to_i
			@class_name = object.attr('Тип')
			@rule_name = object.attr('ИмяПравила')
			@obj = {
				"guid" => data.xpath('Ссылка/Свойство[@Имя = "{УникальныйИдентификатор}"][1]').text.strip
			}.merge(
				extract_properties(data)
			).merge(
				Hash[
					data.xpath('ТабличнаяЧасть').map do |table|
						[
							table.attr('Имя'),
							table.xpath('Запись').map do |record|
								extract_properties(record)
							end
						]
					end
				]
			)
		end

		def extract_properties(object)
			Hash[
				object.xpath('Свойство').map do |property|
					extract_property(property)
				end
			]
		end

		def extract_property(property)
			[
				property.attr('Имя'),
				if property.attr('Тип') == "Число"
					property.text.strip.to_i
				elsif property.attr('Тип') == "Булево"
					property.text.strip == "true"
				elsif property.attr('Тип') == "Дата"
					Time.parse(property.text.strip)
				else
					property.text.strip
				end
			]
		end

		def to_h
			@obj
		end
	end
end
