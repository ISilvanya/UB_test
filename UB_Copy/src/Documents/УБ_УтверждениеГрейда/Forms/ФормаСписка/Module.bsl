
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УБ_ОбщегоНазначения.СкорректироватьТекстЗапросаПодТекущуюКонфигурацию(Список.ТекстЗапроса);
	
	УстановитьУсловноеОформление();
	УстановитьОтборСписка(ЭтотОбъект);
	
	Подразделение = УБ_ОбщегоНазначения.ЗначениеРеквизитаПоУмолчанию("Подразделение");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ДокументыГрейдов(Список);
	
	ЗаполнитьСписокСтатусов();
	
КонецПроцедуры

&НаСервере
Процедура ДокументыГрейдов(Список) 	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УБ_ВерсииГрейдовСрезПоследних.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.УБ_ВерсииГрейдов.СрезПоследних КАК УБ_ВерсииГрейдовСрезПоследних";
	
	//Запрос.УстановитьПараметр("Статус", Статус);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Проверка = Выборка.Регистратор;
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Настройки.Вставить("МодельПланированияЭффективности", МодельПланированияЭффективности);
	Настройки.Вставить("Подразделение", Подразделение);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	МодельПланированияЭффективности = Настройки.Получить("МодельПланированияЭффективности");
	Подразделение = Настройки.Получить("Подразделение");
	Если Не ЗначениеЗаполнено(Подразделение) Тогда
		Подразделение = УБ_ОбщегоНазначения.ЗначениеРеквизитаПоУмолчанию("Подразделение");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"МодельПланированияЭффективности",
		МодельПланированияЭффективности,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(МодельПланированияЭффективности));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Подразделение",
		Подразделение,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Подразделение));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МодельПланированияЭффективностиПриИзменении(Элемент)
	
	СохраняемыеВНастройкахДанныеМодифицированы = Истина;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"МодельПланированияЭффективности",
		МодельПланированияЭффективности,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(МодельПланированияЭффективности));
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	СохраняемыеВНастройкахДанныеМодифицированы = Истина;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Подразделение",
		Подразделение,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Подразделение));
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьЗакрытыеМоделиПриИзменении(Элемент)
	
	УстановитьОтборСписка(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемы_ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокСтатусов()
	
	ОтборСтатусы.Очистить();
	
	ОтборСтатусы.Добавить(Перечисления.УБ_СтатусыМоделейПланирования.Планируется);
	ОтборСтатусы.Добавить(Перечисления.УБ_СтатусыМоделейПланирования.Действует);
	ОтборСтатусы.Добавить(Перечисления.УБ_СтатусыМоделейПланирования.Неактуальный);
	ОтборСтатусы.Добавить(Перечисления.УБ_СтатусыМоделейПланирования.Закрыто);	
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.СписокДата", Элементы.СписокДата.Имя);
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.МодельЗакрыта");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Список");
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СкрытыйВариантОтчетаЦвет);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(Форма)
	
	Список = Форма.Список;
	
	//Если Не Форма.ПоказыватьЗакрытыеГрейды Тогда
	//	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Грейд.ВАрхиве", Ложь);
	//Иначе
	//	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Грейд.ВАрхиве");
	//КонецЕсли;
	//
	//Если Не Форма.ПоказыватьНеактуальныеУтвержденияГрейдов Тогда
	//	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус", ПредопределенноеЗначение("Перечисление.УБ_СтатусыМоделейПланирования.Действует"));
	//Иначе 
	//	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Статус");
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНеактуальныеУтвержденияГрейдовПриИзменении(Элемент)
	УстановитьОтборСписка(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОтборГрейдПриИзменении(Элемент)
	
	СохраняемыеВНастройкахДанныеМодифицированы = Истина;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Грейд",
		ОтборГрейд,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ОтборГрейд));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусыПриИзменении(Элемент)
	
	СохраняемыеВНастройкахДанныеМодифицированы = Истина;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Статус",
		ОтборСтатусы,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		ЗначениеЗаполнено(ОтборСтатусы));
	
КонецПроцедуры

&НаСервере
Процедура ОтборСтатусыЗначениеПриИзмененииНаСервере()
	
	ОтборСтатус = "";
	СписокСтатусов = Новый СписокЗначений;
	Для каждого Строка из ОтборСтатусы Цикл
		Если Строка.Пометка Тогда
			ОтборСтатус = ОтборСтатус + Строка.Значение + "; ";
			СписокСтатусов.Добавить(Строка.Значение);
		КонецЕсли;	
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Статус",
		СписокСтатусов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		ЗначениеЗаполнено(СписокСтатусов));	
	

КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка	= Ложь;
	Элементы.ГруппаСписокСтатусов.Показать();
	ПодключитьОбработчикОжидания("ПроверитьВсплывающиеГруппы", 0.3, Истина);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПроверитьВсплывающиеГруппы()
	
	Если Элементы.ГруппаСписокСтатусов.Скрыта() Тогда
		ОтборСтатусыЗначениеПриИзмененииНаСервере();	
	Иначе	
		ПодключитьОбработчикОжидания("ПроверитьВсплывающиеГруппы", 0.3, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти