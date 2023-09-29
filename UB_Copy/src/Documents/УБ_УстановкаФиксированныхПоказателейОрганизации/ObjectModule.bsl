#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	УБ_ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	Документы.УБ_УстановкаФиксированныхПоказателейОрганизации.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	УБ_ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыСведений.УБ_РасценкиПоказателейЭффективности.ОтразитьРасценкиПоказателейЭффективности(ДополнительныеСвойства, Движения, Отказ);
	
	УБ_ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	УБ_ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого СтрокаПоказатели Из Показатели Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаПоказатели.Подразделение)
			И ЗначениеЗаполнено(СтрокаПоказатели.МодельПланирования) Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не заполнена колонка ""Подразделение"" в строке %1 списка ""Показатели""'"),
				СтрокаПоказатели.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Показатели", СтрокаПоказатели.НомерСтроки, "Подразделение"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	УБ_ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	УБ_ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	УБ_ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	УБ_ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаПоказатели Из Показатели Цикл
		Если Не ЗначениеЗаполнено(СтрокаПоказатели.Подразделение) Тогда
			СтрокаПоказатели.Подразделение = УБ_ОбщегоНазначения.ЗначениеРеквизитаПоУмолчанию("Подразделение");
		КонецЕсли;
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли