
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандарныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) И Не ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.ЦветИндекс			= 10;
		Объект.ЦветПредставление 	= НСтр("ru='Стальной';en='The steel'");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
// Процедура - обработчик события "НачалоВыбора" элемента формы "Цвет"
//
Процедура ЦветПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("ТекущийЦвет", Объект.ЦветИндекс);
	ОповещениеНовое = Новый ОписаниеОповещения("ЦветНачалоВыбораЗавершение", ЭтотОбъект);
	ФормаВыбораЦвета = ОткрытьФорму("Справочник.УБ_ПерспективыССП.Форма.ФормаВыбораЦвета", ПараметрыФормы, Элемент,,,,
		ОповещениеНовое, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);	
КонецПроцедуры // ЦветНачалоВыбора()

&НаКлиенте
// Продолжение процедуры "ЦветНачалоВыбора"
//
Процедура ЦветНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если НЕ (Результат = Неопределено) И НЕ (Результат = КодВозвратаДиалога.Отмена) Тогда
		Объект.ЦветПредставление 	= Результат[0].Представление;
		Объект.ЦветИндекс 			= Результат[0].Картинка;
		Объект.ЦветКрасный 			= Результат[0].Красный;
		Объект.ЦветЗеленый 			= Результат[0].Зеленый;
		Объект.ЦветСиний 			= Результат[0].Синий;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры	

&НаКлиенте
// Процедура - обработчик события "ПриИзменении" элемента формы "Цвет"
//
Процедура ЦветПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры // ЦветПриИзменении()

&НаСервере
// Функция вычисляет контрастный цвет для фона.
//
// Параметры:
//	ЦветФона	- Цвет	- Цвет фона.
//
// Возвращаемое значение:
//	Цвет	- Контрастный цвет
//
Функция ПолучитьКонтрастныйЦвет(ЦветФона) Экспорт 
    Яркость = 0.3 * ЦветФона.Красный + 0.59 * ЦветФона.Зеленый + 0.11 * ЦветФона.Синий;
    Возврат ?(Яркость  > 128, WebЦвета.Черный, WebЦвета.Белый);
КонецФункции // ПолучитьКонтрастныйЦвет()

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемы_ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

#КонецОбласти

#КонецОбласти