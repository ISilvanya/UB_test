#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура СформироватьОтчетПоВерсиямГрейда(ПараметрыОтчета, АдресРезультата) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИтогиСнизу = Ложь;
	ТабличныйДокумент.ОтображатьСетку = Ложь;
	ТабличныйДокумент.Защита = Ложь;
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	
	Макет = ПолучитьМакет("ПФ_MXL_СравнениеВерсийГрейдов");
	
	СвободнаяСтрока = Макет.ПолучитьОбласть("СвободнаяСтрока");
	
	МодельПланированияЭффективности = ПараметрыОтчета.МодельПланированияЭффективности;
	Грейд = ПараметрыОтчета.Грейд;
	ПоказыватьТолькоОтличия = ПараметрыОтчета.ПоказыватьТолькоОтличия;
	ПерваяВерсияГрейда = ПараметрыОтчета.ПерваяВерсияГрейда;
	ВтораяВерсияГрейда = ПараметрыОтчета.ВтораяВерсияГрейда;
	
	РазличияВерсий = РассчитатьРазличияВерсий(МодельПланированияЭффективности, Грейд, ПоказыватьТолькоОтличия,
		ПерваяВерсияГрейда, ВтораяВерсияГрейда);
	
	РазличияРеквизитовШапки = РазличияВерсий.РазличияРеквизитовШапки;
	РазличияПоказателей = РазличияВерсий.РазличияПоказателей;
	РазличияСтандартов = РазличияВерсий.РазличияСтандартов;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("МодельПланированияЭффективности", МодельПланированияЭффективности);
	СтруктураПараметров.Вставить("Грейд", Грейд);
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.Заполнить(СтруктураПараметров);
	
	ТабличныйДокумент.Вывести(ОбластьШапка);
	
	ПустаяЯчейка = Макет.ПолучитьОбласть("ПустаяЯчейка");
	ЗаголовокВерсии = Макет.ПолучитьОбласть("ЗаголовокВерсии");
	ПредставлениеВерсии = Макет.ПолучитьОбласть("ПредставлениеВерсии");
	
	ОбластьВерсии = Новый ТабличныйДокумент;
	ОбластьВерсии.Вывести(ПустаяЯчейка);
	ОбластьВерсии.Присоединить(ЗаголовокВерсии);
	
	ПредставлениеВерсии.Параметры.ПредставлениеВерсии = ПерваяВерсияГрейда;
	ОбластьВерсии.Присоединить(ПредставлениеВерсии);
	
	ПредставлениеВерсии.Параметры.ПредставлениеВерсии = ВтораяВерсияГрейда;
	ОбластьВерсии.Присоединить(ПредставлениеВерсии);
	
	ТабличныйДокумент.Вывести(ОбластьВерсии);
	
	Если РазличияРеквизитовШапки.Количество() Тогда
		
		ТабличныйДокумент.Вывести(СвободнаяСтрока);
		
		ТабличныйДокумент.НачатьАвтогруппировкуСтрок();
		
		ОбластьШапкаРеквизиты = Макет.ПолучитьОбласть("ШапкаРеквизиты");
		ТабличныйДокумент.Вывести(ОбластьШапкаРеквизиты, 1);
		
		РеквизитыШапкиМоделиПланирования = РеквизитыШапкиМоделиПланирования();
		
		Пока РазличияРеквизитовШапки.Следующий() Цикл
						
			Для Каждого РеквизитШапки Из РеквизитыШапкиМоделиПланирования Цикл
				
				Если ПоказыватьТолькоОтличия
					И Не РазличияРеквизитовШапки.Добавление
					И Не РазличияРеквизитовШапки.Удаление
					И Не РазличияРеквизитовШапки["ИзменилсяРесурс" + РеквизитШапки.Значение] Тогда
					Продолжить;
				КонецЕсли;
				
				ВывестиСтрокуРеквизита(РазличияРеквизитовШапки, РеквизитШапки, ТабличныйДокумент, Макет, 2);
				
			КонецЦикла;
			
		КонецЦикла;
		
		ТабличныйДокумент.ЗакончитьАвтогруппировкуСтрок();
		
	КонецЕсли;
	
	Если РазличияПоказателей.Количество() Тогда
		
		ТабличныйДокумент.Вывести(СвободнаяСтрока);
		
		ТабличныйДокумент.НачатьАвтогруппировкуСтрок();
		
		ОбластьШапкаПоказатели = Макет.ПолучитьОбласть("ШапкаТаблицыПоказатели");
		ТабличныйДокумент.Вывести(ОбластьШапкаПоказатели, 1);
		
		РеквизитыТаблицы = РеквизитыТаблицыПоказателиЭффективности();
		
		Пока РазличияПоказателей.Следующий() Цикл
			
			Если ПоказыватьТолькоОтличия
				И Не РазличияПоказателей.Добавление
				И Не РазличияПоказателей.Удаление Тогда
				
				ЕстьИзменения = Ложь;
				
				Для Каждого ИмяРеквизита Из РеквизитыТаблицы Цикл
					Если РазличияПоказателей["ИзменилсяРесурс" + ИмяРеквизита.Значение] Тогда
						ЕстьИзменения = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Если Не ЕстьИзменения Тогда
					Продолжить;
				КонецЕсли;
				
			КонецЕсли;
			
			ОбластьШапкаСтрокиТаблицы = Макет.ПолучитьОбласть("ШапкаСтрокиТаблицы");
			ОбластьШапкаСтрокиТаблицы.Параметры.ПредставлениеСтрокиТаблицы = РазличияПоказателей.ПоказательЭффективности;
			ТабличныйДокумент.Вывести(ОбластьШапкаСтрокиТаблицы, 2);
			
			ВыборкаДетальныеЗаписи = РазличияПоказателей.Выбрать();
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Для Каждого ИмяРеквизита Из РеквизитыТаблицы Цикл
					Если ПоказыватьТолькоОтличия
						И Не ВыборкаДетальныеЗаписи.Добавление
						И Не ВыборкаДетальныеЗаписи.Удаление
						И Не ВыборкаДетальныеЗаписи["ИзменилсяРесурс" + ИмяРеквизита.Значение] Тогда
						Продолжить;
					КонецЕсли;
					ВывестиСтрокуРеквизита(ВыборкаДетальныеЗаписи, ИмяРеквизита, ТабличныйДокумент, Макет, 3);
				КонецЦикла;
			КонецЦикла;
			
		КонецЦикла;
		
		ТабличныйДокумент.ЗакончитьАвтогруппировкуСтрок();
		
	КонецЕсли;
	
	Если РазличияСтандартов.Количество() Тогда
		
		ТабличныйДокумент.Вывести(СвободнаяСтрока);
		
		ТабличныйДокумент.НачатьАвтогруппировкуСтрок();
		
		ОбластьШапкаСтандарты = Макет.ПолучитьОбласть("ШапкаТаблицыСтандарты");
		ТабличныйДокумент.Вывести(ОбластьШапкаСтандарты, 1);
		
		РеквизитыТаблицы = РеквизитыТаблицыСтандарты();
		
		Пока РазличияСтандартов.Следующий() Цикл
			
			Если ПоказыватьТолькоОтличия
				И Не РазличияСтандартов.Добавление
				И Не РазличияСтандартов.Удаление Тогда
				
				ЕстьИзменения = Ложь;
				
				Для Каждого ИмяРеквизита Из РеквизитыТаблицы Цикл
					Если РазличияСтандартов["ИзменилсяРесурс" + ИмяРеквизита.Значение] Тогда
						ЕстьИзменения = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Если Не ЕстьИзменения Тогда
					Продолжить;
				КонецЕсли;
				
			КонецЕсли;
			
			ОбластьШапкаСтрокиТаблицы = Макет.ПолучитьОбласть("ШапкаСтрокиТаблицы");
			ОбластьШапкаСтрокиТаблицы.Параметры.ПредставлениеСтрокиТаблицы = РазличияСтандартов.Стандарт;
			ТабличныйДокумент.Вывести(ОбластьШапкаСтрокиТаблицы, 2);
			
			ВыборкаДетальныеЗаписи = РазличияСтандартов.Выбрать();
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Для Каждого ИмяРеквизита Из РеквизитыТаблицы Цикл
					Если ПоказыватьТолькоОтличия
						И Не ВыборкаДетальныеЗаписи.Добавление
						И Не ВыборкаДетальныеЗаписи.Удаление
						И Не ВыборкаДетальныеЗаписи["ИзменилсяРесурс" + ИмяРеквизита.Значение] Тогда
						Продолжить;
					КонецЕсли;
					ВывестиСтрокуРеквизита(ВыборкаДетальныеЗаписи, ИмяРеквизита, ТабличныйДокумент, Макет, 3);
				КонецЦикла;
			КонецЦикла;
			
		КонецЦикла;
		
		ТабличныйДокумент.ЗакончитьАвтогруппировкуСтрок();
		
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(ТабличныйДокумент, АдресРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РассчитатьРазличияВерсий(МодельПланированияЭффективности, Грейд, ПоказыватьТолькоОтличия, ПерваяВерсияГрейда, ВтораяВерсияГрейда)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МодельПланированияЭффективности", МодельПланированияЭффективности);
	Запрос.УстановитьПараметр("Грейд", Грейд);
	Запрос.УстановитьПараметр("ПоказыватьТолькоОтличия", ПоказыватьТолькоОтличия);
	Запрос.УстановитьПараметр("ПерваяВерсияГрейда", ПерваяВерсияГрейда);
	Запрос.УстановитьПараметр("ВтораяВерсияГрейда", ВтораяВерсияГрейда);
	
	РазличияРеквизитовШапки = РезультатРазличияРеквизитовШапки(Запрос);
	РазличияПоказателей = РезультатРазличияПоказателей(Запрос);
	РазличияСтандартов = РезультатРазличияСтандартов(Запрос);
	
	РазличияВерсий = Новый Структура;
	РазличияВерсий.Вставить("РазличияРеквизитовШапки", РазличияРеквизитовШапки);
	РазличияВерсий.Вставить("РазличияПоказателей", РазличияПоказателей);
	РазличияВерсий.Вставить("РазличияСтандартов", РазличияСтандартов);
	
	Возврат РазличияВерсий;
	
КонецФункции

Функция РезультатРазличияРеквизитовШапки(Запрос)
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВложенныйЗапрос.МодельПланированияЭффективности КАК МодельПланированияЭффективности,
		|	ВложенныйЗапрос.Грейд КАК Грейд,
		|	ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.ВариантРасчетаПремии) <> МИНИМУМ(ВложенныйЗапрос.ВариантРасчетаПремии)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ИзменилсяРесурсВариантРасчетаПремии,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА НЕ ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.ВариантРасчетаПремии
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК СтароеЗначениеВариантРасчетаПремии,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.ВариантРасчетаПремии
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК НовоеЗначениеВариантРасчетаПремии,
		|	ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.ШкалаПоказателей) <> МИНИМУМ(ВложенныйЗапрос.ШкалаПоказателей)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ИзменилсяРесурсШкалаПоказателей,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА НЕ ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.ШкалаПоказателей
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК СтароеЗначениеШкалаПоказателей,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.ШкалаПоказателей
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК НовоеЗначениеШкалаПоказателей,
		|	ВЫБОР
		|		КОГДА СУММА(ВложенныйЗапрос.ФлагИзменений) = 1
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Удаление,
		|	ВЫБОР
		|		КОГДА СУММА(ВложенныйЗапрос.ФлагИзменений) = -1
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Добавление
		|ИЗ
		|	(ВЫБРАТЬ
		|		СтарыйНабор.МодельПланированияЭффективности КАК МодельПланированияЭффективности,
		|		СтарыйНабор.Грейд КАК Грейд,
		|		СтарыйНабор.ВариантРасчетаПремии КАК ВариантРасчетаПремии,
		|		СтарыйНабор.ШкалаПоказателей КАК ШкалаПоказателей,
		|		1 КАК ФлагИзменений,
		|		ЛОЖЬ КАК НовыйНабор
		|	ИЗ
		|		РегистрСведений.УБ_ВерсииГрейдов КАК СтарыйНабор
		|	ГДЕ
		|		СтарыйНабор.МодельПланированияЭффективности = &МодельПланированияЭффективности
		|		И СтарыйНабор.Грейд = &Грейд
		|		И СтарыйНабор.Статус = ЗНАЧЕНИЕ(Перечисление.УБ_СтатусыМоделейПланирования.Действует)
		|		И СтарыйНабор.ВерсияГрейда = &ПерваяВерсияГрейда
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		НовыйНабор.МодельПланированияЭффективности,
		|		НовыйНабор.Грейд,
		|		НовыйНабор.ВариантРасчетаПремии,
		|		НовыйНабор.ШкалаПоказателей,
		|		-1,
		|		ИСТИНА
		|	ИЗ
		|		РегистрСведений.УБ_ВерсииГрейдов КАК НовыйНабор
		|	ГДЕ
		|		НовыйНабор.МодельПланированияЭффективности = &МодельПланированияЭффективности
		|		И НовыйНабор.Грейд = &Грейд
		|		И НовыйНабор.Статус = ЗНАЧЕНИЕ(Перечисление.УБ_СтатусыМоделейПланирования.Действует)
		|		И НовыйНабор.ВерсияГрейда = &ВтораяВерсияГрейда) КАК ВложенныйЗапрос
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос.МодельПланированияЭффективности,
		|	ВложенныйЗапрос.Грейд
		|ИМЕЮЩИЕ
		|	(НЕ &ПоказыватьТолькоОтличия
		|	ИЛИ СУММА(ВложенныйЗапрос.ФлагИзменений) <> 0
		|	ИЛИ ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.ВариантРасчетаПремии) <> МИНИМУМ(ВложенныйЗапрос.ВариантРасчетаПремии)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|	ИЛИ ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.ШкалаПоказателей) <> МИНИМУМ(ВложенныйЗапрос.ШкалаПоказателей)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выбрать();
	
КонецФункции

Функция РезультатРазличияПоказателей(Запрос)
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВложенныйЗапрос.МодельПланированияЭффективности КАК МодельПланированияЭффективности,
		|	ВложенныйЗапрос.Грейд КАК Грейд,
		|	ВложенныйЗапрос.ПоказательЭффективности КАК ПоказательЭффективности,
		|	ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.Вес) <> МИНИМУМ(ВложенныйЗапрос.Вес)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ ИзменилсяРесурсВес,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА НЕ ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.Вес
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК СтароеЗначениеВес,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.Вес
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК НовоеЗначениеВес,
		|	ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.План) <> МИНИМУМ(ВложенныйЗапрос.План)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ ИзменилсяРесурсПлан,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА НЕ ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.План
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК СтароеЗначениеПлан,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.План
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК НовоеЗначениеПлан,
		|	ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.КритическоеЗначение) <> МИНИМУМ(ВложенныйЗапрос.КритическоеЗначение)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ ИзменилсяРесурсКритическоеЗначение,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА НЕ ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.КритическоеЗначение
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК СтароеЗначениеКритическоеЗначение,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.КритическоеЗначение
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК НовоеЗначениеКритическоеЗначение,
		|	ВЫБОР
		|		КОГДА
		|			МАКСИМУМ(ВложенныйЗапрос.МинимальноеЗначениеРезультата) <> МИНИМУМ(ВложенныйЗапрос.МинимальноеЗначениеРезультата)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ ИзменилсяРесурсМинимальноеЗначениеРезультата,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА НЕ ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.МинимальноеЗначениеРезультата
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК СтароеЗначениеМинимальноеЗначениеРезультата,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.МинимальноеЗначениеРезультата
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК НовоеЗначениеМинимальноеЗначениеРезультата,
		|	ВЫБОР
		|		КОГДА
		|			МАКСИМУМ(ВложенныйЗапрос.МаксимальноеЗначениеРезультата) <> МИНИМУМ(ВложенныйЗапрос.МаксимальноеЗначениеРезультата)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ ИзменилсяРесурсМаксимальноеЗначениеРезультата,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА НЕ ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.МаксимальноеЗначениеРезультата
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК СтароеЗначениеМаксимальноеЗначениеРезультата,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.МаксимальноеЗначениеРезультата
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК НовоеЗначениеМаксимальноеЗначениеРезультата,
		|	ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.ШкалаПоказателей) <> МИНИМУМ(ВложенныйЗапрос.ШкалаПоказателей)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ ИзменилсяРесурсШкалаПоказателей,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА НЕ ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.ШкалаПоказателей
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК СтароеЗначениеШкалаПоказателей,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.ШкалаПоказателей
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК НовоеЗначениеШкалаПоказателей,
		|	ВЫБОР
		|		КОГДА СУММА(ВложенныйЗапрос.ФлагИзменений) = 1
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Удаление,
		|	ВЫБОР
		|		КОГДА СУММА(ВложенныйЗапрос.ФлагИзменений) = -1
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Добавление
		|ИЗ
		|	(ВЫБРАТЬ
		|		СтарыйНабор.МодельПланированияЭффективности КАК МодельПланированияЭффективности,
		|		СтарыйНабор.Грейд КАК Грейд,
		|		СтарыйНабор.ПоказательЭффективности КАК ПоказательЭффективности,
		|		СтарыйНабор.Вес КАК Вес,
		|		СтарыйНабор.План КАК План,
		|		СтарыйНабор.КритическоеЗначение КАК КритическоеЗначение,
		|		СтарыйНабор.МинимальноеЗначениеРезультата КАК МинимальноеЗначениеРезультата,
		|		СтарыйНабор.МаксимальноеЗначениеРезультата КАК МаксимальноеЗначениеРезультата,
		|		СтарыйНабор.ШкалаПоказателей КАК ШкалаПоказателей,
		|		1 КАК ФлагИзменений,
		|		ЛОЖЬ КАК НовыйНабор
		|	ИЗ
		|		РегистрСведений.УБ_СоставПоказателейМоделейПланирования.СрезПоследних(,
		|			МодельПланированияЭффективности = &МодельПланированияЭффективности
		|		И Грейд = &Грейд
		|		И ВерсияГрейда = &ПерваяВерсияГрейда) КАК СтарыйНабор
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		НовыйНабор.МодельПланированияЭффективности,
		|		НовыйНабор.Грейд,
		|		НовыйНабор.ПоказательЭффективности,
		|		НовыйНабор.Вес,
		|		НовыйНабор.План,
		|		НовыйНабор.КритическоеЗначение,
		|		НовыйНабор.МинимальноеЗначениеРезультата,
		|		НовыйНабор.МаксимальноеЗначениеРезультата,
		|		НовыйНабор.ШкалаПоказателей,
		|		-1,
		|		ИСТИНА
		|	ИЗ
		|		РегистрСведений.УБ_СоставПоказателейМоделейПланирования.СрезПоследних(,
		|			МодельПланированияЭффективности = &МодельПланированияЭффективности
		|		И Грейд = &Грейд
		|		И ВерсияГрейда = &ВтораяВерсияГрейда) КАК НовыйНабор) КАК ВложенныйЗапрос
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос.МодельПланированияЭффективности,
		|	ВложенныйЗапрос.Грейд,
		|	ВложенныйЗапрос.ПоказательЭффективности
		|ИМЕЮЩИЕ
		|	(НЕ &ПоказыватьТолькоОтличия
		|	ИЛИ СУММА(ВложенныйЗапрос.ФлагИзменений) <> 0
		|	ИЛИ ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.Вес) <> МИНИМУМ(ВложенныйЗапрос.Вес)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|	ИЛИ ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.План) <> МИНИМУМ(ВложенныйЗапрос.План)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|	ИЛИ ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.КритическоеЗначение) <> МИНИМУМ(ВложенныйЗапрос.КритическоеЗначение)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|	ИЛИ ВЫБОР
		|		КОГДА
		|			МАКСИМУМ(ВложенныйЗапрос.МинимальноеЗначениеРезультата) <> МИНИМУМ(ВложенныйЗапрос.МинимальноеЗначениеРезультата)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|	ИЛИ ВЫБОР
		|		КОГДА
		|			МАКСИМУМ(ВложенныйЗапрос.МаксимальноеЗначениеРезультата) <> МИНИМУМ(ВложенныйЗапрос.МаксимальноеЗначениеРезультата)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|	ИЛИ ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.ШкалаПоказателей) <> МИНИМУМ(ВложенныйЗапрос.ШкалаПоказателей)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ)
		|ИТОГИ
		|	МАКСИМУМ(ИзменилсяРесурсВес),
		|	МАКСИМУМ(ИзменилсяРесурсПлан),
		|	МАКСИМУМ(ИзменилсяРесурсКритическоеЗначение),
		|	МАКСИМУМ(ИзменилсяРесурсМинимальноеЗначениеРезультата),
		|	МАКСИМУМ(ИзменилсяРесурсМаксимальноеЗначениеРезультата),
		|	МАКСИМУМ(ИзменилсяРесурсШкалаПоказателей),
		|	МАКСИМУМ(Удаление),
		|	МАКСИМУМ(Добавление)
		|ПО
		|	ПоказательЭффективности";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
КонецФункции

Функция РезультатРазличияСтандартов(Запрос)
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВложенныйЗапрос.МодельПланированияЭффективности КАК МодельПланированияЭффективности,
		|	ВложенныйЗапрос.Грейд КАК Грейд,
		|	ВложенныйЗапрос.Стандарт КАК Стандарт,
		|	ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.ШкалаОценок) <> МИНИМУМ(ВложенныйЗапрос.ШкалаОценок)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ИзменилсяРесурсШкалаОценок,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА НЕ ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.ШкалаОценок
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК СтароеЗначениеШкалаОценок,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.ШкалаОценок
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК НовоеЗначениеШкалаОценок,
		|	ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.Вес) <> МИНИМУМ(ВложенныйЗапрос.Вес)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ИзменилсяРесурсВес,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА НЕ ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.Вес
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК СтароеЗначениеВес,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ВложенныйЗапрос.НовыйНабор
		|			ТОГДА ВложенныйЗапрос.Вес
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ) КАК НовоеЗначениеВес,
		|	ВЫБОР
		|		КОГДА СУММА(ВложенныйЗапрос.ФлагИзменений) = 1
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Удаление,
		|	ВЫБОР
		|		КОГДА СУММА(ВложенныйЗапрос.ФлагИзменений) = -1
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Добавление
		|ИЗ
		|	(ВЫБРАТЬ
		|		СтарыйНабор.МодельПланированияЭффективности КАК МодельПланированияЭффективности,
		|		СтарыйНабор.Грейд КАК Грейд,
		|		СтарыйНабор.Стандарт КАК Стандарт,
		|		СтарыйНабор.ШкалаОценок КАК ШкалаОценок,
		|		СтарыйНабор.Вес КАК Вес,
		|		1 КАК ФлагИзменений,
		|		ЛОЖЬ КАК НовыйНабор
		|	ИЗ
		|		РегистрСведений.УБ_СоставСтандартовМоделейПланирования.СрезПоследних(,
		|			МодельПланированияЭффективности = &МодельПланированияЭффективности
		|		И Грейд = &Грейд
		|		И ВерсияГрейда = &ПерваяВерсияГрейда) КАК СтарыйНабор
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		НовыйНабор.МодельПланированияЭффективности,
		|		НовыйНабор.Грейд,
		|		НовыйНабор.Стандарт,
		|		НовыйНабор.ШкалаОценок,
		|		НовыйНабор.Вес,
		|		-1,
		|		ИСТИНА
		|	ИЗ
		|		РегистрСведений.УБ_СоставСтандартовМоделейПланирования.СрезПоследних(,
		|			МодельПланированияЭффективности = &МодельПланированияЭффективности
		|		И Грейд = &Грейд
		|		И ВерсияГрейда = &ВтораяВерсияГрейда) КАК НовыйНабор) КАК ВложенныйЗапрос
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос.МодельПланированияЭффективности,
		|	ВложенныйЗапрос.Грейд,
		|	ВложенныйЗапрос.Стандарт
		|ИМЕЮЩИЕ
		|	(НЕ &ПоказыватьТолькоОтличия
		|	ИЛИ СУММА(ВложенныйЗапрос.ФлагИзменений) <> 0
		|	ИЛИ ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.ШкалаОценок) <> МИНИМУМ(ВложенныйЗапрос.ШкалаОценок)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|	ИЛИ ВЫБОР
		|		КОГДА МАКСИМУМ(ВложенныйЗапрос.Вес) <> МИНИМУМ(ВложенныйЗапрос.Вес)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ)
		|ИТОГИ
		|	МАКСИМУМ(ИзменилсяРесурсШкалаОценок),
		|	МАКСИМУМ(ИзменилсяРесурсВес),
		|	МАКСИМУМ(Удаление),
		|	МАКСИМУМ(Добавление)
		|ПО
		|	Стандарт";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
КонецФункции

Функция РеквизитыШапкиМоделиПланирования()
	
	СписокРеквизитов = Новый СписокЗначений;
	СписокРеквизитов.Добавить("ШкалаПоказателей", НСтр("ru = 'Шкала показателей'"));
	СписокРеквизитов.Добавить("ВариантРасчетаПремии", НСтр("ru = 'Вариант расчета премии'"));
	
	Возврат СписокРеквизитов;
	
КонецФункции

Функция РеквизитыТаблицыПоказателиЭффективности()
	
	СписокРеквизитов = Новый СписокЗначений;
	СписокРеквизитов.Добавить("Вес", НСтр("ru = 'Вес'"));
	СписокРеквизитов.Добавить("План", НСтр("ru = 'План'"));
	СписокРеквизитов.Добавить("КритическоеЗначение", НСтр("ru = 'Критическое значение'"));
	СписокРеквизитов.Добавить("МинимальноеЗначениеРезультата", НСтр("ru = 'Минимальное значение результата'"));
	СписокРеквизитов.Добавить("МаксимальноеЗначениеРезультата", НСтр("ru = 'Максимальное значение результата'"));
	СписокРеквизитов.Добавить("ШкалаПоказателей", НСтр("ru = 'Шкала показателей'"));
	
	Возврат СписокРеквизитов;
	
КонецФункции

Функция РеквизитыТаблицыСтандарты()
	
	СписокРеквизитов = Новый СписокЗначений;
	СписокРеквизитов.Добавить("ШкалаОценок", НСтр("ru = 'Шкала оценок'"));
	СписокРеквизитов.Добавить("Вес", НСтр("ru = 'Вес'"));
	
	Возврат СписокРеквизитов;
	
КонецФункции

Процедура ВывестиСтрокуРеквизита(Выборка, СтруктураРеквизита, ТабличныйДокумент, Макет, УровеньГруппировки)
	
	ИмяРеквизита = СтруктураРеквизита.Значение;
	
	ПустаяЯчейка = Макет.ПолучитьОбласть("ПустаяЯчейка");
	
	СтрокаРеквизита = Новый ТабличныйДокумент;
	СтрокаРеквизита.Вывести(ПустаяЯчейка);
	
	ОбластьНаименованиеРеквизитаПоля = Макет.ПолучитьОбласть("НаименованиеРеквизитаПоля");
	ОбластьНаименованиеРеквизитаПоля.Параметры.НаименованиеРеквизитаПоля = СтруктураРеквизита.Представление;
	
	СтрокаРеквизита.Присоединить(ОбластьНаименованиеРеквизитаПоля);
	
	Если Выборка.Удаление Тогда
		
		ЯчейкаСтароеЗначение = Макет.ПолучитьОбласть("УдаленныйРеквизит");
		ЯчейкаСтароеЗначение.Параметры.ЗначениеРеквизита = Выборка["СтароеЗначение" + ИмяРеквизита];
		
		ЯчейкаНовоеЗначение = Макет.ПолучитьОбласть("ИсходноеЗначениеРеквизита");
		
	ИначеЕсли Выборка.Добавление Тогда
		
		ЯчейкаСтароеЗначение = Макет.ПолучитьОбласть("ИсходноеЗначениеРеквизита");
		
		ЯчейкаНовоеЗначение = Макет.ПолучитьОбласть("ДобавленныйРеквизит");
		ЯчейкаНовоеЗначение.Параметры.ЗначениеРеквизита = Выборка["НовоеЗначение" + ИмяРеквизита];
		
	ИначеЕсли Выборка["ИзменилсяРесурс" + ИмяРеквизита] Тогда
		
		ЯчейкаСтароеЗначение = Макет.ПолучитьОбласть("ИзмененноеЗначениеРеквизита");
		ЯчейкаСтароеЗначение.Параметры.ЗначениеРеквизита = Выборка["СтароеЗначение" + ИмяРеквизита];
		
		ЯчейкаНовоеЗначение = Макет.ПолучитьОбласть("ИзмененноеЗначениеРеквизита");
		ЯчейкаНовоеЗначение.Параметры.ЗначениеРеквизита = Выборка["НовоеЗначение" + ИмяРеквизита];
		
	Иначе
		
		ЯчейкаСтароеЗначение = Макет.ПолучитьОбласть("ИсходноеЗначениеРеквизита");
		ЯчейкаСтароеЗначение.Параметры.ЗначениеРеквизита = Выборка["СтароеЗначение" + ИмяРеквизита];
		
		ЯчейкаНовоеЗначение = Макет.ПолучитьОбласть("ИсходноеЗначениеРеквизита");
		ЯчейкаНовоеЗначение.Параметры.ЗначениеРеквизита = Выборка["НовоеЗначение" + ИмяРеквизита];
		
	КонецЕсли;
	
	СтрокаРеквизита.Присоединить(ЯчейкаСтароеЗначение);
	СтрокаРеквизита.Присоединить(ЯчейкаНовоеЗначение);
	
	ТабличныйДокумент.Вывести(СтрокаРеквизита, УровеньГруппировки);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли