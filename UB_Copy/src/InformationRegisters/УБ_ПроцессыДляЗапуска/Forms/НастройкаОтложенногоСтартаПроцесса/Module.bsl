///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.БизнесПроцесс) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	БизнесПроцесс = Параметры.БизнесПроцесс;
	СрокИсполнения = Параметры.СрокИсполнения;
	
	// Заполнение настроек.
	ЗаполнитьРеквизитыФормы();
	// Установка доступности настройки
	УстановитьСвойстваЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьОтображениеИнтервала();
	ОбновитьСписокВыбораВремени();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтложенныйСтартПроцессаПриИзменении(Элемент)
	
	УстановитьСостояниеОтложенногоСтартаПроцесса();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОтложенногоСтартаПриИзменении(Элемент)
	
	ПриИзмененииДатыВремени();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОтложенногоСтартаВремяПриИзменении(Элемент)
	
	ПриИзмененииДатыВремени();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если ФормаЗаполненаКорректно() Тогда
		ЗаписатьНастройкиНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриИзмененииДатыВремени()

	ОбновитьОтображениеИнтервала();
	ОбновитьСписокВыбораВремени();

КонецПроцедуры

// Записывает настройки.
//
&НаКлиенте
Процедура ЗаписатьНастройкиНаКлиенте()
	
	ЗаписатьНастройку();
	Закрыть();
	
	НастройкиОтложенногоСтарта = Новый Структура;
	НастройкиОтложенногоСтарта.Вставить("БизнесПроцесс", БизнесПроцесс);
	НастройкиОтложенногоСтарта.Вставить("Отложен", ОтложенныйСтартПроцесса);
	НастройкиОтложенногоСтарта.Вставить("ДатаОтложенногоСтарта", ДатаОтложенногоСтарта);
	НастройкиОтложенногоСтарта.Вставить("Состояние", Состояние);
	
	Оповестить("ИзмененаНастройкаОтложенногоСтарта", НастройкиОтложенногоСтарта);
	
	Если ОтложенныйСтартПроцесса <> ОтложенныйСтартПроцессаПриОткрытии Тогда 
		
		ТекстОповещения = ?(ОтложенныйСтартПроцесса, НСтр("ru = 'Отложенный старт:'"), НСтр("ru = 'Отложенный старт отменен:'"));
		НавигационнаяСсылкаНаПроцесс = ПолучитьНавигационнуюСсылку(БизнесПроцесс);
		
		ПоказатьОповещениеПользователя(
			ТекстОповещения,
			НавигационнаяСсылкаНаПроцесс,
			БизнесПроцесс,
			БиблиотекаКартинок.Информация32);
			
		ОповеститьОбИзменении(БизнесПроцесс);
		ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ДанныеБизнесПроцессов"));
			
	КонецЕсли;
	
КонецПроцедуры

// Заполняет реквизит формы Состояние и устанавливает доступность
// полей ДатаОтложенногоСтарта и ДатаОтложенногоСтартаВремя.
//
&НаСервере
Процедура УстановитьСостояниеОтложенногоСтартаПроцесса()
	
	Если ОтложенныйСтартПроцесса Тогда
		Состояние = ПредопределенноеЗначение("Перечисление.УБ_СостоянияПроцессовДляЗапуска.ГотовКСтарту");
	Иначе
		Состояние = ПредопределенноеЗначение("Перечисление.УБ_СостоянияПроцессовДляЗапуска.ПустаяСсылка");
	КонецЕсли;
	
	УстановитьСвойстваЭлементовФормы();
	
КонецПроцедуры

// Записывает настройку отложенного старта в регистр.
//
&НаСервере
Процедура ЗаписатьНастройку()
	
	Если ОтложенныйСтартПроцесса Тогда
		УБ_БизнесПроцессыИЗадачиСервер.ДобавитьПроцессДляОтложенногоСтарта(БизнесПроцесс, ДатаОтложенногоСтарта);
	Иначе
		УБ_БизнесПроцессыИЗадачиСервер.ОтключитьОтложенныйСтартПроцесса(БизнесПроцесс);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет заголовок декорации ДекорацияИнтервал.
//
&НаКлиенте
Процедура ОбновитьОтображениеИнтервала()
	
	Если НЕ ЗначениеЗаполнено(ДатаОтложенногоСтарта)
		ИЛИ ПроцессСтартован Тогда
		
		Элементы.ДекорацияИнтервал.Заголовок = "";
		Возврат;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДекорацияИнтервал",
		"Заголовок",
		ТекстИнтервала(ТекущаяДатаСервера, ДатаОтложенногоСтарта));
			
КонецПроцедуры

// Заполняет список выбора для элемента формы ДатаОтложенногоСтартаВремя значениями
// времени.
//
&НаКлиенте
Процедура ОбновитьСписокВыбораВремени()
	
	Элементы.ДатаОтложенногоСтартаВремя.СписокВыбора.Очистить();
	
	ПустаяДата = НачалоДня(ДатаОтложенногоСтарта);
	
	Для Инд = 1 По 48 Цикл
		Элементы.ДатаОтложенногоСтартаВремя.СписокВыбора.Добавить(ПустаяДата, Формат(ПустаяДата, НСтр("ru = 'ДФ=ЧЧ:мм'")));
		ПустаяДата = ПустаяДата + 1800;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ТекстИнтервала(ДатаНачала, ДатаОкончания)

	Если ДатаНачала > ДатаОкончания Тогда
		Возврат НСтр("ru = 'Дата запуска задания находится в прошлом.'");
	КонецЕсли;	
	
	Если ИспользоватьДатуИВремяВСрокахЗадач Тогда
		ЧислоЧасов = Окр((ДатаОкончания - ДатаНачала) / (60*60));
		ЧислоДней = Окр(ЧислоЧасов / 24);
		ЧислоЧасов = ЧислоЧасов - ЧислоДней * 24;
	Иначе
		ЧислоЧасов = 0;
		ЧислоДней = (НачалоДня(ДатаОкончания) - НачалоДня(ДатаНачала)) / (60*60*24);
	КонецЕсли;
		
	Если ЧислоЧасов < 0 Тогда
		ЧислоДней = ЧислоДней - 1;
		ЧислоЧасов = ЧислоЧасов + 24;
	КонецЕсли;
	
	РазностьДат = "";
	Если ИспользоватьДатуИВремяВСрокахЗадач Тогда
		Если ЧислоДней > 0 И ЧислоЧасов > 0 Тогда
			РазностьДат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Задание будет запущено через %1 дн. и %2 ч.'"),
				Строка(ЧислоДней),
				Строка(ЧислоЧасов));
		ИначеЕсли ЧислоДней > 0 Тогда
			РазностьДат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Задание будет запущено через %1 дн.'"), Строка(ЧислоДней));
		ИначеЕсли ЧислоЧасов > 0 Тогда
			РазностьДат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Задание будет запущено через %1 ч.'"), Строка(ЧислоЧасов));
		Иначе
			РазностьДат = НСтр("ru = 'Задание будет запущено менее чем через час.'");
		КонецЕсли;
	Иначе
		Если ЧислоДней > 0 Тогда
			РазностьДат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Задание будет запущено через %1 дн.'"), Строка(ЧислоДней));
		Иначе
			РазностьДат = НСтр("ru = 'Задание будет запущено менее чем через день.'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат РазностьДат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьРеквизитыФормы()
	
	РеквизитыПроцесса = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Параметры.БизнесПроцесс, "Стартован, Завершен");
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("УБ_ИспользоватьДатуИВремяВСрокахЗадач");
	ТекущаяДатаСервера = ТекущаяДатаСеанса();
	
	ПроцессСтартован = РеквизитыПроцесса.Стартован;
	ПроцессЗавершен = РеквизитыПроцесса.Завершен;
	
	Настройка = УБ_БизнесПроцессыИЗадачиСервер.ПараметрыОтложенногоПроцесса(Параметры.БизнесПроцесс);
	
	Если ЗначениеЗаполнено(Настройка) Тогда
		// Если процесс уже отложен - заполняем реквизиты по нему.
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Настройка);
		
		ОтложенныйСтартПроцесса = (Настройка.Состояние = Перечисления.УБ_СостоянияПроцессовДляЗапуска.ГотовКСтарту);
		ОтложенныйСтартПроцессаПриОткрытии = ОтложенныйСтартПроцесса;
		
	ИначеЕсли НЕ ПроцессСтартован Тогда
		// Если еще не откладывали - заполняем по умолчанию.
		ОтложенныйСтартПроцессаПриОткрытии = Ложь;
		ОтложенныйСтартПроцесса = Истина;
		ДатаОтложенногоСтарта = НачалоДня(ТекущаяДатаСеанса() + 86400);
		Состояние = ПредопределенноеЗначение("Перечисление.УБ_СостоянияПроцессовДляЗапуска.ГотовКСтарту");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЭлементовФормы()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОтложенныйСтартПроцесса",
		"ТолькоПросмотр",
		ПроцессСтартован);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаИнфоНадпись",
		"Видимость",
		ПроцессСтартован);
		
	Если ПроцессСтартован Тогда
		Элементы.СтраницыКоманд.ТекущаяСтраница = Элементы.СтраницаПроцессСтартован;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Закрыть", "КнопкаПоУмолчанию", Истина);

		Если ПроцессЗавершен Тогда
			Элементы.СтраницыПодвала.ТекущаяСтраница = Элементы.СтраницаЗаданиеЗавершено;
		Иначе
			Элементы.СтраницыПодвала.ТекущаяСтраница = Элементы.СтраницаЗаданиеЗапущено;
		КонецЕсли;
	Иначе
		Элементы.СтраницыКоманд.ТекущаяСтраница = Элементы.СтраницаПроцессНеСтартован;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Готово", "КнопкаПоУмолчанию", Истина);
		
		Если Состояние = ПредопределенноеЗначение("Перечисление.УБ_СостоянияПроцессовДляЗапуска.СтартОтменен") Тогда
			Элементы.СтраницыПодвала.ТекущаяСтраница = Элементы.СтраницаОтменаСтарта;
		Иначе
			Элементы.СтраницыПодвала.ТекущаяСтраница = Элементы.СтраницаПусто;
		КонецЕсли;
	КонецЕсли;
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДатаОтложенногоСтарта",
		"ТолькоПросмотр",
		ПроцессСтартован ИЛИ НЕ ОтложенныйСтартПроцесса);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДатаОтложенногоСтартаВремя",
		"Видимость",
		ИспользоватьДатуИВремяВСрокахЗадач);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДатаОтложенногоСтартаВремя",
		"ТолькоПросмотр",
		ПроцессСтартован ИЛИ НЕ ОтложенныйСтартПроцесса);
		
КонецПроцедуры

&НаКлиенте
Функция ФормаЗаполненаКорректно()
	
	ЗаполненаКорректно = Истина;
	ОчиститьСообщения();
	
	Если ОтложенныйСтартПроцесса И ДатаОтложенногоСтарта < ТекущаяДатаСервера Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Дата и время отложенного старта должны быть больше текущей даты.'"),,
			"ДатаОтложенногоСтарта");
		ЗаполненаКорректно = Ложь;
	КонецЕсли;
		
	Если ОтложенныйСтартПроцесса И ДатаОтложенногоСтарта > СрокИсполнения Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Дата и время отложенного старта должны быть меньше срока исполнения задания.'"),,
			"ДатаОтложенногоСтарта");
		ЗаполненаКорректно = Ложь;
	КонецЕсли;
	
	Возврат ЗаполненаКорректно;
	
КонецФункции

#КонецОбласти

