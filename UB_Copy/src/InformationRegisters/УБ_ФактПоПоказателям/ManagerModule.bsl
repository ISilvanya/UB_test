#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаписатьФактПоПоказателям(Таблица, Движения, Отказ) Экспорт
	
	Если Отказ Или Таблица.Количество() = 0 Тогда	
		Возврат;
	КонецЕсли;    
	Для Каждого Строка Из Таблица Цикл
		НоваяЗапись = РегистрыСведений.УБ_ФактПоПоказателям.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, Строка);
		НоваяЗапись.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли