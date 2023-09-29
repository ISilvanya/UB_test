#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПодсистемы") Тогда
		ТекстЗапросаТаблицаКадроваяИсторияСотрудников(Запрос, ТекстыЗапроса, Регистры);
	КонецЕсли;
	
	//ТекстЗапросаНазначенныеРуководителиПодразделений(Запрос, ТекстыЗапроса, Регистры);
	
	УБ_ПроведениеСервер.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.УстановитьПараметр("НоваяДатаОтстранения", ДокументСсылка.ДатаОтстранения);
	Запрос.УстановитьПараметр("Организация", ДокументСсылка.Организация);
	Запрос.УстановитьПараметр("Руководитель", ДокументСсылка.Сотрудник);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаКадроваяИсторияСотрудников(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "КадроваяИсторияСотрудников";
	
	Если Не УБ_ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ДОБАВИТЬКДАТЕ(ДанныеДокумента.ДатаОтстранения, ДЕНЬ, 1) КАК Период,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Сотрудник КАК Сотрудник,
		|	ДанныеДокумента.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ЗНАЧЕНИЕ(Перечисление.УБ_ВидыКадровыхСобытий.Увольнение) КАК ВидСобытия
		|ИЗ
		|	Документ.УБ_ОтстранениеОтДолжности КАК ДанныеДокумента
		|ГДЕ
		|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаНазначенныеРуководителиПодразделений(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НазначенныеРуководителиПодразделений";
	
	Если Не УБ_ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	УБ_НазначенныеРуководителиПодразделенийСрезПоследних.Организация КАК Организация,
		|	УБ_НазначенныеРуководителиПодразделенийСрезПоследних.Руководитель КАК Руководитель,
		|	&НоваяДатаОтстранения КАК ДатаОтстранения,
		|	УБ_НазначенныеРуководителиПодразделенийСрезПоследних.Период КАК Период,
		|	УБ_НазначенныеРуководителиПодразделенийСрезПоследних.Подразделение КАК Подразделение,
		|	УБ_НазначенныеРуководителиПодразделенийСрезПоследних.Пользователь КАК Пользователь
		|ИЗ
		|	РегистрСведений.УБ_НазначенныеРуководителиПодразделений.СрезПоследних КАК УБ_НазначенныеРуководителиПодразделенийСрезПоследних
		|ГДЕ
		|	УБ_НазначенныеРуководителиПодразделенийСрезПоследних.Организация = &Организация
		|	И УБ_НазначенныеРуководителиПодразделенийСрезПоследних.Руководитель = &Руководитель";
		
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
		
	возврат ТекстЗапроса;
	
КонецФункции


#КонецОбласти

#Область Печать

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли