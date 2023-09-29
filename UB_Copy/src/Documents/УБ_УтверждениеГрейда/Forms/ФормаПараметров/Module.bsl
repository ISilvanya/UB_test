
&НаКлиенте
Процедура ПеренестиИЗакрыть(Команда)
	
	
	ДопПараметры = СформироватьДопПараметры();
	
	Закрыть(ДопПараметры);
	
КонецПроцедуры

&НаСервере
Функция СформироватьДопПараметры()
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Показатель", Показатель);
	ДопПараметры.Вставить("ТипПоказателя", ТипПоказателя);
	ДопПараметры.Вставить("КритическоеЗначение", КритическоеЗначение);
	ДопПараметры.Вставить("ВидРасценки",ВидРасценки);
	ДопПараметры.Вставить("РассчитыватьРезультатОтФакта", РассчитыватьРезультатОтФакта);
	ДопПараметры.Вставить("Фиксированный", Фиксированный);
	ДопПараметры.Вставить("НегативноеОтклонениеНормыДо", НегативноеОтклонениеНормыДо);
	ДопПараметры.Вставить("ПограничноеОтклонениеНормыДо", ПограничноеОтклонениеНормыДо);
	ДопПараметры.Вставить("ПограничноеОтклонениеНормыОт", ПограничноеОтклонениеНормыОт);
	ДопПараметры.Вставить("ПозитивноеОтклонениеНормыОт", ПозитивноеОтклонениеНормыОт);
	ДопПараметры.Вставить("Формула", Формула);
	ДопПараметры.Вставить("ФормулаИзменена", ФормулаИзменена);
	ДопПараметры.Вставить("МассивФормул", ПолучитьМассивФормул());
	ДопПараметры.Вставить("МассивЯчеек", ПолучитьМассивЯчеек());
	ДопПараметры.Вставить("ШкалаПоказателя", ШкалаПоказателя);
	ДопПараметры.Вставить("ПериодичностьРасчета", ПериодичностьРасчета);
	ДопПараметры.Вставить("МассивМесяцев", ПолучитьМассивМесяцев());
	ДопПараметры.Вставить("ОграничиватьМинимальноеЗначениеРезультата", ОграничиватьМинимальноеЗначениеРезультата);
	ДопПараметры.Вставить("ОграничиватьМаксимальноеЗначениеРезультата", ОграничиватьМаксимальноеЗначениеРезультата);
	ДопПараметры.Вставить("МинимальноеЗначение", МинимальноеЗначение);
	ДопПараметры.Вставить("МаксимальноеЗначение", МаксимальноеЗначение);
	
	Возврат ДопПараметры;
	
КонецФункции

&НаСервере
Функция ПолучитьМассивФормул()
	
	МассивФормул = Новый Массив;
	Для каждого Строка из Формулы Цикл
		МассивФормул.Добавить(Строка.Формула);
	КонецЦикла;	
	
	Возврат МассивФормул;
	
КонецФункции	

&НаСервере
Функция ПолучитьМассивЯчеек()
	
	МассивЯчеек = Новый Массив;
	Для каждого Строка из Формулы Цикл
		МассивЯчеек.Добавить(Строка.Ячейка);
	КонецЦикла;	
	
	Возврат МассивЯчеек;
	
КонецФункции	

&НаСервере
Функция ПолучитьМассивМесяцев()
	
	МассивМесяцев = Новый Массив;
	Если Январь Тогда
		МассивМесяцев.Добавить(Дата("20010101"));
	КонецЕсли;	
	Если Февраль Тогда
		МассивМесяцев.Добавить(Дата("20010201"));
	КонецЕсли;	
	Если Март Тогда
		МассивМесяцев.Добавить(Дата("20010301"));
	КонецЕсли;	
	Если Апрель Тогда
		МассивМесяцев.Добавить(Дата("20010401"));
	КонецЕсли;	
	Если Май Тогда
		МассивМесяцев.Добавить(Дата("20010501"));
	КонецЕсли;	
	Если Июнь Тогда
		МассивМесяцев.Добавить(Дата("20010601"));
	КонецЕсли;	
	Если Июль Тогда
		МассивМесяцев.Добавить(Дата("20010701"));
	КонецЕсли;	
	Если Август Тогда
		МассивМесяцев.Добавить(Дата("20010801"));
	КонецЕсли;	
	Если Сентябрь Тогда
		МассивМесяцев.Добавить(Дата("20010901"));
	КонецЕсли;	
	Если Октябрь Тогда
		МассивМесяцев.Добавить(Дата("20011001"));
	КонецЕсли;	
	Если Ноябрь Тогда
		МассивМесяцев.Добавить(Дата("20011101"));
	КонецЕсли;	
	Если Декабрь Тогда
		МассивМесяцев.Добавить(Дата("20011201"));
	КонецЕсли;	

	
	Возврат МассивМесяцев;
	
КонецФункции	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УБ_СобытияФорм.ПриСозданииНаСервере(ЭтаФорма,Отказ,СтандартнаяОбработка);
	
	ЗаполнитьФормуИзПараметров();
	Если Параметры.Свойство("ДопПараметры") Тогда
		Заголовок = "Дополнительные параметры";
		Элементы.ДополнительныеПараметры.Видимость = Параметры.ДопПараметры;
		Элементы.ОсновныеПараметры.Видимость = Не Параметры.ДопПараметры;
		Если Параметры.УровеньГруппировки = 0 Тогда
			Элементы.ГруппаПериодичность.Видимость = Ложь;
			Элементы.ГруппаОграничения.Видимость = Ложь;
		КонецЕсли;	
	КонецЕсли;
	Если Параметры.Свойство("ОснПараметры") Тогда
		Заголовок = "Основные параметры";
		Элементы.ОсновныеПараметры.Видимость = Параметры.ОснПараметры;
		Элементы.ДополнительныеПараметры.Видимость = Не Параметры.ОснПараметры;
		Если Параметры.ТипПоказателя.Матричный Тогда
			Элементы.ГруппаНастройкиРасценки.Видимость = Ложь;	
		КонецЕсли;	
	КонецЕсли;
	
	ТолькоПросмотрФормы = (Параметры.Статус = ПредопределенноеЗначение("Перечисление.УБ_СтатусыМоделейПланирования.Действует"));
	Элементы.ДополнительныеПараметры.ТолькоПросмотр = ТолькоПросмотрФормы;
	Элементы.ОсновныеПараметры.ТолькоПросмотр = ТолькоПросмотрФормы;
	
	Элементы.ФормаПеренестиИЗакрыть.Доступность = НЕ ТолькоПросмотрФормы;
	
	Элементы.КритическоеЗначение.ТолькоПросмотр = (ТипРасчета = ПредопределенноеЗначение("Перечисление.УБ_ТипыРасчета.Прямой"));

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//++Графика
	Если Элементы.Найти("КИндикатор") <> Неопределено Тогда
		типПрямой = УБ_СобытияФормКлиент.ТипРасчетаПрямой(ТипРасчета);
		УБ_ПользовательскийИнтерфейсКлиент.СменаНаправленияИндикаторовГНЭ(Элементы.КИндикатор, Элементы.ЗИндикатор, типПрямой);
	КонецЕсли;
	//--Графика
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуИзПараметров()
	
	Если Параметры.Свойство("Показатель") Тогда
		Показатель = Параметры.Показатель;
		ТипПоказателя = Параметры.ТипПоказателя;
		
		Если ЗначениеЗаполнено(ТипПоказателя) Тогда
			ПоказательУтвержденияСтандартов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТипПоказателя,"ПоказательУтвержденияСтандартов");
			ТипРасчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПоказательУтвержденияСтандартов, "ТипРасчета");
		Иначе
			ПоказательУтвержденияСтандартов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Показатель,"ПоказательУтвержденияСтандартов");
			ТипРасчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПоказательУтвержденияСтандартов, "ТипРасчета");
		КонецЕсли;	
		
		КритическоеЗначение = Параметры.КритическоеЗначение;	
		ВидРасценки = Параметры.ВидРасценки;	
		РассчитыватьРезультатОтФакта = Параметры.РассчитыватьРезультатОтФакта;	
		Фиксированный = Параметры.Фиксированный;	
		НегативноеОтклонениеНормыДо = Параметры.НегативноеОтклонениеНормыДо;	
		ПограничноеОтклонениеНормыОт = Параметры.ПограничноеОтклонениеНормыОт;	
		ПограничноеОтклонениеНормыДо = Параметры.ПограничноеОтклонениеНормыДо;	
		ПозитивноеОтклонениеНормыОт = Параметры.ПозитивноеОтклонениеНормыОт;
		ФормулаИзменена = Параметры.ФормулаИзменена;	
		ШкалаПоказателя = Параметры.ШкалаПоказателя;	
		Формула = Параметры.Формула;	
		ПериодичностьРасчета = Параметры.ПериодичностьРасчета;
		МаксимальноеЗначение = Параметры.МаксимальноеЗначение;	
		МинимальноеЗначение = Параметры.МинимальноеЗначение;
		ЗаполнитьФормулы();
		ЗаполнитьМесяцаИспользования();
		ЗаполнитьРазрешенныеПоказатели();
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормулы()
	
	Номер = 0;	
	Пока Номер<Параметры.МассивФормул.Количество() Цикл
	    НоваяСтрока = Формулы.Добавить();
		НоваяСтрока.Ячейка = Параметры.МассивЯчеек[Номер];
		НоваяСтрока.Формула = Параметры.МассивФормул[Номер];
		Номер = Номер+1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМесяцаИспользования()
	
	Для каждого СтрокаПериода из Параметры.МассивМесяцев Цикл
		Если Месяц(СтрокаПериода) = 1 Тогда
			Январь = Истина;
		КонецЕсли;
		
		Если Месяц(СтрокаПериода) = 2 Тогда
			Февраль = Истина;
		КонецЕсли;
		
		Если Месяц(СтрокаПериода) = 3 Тогда
			Март = Истина;
		КонецЕсли;
		
		Если Месяц(СтрокаПериода) = 4 Тогда
			Апрель = Истина;
		КонецЕсли;
		
		Если Месяц(СтрокаПериода) = 5 Тогда
			Май = Истина;
		КонецЕсли;
		
		Если Месяц(СтрокаПериода) = 6 Тогда
			Июнь = Истина;
		КонецЕсли;
		
		Если Месяц(СтрокаПериода) = 7 Тогда
			Июль = Истина;
		КонецЕсли;
		
		Если Месяц(СтрокаПериода) = 8 Тогда
			Август = Истина;
		КонецЕсли;
		
		Если Месяц(СтрокаПериода) = 9 Тогда
			Сентябрь = Истина;
		КонецЕсли;
		
		Если Месяц(СтрокаПериода) = 10 Тогда
			Октябрь = Истина;
		КонецЕсли;
		
		Если Месяц(СтрокаПериода) = 11 Тогда
			Ноябрь = Истина;
		КонецЕсли;
		
		Если Месяц(СтрокаПериода) = 12 Тогда
			Декабрь = Истина;
		КонецЕсли;		
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьРазрешенныеПоказатели()
	
	Для каждого строка из Параметры.РазрешенныеПоказатели Цикл
		РазрешенныеПоказатели.Добавить(Строка);
	КонецЦикла;	
	
КонецПроцедуры	

&НаКлиенте
Функция СформироватьСтруктуруИзмененияФормулы(ЗначениеЗаполнено)
	Результат = Новый Структура();
	Результат.Вставить("СписокДоступныхПоказателей",СобратьМассивДоступныхЗначений());
	Результат.Вставить("НаименованиеПоказателя", Строка(Показатель));
	Результат.Вставить("ПоказательЭффективности", Показатель);
	Результат.Вставить("ТолькоПросмотр", ТолькоПросмотрФормы);
	
	Если ЗначениеЗаполнено Тогда
		СФормироватьСписокФормул(Результат);
	Иначе
		Результат.Вставить("Формула", Формула);
	КонецЕсли;
		
	возврат Результат;
КонецФункции

&НаКлиенте
Процедура ИзменитьФормулу(Команда)
	
	ЗначениеЗаполнено = ЗначениеЗаполнено(ТипПоказателя);
	ПараметрыФормы = СформироватьСтруктуруИзмененияФормулы(ЗначениеЗаполнено);
	
	Если ЗначениеЗаполнено Тогда
		
		ИмяПроцедуры = "ЗафиксироватьФормулыРасчета";
		ИмяОткрываемойФормы = "ОбщаяФорма.УБ_ФормаПодбораФормулРасчета";
		
	Иначе
		
		ИмяПроцедуры = "ЗафиксироватьФормулуРасчетаЗавершение";
		ИмяОткрываемойФормы = "ОбщаяФорма.УБ_РедактированиеФормулыПоказателВУтвержденииММ";
		
	КонецЕсли;		
	
	Оповещение = Новый ОписаниеОповещения(ИмяПроцедуры, ЭтотОбъект, Показатель);
	ОткрытьФорму(ИмяОткрываемойФормы, ПараметрыФормы, ЭтотОбъект,,,,
			Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьФормулыРасчета(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Формулы.Очистить();
			
	н = 0;	
	Пока н<Результат.МассивФормул.Количество() Цикл
	    НоваяСтрока = Формулы.Добавить();
		НоваяСтрока.Ячейка = Результат.МассивЯчеек[н];
		НоваяСтрока.Формула = Результат.МассивФормул[н];
		н = н+1;
	КонецЦикла;
	
	ЗаполнитьНадписиФормулРасчета();
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьНадписиФормулРасчета()
	
	Если ФормулыРавны(Формулы,Показатель) Тогда
		ФормулаИзменена = Ложь;
	Иначе	
		ФормулаИзменена = Истина;
	КонецЕсли;

КонецПроцедуры	

&НаСервере
Функция ФормулыРавны(Формулы,Показатель)
	
	Равны = Истина;
	Если ТипЗнч(Показатель) = Тип("СправочникСсылка.УБ_ПоказателиЭффективности") Тогда
		Если Формулы.Количество() = Показатель.ФормулыРасчета.Количество() Тогда
			Для каждого Строка из Формулы Цикл
				Отбор = Новый Структура;
				Отбор.Вставить("Ячейка",Строка.Ячейка);
				Отбор.Вставить("Формула",Строка.Формула);
				Если Показатель.ФормулыРасчета.НайтиСтроки(Отбор).Количество() = 0 Тогда
					Равны = Ложь;	
				КонецЕсли;
			КонецЦикла;
		Иначе
			Равны = Ложь;
		КонецЕсли;
	Иначе
		Если Не Формулы = Показатель.ФормулаРасчета Тогда
			Равны = Ложь;	
		КонецЕсли;	
	КонецЕсли;
	Возврат Равны;
	
КонецФункции

&НаКлиенте
Процедура ЗафиксироватьФормулуРасчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Формула = Результат.Формула;
	
	ЗаполнитьНадписиФормулРасчета();
	
КонецПроцедуры	

&НаСервере
Функция СобратьМассивДоступныхЗначений()
	
	МассивПоказателей = Новый Массив;
	Для каждого Строка из РазрешенныеПоказатели Цикл
		МассивПоказателей.Добавить(Строка.Значение);
	КонецЦикла;	
	
	Возврат МассивПоказателей; 
	
КонецФункции	

&НаСервере
Процедура СФормироватьСписокФормул(ПараметрыФормы)
	
	МассивФормул = Новый Массив;
	МассивЯчеек = Новый Массив;
	Для каждого Строка из Формулы Цикл
		МассивЯчеек.Добавить(Строка.Ячейка);
		МассивФормул.Добавить(Строка.Формула);
	КонецЦикла;
	
	ПараметрыФормы.Вставить("МассивФормул", МассивФормул);
	ПараметрыФормы.Вставить("МассивЯчеек", МассивЯчеек);
	
КонецПроцедуры	

&НаКлиенте
Процедура ШкалаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказательЭффективности", Показатель);
	
	Оповещение = Новый ОписаниеОповещения("ЗафиксироватьШкалуПоказателяЗавершение", ЭтотОбъект,Показатель);
	
	ОткрытьФорму("Документ.УБ_УтверждениеГрейда.Форма.ФормаПодбораШкалы", ПараметрыФормы,ЭтотОбъект,,,,
		Оповещение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьШкалуПоказателяЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ШкалаПоказателя = Результат.ШкалаПоказателя;
	
КонецПроцедуры	

#Область ИзменениеГраницНормЭффективности
&НаКлиенте
Процедура ИзменениеГраницыПоказателей(Элемент, Пограничное)
	Структура = УБ_СобытияФормКлиент.СформироватьСтруктуру();
	ЗаполнитьЗначенияСвойств(Структура, ЭтотОбъект);
	Структура.ТипРасчета = ТипРасчета;
	
	УБ_СобытияФормКлиент.ИзменениеЗначенияОтклонения(Структура,Элемент, Пограничное);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Структура);
КонецПроцедуры


&НаКлиенте
Процедура НегативноеОтклонениеНормыДоПриИзменении(Элемент)
	ИзменениеГраницыПоказателей(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ПограничноеОтклонениеНормыОтПриИзменении(Элемент)
	ИзменениеГраницыПоказателей(Элемент, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПограничноеОтклонениеНормыДоПриИзменении(Элемент)
	ИзменениеГраницыПоказателей(Элемент, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПозитивноеОтклонениеНормыОтПриИзменении(Элемент)
	ИзменениеГраницыПоказателей(Элемент, Ложь);
КонецПроцедуры

#КонецОбласти
