#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированияОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

////Процедура УстановитьОтборДереваПоПринадлежностиВФоне(Форма) Экспорт
////	
////	ИмяДереваИсточника = "СписокПоПринадлежности";
////	Отборы = Новый Структура;      
////	РодителиКУдалению = Новый Массив;
////	
////	ВключеноОтборов = 0;
////	
////	// Надо снять отбор
////	ДеревоКопия = Форма.РеквизитФормыВЗначение(ИмяКопииДереваЗаказа(ИмяДереваИсточника));
////	ДеревоЗаказа = Форма.РеквизитФормыВЗначение("СписокПоПринадлежности");
////	ДеревоЗаказа = ДеревоКопия.Скопировать(); // Замещаем основное дерево, данными из копии
////	
////	Если ЗначениеЗаполнено(Форма.ОтборГруппыТекущая) Тогда
////		Отборы.Вставить("ОтборГруппыТекущая", Форма.ОтборГруппыТекущая );
////		ВключеноОтборов = ВключеноОтборов+1;																			
////	КонецЕсли;  
////		
////	Если ЗначениеЗаполнено(Форма.ОтборПринадлежностиТекущая) Тогда
////		Отборы.Вставить("ОтборПринадлежностиТекущая", Форма.ОтборПринадлежностиТекущая);
////		ВключеноОтборов = ВключеноОтборов+1;																			
////	КонецЕсли;
////	    
////	Если ВключеноОтборов <= 0 Тогда
////		Форма.ЗначениеВРеквизитФормы(ДеревоЗаказа, "СписокПоПринадлежности"); // Возвращаем данные на форму
////		Возврат;
////	КонецЕсли;
////	
////	
////	УдалитьНенужныеРекурсивно(Форма, Отборы, ДеревоЗаказа.Строки, РодителиКУдалению);
////	Для Каждого Родитель Из РодителиКУдалению Цикл
////		Попытка                            
////			ВладелецУровня = Родитель.Родитель;
////			//может оказаться, что строка уже удалена
////			Если ЗначениеЗаполнено(ВладелецУровня) Тогда
////				ВладелецУровня.Строки.Удалить(Родитель);	
////			Иначе
////				ДеревоЗаказа.Строки.Удалить(Родитель);		
////			КонецЕсли;
////		Исключение
////		КонецПопытки;
////	КонецЦикла;
////	
////	
////	Форма.ЗначениеВРеквизитФормы(ДеревоЗаказа, "СписокПоПринадлежности"); // Передаем на форму, наше обновленное дерево

////КонецПроцедуры 

//Функция ИмяКопииДереваЗаказа(ИмяДереваЗначениеа)
//	
//	Возврат "Копия"+ИмяДереваЗначениеа;
//	
//КонецФункции     

//Процедура УдалитьНенужныеРекурсивно(Форма, Отборы, Родители, РодителиКУдалению)
//	
//	Для Каждого ТекРодитель Из Родители Цикл
//		
//		СтрокаРодителяСоответствуетОтбору = Истина;
//		
//		Если Отборы.Свойство("ОтборГруппыТекущая") 
//			и ТипЗнч( ТекРодитель.Значение) = Тип("СправочникСсылка.УБ_Цели") 
//			и Не ТекРодитель.Значение.ПринадлежитЭлементу(Форма.ОтборГруппыТекущая) Тогда
//		
//			СтрокаРодителяСоответствуетОтбору = Ложь;
//			
//		КонецЕсли; 
//		
//		Если СтрокаРодителяСоответствуетОтбору и Отборы.Свойство("ОтборПринадлежностиТекущая") Тогда
//			Если ТипЗнч(Форма.ОтборПринадлежностиТекущая) = Тип("СправочникСсылка.СтруктураПредприятия") 
//				и ТипЗнч(ТекРодитель.Значение) = Тип("СправочникСсылка.СтруктураПредприятия") 
//				и Не ТекРодитель.Значение.ПринадлежитЭлементу(Форма.ОтборПринадлежностиТекущая)
//				и Не ТекРодитель.Значение = Форма.ОтборПринадлежностиТекущая Тогда
//				СтрокаРодителяСоответствуетОтбору = Ложь;
//			ИначеЕсли ТипЗнч(ТекРодитель.Значение) = Тип("СправочникСсылка.УБ_Цели") 
//				и Форма.ОтборПринадлежностиТекущая = Справочники.УБ_Компании.Компания 
//				и Не ТекРодитель.Значение.ПринадлежностьЦели	= Форма.ОтборПринадлежностиТекущая Тогда
//				СтрокаРодителяСоответствуетОтбору = Ложь;
//			ИначеЕсли ТипЗнч(ТекРодитель.Значение) = Тип("СправочникСсылка.УБ_Цели") 
//				и Не ТекРодитель.Значение.ПринадлежностьЦели	= Форма.ОтборПринадлежностиТекущая Тогда
//				СтрокаРодителяСоответствуетОтбору = Ложь;
//			КонецЕсли;

//		КонецЕсли;
//		
//		Если Не СтрокаРодителяСоответствуетОтбору Тогда
//			РодителиКУдалению.Добавить(ТекРодитель);              
//			УдалитьНенужныеРекурсивно(Форма, Отборы, ТекРодитель.Строки, РодителиКУдалению);
//		Иначе
//			ОтменитьУдалениеРекурсивно(РодителиКУдалению, ТекРодитель);
//			УдалитьНенужныеРекурсивно(Форма, Отборы, ТекРодитель.Строки, РодителиКУдалению);
//			//всех, кто оказался уровнем выше - не удалеяем
//		КонецЕсли;		
//		
//	КонецЦикла;	  
//	

//КонецПроцедуры     

//Процедура ОтменитьУдалениеРекурсивно(РодителиКУдалению, ТекРодитель)
//	
//	РодительКОтмене = ТекРодитель.Родитель;    
//	Если РодительКОтмене = Неопределено Тогда
//		Возврат;
//	КонецЕсли;
//	
//	Элемент = РодителиКУдалению.Найти(РодительКОтмене);          
//	Если Не Элемент = Неопределено Тогда
//		РодителиКУдалению.Удалить(Элемент);
//	КонецЕсли;
//	ОтменитьУдалениеРекурсивно(РодителиКУдалению, РодительКОтмене)
//	
//КонецПроцедуры



// Конец СтандартныеПодсистемы.ВерсионированияОбъектов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	// оставлено для образца
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Процедура = "Справочники.УБ_ПоказателиЭффективности.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	//Обработчик.Версия = "1.0.1.7";
	//Обработчик.РежимВыполнения = "Отложенно";
	//Обработчик.Комментарий = НСтр("ru = 'Заполнение идентификаторов и периодичности расчета показателей эффективности'");
	
КонецПроцедуры

#КонецОбласти

Функция ИдентификаторПоПредставлению(Знач Представление)
	
	Идентификатор = "";
	БылРазделитель = Ложь;
	Для НомерСимвола = 1 По СтрДлина(Представление) Цикл
		Символ = Сред(Представление, НомерСимвола, 1);
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Символ)
			И ПустаяСтрока(Идентификатор) Тогда
			Продолжить;
		КонецЕсли;
		Если СтроковыеФункцииКлиентСервер.ЭтоРазделительСлов(КодСимвола(Символ)) Тогда
			БылРазделитель = Истина; 
		Иначе
			Если БылРазделитель Тогда
				БылРазделитель = Ложь;
				Символ = ВРег(Символ);
			КонецЕсли;
			Идентификатор = Идентификатор + Символ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Идентификатор;
	
КонецФункции

Функция СформироватьИдентификаторПоказателя(Идентификатор, Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоказателиЭффективности.Идентификатор КАК Идентификатор
		|ИЗ
		|	Справочник.УБ_ПоказателиЭффективности КАК ПоказателиЭффективности
		|ГДЕ
		|	ПОДСТРОКА(ПоказателиЭффективности.Идентификатор, 1, &КоличествоСимволов) = &Идентификатор
		|	И ПоказателиЭффективности.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.УстановитьПараметр("КоличествоСимволов", СтрДлина(Идентификатор));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Идентификатор;
	КонецЕсли;
	
	ТекущиеИдентфикаторы = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Идентификатор");
	
	Счетчик = 1;
	Пока Истина Цикл
		НовыйИдентификатор = Идентификатор + Счетчик;
		Если ТекущиеИдентфикаторы.Найти(НовыйИдентификатор) = Неопределено Тогда
			Возврат НовыйИдентификатор;
		КонецЕсли;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	
КонецФункции

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	//перем СписокДопустимых;
	//перем МассивИсключений;
	//
	//СтандартнаяОбработка = Ложь;
	//ДанныеВыбора = Новый СписокЗначений;
	//
	//Если Параметры.Свойство("СтрокаПоиска") И Не ПустаяСтрока(Параметры.СтрокаПоиска) Тогда
	//	СтрокаПоиска = Параметры.СтрокаПоиска;
	//Иначе
	//	СтрокаПоиска = "";
	//КонецЕсли;
	//
	//Запрос = Новый Запрос;
	//Запрос.Текст =      
	//
	// "ВЫБРАТЬ ПЕРВЫЕ 50
	// |	УБ_ПоказателиЭффективности.Ссылка КАК Ссылка,
	// |	ПРЕДСТАВЛЕНИЕ(УБ_ПоказателиЭффективности.Ссылка) КАК Представление,
	// |	УБ_ПоказателиЭффективности.Наименование КАК Наименование,
	// |	УБ_ПоказателиЭффективности.Код КАК Код,
	// |	УБ_ПоказателиЭффективности.ПометкаУдаления КАК ПометкаУдаления
	// |ИЗ
	// |	Справочник.УБ_ПоказателиЭффективности КАК УБ_ПоказателиЭффективности
	// |ГДЕ
	// |	&УсловиеОтбора
	// |	И &УсловиеИсключений
	// |	И НЕ УБ_ПоказателиЭффективности.ЭтоГруппа
	// |	И (&УсловияОтбораПоНаименованию ИЛИ &УсловияОтбораПоКоду)";
	//      
	//
	//
	//Если Параметры.Отбор.Свойство("СписокДопустимых", СписокДопустимых) Тогда
	//	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбора",?(ЗначениеЗаполнено(СписокДопустимых),"УБ_ПоказателиЭффективности.ПринадлежностьПоказателя В (&СписокДопустимых)","Истина"));
	//	Запрос.УстановитьПараметр("СписокДопустимых", СписокДопустимых); 
	//Иначе
	//	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтбора", "ИСТИНА = ИСТИНА");
	//КонецЕсли;
	//
	//Если Параметры.Отбор.Свойство("МассивИсключений", МассивИсключений) Тогда
	//	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеИсключений",?(ЗначениеЗаполнено(МассивИсключений),"НЕ УБ_ПоказателиЭффективности.Ссылка В (&МассивИсключений)","Истина"));
	//	Запрос.УстановитьПараметр("МассивИсключений", МассивИсключений);
	//Иначе
	//	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеИсключений", "");		
	//КонецЕсли;
	//
	//Запрос.Текст = Запрос.Текст + "
	//	|
	//	|УПОРЯДОЧИТЬ ПО
	//	|	УБ_ПоказателиЭффективности.Наименование";
	//
	//УБ_ОбщегоНазначения.СкорректироватьТекстЗапросаПодТекущуюКонфигурацию(Запрос.Текст);
	//
	//Если Не ПустаяСтрока(СтрокаПоиска) Тогда
	//	
	//	Запрос.УстановитьПараметр("СтрокаПоиска", СтрокаПоиска + "%");
	//	Запрос.УстановитьПараметр("СтрокаПоискаПоКоду", "%" + СтрокаПоиска + "%");
	//	
	//	Запрос.Текст = СтрЗаменить(Запрос.Текст,
	//		"&УсловияОтбораПоНаименованию",
	//		"УБ_ПоказателиЭффективности.Наименование ПОДОБНО &СтрокаПоиска");
	//	Запрос.Текст = СтрЗаменить(Запрос.Текст,
	//		"&УсловияОтбораПоКоду",
	//		"УБ_ПоказателиЭффективности.Код ПОДОБНО &СтрокаПоискаПоКоду");
	//	
	//Иначе
	//	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловияОтбораПоНаименованию", "ИСТИНА");
	//	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловияОтбораПоКоду", "ИСТИНА");
	//КонецЕсли;
	//
	//РезультатЗапроса = Запрос.Выполнить();
	//
	//ДлинаСтрокиПоиска = СтрДлина(СтрокаПоиска);
	//
	//Выборка = РезультатЗапроса.Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	
	//	Если Не ПустаяСтрока(СтрокаПоиска) И Не СтрНачинаетсяС(ВРег(Выборка.Представление), ВРег(СтрокаПоиска)) Тогда
	//		
	//		ПредставлениеМодели = "(" + Выборка.Код + ") " + Выборка.Представление;
	//		
	//		ПозицияСтрокиПоиска = СтрНайти(ВРег(ПредставлениеМодели), ВРег(СтрокаПоиска));
	//		Представление = Новый ФорматированнаяСтрока(
	//			Лев(ПредставлениеМодели, ПозицияСтрокиПоиска - 1),
	//			Новый ФорматированнаяСтрока(
	//				Сред(ПредставлениеМодели, ПозицияСтрокиПоиска, ДлинаСтрокиПоиска),
	//				Новый Шрифт( , , Истина),
	//				WebЦвета.Зеленый),
	//			Сред(ПредставлениеМодели, ПозицияСтрокиПоиска + ДлинаСтрокиПоиска));
	//		
	//	Иначе
	//		
	//		ПредставлениеМодели = Выборка.Представление + " (" + Выборка.Код + ")";
	//		
	//		Представление = Новый ФорматированнаяСтрока(
	//			Новый ФорматированнаяСтрока(
	//				Лев(ПредставлениеМодели, ДлинаСтрокиПоиска),
	//				Новый Шрифт( , , Истина),
	//				WebЦвета.Зеленый),
	//			Сред(ПредставлениеМодели, ДлинаСтрокиПоиска + 1));
	//		
	//	КонецЕсли;
	//	
	//	ЗначениеВыбора = Новый Структура;
	//	ЗначениеВыбора.Вставить("Значение", Выборка.Ссылка);
	//	ЗначениеВыбора.Вставить("ПометкаУдаления", Выборка.ПометкаУдаления);
	//	ЗначениеВыбора.Вставить("Предупреждение", "");
	//	
	//	ДанныеВыбора.Добавить(ЗначениеВыбора, Представление, Выборка.ПометкаУдаления);
	//	
	//КонецЦикла;
КонецПроцедуры

#КонецОбласти


#КонецЕсли