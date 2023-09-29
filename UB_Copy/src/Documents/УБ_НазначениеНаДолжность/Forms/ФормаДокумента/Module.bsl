
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УБ_СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	УБ_КадровыйУчет.УстановитьСвязиПараметровВыбора(Элементы.СотрудникиСотрудник, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	УБ_СобытияФорм.ПередЗаписьюНаСервере(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
КонецПроцедуры

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
Процедура ДатаНазначенияПриИзменении(Элемент)
	
	ДатаНазначенияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ТекущиеДанные.Сотрудник = УБ_ОбщегоНазначенияКлиент.ЗначениеРеквизитаПоУмолчанию("Сотрудник");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	Отбор = Новый Структура;
	
	Если Элемент.СвязиПараметровВыбора.Количество() Тогда
		
		Для Каждого Связь Из Элемент.СвязиПараметровВыбора Цикл
			
			ИмяСвойстваДляОтбора = СтрЗаменить(Связь.Имя, "Отбор.", "");
			
			Если СтрНайти(Связь.ПутьКДанным, "Объект") Тогда
				ИмяРеквизита = СтрЗаменить(Связь.ПутьКДанным, "Объект.", "");
				ЗначениеОтбора = Объект[ИмяРеквизита];
			Иначе
				ЗначениеОтбора = ЭтотОбъект[Связь.ПутьКДанным];
			КонецЕсли;
			
			Отбор.Вставить(ИмяСвойстваДляОтбора, ЗначениеОтбора);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Отбор.Количество() Тогда
		ПараметрыФормы.Вставить("Отбор", Отбор);
	КонецЕсли;
	
	Если Элемент.ПараметрыВыбора.Количество() Тогда
		
		Для Каждого ПараметрВыбора Из Элемент.ПараметрыВыбора Цикл
			ПараметрыФормы.Вставить(ПараметрВыбора.Имя, ПараметрВыбора.Значение);
		КонецЦикла;
		
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
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
	
	СписокСвязанныхРеквизитов = "Подразделение";
	УБ_ОбщегоНазначения.УстановитьТипЗначенияСвязанныхРеквизитовПоУмолчанию(Объект, СписокСвязанныхРеквизитов);
	
	СписокСвязанныхРеквизитов = "Сотрудник";
	УБ_ОбщегоНазначения.УстановитьТипЗначенияСвязанныхРеквизитовПоУмолчанию(
		Объект,
		СписокСвязанныхРеквизитов,
		"Сотрудники");
	
КонецПроцедуры

&НаСервере
Процедура ПодразделениеПриИзмененииНаСервере()
	
	СписокСвязанныхРеквизитов = "Сотрудник";
	УБ_ОбщегоНазначения.УстановитьТипЗначенияСвязанныхРеквизитовПоУмолчанию(
		Объект,
		СписокСвязанныхРеквизитов,
		"Сотрудники");
	
КонецПроцедуры

&НаСервере
Процедура ДатаНазначенияПриИзмененииНаСервере()
	
	СписокСвязанныхРеквизитов = "Сотрудник";
	УБ_ОбщегоНазначения.УстановитьТипЗначенияСвязанныхРеквизитовПоУмолчанию(
		Объект,
		СписокСвязанныхРеквизитов,
		"Сотрудники");
	
КонецПроцедуры

//&НаСервереБезКонтекста
//Функция ЗначениеРеквизитаПоУмолчанию(ИмяРеквизита)
//	Возврат УБ_ОбщегоНазначения.ЗначениеРеквизитаПоУмолчанию(ИмяРеквизита);
//КонецФункции

#Область СтандартныеПодсистемы_ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ПодборСотрудников(Команда)
	
	Отбор = Новый Структура;
	Отбор.Вставить("СотрудникуПрисвоенаМодель",Ложь);
	Отбор.Вставить("ТекущаяОрганизация",Объект.Организация);
	Отбор.Вставить("ТекущееПодразделение", Объект.Подразделение);
	ПараметрыФормы = Новый Структура("Отбор",Отбор);
	ПараметрыФормы.Вставить("АдресСпискаПодобранныхСотрудников",ПолучитьАдресСпискаПодобранныхСотрудников());
	
	Оповещение = Новый ОписаниеОповещения("ПодборСотрудниковЗавершение",ЭтотОбъект,ПараметрыФормы);
	
	ОткрытьФорму("ОбщаяФорма.УБ_ФормаПодбораДляНазначения",ПараметрыФормы,ЭтаФорма,УникальныйИдентификатор,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборСотрудниковЗавершение(Результат,ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	Для каждого Строка из Результат Цикл
		НовыйСотрудник = Объект.Сотрудники.Добавить();
		НовыйСотрудник.Сотрудник = Строка;
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервере
Функция ПолучитьАдресСпискаПодобранныхСотрудников()
	
	СписокПодобранных = Новый СписокЗначений;
	Для каждого Строка из Объект.Сотрудники Цикл
		
		СписокПодобранных.Добавить(Строка.Сотрудник);
		
	КонецЦикла;	
	
	АдресСпискаПодобранныхСотрудников = ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(, "Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
	Возврат АдресСпискаПодобранныхСотрудников
	
КонецФункции	

&НаКлиенте
Процедура СотрудникиМодельПланированияЭффективностиСоздание(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	УБ_СобытияФормКлиент.СозданиеМоделиММ(Элемент);
КонецПроцедуры

#КонецОбласти

#КонецОбласти