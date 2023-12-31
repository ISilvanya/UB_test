
#Область ОбработчикиСобытийФормы
	
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УБ_СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	УстановитьУсловноеОформление();    
	
	// СтандартныеПодсистемы.ПодключаемыеКомагды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	//Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)

    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура СоздатьДелегированиеПодсистемыМотивации(Команда)
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.УБ_ВидыОперацийДелегирования.ПодсистемаМотивации"));
	ОткрытьФорму("Документ.УБ_Делегирование.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДелегированиеПодсистемыПланирование(Команда)
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.УБ_ВидыОперацийДелегирования.ПодсистемаПланирования"));
	ОткрытьФорму("Документ.УБ_Делегирование.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
КонецПроцедуры  

#Область СтандартныеПодсистемы_ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура Подключаемый_ПриИзмененииЭлемента(Элемент)
	ОтборПриИзмененииНаСервере(Элемент.Имя);
КонецПроцедуры   

&НаСервере
Процедура ОтборПриИзмененииНаСервере(Элемент)
	УБ_СобытияФорм.ПриИзмененииЭлемента(ЭтотОбъект, Элемент);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции 

&НаКлиенте
Функция ПолучитьСтруктуруПараметровФормы(ВидОперации)
	
	СтруктураПараметров = Новый Структура;
	
	ЗначенияЗаполнения = УБ_ОбщегоНазначенияКлиентВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	
	Если ЗначениеЗаполнено(ВидОперации) Тогда
		ЗначенияЗаполнения.Вставить("ВидОперации", ВидОперации);
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры





#КонецОбласти
