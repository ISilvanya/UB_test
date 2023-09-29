///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок на события подсистемы.

// Обработчик подписки на событие ЗаписатьВСписокБизнесПроцессов.
//
Процедура ЗаписатьВСписокБизнесПроцессов(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ДанныеБизнесПроцессов");
	ЭлементБлокировки.УстановитьЗначение("Владелец", Источник.Ссылка);
	Блокировка.Заблокировать();
	
	СтароеСостояние = Неопределено;
	Если Источник.ДополнительныеСвойства.Свойство("СтароеСостояние", СтароеСостояние) Тогда
		УБ_БизнесПроцессыИЗадачиСервер.ПриИзмененииСостоянияБизнесПроцесса(Источник, СтароеСостояние);
	КонецЕсли;	
	
	НаборЗаписей = РегистрыСведений.ДанныеБизнесПроцессов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Владелец.Значение = Источник.Ссылка;
	НаборЗаписей.Отбор.Владелец.Использование = Истина;
	Запись = НаборЗаписей.Добавить();
	Запись.Владелец = Источник.Ссылка;
	СписокПолей = "Номер,Дата,Завершен,Стартован,Автор,ДатаЗавершения,Наименование,ПометкаУдаления";
	ЗаполнитьЗначенияСвойств(Запись, Источник, СписокПолей);
	
	УБ_БизнесПроцессыИЗадачиПереопределяемый.ПриЗаписиСпискаБизнесПроцессов(Запись);
	
	УстановитьПривилегированныйРежим(Истина);
	НаборЗаписей.Записать();

КонецПроцедуры

// Обработчик подписки на событие УстановитьПометкуУдаленияЗадач.
//
Процедура УстановитьПометкуУдаленияЗадач(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
        Возврат;  
	КонецЕсли; 
	
	Если Источник.ЭтоНовый() Тогда 
        Возврат;  
	КонецЕсли; 
	
	ПредыдущаяПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "ПометкаУдаления");
	Если Источник.ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		УстановитьПривилегированныйРежим(Истина);
		УБ_БизнесПроцессыИЗадачиСервер.УстановитьПометкуУдаленияЗадач(Источник.Ссылка, Источник.ПометкаУдаления);
	КонецЕсли;	
	
КонецПроцедуры

// Обработчик подписки на событие ОбновитьСостояниеБизнесПроцесса.
//
Процедура ОбновитьСостояниеБизнесПроцесса(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
        Возврат;  
	КонецЕсли; 
	
	Если Источник.Метаданные().Реквизиты.Найти("Состояние") = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если Не Источник.ЭтоНовый() Тогда
		СтароеСостояние = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "Состояние");
		Если Источник.Состояние <> СтароеСостояние Тогда
			Источник.ДополнительныеСвойства.Вставить("СтароеСостояние", СтароеСостояние);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

// Обработчик регламентного задания СтартОтложенныхПроцессов
//
Процедура СтартОтложенныхПроцессов() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.СтартОтложенныхПроцессов);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УБ_ПроцессыДляЗапуска.Владелец КАК БизнесПроцесс
		|ИЗ
		|	РегистрСведений.УБ_ПроцессыДляЗапуска КАК УБ_ПроцессыДляЗапуска
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеБизнесПроцессов КАК ДанныеБизнесПроцессов
		|		ПО УБ_ПроцессыДляЗапуска.Владелец = ДанныеБизнесПроцессов.Владелец
		|ГДЕ
		|	УБ_ПроцессыДляЗапуска.Состояние = ЗНАЧЕНИЕ(Перечисление.УБ_СостоянияПроцессовДляЗапуска.ГотовКСтарту)
		|	И УБ_ПроцессыДляЗапуска.ДатаОтложенногоСтарта <= &ТекущаяДата
		|	И УБ_ПроцессыДляЗапуска.ДатаОтложенногоСтарта <> ДАТАВРЕМЯ(1, 1, 1)
		|	И ДанныеБизнесПроцессов.ПометкаУдаления = ЛОЖЬ";
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	Выборка  = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		УБ_БизнесПроцессыИЗадачиСервер.СтартоватьОтложенныйПроцесс(Выборка.БизнесПроцесс);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
