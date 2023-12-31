
#Область ОбработчикиСобытийФормы
	
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКомагды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	//Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	//УБ_КадровыйУчет.УстановитьСвязиПараметровВыбора(Элементы.ЗаместительРуководителя);
	УБ_СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);	
	ЦветСтиляЗеленый = ЦветаСтиля.ЦветАкцента;
	

КонецПроцедуры  

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ВосстановитьЭлементыПоОперации();
	
	 // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ВидыОпераций.Очистить();
	Если Мотивация Тогда
		НоваяСтрока = ТекущийОбъект.ВидыОпераций.Добавить();
		НоваяСтрока.ВидОперации = Перечисления.УБ_ВидыОперацийДелегирования.ПодсистемаМотивации;
	КонецЕсли;                                                                                   
	Если Планирование Тогда
		НоваяСтрока = ТекущийОбъект.ВидыОпераций.Добавить();
		НоваяСтрока.ВидОперации = Перечисления.УБ_ВидыОперацийДелегирования.ПодсистемаПланирования;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
 
&НаКлиенте
Процедура ДобавитьВидОперацииМотивация(Команда)   
	Мотивация = Не Мотивация;
	Элементы.ДобавитьВидОперацииМотивация.Пометка = Мотивация;
	Элементы.ДобавитьВидОперацииМотивация.ЦветТекста = ?(Мотивация,
														 ЦветСтиляЗеленый, 
														 Новый Цвет);
КонецПроцедуры 

&НаКлиенте
Процедура ДобавитьВидОперацииПланирование(Команда)   
	Планирование = Не Планирование;	
	Элементы.ДобавитьВидОперацииПланирование.Пометка = Планирование;
	Элементы.ДобавитьВидОперацииПланирование.ЦветТекста = ?(Планирование,
															ЦветСтиляЗеленый, 
															Новый Цвет);
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами

&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
КонецПроцедуры

// Конец СтандартныеПодсистемы.РаботаСФайлами

#Область СтандартныеПодсистемы_ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УБ_СобытияФормКлиент.ПодразделениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры 

&НаКлиенте
Процедура ПодразделениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	УБ_СобытияФормКлиент.ПодразделениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
КонецПроцедуры


&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ПодразделениеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура ДелегироватьСотрудниковПриИзменении(Элемент)
	
	Если Объект.ДелегироватьВсехСотрудников = Ложь Тогда
		ЭтаФорма.ПодчиненныеЭлементы.ДелегируемыеСотрудники.Доступность = Истина;
	Иначе
		ЭтаФорма.ПодчиненныеЭлементы.ДелегируемыеСотрудники.Доступность = Ложь;	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаместительРуководителяПриИзменении(Элемент)
	ЗаместительРуководителяПриИзмененииНаСервере();
	Если ЗначениеЗаполнено(Объект.Сотрудник) и НЕ ЗначениеЗаполнено(Объект.ЗаместительРуководителя) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не найден пользователь базы данных  для выбранного сотрудника!";
		Сообщение.Поле = "ЗаместительРуководителя"; //имя реквизита 
		Сообщение.Сообщить();
	КонецЕсли;
КонецПроцедуры    
#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыДелегируемыеСотрудники

&НаКлиенте
Процедура ДелегируемыеСотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если НоваяСтрока И Не Копирование Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ТекущиеДанные.Сотрудник = УБ_ОбщегоНазначенияКлиент.ЗначениеРеквизитаПоУмолчанию("Сотрудник");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДелегируемыеСотрудникиСотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Отбор = Новый Структура;
	Отбор.Вставить("МесяцПримененияОтбора", Объект.ДатаНачала);
	Отбор.Вставить("ТекущаяОрганизация", Объект.Организация);
	Отбор.Вставить("ТекущееПодразделение", Объект.Подразделение);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Отбор);
	
	ТекущиеДанные = Элементы.ДелегируемыеСотрудники.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("ТекущаяСтрока", ТекущиеДанные.Сотрудник);
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.УБ_ФормаВыбораСотрудника", ПараметрыФормы, Элемент,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()  
	
	УБ_СобытияФорм.ОрганизацияПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПодразделениеПриИзмененииНаСервере()
	
	СписокСвязанныхРеквизитов = "Сотрудник";
	УБ_ОбщегоНазначения.УстановитьТипЗначенияСвязанныхРеквизитовПоУмолчанию(
		Объект,
		СписокСвязанныхРеквизитов,
		"ДелегируемыеСотрудники");
	
КонецПроцедуры

&НаСервере
Процедура ЗаместительРуководителяПриИзмененииНаСервере()         

	ВсеСотрудники = УБ_КадровыйУчет.ВсеСотрудникиПользователя(Объект.ЗаместительРуководителя);
	Если ВсеСотрудники.Количество() Тогда
		Объект.Сотрудник = ВсеСотрудники[0];	
	КонецЕсли;

КонецПроцедуры

//&НаСервереБезКонтекста
//Функция ЗначениеРеквизитаПоУмолчанию(ИмяРеквизита)
//	Возврат УБ_ОбщегоНазначения.ЗначениеРеквизитаПоУмолчанию(ИмяРеквизита);
//КонецФункции

&НаКлиенте
Процедура ВосстановитьЭлементыПоОперации()
	Для каждого Строка Из Объект.ВидыОпераций Цикл
		Если Строка.ВидОперации = ПредопределенноеЗначение("Перечисление.УБ_ВидыОперацийДелегирования.ПодсистемаМотивации") Тогда
			ДобавитьВидОперацииМотивация(Неопределено);
		КонецЕсли;
		Если Строка.ВидОперации = ПредопределенноеЗначение("Перечисление.УБ_ВидыОперацийДелегирования.ПодсистемаПланирования") Тогда
			ДобавитьВидОперацииПланирование(Неопределено);
		КонецЕсли;
	КонецЦикла; 
КонецПроцедуры

#КонецОбласти

