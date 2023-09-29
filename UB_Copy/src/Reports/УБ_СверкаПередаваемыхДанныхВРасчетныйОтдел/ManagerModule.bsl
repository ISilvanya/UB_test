#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.

Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

    НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СверкаДанныхПередаваемыхВРасчетныйОтдел");
    НастройкиВарианта.Включен = ПолучитьФункциональнуюОпцию("УБ_ИспользоватьСправочникиКАУП");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ДанныеПередаваемыеВРасчетныйОтдел");
    НастройкиВарианта.Включен = Не ПолучитьФункциональнуюОпцию("УБ_ИспользоватьСправочникиКАУП");

КонецПроцедуры   


#Область ОбработчикиСобытий

#КонецОбласти


#КонецОбласти

#КонецЕсли