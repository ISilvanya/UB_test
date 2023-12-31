#Область ДанныеВБазе

// Возвращает структуру, содержащую значения реквизитов, прочитанные из информационной базы по ссылке на объект.
// Рекомендуется использовать вместо обращения к реквизитам объекта через точку от ссылки на объект
// для быстрого чтения отдельных реквизитов объекта из базы данных.
//
// Если необходимо зачитать реквизит независимо от прав текущего пользователя,
// то следует использовать предварительный переход в привилегированный режим.
//
// Параметры:
//  Ссылка    - ЛюбаяСсылка - объект, значения реквизитов которого необходимо получить.
//            - Строка      - полное имя предопределенного элемента, значения реквизитов которого необходимо получить.
//  Реквизиты - Строка - имена реквизитов, перечисленные через запятую, в формате
//                       требований к свойствам структуры.
//                       Например, "Код, Наименование, Родитель".
//            - Структура
//            - ФиксированнаяСтруктура - в качестве ключа передается
//                       псевдоним поля для возвращаемой структуры с результатом, а в качестве
//                       значения (опционально) фактическое имя поля в таблице.
//                       Если ключ задан, а значение не определено, то имя поля берется из ключа.
//            - Массив
//            - ФиксированныйМассив - имена реквизитов в формате требований
//                       к свойствам структуры.
//  ВыбратьРазрешенные - Булево - если Истина, то запрос к объекту выполняется с учетом прав пользователя;
//                                если есть ограничение на уровне записей, то все реквизиты вернутся со 
//                                значением Неопределено; если нет прав для работы с таблицей, то возникнет исключение;
//                                если Ложь, то возникнет исключение при отсутствии прав на таблицу 
//                                или любой из реквизитов.
//  КодЯзыка - Строка - код языка для мультиязычного реквизита.
//
// Возвращаемое значение:
//  Структура - содержит имена (ключи) и значения затребованных реквизитов.
//            - если в параметр Реквизиты передана пустая строка, то возвращается пустая структура.
//            - если в параметр Ссылка передана пустая ссылка, то возвращается структура, 
//              соответствующая именам реквизитов со значениями Неопределено.
//            - если в параметр Ссылка передана ссылка несуществующего объекта (битая ссылка), 
//              то все реквизиты вернутся со значением Неопределено.
//
Функция ЗначенияРеквизитовОбъекта(Ссылка, Знач Реквизиты, ВыбратьРазрешенные = Ложь, КодЯзыка = Неопределено) Экспорт
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, Реквизиты, ВыбратьРазрешенные, КодЯзыка );
	
КонецФункции

// Возвращает значения реквизита, прочитанного из информационной базы по ссылке на объект.
// Рекомендуется использовать вместо обращения к реквизитам объекта через точку от ссылки на объект
// для быстрого чтения отдельных реквизитов объекта из базы данных.
//
// Если необходимо зачитать реквизит независимо от прав текущего пользователя,
// то следует использовать предварительный переход в привилегированный режим.
//
// Параметры:
//  Ссылка    - ЛюбаяСсылка - объект, значения реквизитов которого необходимо получить.
//            - Строка      - полное имя предопределенного элемента, значения реквизитов которого необходимо получить.
//  ИмяРеквизита       - Строка - имя получаемого реквизита.
//  ВыбратьРазрешенные - Булево - если Истина, то запрос к объекту выполняется с учетом прав пользователя;
//                                если есть ограничение на уровне записей, то возвращается Неопределено;
//                                если нет прав для работы с таблицей, то возникнет исключение;
//                                если Ложь, то возникнет исключение при отсутствии прав на таблицу
//                                или любой из реквизитов.
//  КодЯзыка - Строка - код языка для мультиязычного реквизита.
//
// Возвращаемое значение:
//  Произвольный - зависит от типа значения прочитанного реквизита.
//               - если в параметр Ссылка передана пустая ссылка, то возвращается Неопределено;
//               - если в параметр Ссылка передана ссылка несуществующего объекта (битая ссылка), 
//                 то возвращается Неопределено.
//
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные = Ложь, КодЯзыка = Неопределено) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные, КодЯзыка);
		
КонецФункции 

// Позволяет определить, есть ли среди реквизитов объекта реквизит с переданным именем.
//
// Параметры:
//  ИмяРеквизита - Строка - имя реквизита;
//  МетаданныеОбъекта - ОбъектМетаданных - объект, в котором требуется проверить наличие реквизита.
//
// Возвращаемое значение:
//  Булево - Истина, если есть.
//
Функция ЕстьРеквизитОбъекта(ИмяРеквизита, МетаданныеОбъекта) Экспорт

	ОбщегоНазначения.ЕстьРеквизитОбъекта(ИмяРеквизита, МетаданныеОбъекта);

КонецФункции
#КонецОбласти  


Функция ПолучитьИмяФормыВыбораПоСсылке(Ссылка) Экспорт
    Возврат УБ_ОбщегоНазначения.ПолучитьИмяФормыВыбораПоСсылке(Ссылка); 
КонецФункции

Функция ПолучитьИмяФормыПоСсылке(Ссылка, ВидФормы = "ФормаЭлемента") Экспорт
    Возврат УБ_ОбщегоНазначения.ПолучитьИмяФормыПоСсылке(Ссылка, ВидФормы); 
КонецФункции


// Возвращает строковое представление незаполненного значения, принятое в конфигурации.
// Возвращаемое значение:
//  Строка
Функция ПредставлениеНезаполненногоЗначения() Экспорт
	
	Возврат "<...>";
	
КонецФункции

// Возвращает строку, в которой символы далее указанной длины заменены на многоточие.
//	Если указано, строка обрамляется в угловые скобки
Функция СокращенноеПредставление(СтрокаТекста, МаксимальнаяДлинаТекста = 30, ОбрамлятьСкобками = Истина) Экспорт

	ДопустимаяДлинаТекста = МаксимальнаяДлинаТекста - ?(ОбрамлятьСкобками, 2, 0);
	Результат = ?(СтрДлина(СтрокаТекста) > ДопустимаяДлинаТекста, Лев(СтрокаТекста, ДопустимаяДлинаТекста - 1) + "…", СтрокаТекста);
	Если ОбрамлятьСкобками Тогда
		Результат = "[" + Результат + "]";
	КонецЕсли;
	 
	Возврат Результат;

КонецФункции

// устарела. Следует использовать УБ_ОбщегоНазначенияКлиент, избегая таким образом лишнего серверного вызова
Функция ЗначениеРеквизитаПоУмолчанию(ИмяРеквизита = "") Экспорт
	
	Возврат УБ_ОбщегоНазначенияПовтИсп.ЗначениеРеквизитаПоУмолчанию(ИмяРеквизита);
	
КонецФункции

Функция ЭтоСотрудник(Значение) Экспорт
	Возврат УБ_ОбщегоНазначения.ЭтоСотрудник(Значение);		
КонецФункции

Функция ЭтоПодразделение(Значение) Экспорт
	Возврат УБ_ОбщегоНазначения.ЭтоПодразделение(Значение);		
КонецФункции


Процедура СоздатьВТПериоды(МенеджерВременныхТаблиц, НачалоИнтервала, ОкончаниеИнтервала, Периодичность = "МЕСЯЦ", ИмяПоляПериод = "Период", ИмяВТ = "ВТПериоды", ДопПараметры) Экспорт
	УБ_ОбщегоНазначения.СоздатьВТПериоды(МенеджерВременныхТаблиц, НачалоИнтервала, ОкончаниеИнтервала, Периодичность, ИмяПоляПериод, ИмяВТ, ДопПараметры);
КонецПроцедуры    

// Возвращает отборы динамического списка как значения заполнения при программном вводе новой строки в список.
//
// Параметры:
//  КомпоновщикНастроек  - КомпоновщикНастроекДинамическогоСписка - компоновщик настроек списка.
//
// Возвращаемое значение:
//   Структура   - значения отборов для заполнения нового элемента списка.
//
Функция ЗначенияЗаполненияДинамическогоСписка(Знач КомпоновщикНастроек) Экспорт
	
	ЗначенияЗаполнения = Новый Структура;
	
	НастройкиСписка = КомпоновщикНастроек.ПолучитьНастройки();
	ДобавитьЗначенияЗаполнения(НастройкиСписка.Отбор.Элементы, ЗначенияЗаполнения);
	
	Возврат ЗначенияЗаполнения;

КонецФункции         

Процедура ДобавитьЗначенияЗаполнения(КоллекцияОтборов, ЗначенияЗаполнения)

	Для каждого ЭлементОтбора Из КоллекцияОтборов Цикл
	
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") 
			И ЭлементОтбора.Использование 
			И ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
			
			НаименованиеОтбора = Строка(ЭлементОтбора.ЛевоеЗначение);
			Если СтрНайти(НаименованиеОтбора, ".") = 0 Тогда
				ЗначенияЗаполнения.Вставить(НаименованиеОтбора, ЭлементОтбора.ПравоеЗначение);
			КонецЕсли;
		ИначеЕсли ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") 
			И ЭлементОтбора.Использование 
			И ЭлементОтбора.ТипГруппы <> ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе Тогда
			
			ДобавитьЗначенияЗаполнения(ЭлементОтбора.Элементы, ЗначенияЗаполнения);
		КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры

