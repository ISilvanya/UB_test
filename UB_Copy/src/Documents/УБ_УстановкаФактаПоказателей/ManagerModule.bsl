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

//Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

//     ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);

//КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт

	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстыЗапросаТаблицаПоказателей(Запрос, ТекстыЗапроса, Регистры);
	
	УБ_ПроведениеСервер.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	ДополнитьНедостающиеПериоды(ДокументСсылка, ДополнительныеСвойства);
	
	
КонецПроцедуры        

//дополняет пропущенные периоды нулевым значением факта и корректным значением нарастающего итога
//одновременно выполняется проверка наличия плана, т.к. для определения периодов обязательно
//нужно знать периодичность планирования
Процедура ДополнитьНедостающиеПериоды(ДокументСсылка, ДополнительныеСвойства)
	
	
	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаФактПоПоказателям;
	СообщениеОбОшибке = НСтр("ru = 'Показатель «%1» не запланирован для назначения %2.'");
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;  
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТЧ.Назначение КАК Назначение,
	|	ТЧ.показатель КАК показатель,
	|	ТЧ.ТекущееЗначение КАК ТекущееЗначение,
	|	ТЧ.Период КАК Период
	|ПОМЕСТИТЬ ВТ_ДокТЧ
	|ИЗ
	|	&ТЧ КАК ТЧ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	показатель
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДокТЧ.Назначение КАК Назначение,
	|	ВТ_ДокТЧ.показатель КАК показатель,
	|	ВТ_ДокТЧ.ТекущееЗначение КАК ТекущееЗначение,
	|	УБ_ПланПоПоказателям.ДатаНачала КАК ДатаНачала,
	|	УБ_ПланПоПоказателям.ДатаОкончания КАК ДатаОкончания,
	|	УБ_ПланПоПоказателям.ПериодичностьПланированияСтрока КАК ПериодичностьПланированияСтрока,
	|	УБ_ПланПоПоказателям.ДатаНачалаНарастающего КАК ДатаНачалаНарастающего,
	|	УБ_ПланПоПоказателям.ДатаОкончанияНарастающего КАК ДатаОкончанияНарастающего,
	|	УБ_ПланПоПоказателям.Календарь КАК Календарь
	|ПОМЕСТИТЬ ДокТЧ
	|ИЗ
	|	ВТ_ДокТЧ КАК ВТ_ДокТЧ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УБ_ПланПоПоказателям КАК УБ_ПланПоПоказателям
	|		ПО ВТ_ДокТЧ.Назначение = УБ_ПланПоПоказателям.Назначение
	|			И ВТ_ДокТЧ.показатель = УБ_ПланПоПоказателям.показатель
	|			И (ВТ_ДокТЧ.Период МЕЖДУ УБ_ПланПоПоказателям.ДатаНачала И УБ_ПланПоПоказателям.ДатаОкончания)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	показатель
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокТЧ.Назначение КАК Назначение,
	|	ДокТЧ.показатель КАК показатель,
	|	МИНИМУМ(ДокТЧ.ДатаНачала) КАК ДатаНачала
	|ПОМЕСТИТЬ МинимальныйПериод
	|ИЗ
	|	ДокТЧ КАК ДокТЧ
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокТЧ.Назначение,
	|	ДокТЧ.показатель
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	МинимальныйПериод.Назначение КАК Назначение,
	|	МинимальныйПериод.показатель КАК показатель,
	|	ВЫБОР
	|		КОГДА УБ_ПланПоПоказателям.ДатаНачалаНарастающего = УБ_ФактПоПоказателям.ДатаНачалаНарастающего
	|			ТОГДА ЕСТЬNULL(УБ_ФактПоПоказателям.НарастающийИтог, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НарастающийИтог,
	|	ВЫБОР
	|		КОГДА УБ_ПланПоПоказателям.НарастающийИтог <> 0
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НуженНИ,
	|	УБ_ПланПоПоказателям.ДатаОкончания КАК ДатаОкончания,
	|	УБ_ПланПоПоказателям.ДатаНачалаНарастающего КАК ДатаНачалаНарастающего,
	|	УБ_ПланПоПоказателям.ДатаОкончанияНарастающего КАК ДатаОкончанияНарастающего
	|ПОМЕСТИТЬ ПредыдущийНИ
	|ИЗ
	|	РегистрСведений.УБ_ПланПоПоказателям КАК УБ_ПланПоПоказателям
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МинимальныйПериод КАК МинимальныйПериод
	|		ПО УБ_ПланПоПоказателям.показатель = МинимальныйПериод.показатель
	|			И УБ_ПланПоПоказателям.Назначение = МинимальныйПериод.Назначение
	|			И УБ_ПланПоПоказателям.ДатаНачалаНарастающего = МинимальныйПериод.ДатаНачала
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УБ_ФактПоПоказателям КАК УБ_ФактПоПоказателям
	|		ПО УБ_ПланПоПоказателям.показатель = УБ_ФактПоПоказателям.показатель
	|			И УБ_ПланПоПоказателям.Назначение = УБ_ФактПоПоказателям.Назначение
	|			И (ДОБАВИТЬКДАТЕ(МинимальныйПериод.ДатаНачала, ДЕНЬ, -1) МЕЖДУ УБ_ФактПоПоказателям.ДатаНачала И УБ_ФактПоПоказателям.ДатаОкончания)
	|ГДЕ
	|	(УБ_ПланПоПоказателям.показатель, УБ_ПланПоПоказателям.Назначение, УБ_ПланПоПоказателям.ДатаНачалаНарастающего) В
	|			(ВЫБРАТЬ
	|				МинимальныйПериод.показатель,
	|				МинимальныйПериод.Назначение,
	|				МинимальныйПериод.ДатаНачала
	|			ИЗ
	|				МинимальныйПериод КАК МинимальныйПериод)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокТЧ.Назначение КАК Назначение,
	|	ДокТЧ.показатель КАК показатель,
	|	ВЫРАЗИТЬ(ДокТЧ.ТекущееЗначение КАК ЧИСЛО(15, 3)) КАК ТекущееЗначение,
	|	ВЫРАЗИТЬ(ДокТЧ.показатель КАК Справочник.УБ_ПоказателиЭффективности).ТипЗначенияПоказателя КАК ТипЗначенияПоказателя,
	|	0 КАК НарастающийИтог,
	|	ДокТЧ.ДатаНачала КАК ДатаНачала,
	|	КОНЕЦПЕРИОДА(ДокТЧ.ДатаОкончания, ДЕНЬ) КАК ДатаОкончания,
	|	ДокТЧ.ПериодичностьПланированияСтрока КАК ПериодичностьПланированияСтрока,
	|	ДокТЧ.ДатаНачалаНарастающего КАК ДатаНачалаНарастающего,
	|	ДокТЧ.ДатаОкончанияНарастающего КАК ДатаОкончанияНарастающего,
	|	ДокТЧ.Календарь КАК Календарь
	|ПОМЕСТИТЬ ТЧ
	|ИЗ
	|	ДокТЧ КАК ДокТЧ
	|ГДЕ
	|	ВЫРАЗИТЬ(ДокТЧ.показатель КАК Справочник.УБ_ПоказателиЭффективности).ТипЗначенияПоказателя = ""Число""
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЧ.Назначение КАК Назначение,
	|	ТЧ.показатель КАК показатель,
	|	МИНИМУМ(ТЧ.ДатаНачала) КАК ДатаНачала,
	|	МАКСИМУМ(ТЧ.ДатаОкончания) КАК ДатаОкончания,
	|	ТЧ.ПериодичностьПланированияСтрока КАК ПериодичностьПланированияСтрока,
	|	ТЧ.ДатаНачалаНарастающего КАК ДатаНачалаНарастающего,
	|	ТЧ.ДатаОкончанияНарастающего КАК ДатаОкончанияНарастающего,
	|	ТЧ.Календарь КАК Календарь
	|ИЗ
	|	ТЧ КАК ТЧ
	|
	|СГРУППИРОВАТЬ ПО
	|	ТЧ.Назначение,
	|	ТЧ.показатель,
	|	ТЧ.ПериодичностьПланированияСтрока,
	|	ТЧ.ДатаНачалаНарастающего,
	|	ТЧ.ДатаОкончанияНарастающего,
	|	ТЧ.Календарь"; 
	
	
	ТекстЗапросаСПериодами =
	
	"ВЫБРАТЬ
	|	НакопленныеДанные.показатель КАК показатель,
	|	НакопленныеДанные.Назначение КАК Назначение,
	|	НакопленныеДанные.ДатаНачалаНарастающего КАК ДатаНачалаНарастающего,
	|	НакопленныеДанные.ДатаОкончанияНарастающего КАК ДатаОкончанияНарастающего,
	|	НакопленныеДанные.ДатаНачала КАК ДатаНачала,
	|	НакопленныеДанные.ДатаОкончания КАК ДатаОкончания,
	|	НакопленныеДанные.ТекущееЗначение КАК ТекущееЗначение,
	|	НакопленныеДанные.НарастающийИтог КАК НарастающийИтог
	|ПОМЕСТИТЬ НакопленныеДанные
	|ИЗ
	|	&НакопленныеДанные КАК НакопленныеДанные
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	показатель
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ПредыдущийНИ.НарастающийИтог КАК ЧИСЛО(15, 3)) КАК НарастающийИтог,
	|	ПредыдущийНИ.НуженНИ КАК НуженНИ,
	|	ПредыдущийНИ.показатель КАК показатель,
	|	ПредыдущийНИ.Назначение КАК Назначение,
	|	ПредыдущийНИ.ДатаНачалаНарастающего КАК ДатаНачалаНарастающего,
	|	ПредыдущийНИ.ДатаОкончанияНарастающего КАК ДатаОкончанияНарастающего
	|ПОМЕСТИТЬ ВТ_ПредыдущийНИ
	|ИЗ
	|	ПредыдущийНИ КАК ПредыдущийНИ
	|ГДЕ
	|	ПредыдущийНИ.показатель = &показатель
	|	И ПредыдущийНИ.Назначение = &Назначение
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	показатель
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(ВТПериоды.Период, ВТ_ТЧ.ДатаНачала) КАК ДатаНачала,
	|	ВЫБОР
	|		КОГДА &ПериодичностьПланированияСтрока = ""ДЕНЬ""
	|			ТОГДА КОНЕЦПЕРИОДА(ВТПериоды.Период, ДЕНЬ)
	|		КОГДА &ПериодичностьПланированияСтрока = ""НЕДЕЛЯ""
	|			ТОГДА КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(ВТПериоды.Период, ДЕНЬ, 7), ДЕНЬ)
	|		КОГДА &ПериодичностьПланированияСтрока = ""МЕСЯЦ""
	|			ТОГДА КОНЕЦПЕРИОДА(ВТПериоды.Период, МЕСЯЦ)
	|		КОГДА &ПериодичностьПланированияСтрока = ""КВАРТАЛ""
	|			ТОГДА КОНЕЦПЕРИОДА(ВТПериоды.Период, КВАРТАЛ)
	|		КОГДА &ПериодичностьПланированияСтрока = ""ГОД""
	|			ТОГДА КОНЕЦПЕРИОДА(ВТПериоды.Период, ГОД)
	|	КОНЕЦ КАК ДатаОкончания,
	|	&показатель КАК показатель,
	|	&Назначение КАК Назначение,
	|	ЕСТЬNULL(ВТ_ТЧ.ТекущееЗначение, 0) КАК ТекущееЗначение,
	|	ВЫБОР
	|		КОГДА ВТ_ТЧ.показатель ЕСТЬ NULL
	|				И УБ_ФактПоПоказателям.показатель ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НуженДопПериод,
	|	ВТ_ТЧ.ДатаНачалаНарастающего КАК ДатаНачалаНарастающего,
	|	ВТ_ТЧ.ДатаОкончанияНарастающего КАК ДатаОкончанияНарастающего
	|ПОМЕСТИТЬ ВТ_Данные
	|ИЗ
	|	ВТПериоды КАК ВТПериоды
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТЧ КАК ВТ_ТЧ
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УБ_ФактПоПоказателям КАК УБ_ФактПоПоказателям
	|			ПО (ВЫБОР
	|					КОГДА НЕ ВТ_ТЧ.показатель ЕСТЬ NULL
	|						ТОГДА ВТ_ТЧ.показатель = УБ_ФактПоПоказателям.показатель
	|					ИНАЧЕ ИСТИНА
	|				КОНЕЦ)
	|				И ВТ_ТЧ.Назначение = УБ_ФактПоПоказателям.Назначение
	|		ПО ВТПериоды.Период = ВТ_ТЧ.ДатаНачала
	|			И (ВТ_ТЧ.показатель = &показатель
	|				ИЛИ ВТ_ТЧ.показатель ЕСТЬ NULL
	|					И ВТ_ТЧ.Назначение = &Назначение
	|				ИЛИ ВТ_ТЧ.Назначение ЕСТЬ NULL)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВТ_Данные.ДатаНачалаНарастающего) КАК ДатаНачалаНарастающего,
	|	МАКСИМУМ(ВТ_Данные.ДатаОкончанияНарастающего) КАК ДатаОкончанияНарастающего,
	|	ВТ_Данные.показатель КАК показатель
	|ПОМЕСТИТЬ ВТ_ДатыНарастающего
	|ИЗ
	|	ВТ_Данные КАК ВТ_Данные
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Данные.показатель
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВложенныйЗапрос.ДатаНачала КАК ДатаНачала,
	|	ВложенныйЗапрос.ДатаОкончания КАК ДатаОкончания,
	|	ВложенныйЗапрос.показатель КАК показатель,
	|	ВложенныйЗапрос.Назначение КАК Назначение,
	|	ВложенныйЗапрос.ТекущееЗначение КАК ТекущееЗначение,
	|	ВложенныйЗапрос.НуженДопПериод КАК НуженДопПериод,
	|	ВЫБОР
	|		КОГДА ВТ_ПредыдущийНИ.НуженНИ
	|				ИЛИ ВТ_ПредыдущийНИ.НуженНИ ЕСТЬ NULL
	|			ТОГДА ВложенныйЗапрос.НарастающийИтог + ЕСТЬNULL(ВТ_ПредыдущийНИ.НарастающийИтог, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НарастающийИтог,
	|	ВТ_ДатыНарастающего.ДатаНачалаНарастающего КАК ДатаНачалаНарастающего,
	|	ВТ_ДатыНарастающего.ДатаОкончанияНарастающего КАК ДатаОкончанияНарастающего
	|ПОМЕСТИТЬ ВТ_СНарастающимИтогом
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВТ_Данные.ДатаНачала КАК ДатаНачала,
	|		ВТ_Данные.ДатаОкончания КАК ДатаОкончания,
	|		ВТ_Данные.показатель КАК показатель,
	|		ВТ_Данные.Назначение КАК Назначение,
	|		ВТ_Данные.ТекущееЗначение КАК ТекущееЗначение,
	|		СУММА(ТеЖеДанные.ТекущееЗначение) КАК НарастающийИтог,
	|		ВТ_Данные.НуженДопПериод КАК НуженДопПериод,
	|		ВТ_Данные.ДатаНачалаНарастающего КАК ДатаНачалаНарастающего,
	|		ВТ_Данные.ДатаОкончанияНарастающего КАК ДатаОкончанияНарастающего
	|	ИЗ
	|		ВТ_Данные КАК ВТ_Данные
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Данные КАК ТеЖеДанные
	|			ПО ВТ_Данные.показатель = ТеЖеДанные.показатель
	|				И ВТ_Данные.Назначение = ТеЖеДанные.Назначение
	|				И ВТ_Данные.ДатаНачала >= ТеЖеДанные.ДатаНачала
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ВТ_Данные.ДатаНачала,
	|		ВТ_Данные.ДатаОкончания,
	|		ВТ_Данные.показатель,
	|		ВТ_Данные.Назначение,
	|		ВТ_Данные.ТекущееЗначение,
	|		ВТ_Данные.НуженДопПериод,
	|		ВТ_Данные.ДатаНачалаНарастающего,
	|		ВТ_Данные.ДатаОкончанияНарастающего) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПредыдущийНИ КАК ВТ_ПредыдущийНИ
	|		ПО ВложенныйЗапрос.показатель = ВТ_ПредыдущийНИ.показатель
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДатыНарастающего КАК ВТ_ДатыНарастающего
	|		ПО ВложенныйЗапрос.показатель = ВТ_ДатыНарастающего.показатель
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_СНарастающимИтогом.ДатаНачала КАК ДатаНачала,
	|	ВТ_СНарастающимИтогом.ДатаОкончания КАК ДатаОкончания,
	|	ВТ_СНарастающимИтогом.показатель КАК показатель,
	|	ВТ_СНарастающимИтогом.Назначение КАК Назначение,
	|	ВТ_СНарастающимИтогом.ТекущееЗначение КАК ТекущееЗначение,
	|	ВТ_СНарастающимИтогом.НарастающийИтог КАК НарастающийИтог,
	|	ВТ_СНарастающимИтогом.НуженДопПериод КАК НуженДопПериод,
	|	ВТ_СНарастающимИтогом.ДатаНачалаНарастающего КАК ДатаНачалаНарастающего,
	|	ВТ_СНарастающимИтогом.ДатаОкончанияНарастающего КАК ДатаОкончанияНарастающего,
	|	&ПериодичностьПланированияСтрока КАК ПериодичностьПланированияСтрока,
	|	&Ссылка КАК Документ
	|ИЗ
	|	ВТ_СНарастающимИтогом КАК ВТ_СНарастающимИтогом
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НакопленныеДанные.ДатаНачала,
	|	НакопленныеДанные.ДатаОкончания,
	|	НакопленныеДанные.показатель,
	|	НакопленныеДанные.Назначение,
	|	НакопленныеДанные.ТекущееЗначение,
	|	НакопленныеДанные.НарастающийИтог,
	|	NULL,
	|	НакопленныеДанные.ДатаНачалаНарастающего,
	|	НакопленныеДанные.ДатаОкончанияНарастающего,
	|	&ПериодичностьПланированияСтрока,
	|	&Ссылка
	|ИЗ
	|	НакопленныеДанные КАК НакопленныеДанные
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаНачала";
		
	
	//TODO ООО 09.03.2022  нужно разработать нормальный пересчет нарастающего итога
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("ТЧ", ТаблицаДвижений);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();                                                              
	ТаблицаНакопленныеДанные = ТаблицаДвижений.СкопироватьКолонки();       
	ТаблицаНакопленныеДанные.Колонки.Добавить("ДатаНачалаНарастающего", 		Новый ОписаниеТипов("Дата"));
	ТаблицаНакопленныеДанные.Колонки.Добавить("ДатаОкончанияНарастающего", 		Новый ОписаниеТипов("Дата"));
	ТаблицаНакопленныеДанные.Колонки.Добавить("НарастающийИтог", 				Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 3)));
	ТаблицаНакопленныеДанные.Колонки.Добавить("ДатаНачала", 					Новый ОписаниеТипов("Дата"));
	ТаблицаНакопленныеДанные.Колонки.Добавить("ДатаОкончания",	 				Новый ОписаниеТипов("Дата"));
	Запрос.УстановитьПараметр("НакопленныеДанные", ТаблицаНакопленныеДанные);		
	
	Пока Выборка.Следующий() Цикл       
    	Запрос.Текст = ТекстЗапросаСПериодами;

		Если Выборка.ПериодичностьПланированияСтрока = NULL Тогда
			ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, Выборка.показатель, Выборка.Назначение));
			ДополнительныеСвойства.Отказ = Истина;
			Продолжить;
		КонецЕсли;       
		ДопПараметры = Новый Структура;
		ДопПараметры.Вставить("ИспользоватьКонецПериода", Ложь); //тут пока	без вариантов
		ДопПараметры.Вставить("Календарь", Выборка.Календарь); 
		УБ_ОбщегоНазначенияКлиентВызовСервера.СоздатьВТПериоды(МенеджерВТ, Выборка.ДатаНачала, Выборка.ДатаОкончания, Выборка.ПериодичностьПланированияСтрока,,,ДопПараметры);			
		Запрос.УстановитьПараметр("показатель", Выборка.показатель);
		Запрос.УстановитьПараметр("Назначение", Выборка.Назначение);
		Запрос.УстановитьПараметр("ПериодичностьПланированияСтрока", Выборка.ПериодичностьПланированияСтрока);
		
		РезультатПоПериодам = Запрос.Выполнить();
		Запрос.Текст =   
		" УНИЧТОЖИТЬ ВТПериоды;
		| УНИЧТОЖИТЬ НакопленныеДанные;
		| УНИЧТОЖИТЬ ВТ_ПредыдущийНИ;
		| УНИЧТОЖИТЬ ВТ_Данные;      
		| УНИЧТОЖИТЬ ВТ_ДатыНарастающего;
		| УНИЧТОЖИТЬ ВТ_СНарастающимИтогом";
		Запрос.ВыполнитьПакет();  
		Запрос.УстановитьПараметр("НакопленныеДанные", РезультатПоПериодам.Выгрузить());
	КонецЦикла;            
	
	Если НЕ РезультатПоПериодам = Неопределено Тогда
		ТаблицаДвижений = РезультатПоПериодам.Выгрузить();
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаФактПоПоказателям = ТаблицаДвижений;
	КонецЕсли;
	
		
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
КонецПроцедуры

Функция ТекстыЗапросаТаблицаПоказателей(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ФактПоПоказателям";
	
	Если Не УБ_ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;

	ТекстЗапроса =
	 
		"ВЫБРАТЬ
		|	ТаблицаФакта.Период КАК Период,
		|	ТаблицаФакта.ТекущееЗначение КАК ТекущееЗначение,
		|	ТаблицаФакта.Назначение КАК Назначение,
		|	ТаблицаФакта.показатель КАК показатель
		|ИЗ
		|	Документ.УБ_УстановкаФактаПоказателей.Расшифровка КАК ТаблицаФакта
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УБ_ПланПоПоказателям КАК УБ_ПланПоПоказателям
		|		ПО ТаблицаФакта.показатель = УБ_ПланПоПоказателям.показатель
		|			И ТаблицаФакта.Назначение = УБ_ПланПоПоказателям.Назначение
		|			И ТаблицаФакта.Период = УБ_ПланПоПоказателям.ДатаНачала
		|ГДЕ
		|	ТаблицаФакта.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстыЗапроса;
		
КонецФункции


#КонецОбласти

#КонецОбласти

#КонецЕсли      

