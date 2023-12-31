#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ОтразитьВерсииГрейдов(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаВерсииГрейдов;
	
	Если Отказ Или Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияВерсииГрейдов = Движения.УБ_ВерсииГрейдов;
	ДвиженияВерсииГрейдов.Записывать = Истина;
	ДвиженияВерсииГрейдов.Загрузить(Таблица);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.УБ_ВерсииГрейдов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "1.0.1.7";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Приведение реквизита ""Показатель расчета зарплаты"" регистра ""Версии грейдов"" к значению по умолчанию'");
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВерсииГрейдов.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.УБ_ВерсииГрейдов КАК ВерсииГрейдов
		|ГДЕ
		|	ВерсииГрейдов.ПоказательРасчетаЗарплатыПриБезокладнойСистеме = НЕОПРЕДЕЛЕНО";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.УБ_ВерсииГрейдов.НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Выборка.Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.УБ_ВерсииГрейдов.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.Прочитать();
			Для Каждого Запись Из НаборЗаписей Цикл
				Запись.ПоказательРасчетаЗарплатыПриБезокладнойСистеме = УБ_ОбщегоНазначения.ЗначениеРеквизитаПоУмолчанию("ПоказательРасчетаЗарплаты");
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать движения по регистру ""Версии грейдов"" документа ""%1"" по причине: %2'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстСообщения,
				Выборка.Регистратор,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы'"),
				УровеньЖурналаРегистрации.Предупреждение,
				Выборка.Регистратор.Метаданные(),
				Выборка.Регистратор,
				ТекстСообщения);
			
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли