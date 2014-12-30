require 'spec_helper'
require 'conversion_1c/conversion_1c'

require 'nokogiri'
require 'time'


module Conversion1C
	describe Conversion1C::ConversionObject do
		describe '#initialize' do
			it "set correct class name, rule name and nth for object" do
				data = Nokogiri::XML('<Объект Нпп="1" Тип="СправочникСсылка.Employees" ИмяПравила="Employees"></Объект>').child
				obj = ConversionObject.new(data)

				expect(obj.rule_name).to eq('Employees')
				expect(obj.class_name).to eq('СправочникСсылка.Employees')
				expect(obj.nth).to eq(1)
			end
		end

		describe "#to_h" do
			it "return correct guid" do
				data = Nokogiri::XML(
					<<-XML
					<Объект Нпп="1" Тип="СправочникСсылка.Employees" ИмяПравила="Employees">
					    <Ссылка Нпп="1">
					      <Свойство Имя="{УникальныйИдентификатор}" Тип="Строка">
					        <Значение>26608149-926e-11e3-93fc-40f2e908438b</Значение>
					      </Свойство>
					</Объект>
					XML
					).child
  				obj = ConversionObject.new(data)
  				expect(obj.to_h["guid"]).to eq('26608149-926e-11e3-93fc-40f2e908438b')
			end



			it "return correct fields values" do
				data = Nokogiri::XML(
					<<-OBJ
					<Объект Нпп="7" Тип="СправочникСсылка.Employees" ИмяПравила="Employees">
					    <Ссылка Нпп="7">
					      <Свойство Имя="{УникальныйИдентификатор}" Тип="Строка">
					        <Значение>75e7c554-d1f7-11db-a0e0-0002b3e9aa0d</Значение>
					      </Свойство>
					    </Ссылка>
					    <Свойство Имя="id" Тип="Число">
					      <Значение>1992</Значение>
					    </Свойство>
					    <Свойство Имя="name" Тип="Строка">
					      <Значение>Иванова</Значение>
					    </Свойство>
					    <Свойство Имя="date" Тип="Дата">
				          <Значение>2013-09-11T00:00:00</Значение>
				        </Свойство>
				        <Свойство Имя="bool" Тип="Булево">
				          <Значение>true</Значение>
				        </Свойство>
					  </Объект>
					OBJ
					).child
  				obj = ConversionObject.new(data)
  				expect(obj.to_h['guid']).to eq("75e7c554-d1f7-11db-a0e0-0002b3e9aa0d")
  				expect(obj.to_h['id']).to eq(1992)
  				expect(obj.to_h['name']).to eq("Иванова")
  				expect(obj.to_h['date']).to eq(Time.parse('2013-09-11T00:00:00'))
  				expect(obj.to_h['bool']).to eq(true)
			end

			it "return correct fields values also for document" do
				data = Nokogiri::XML(
					<<-OBJ
					<?xml version="1.0" encoding="utf-8"?>
					<ФайлОбмена>
						<Объект Нпп="7" Тип="СправочникСсылка.Employees" ИмяПравила="Employees">
						    <Ссылка Нпп="8">
						      <Свойство Имя="{УникальныйИдентификатор}" Тип="Строка">
						        <Значение>75e7c554-d1f7-11db-a0e0-0002b3e9aa0d</Значение>
						      </Свойство>
						    </Ссылка>
						    <Свойство Имя="id" Тип="Число">
						      <Значение>1992</Значение>
						    </Свойство>
						    <Свойство Имя="name" Тип="Строка">
						      <Значение>Иванова</Значение>
						    </Свойство>
						    <Свойство Имя="date" Тип="Дата">
					          <Значение>2013-09-11T00:00:00</Значение>
					        </Свойство>
					        <Свойство Имя="bool" Тип="Булево">
					          <Значение>true</Значение>
					        </Свойство>
						</Объект>
						<Объект Нпп="8" Тип="СправочникСсылка.Employees" ИмяПравила="Employees">
						    <Ссылка Нпп="8">
						      <Свойство Имя="{УникальныйИдентификатор}" Тип="Строка">
						        <Значение>22e7c554-d1f7-11db-a0e0-0002b3e9aa0d</Значение>
						      </Свойство>
						    </Ссылка>
						    <Свойство Имя="id" Тип="Число">
						      <Значение>1993</Значение>
						    </Свойство>
						    <Свойство Имя="name" Тип="Строка">
						      <Значение>Петрова</Значение>
						    </Свойство>
						    <Свойство Имя="date" Тип="Дата">
					          <Значение>2014-09-11T00:00:00</Значение>
					        </Свойство>
					        <Свойство Имя="bool" Тип="Булево">
					          <Значение>true</Значение>
					        </Свойство>
						</Объект>
					</ФайлОбмена>
					OBJ
					).child
				first = data.xpath('//ФайлОбмена/Объект').first
				obj = ConversionObject.new(first)
  				expect(obj.nth).to eq(7)
  				expect(obj.to_h['guid']).to eq("75e7c554-d1f7-11db-a0e0-0002b3e9aa0d")
  				expect(obj.to_h['id']).to eq(1992)
  				expect(obj.to_h['name']).to eq("Иванова")
  				expect(obj.to_h['date']).to eq(Time.parse('2013-09-11T00:00:00'))
  				expect(obj.to_h['bool']).to eq(true)
			end

			it 'return correct data for tables' do
				data = Nokogiri::XML(
					<<-XML
					<Объект Нпп="4" Тип="СправочникСсылка.Clients" ИмяПравила="Clients">
					    <Свойство Имя="id" Тип="Строка">
					      <Значение>00106</Значение>
					    </Свойство>
					    <ТабличнаяЧасть Имя="support_events">
					      <Запись>
					        <Свойство Имя="date" Тип="Дата">
					          <Значение>2014-07-07T00:00:00</Значение>
					        </Свойство>
					        <Свойство Имя="db_id" Тип="УникальныйИдентификатор">
					          <Значение>5e623fff-05eb-11e4-940b-40f2e908438d</Значение>
					        </Свойство>
					        <Свойство Имя="kind" Тип="Строка">
					          <Значение>Ответ на конкретный вопрос</Значение>
					        </Свойство>
					        <Свойство Имя="way" Тип="Строка">
					          <Значение>Телефон</Значение>
					        </Свойство>
					      </Запись>
					      <Запись>
					        <Свойство Имя="date" Тип="Дата">
					          <Значение>2013-09-11T00:00:00</Значение>
					        </Свойство>
					        <Свойство Имя="db_id" Тип="УникальныйИдентификатор">
					          <Значение>8e2e363a-1ac0-11e3-93f6-40f2e908438b</Значение>
					        </Свойство>
					        <Свойство Имя="kind" Тип="Строка">
					          <Значение>Заказ тематической подборки по возникшей проблеме</Значение>
					        </Свойство>
					        <Свойство Имя="way" Тип="Строка">
					          <Значение>Телефон</Значение>
					        </Свойство>
					      </Запись>
					    </ТабличнаяЧасть>
					</Объект>
					XML
				).child
				conversion = ConversionObject.new(data)
				hash = conversion.to_h
				support_events = hash['support_events']

				expect(support_events).not_to be_empty
				expect(support_events.size).to be_equal(2)

				first_line = support_events[0]

				expect(first_line['kind']).to eq("Ответ на конкретный вопрос")
				expect(first_line['date']).to eq(Time.parse('2014-07-07T00:00:00'))

				second_line = support_events[1]

				expect(second_line['kind']).to eq("Заказ тематической подборки по возникшей проблеме")
				expect(second_line['way']).to eq("Телефон")
			end


			it 'return correct data for multiple tables' do
				data = Nokogiri::XML(
					<<-XML
					<Объект Нпп="4" Тип="СправочникСсылка.Clients" ИмяПравила="Clients">
							<Свойство Имя="text" Тип="Строка">
								<Значение>Текст0</Значение>
							</Свойство>
					    <ТабличнаяЧасть Имя="table1">
					      <Запись>
					        <Свойство Имя="text" Тип="Строка">
					          <Значение>Текст1</Значение>
					        </Свойство>
					      </Запись>
					      <Запись>
					        <Свойство Имя="text" Тип="Строка">
					          <Значение>Текст2</Значение>
					        </Свойство>
					      </Запись>
					    </ТабличнаяЧасть>
					    <ТабличнаяЧасть Имя="table2">
					      <Запись>
					        <Свойство Имя="text" Тип="Строка">
					          <Значение>Текст3</Значение>
					        </Свойство>
					      </Запись>
					      <Запись>
					        <Свойство Имя="text" Тип="Строка">
					          <Значение>Текст4</Значение>
					        </Свойство>
					      </Запись>
					    </ТабличнаяЧасть>
					</Объект>
					XML
				).child
				conversion = ConversionObject.new(data)
				hash = conversion.to_h
				expect(hash['text']).to eq("Текст0")
				expect(hash['table1']).not_to be_empty
				expect(hash['table1'].size).to be_equal(2)
				expect(hash['table1'][0]['text']).to eq("Текст1")

				expect(hash['table2']).not_to be_empty
				expect(hash['table2'].size).to be_equal(2)
				expect(hash['table2'][0]['text']).to eq("Текст3")
			end
		end
	end
end
