
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("ОграничитьДоступКСотрудникамДляРасчетаЭффективности")
		И Параметры.Отбор.ОграничитьДоступКСотрудникамДляРасчетаЭффективности
		И Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		
		ТекущийПользователь = Пользователи.ТекущийПользователь();
		УстановитьОграничениеДоступаКСотрудникамДляРасчетаЭффективности();
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
			"ТекущийПользователь",
			ТекущийПользователь);
		
	КонецЕсли;
	
	ТекстЗапроса = Список.ТекстЗапроса;
	УБ_ОбщегоНазначения.СкорректироватьТекстЗапросаПодТекущуюКонфигурацию(ТекстЗапроса);
	ОсновнаяТаблица = "Справочник.УБ_Сотрудники";
	УБ_ОбщегоНазначения.СкорректироватьТекстЗапросаПодТекущуюКонфигурацию(ОсновнаяТаблица);
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица = ОсновнаяТаблица;
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
	УстановитьУсловноеОформление();
	
	// Настройка списка в зависимости от значения функциональной опции ИспользоватьШтатноеРасписание.
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы.УправлениеШтатнымРасписанием") Тогда
		ИспользоватьШтатноеРасписание = ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание");
	Иначе
		ИспользоватьШтатноеРасписание = Ложь;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокПодразделение",
		"Видимость",
		Не ИспользоватьШтатноеРасписание);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокДолжность",
		"Видимость",
		Не ИспользоватьШтатноеРасписание);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокДолжностьПоШтатномуРасписанию",
		"Видимость",
		ИспользоватьШтатноеРасписание);
	
	// Установка параметров динамических списков
	ПериодРаботы = УБ_КадровыйУчет.ПериодРаботыПоПериодуПараметровОткрытияФормыСписка(Параметры);
	ДатаНачала = НачалоДня(?(ЗначениеЗаполнено(ПериодРаботы.ДатаНачала), ПериодРаботы.ДатаНачала, '00010101'));
	ДатаОкончания = КонецДня(?(ЗначениеЗаполнено(ПериодРаботы.ДатаОкончания), ПериодРаботы.ДатаОкончания, '39991231235959'));

	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ДатаНачала", ДатаНачала, Истина);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ДатаОкончания", ДатаОкончания, Истина);
	
	
	ДоступныНеПринятые = Неопределено;
	
	Если Параметры.Свойство("ДоступныНеПринятые") Тогда
		Если Не ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
			ДоступныНеПринятые = Параметры.ДоступныНеПринятые;
		КонецЕсли;
	Иначе
		ДоступныНеПринятые = Ложь;
	КонецЕсли;
	
	Если ДоступныНеПринятые <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"ДействующийСотрудник",
			Не ДоступныНеПринятые);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ВАрхиве",
		Ложь);
	
	Если Параметры.Отбор.Свойство("СотрудникуПрисвоенаМодель")
		И Параметры.Отбор.СотрудникуПрисвоенаМодель = Истина Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"МодельПланированияЭффективности",
			Справочники.УБ_МоделиПланированияЭффективности.ПустаяСсылка(),
			ВидСравненияКомпоновкиДанных.НеРавно);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Грейд",
			Справочники.УБ_Грейды.ПустаяСсылка(),
			ВидСравненияКомпоновкиДанных.НеРавно);
	ИначеЕсли Параметры.Отбор.Свойство("СотрудникуПрисвоенаМодель")
		И Параметры.Отбор.СотрудникуПрисвоенаМодель = Ложь Тогда		
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"МодельПланированияЭффективности",
			Справочники.УБ_МоделиПланированияЭффективности.ПустаяСсылка(),
			ВидСравненияКомпоновкиДанных.Равно);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Грейд",
			Справочники.УБ_Грейды.ПустаяСсылка(),
			ВидСравненияКомпоновкиДанных.Равно);
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ТекущаяОрганизация")
		И ЗначениеЗаполнено(Параметры.Отбор.ТекущаяОрганизация) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Организация",
			Параметры.Отбор.ТекущаяОрганизация);
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ТекущееПодразделение")
		И ЗначениеЗаполнено(Параметры.Отбор.ТекущееПодразделение) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Подразделение",
			Параметры.Отбор.ТекущееПодразделение,
			?(Параметры.Свойство("ВИерархии") ,ВидСравненияКомпоновкиДанных.ВИерархии, ВидСравненияКомпоновкиДанных.Равно));
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ФизическоеЛицо")
		И ЗначениеЗаполнено(Параметры.Отбор.ФизическоеЛицо) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"ФизическоеЛицо",
			Параметры.Отбор.ФизическоеЛицо,
			ВидСравненияКомпоновкиДанных.ВСписке);
		
	КонецЕсли;
	
	АдресСпискаПодобранныхСотрудников = "";
	Если Параметры.Свойство("АдресСпискаПодобранныхСотрудников", АдресСпискаПодобранныхСотрудников) Тогда
		Если Не ПустаяСтрока(АдресСпискаПодобранныхСотрудников) Тогда
			СписокПодобранных.ЗагрузитьЗначения(ПолучитьИзВременногоХранилища(АдресСпискаПодобранныхСотрудников));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ВыбранныеСотрудники.Количество() Тогда
		ОповеститьОВыборе(ВыбранныеСотрудники.ВыгрузитьЗначения());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МассивВыбранных = Новый Массив;
	Для Каждого ИдентификаторВыбраннойСтроки Из Элементы.Список.ВыделенныеСтроки Цикл
		ВыбраннаяСтрока = Элементы.Список.ДанныеСтроки(ИдентификаторВыбраннойСтроки);
		МассивВыбранных.Добавить(ВыбраннаяСтрока.Ссылка);
	КонецЦикла;
	
	Если МассивВыбранных.Количество() Тогда
		
		Если Элементы.Список.МножественныйВыбор Тогда
			
			ОбновитьСписокПодобранных(МассивВыбранных);
			Если МассивВыбранных.Количество() > 1 Тогда
				Закрыть();
			КонецЕсли;
			
		Иначе
			
			Если СписокПодобранных.НайтиПоЗначению(МассивВыбранных[0]) = Неопределено Тогда
				ОповеститьОВыборе(МассивВыбранных[0]);
			Иначе
				Закрыть();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОграничениеДоступаКСотрудникамДляРасчетаЭффективности()
	
	ТекстОграничениеДоступа = УБ_ДоступностьРасчетаЭффективностиСотрудниковДляПользователей.ТекстОграниченияДоступаКСотрудникамРуководителя(); 
			
	Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса,
		"// УсловиеОграниченияДоступаКСотрудникам",
		ТекстОграничениеДоступа);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокПодобранных;
	
	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Список");
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.СветлоСерый);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокПодобранных(Знач Значение)
	
	Если ТипЗнч(Значение) = тип("Массив") Тогда
		СписокЗначений = Значение;
	Иначе
		СписокЗначений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Значение);
	КонецЕсли;
	
	Для Каждого ВыбранноеЗначение Из СписокЗначений Цикл
		Если СписокПодобранных.НайтиПоЗначению(ВыбранноеЗначение) = Неопределено Тогда
			СписокПодобранных.Добавить(ВыбранноеЗначение);
			ВыбранныеСотрудники.Добавить(ВыбранноеЗначение);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
