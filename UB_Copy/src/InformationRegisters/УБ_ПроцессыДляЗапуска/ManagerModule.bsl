///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Добавляет сведения об успешном старте процесса.
//
// Параметры:
//   - БизнесПроцесс - БизнесПроцессСсылка.
//
Процедура ЗарегистрироватьСтартПроцесса(Процесс) Экспорт
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.Владелец = Процесс;
	Запись.Прочитать();
	
	Если Не Запись.Выбран() Тогда
		Возврат;
	КонецЕсли;
	
	Запись.Удалить();
	
КонецПроцедуры

// Добавляет сведения об отмене старта процесса.
//
// Параметры:
//   - БизнесПроцесс - БизнесПроцессСсылка.
//
Процедура ЗарегистрироватьОтменуСтарта(Процесс, ПричинаОтмены) Экспорт
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.Владелец = Процесс;
	Запись.Прочитать();
	
	Если Не Запись.Выбран() Тогда
		Возврат;
	КонецЕсли;
	
	Запись.Состояние = Перечисления.УБ_СостоянияПроцессовДляЗапуска.СтартОтменен;
	Запись.ПричинаОтменыСтарта = ПричинаОтмены;
	
	Запись.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли