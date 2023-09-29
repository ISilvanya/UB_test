#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ОтразитьСостоянияДокументовРасчетаЭффективностиСотрудников(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСостоянияДокументовРасчетаЭффективностиСотрудников;
	
	Если Отказ Или Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияСостоянияДокументовРасчетаЭффективностиСотрудников = Движения.УБ_СостоянияДокументовРасчетаЭффективностиСотрудников;
	ДвиженияСостоянияДокументовРасчетаЭффективностиСотрудников.Записывать = Истина;
	ДвиженияСостоянияДокументовРасчетаЭффективностиСотрудников.Загрузить(Таблица);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.УБ_СостоянияДокументовРасчетаЭффективностиСотрудников.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "1.0.1.7";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Первоначальное заполнение регистра состояний документов расчета эффективности.'");
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если Не Параметры.Свойство("ИнициализацияВыполнена") Тогда
		
		Параметры.Вставить("ИнициализацияВыполнена", Истина);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	РасчетЭффективностиСотрудников.Ссылка КАК Ссылка
			|ИЗ
			|	Документ.УБ_РасчетЭффективностиСотрудников КАК РасчетЭффективностиСотрудников
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УБ_СостоянияДокументовРасчетаЭффективностиСотрудников КАК СостоянияДокументов
			|		ПО РасчетЭффективностиСотрудников.Ссылка = СостоянияДокументов.РасчетЭффективностиСотрудника
			|ГДЕ
			|	РасчетЭффективностиСотрудников.Проведен
			|	И СостоянияДокументов.Состояние ЕСТЬ NULL";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			Параметры.ОбработкаЗавершена = Истина;
			Возврат;
		КонецЕсли;
		
		Выборка = РезультатЗапроса.Выбрать();
		Параметры.ПрогрессВыполнения.ВсегоОбъектов = Выборка.Количество();
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 100
		|	РасчетЭффективностиСотрудников.Ссылка КАК Ссылка,
		|	РасчетЭффективностиСотрудников.Сотрудник КАК Сотрудник,
		|	РасчетЭффективностиСотрудников.Подразделение КАК Подразделение,
		|	РасчетЭффективностиСотрудников.Организация КАК Организация,
		|	РасчетЭффективностиСотрудников.НачалоПериода КАК НачалоПериода,
		|	РасчетЭффективностиСотрудников.КонецПериода КАК КонецПериода,
		|	ВЫБОР
		|		КОГДА РасчетЭффективностиСотрудников.ФактУтвержден
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.УБ_СостоянияДокументовРасчетаЭффективностиСотрудников.ФактУтвержден)
		|		КОГДА РасчетЭффективностиСотрудников.ПланУтвержден
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.УБ_СостоянияДокументовРасчетаЭффективностиСотрудников.ПланУтвержден)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.УБ_СостоянияДокументовРасчетаЭффективностиСотрудников.НеУтвержден)
		|	КОНЕЦ КАК Состояние
		|ИЗ
		|	Документ.УБ_РасчетЭффективностиСотрудников КАК РасчетЭффективностиСотрудников
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УБ_СостоянияДокументовРасчетаЭффективностиСотрудников КАК СостоянияДокументов
		|		ПО РасчетЭффективностиСотрудников.Ссылка = СостоянияДокументов.РасчетЭффективностиСотрудника
		|ГДЕ
		|	РасчетЭффективностиСотрудников.Проведен
		|	И СостоянияДокументов.Состояние ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	РасчетЭффективностиСотрудников.Дата УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ОбработаноОбъектов = 0;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.УБ_СостоянияДокументовРасчетаЭффективностиСотрудников");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("РасчетЭффективностиСотрудника", Выборка.Ссылка);
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.УБ_СостоянияДокументовРасчетаЭффективностиСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Ссылка);
			
			Запись = НаборЗаписей.Добавить();
			Запись.Регистратор = Выборка.Ссылка;
			Запись.РасчетЭффективностиСотрудника = Выборка.Ссылка;
			ЗаполнитьЗначенияСвойств(Запись, Выборка);
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			
			ОбработаноОбъектов = ОбработаноОбъектов + 1;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %1 по причине: %2'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстСообщения,
				Выборка.Ссылка,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы'"),
				УровеньЖурналаРегистрации.Предупреждение,
				Выборка.Ссылка.Метаданные(),
				Выборка.Ссылка,
				ТекстСообщения);
			
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов = Параметры.ПрогрессВыполнения.ОбработаноОбъектов + ОбработаноОбъектов;
	Параметры.ОбработкаЗавершена = (Параметры.ПрогрессВыполнения.ВсегоОбъектов = Параметры.ПрогрессВыполнения.ОбработаноОбъектов);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли