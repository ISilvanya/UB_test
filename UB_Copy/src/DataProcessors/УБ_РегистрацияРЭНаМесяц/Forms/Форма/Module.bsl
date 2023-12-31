
&НаСервере
Процедура ПодборСотрудниковНаСервере(СИерархией = Ложь)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Сотрудники.Ссылка КАК Ссылка,
			|	Сотрудники.Код КАК Код,
			|	Сотрудники.Наименование КАК Наименование,
			|	ДанныеДляПодбора.Наименование КАК НаименованиеСотрудника,
			|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
			|	Сотрудники.ГоловнаяОрганизация КАК Организация,
			|	Сотрудники.ВАрхиве КАК ВАрхиве,
			|	Сотрудники.УточнениеНаименования КАК УточнениеНаименования,
			|	ДанныеДляПодбора.Подразделение КАК Подразделение,
			|	ДанныеДляПодбора.Должность КАК Должность,
			|	ДанныеДляПодбора.ДолжностьПоШтатномуРасписанию КАК ДолжностьПоШтатномуРасписанию,
			|	ДанныеДляПодбора.Начало КАК Начало,
			|	ДанныеДляПодбора.Окончание КАК Окончание,
			|	ЕСТЬNULL(МоделиПланированияСотрудников.МодельПланированияЭффективности, ЗНАЧЕНИЕ(Справочник.УБ_МоделиПланированияЭффективности.ПустаяСсылка)) КАК МодельПланированияЭффективности,
			|	ЕСТЬNULL(МоделиПланированияСотрудников.Грейд, ЗНАЧЕНИЕ(Справочник.УБ_Грейды.ПустаяСсылка)) КАК Грейд,
			|	ДанныеДляПодбора.ВидСобытия КАК ВидСобытия,
			|	ВЫБОР
			|		КОГДА ДанныеДляПодбора.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.УБ_ВидыКадровыхСобытий.Прием)
			|				ИЛИ ДанныеДляПодбора.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.УБ_ВидыКадровыхСобытий.Перемещение)
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК ДействующийСотрудник
			|ПОМЕСТИТЬ ВТ_Данные
			|ИЗ
			|	РегистрСведений.УБ_ДанныеДляПодбораСотрудников КАК ДанныеДляПодбора
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УБ_Сотрудники КАК Сотрудники
			|		ПО ДанныеДляПодбора.Сотрудник = Сотрудники.Ссылка
			|			И ДанныеДляПодбора.Наименование = Сотрудники.Наименование
			|			И (ДанныеДляПодбора.ИдентификаторЗаписи В
			|				(ВЫБРАТЬ ПЕРВЫЕ 1
			|					ДанныеДляПодбораСотрудниковОтбор.ИдентификаторЗаписи
			|				ИЗ
			|					РегистрСведений.УБ_ДанныеДляПодбораСотрудников КАК ДанныеДляПодбораСотрудниковОтбор
			|				ГДЕ
			|					ДанныеДляПодбораСотрудниковОтбор.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.УБ_ВидыКадровыхСобытий.Увольнение)
			|					И ДанныеДляПодбораСотрудниковОтбор.Сотрудник = ДанныеДляПодбора.Сотрудник
			|					И ДанныеДляПодбораСотрудниковОтбор.Наименование = ДанныеДляПодбора.Наименование
			|					И ДанныеДляПодбораСотрудниковОтбор.Начало <= &ДатаОкончания
			|					И (ДанныеДляПодбораСотрудниковОтбор.Окончание = ДАТАВРЕМЯ(1, 1, 1)
			|						ИЛИ ДанныеДляПодбораСотрудниковОтбор.Окончание >= &ДатаНачала)
			|				УПОРЯДОЧИТЬ ПО
			|					ДанныеДляПодбораСотрудниковОтбор.Начало УБЫВ,
			|					ДанныеДляПодбораСотрудниковОтбор.Организация,
			|					ДанныеДляПодбораСотрудниковОтбор.Подразделение))
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УБ_МоделиПланированияСотрудников.СрезПоследних(
			|				&ДатаНачала,
			|				(Период, Сотрудник) В
			|					(ВЫБРАТЬ
			|						МАКСИМУМ(МоделиПланированияСотрудников.Период) КАК Период,
			|						МоделиПланированияСотрудников.Сотрудник КАК Сотрудник
			|					ИЗ
			|						РегистрСведений.УБ_МоделиПланированияСотрудников.СрезПоследних(&ДатаНачала, ) КАК МоделиПланированияСотрудников
			|					СГРУППИРОВАТЬ ПО
			|						МоделиПланированияСотрудников.Сотрудник)) КАК МоделиПланированияСотрудников
			|		ПО ДанныеДляПодбора.Сотрудник = МоделиПланированияСотрудников.Сотрудник
			|			И (НЕ ДанныеДляПодбора.ДолжностьПоШтатномуРасписанию.Закрыта
			|				ИЛИ &ДатаНачала < ДанныеДляПодбора.ДолжностьПоШтатномуРасписанию.ДатаЗакрытия)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВТ_Данные.Ссылка КАК Сотрудник,
			|	ВТ_Данные.Код КАК Код,
			|	ВТ_Данные.Наименование КАК Наименование,
			|	ВТ_Данные.НаименованиеСотрудника КАК НаименованиеСотрудника,
			|	ВТ_Данные.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ВТ_Данные.Организация КАК Организация,
			|	ВТ_Данные.ВАрхиве КАК ВАрхиве,
			|	ВТ_Данные.УточнениеНаименования КАК УточнениеНаименования,
			|	ВТ_Данные.Подразделение КАК Подразделение,
			|	ВТ_Данные.Должность КАК Должность,
			|	ВТ_Данные.ДолжностьПоШтатномуРасписанию КАК ДолжностьПоШтатномуРасписанию,
			|	ВТ_Данные.Начало КАК Начало,
			|	ВТ_Данные.Окончание КАК Окончание,
			|	ВТ_Данные.МодельПланированияЭффективности КАК МодельПланированияЭффективности,
			|	ВТ_Данные.Грейд КАК Грейд,
			|	ВТ_Данные.ВидСобытия КАК ВидСобытия,
			|	ВТ_Данные.ДействующийСотрудник КАК ДействующийСотрудник
			|ИЗ
			|	ВТ_Данные КАК ВТ_Данные
			|ГДЕ
			|	ВТ_Данные.Организация = &Организация
			|	И ВТ_Данные.Начало <= &ДатаОкончания
			|	И ВТ_Данные.Окончание >= &ДатаНачала";
	Если ЗначениеЗаполнено(Подразделение) Тогда
		Если СИерархией Тогда
			Запрос.Текст = Запрос.Текст +" И ВТ_Данные.Подразделение В Иерархии (&Подразделение)";
			Запрос.УстановитьПараметр("Подразделение",Подразделение);
		Иначе	
			Запрос.Текст = Запрос.Текст +" И ВТ_Данные.Подразделение = &Подразделение";
			Запрос.УстановитьПараметр("Подразделение",Подразделение);
		КонецЕсли;
	КонецЕсли;
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.УстановитьПараметр("ДатаНачала",НачалоМесяца(ПериодФормирования));
	Запрос.УстановитьПараметр("ДатаОкончания",КонецМесяца(ПериодФормирования)); 
	
	УБ_ОбщегоНазначения.СкорректироватьТекстЗапросаПодТекущуюКонфигурацию(Запрос.Текст);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Сотрудники.Очистить();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.МодельПланированияЭффективности) Тогда
			НовыйСотрудник = Сотрудники.Добавить();
			НовыйСотрудник.Сотрудник = Выборка.Сотрудник;
			НайтиСозданныйДОкументРЭИЗадачу(НовыйСотрудник);
		КонецЕсли;		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура НайтиСозданныйДОкументРЭИЗадачу(СтрокаСотрудника)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УБ_РасчетЭффективностиСотрудников.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.УБ_РасчетЭффективностиСотрудников КАК УБ_РасчетЭффективностиСотрудников
	               |ГДЕ
	               |	УБ_РасчетЭффективностиСотрудников.Сотрудник = &Сотрудник
	               |	И УБ_РасчетЭффективностиСотрудников.Организация = &Организация
	               |	И УБ_РасчетЭффективностиСотрудников.КонецПериода = &КонецПериода
	               |	И УБ_РасчетЭффективностиСотрудников.НачалоПериода = &НачалоПериода";
	Запрос.УстановитьПараметр("Сотрудник",СтрокаСотрудника.Сотрудник);
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.УстановитьПараметр("КонецПериода",НачалоДня(КонецМесяца(ПериодФормирования)));
	Запрос.УстановитьПараметр("НачалоПериода",НачалоМесяца(ПериодФормирования));
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СтрокаСотрудника.ДокументРЭ = Выборка.Ссылка;
		СтрокаСотрудника.ДокументРЭСтрокой = Истина;
		НайтиЗадачуКДокументу(СтрокаСотрудника); 
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура НайтиЗадачуКДокументу(СтрокаСотрудника)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УБ_ЗадачаИсполнителя.Ссылка КАК Ссылка
	               |ИЗ
	               |	Задача.УБ_ЗадачаИсполнителя КАК УБ_ЗадачаИсполнителя
	               |ГДЕ
	               |	УБ_ЗадачаИсполнителя.Предмет = &Предмет";
	Запрос.УстановитьПараметр("Предмет",СтрокаСотрудника.ДокументРЭ);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СтрокаСотрудника.Задача = Выборка.Ссылка;
		СтрокаСотрудника.ЗадачаСтрокой = Истина;
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПодборСотрудников(Команда)
	
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ПериодФормирования) Тогда
		
		ДанныеОтбора = Новый Структура;
		ДанныеОтбора.Вставить("НачалоПериодаПримененияОтбора",НачалоМесяца(ПериодФормирования));
		ДанныеОтбора.Вставить("ОкончаниеПериодаПримененияОтбора",КонецМесяца(ПериодФормирования));
		ДанныеОтбора.Вставить("ТекущаяОрганизация",Организация);
		ДанныеОтбора.Вставить("ДоступныНеПринятые", Ложь);
		Если ЗначениеЗаполнено(Подразделение) Тогда
			ДанныеОтбора.Вставить("ТекущееПодразделение",Подразделение);	
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура("Отбор",ДанныеОтбора);
		ПараметрыФормы.Вставить("АдресСпискаПодобранныхСотрудников",АдресСпискаПодобранныхСотрудников());
		ПараметрыФормы.Вставить("МножественныйВыбор", Истина);
		
		Описание = Новый ОписаниеОповещения("ПодборСотрудниковЗавершение",ЭтотОбъект,ДанныеОтбора);
		
		ОткрытьФорму("ОбщаяФорма.УБ_ФормаВыбораСотрудника",ПараметрыФормы,ЭтотОбъект,УникальныйИдентификатор,
			,,Описание,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе
		Сообщить("Выбирете организацию и заполните период формирования ");	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборСотрудниковЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	Иначе
		Если ТипЗнч(Результат) = Тип("СправочникСсылка.Сотрудники") 
			ИЛИ ТипЗнч(Результат) = Тип("СправочникСсылка.УБ_Сотрудники") Тогда
			МассивСотрудников = Новый Массив;
			МассивСотрудников.Добавить(Результат);
			ДобавитьСотрудниковВСписок(МассивСотрудников);	
		ИначеЕсли ТипЗнч(Результат) = Тип("Массив") Тогда
		    ДобавитьСотрудниковВСписок(Результат);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ДобавитьСотрудниковВСписок(МассивСотрудников)
	
	Для каждого Сотрудник из МассивСотрудников Цикл
		
		Отбор = Новый Структура("Сотрудник", Сотрудник);
		Найденные = Сотрудники.НайтиСтроки(Отбор);
		Если Найденные.Количество() = 0 Тогда
			НовыйСотрудник = Сотрудники.Добавить();
			НовыйСотрудник.Сотрудник = Сотрудник;
			НайтиСозданныйДОкументРЭИЗадачу(НовыйСотрудник);
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Подразделение = УБ_ОбщегоНазначения.ЗначениеРеквизитаПоУмолчанию("Подразделение");
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	УстановитьУсловноеОФормление();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОФормление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СотрудникиСоздаватьЗадачу.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СотрудникиОтветсвенныйЗаЗаполнение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сотрудники.Задача");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СотрудникиЗадачаСтрокой.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сотрудники.ЗадачаСтрокой");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Сотрудники.Задача")); 
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СотрудникиЗадачаСтрокой.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сотрудники.ЗадачаСтрокой");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "<не создано>");
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СотрудникиОтветсвенныйЗаЗаполнение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сотрудники.СоздаватьЗадачу");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СотрудникиДокументРЭСтрокой.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сотрудники.ДокументРЭСтрокой");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Сотрудники.ДокументРЭ")); 
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СотрудникиДокументРЭСтрокой.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сотрудники.ДокументРЭСтрокой");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "<не создано>");
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры	

&НаКлиенте
Процедура ПодразделенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ДанныеОтбора = Новый Структура("Владелец",Организация);
		ПараметрыФормы = Новый Структура("Отбор",ДанныеОтбора);
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		
		Описание = Новый ОписаниеОповещения("ПодразделениеВыборЗавершение",ЭтотОбъект,ДанныеОтбора);
		
		Если УБ_ОбщегоНазначенияПовтИсп.ИспользоватьСправочникиКАУП() Тогда
			ОткрытьФорму("Справочник.ПодразделенияОрганизаций.ФормаВыбора",ПараметрыФормы,ЭтотОбъект,УникальныйИдентификатор,
				,,Описание,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			ОткрытьФорму("Справочник.УБ_Подразделения.ФормаВыбора",ПараметрыФормы,ЭтотОбъект,УникальныйИдентификатор,
				,,Описание,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	Иначе		
		 Сообщить("Выбирете организацию");
	КонецЕсли;	
	
	
КонецПроцедуры 

&НаКлиенте
Процедура ПодразделениеВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено ТОгда
		Возврат;
	Иначе
		Если Не Подразделение = Результат Тогда
			Подразделение = Результат;
			Руководитель = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
			Зам_Руководителя = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
		КонецЕсли;	
	КонецЕсли;
	
	ЗаполнитьСписокВыбора();
	
КонецПроцедуры	

&НаКлиенте
Процедура СоздатьДокументы(Команда)
	
	ДлительнаяОперация = СоздатьДокументыНаСервере();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьДокументыЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция СоздатьДокументыНаСервере()
		
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Создание и заполнение документа ""Расчет эффективности сотрудников""'");
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Организация", Организация);
	СтруктураПараметров.Вставить("Подразделение", Подразделение);
	СтруктураПараметров.Вставить("Сотрудники", Сотрудники.Выгрузить());
	СтруктураПараметров.Вставить("ПериодФормирования", ПериодФормирования);
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.УБ_РегистрацияРЭНаМесяц.СоздатьИЗаполнитьДокументыВФоне",
		СтруктураПараметров,
		ПараметрыВыполнения);
	
	ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	АдресХранилища = ДлительнаяОперация.АдресРезультата;
	
	Возврат ДлительнаяОперация;
	
КонецФункции

&НаСервере
Функция ЗаполнитьНачисленияНаСервере(ДокументРЭ)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Заполнение документа ""Расчет эффективности сотрудников""'");
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Организация", ДокументРЭ.Организация);
	СтруктураПараметров.Вставить("Подразделение", ДокументРЭ.Подразделение);
	СтруктураПараметров.Вставить("Сотрудники", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокументРЭ.Сотрудник));
	СтруктураПараметров.Вставить("МесяцНачисления", ДокументРЭ.НачалоПериода);
	СтруктураПараметров.Вставить("ДокументРЭ", ДокументРЭ);

	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
		"Документы.УБ_РасчетЭффективностиСотрудников.ПодготовитьДанныеНачислений",
		СтруктураПараметров,
		ПараметрыВыполнения);
	
	ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	АдресХранилища = ДлительнаяОперация.АдресРезультата;
	
	Возврат ДлительнаяОперация;
	
КонецФункции

&НаСервере
Процедура ПриЗавершенииОперацииЗаполненияНачислений(Результат, ДополнительныеПараметры)
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат.Вставить("СохранятьИсправления", Ложь);
	Результат.Вставить("ТекстОповещения");
	Результат.Вставить("ПояснениеОповещения");
	Результат.Вставить("ЕстьДанныеДляЗаполнения", Ложь);
	
	ПриЗавершенииОперацииЗаполненияНачисленийНаСервере(Результат,ДополнительныеПараметры.ДокументРЭ);
		
КонецПроцедуры

&НаСервере
Процедура ПриЗавершенииОперацииЗаполненияНачисленийНаСервере(Результат, ДокументРЭ)
	
	ДокументРЭОбъект = ДокументРЭ.ПолучитьОбъект();
	Документы.УБ_РасчетЭффективностиСотрудников.ЗаполнениеПослеВыполненияДлительнойОперации(ДокументРЭОбъект, Результат);
	ДокументРЭОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(НСтр("ru = 'Заполнение документа ""Расчет эффективности сотрудников""'"),
			"Ошибка", Результат.ПодробноеПредставлениеОшибки,, Истина);
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	ЗагрузитьДанныеИзПолученогоРезультата(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеИзПолученогоРезультата(Результат)
	
	СтруктураПараметров = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Сотрудники.Очистить();
	Сотрудники.Загрузить(СтруктураПараметров.Сотрудники);
	
КонецПроцедуры	

&НаСервере
Функция ЕстьРуководитель()

	Структура = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РуководителиПодразделений.Руководитель КАК Руководитель
		|ИЗ
		|	РегистрСведений.УБ_НазначенныеРуководителиПодразделений.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И Подразделение = &Подразделение) КАК РуководителиПодразделений";
	Запрос.УстановитьПараметр("Период", НачалоМесяца(ПериодФормирования));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		//МассивФИО = СтрРазделить(Строка(Выборка.Руководитель)," ",Ложь);
		//Руководитель = ?(МассивФИО.Количество()>=1,МассивФИО[0],"")+ " " +?(МассивФИО.Количество()>=2,МассивФИО[1],"")+ " " +?(МассивФИО.Количество()>=3,МассивФИО[2],""); 
		Структура.Вставить("Руководитель",Выборка.Руководитель);
	Иначе
		Структура.Вставить("Руководитель",Справочники.Пользователи.ПустаяСсылка());
	КонецЕсли;	
	
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	ДелегированныеСотрудники.ЗаместительРуководителя
	//	|ИЗ
	//	|	РегистрСведений.УБ_ДелегированныеСотрудникиПодразделения.СрезПоследних(
	//	|			&Период,
	//	|			Организация = &Организация
	//	|				И Подразделение = &Подразделение)";
	//Запрос.УстановитьПараметр("Период", НачалоМесяца(ПериодФормирования));
	//Запрос.УстановитьПараметр("Организация", Организация);
	//Запрос.УстановитьПараметр("Подразделение", Подразделение);
	//Выборка = Запрос.Выполнить().Выбрать();
	//Если Выборка.Следующий() Тогда 
	//	//МассивФИО = СтрРазделить(Строка(Выборка.ЗаместительРуководителя)," ",Ложь);
	//	//Зам_Руководителя = ?(МассивФИО.Количество()>=1,МассивФИО[0],"")+ " " +?(МассивФИО.Количество()>=2,МассивФИО[1],"")+ " " +?(МассивФИО.Количество()>=3,МассивФИО[2],"");	
	//	Структура.Вставить("Зам_Руководителя",Выборка.ЗаместительРуководителя);
	//Иначе
	//	Структура.Вставить("Зам_Руководителя",Справочники.Пользователи.ПустаяСсылка());
	//КонецЕсли;
	
	Возврат Структура;
	
КонецФункции	
 
&НаКлиенте
Процедура ЗаполнитьСписокВыбора()
	
	СписокВыбора = Элементы.СотрудникиОтветсвенныйЗаЗаполнение.СписокВыбора;
	СписокВыбора.Очистить();
	СписокВыбора.Добавить("Сотрудник");
	Если ЗначениеЗаполнено(КонтролирующееЛицо) Тогда 
		СписокВыбора.Добавить("Контролирующее лицо");
	КонецЕсли;
	Структура = ЕстьРуководитель();
	Если ЗначениеЗаполнено(Структура.Руководитель) Тогда
		Руководитель = Структура.Руководитель;
		СписокВыбора.Добавить("Руководитель");
	КонецЕсли;
	//Если ЗначениеЗаполнено(Структура.Зам_Руководителя) Тогда
	//	Зам_Руководителя = Структура.Зам_Руководителя;
	//	СписокВыбора.Добавить("Зам. руководителя");
	//КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЗаполнитьСписокВыбора()
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		ДанныеОтбора = Новый Структура;
		ДанныеОтбора.Вставить("НачалоПериодаПримененияОтбора",НачалоМесяца(ПериодФормирования));
		ДанныеОтбора.Вставить("ОкончаниеПериодаПримененияОтбора",КонецМесяца(ПериодФормирования));
		ДанныеОтбора.Вставить("ТекущаяОрганизация",Организация);
		Если ЗначениеЗаполнено(Подразделение) Тогда
			ДанныеОтбора.Вставить("ТекущееПодразделение",Подразделение);	
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура("Отбор",ДанныеОтбора);
		ПараметрыФормы.Вставить("АдресСпискаПодобранныхСотрудников",АдресСпискаПодобранныхСотрудников());
		
		Описание = Новый ОписаниеОповещения("ВыборСотрудниковЗавершение",ЭтотОбъект,ДанныеОтбора);
		
		ОткрытьФорму("ОбщаяФорма.УБ_ФормаВыбораСотрудника",ПараметрыФормы,ЭтотОбъект,УникальныйИдентификатор,
			,,Описание,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе
		Сообщить("Выбирете организацию");	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборСотрудниковЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	Иначе
		ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
		Если ТипЗнч(Результат) = Тип("СправочникСсылка.Сотрудники") 
			ИЛИ ТипЗнч(Результат) = Тип("СправочникСсылка.УБ_Сотрудники") Тогда
			ТекущиеДанные.Сотрудник = Результат; 	
		ИначеЕсли ТипЗнч(Результат) = Тип("Массив") Тогда
		    ТекущиеДанные.Сотрудник = Результат[0];
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников() 
	
	Массив = Новый Массив;
	Для Каждого Строка из Сотрудники Цикл
		Массив.Добавить(Строка.Сотрудник);
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(Массив);
		
КонецФункции	

&НаКлиенте
Процедура ПериодФормированияПриИзменении(Элемент)
	
	ПериодФормирования = КонецМесяца(ПериодФормирования);
	ЗаполнитьСписокВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПодразделению(Команда)
	
	ПодборСотрудниковНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПодразделениюСИерархией(Команда)
	
	ПодборСотрудниковНаСервере(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИстинуЗадачи(Команда)
	
	ЗаполнитьИспользованиеЗадачиСотрудников(Истина);	
	
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьИспользованиеЗадачиСотрудников(Использование)
	
	ТаблицаСотрудников = РеквизитФормыВЗначение("Сотрудники");
	Для каждого Строка из ТаблицаСотрудников Цикл
		Строка.СоздаватьЗадачу = Использование;
	КонецЦикла;
	ЗначениеВРеквизитФормы(ТаблицаСотрудников,"Сотрудники");
	
КонецПроцедуры	

&НаКлиенте
Процедура УбратьИстинуЗадачи(Команда)
	
	ЗаполнитьИспользованиеЗадачиСотрудников(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументыСЗадачами(Команда)
	
	ДлительнаяОперация = СоздатьДокументыИЗадачиНаСервере();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьДокументыЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция СоздатьДокументыИЗадачиНаСервере()
		
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Создание и заполнение задач'");
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Организация", Организация);
	СтруктураПараметров.Вставить("Подразделение", Подразделение);
	СтруктураПараметров.Вставить("Сотрудники", Сотрудники.Выгрузить());
	СтруктураПараметров.Вставить("ТекущийПользователь", ТекущийПользователь);
	СтруктураПараметров.Вставить("КонтролирующееЛицо", КонтролирующееЛицо);
	СтруктураПараметров.Вставить("Руководитель", Руководитель);
	СтруктураПараметров.Вставить("Зам_Руководителя", Зам_Руководителя);
	СтруктураПараметров.Вставить("ЗадачаРуководителя", ЗадачаРуководителя);
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.УБ_РегистрацияРЭНаМесяц.СоздатьИЗаполнитьДокументыИЗадачиВФоне",
		СтруктураПараметров,
		ПараметрыВыполнения);
	
	ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	АдресХранилища = ДлительнаяОперация.АдресРезультата;
	
	Возврат ДлительнаяОперация;
	
КонецФункции

&НаКлиенте
Процедура ПодразделенияПриИзменении(Элемент)
	
	ЗаполнитьСписокВыбора();	
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролирующееЛицоПриИзменении(Элемент)
	
	ЗаполнитьСписокВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиДокументРЭСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	ПоказатьЗначение(,ТекущиеДанные.ДокументРЭ);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиЗадачаСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	ПоказатьЗначение(,ТекущиеДанные.Задача);
	
КонецПроцедуры


