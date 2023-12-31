////////////////////////////////////////////////////////////////////////////////
#Область ОписаниеПеременных

&НаКлиенте
перем КэшСостоянияДерева;

&НаСервере
перем СхемаКомпоновкиДанных;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = Список.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ФормаКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	Если Не ЗначениеЗаполнено(ВывестиЦелиСтатусом) Тогда	
		ВывестиЦелиСтатусом = "Все";
	КонецЕсли; 

	// когда форма открывается в режиме выбора, Структура предприятия всегда передана
	Параметры.Отбор.Свойство("СтруктураПредприятия", ПредопределенныйОтбор);	
	Параметры.Свойство("ОтборИерархияПереключатель", ОтборИерархияПереключатель);
	ПодготовитьФормуНаСервере();     

КонецПроцедуры      

////////////////////////////////////////////////////////////////////////////////
//
// Процедура ПодготовитьФормуНаСервере
//
// Описание:
//
//
// Параметры (название, тип, дифференцированное значение)
//  
&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПринадлежностьЦели", ПредопределенныйОтбор,
																				ВидСравненияКомпоновкиДанных.ВИерархии, "ПринадлежностьЦели", ЗначениеЗаполнено(ПредопределенныйОтбор));	

	Элементы.СтатусЦели.СписокВыбора.Добавить("Все", "Все");
	Элементы.СтатусЦели.СписокВыбора.Добавить(Перечисления.УБ_СостоянияПоказателейЭффективности.Действует, "Действует");
	Элементы.СтатусЦели.СписокВыбора.Добавить(Перечисления.УБ_СостоянияПоказателейЭффективности.Планируется, "Планируется");
	Элементы.СтатусЦели.СписокВыбора.Добавить(Перечисления.УБ_СостоянияПоказателейЭффективности.Архивный, "Архивный");

	// !!! до выяснения ШОО
	//Если Параметры.РежимВыбора Тогда 
	//	Элементы.Список.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	//	Элементы.СписокПоПринадлежности.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	//КонецЕсли;                      
	
КонецПроцедуры //ПодготовитьФормуНаСервере

&НаСервере
Процедура ЗаполнитьДеревьяОтборов()
	
	Если ОтборИерархияПереключатель = 0 Тогда
		ЗаполнитьОтборДереваГрупп(); 	
	Иначе
		ЗаполнитьОтборДереваПринадлежностей();
	КонецЕсли;

КонецПроцедуры     

&НаСервере
Процедура ЗаполнитьСпискиЦелей()
	
	Если РежимСпискаЦелейПоГруппам Тогда
		//
	Иначе
		ЗаполнитьЭлементПоПринадлежности("СписокПоПринадлежности");
	КонецЕсли;

КонецПроцедуры     




&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
																					
	ЗаполнитьДеревьяОтборов();																				
	ЗаполнитьЭлементПоПринадлежности("СписокПоПринадлежности");
	СкопироватьДерево("СписокПоПринадлежности");
	
	УстановитьУсловноеОформление();
	УправлениеВидимостью();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)   
	//TODO ООО 11.09.2023  ПодключитьОбработчикОжидания("ОтборПриАктивизацииСтрокиНаКлиенте", 0.1, Истина);	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзмененЭлементСправочникаЦели" Тогда
		
		// !!! ШОО пока просто перерисовываем списки и переходим на новый элемент
		////если у цели изменилась принадлежность - ее надо удалить из старой строки и вернуть в новой
		//Если НЕ Элементы.СписокПоПринадлежности.ТекущиеДанные.Получитьродителя().Значение = Параметр Тогда   
		//	НовыйОбъект = Элементы.СписокПоПринадлежности.ТекущиеДанные.Значение;
		//	УдаляемаяСтрока = СписокПоПринадлежности.НайтиПоИдентификатору(Элементы.СписокПоПринадлежности.ТекущаяСтрока);					
		//	УдаляемаяСтрока.ПолучитьРодителя().ПолучитьЭлементы().Удалить(УдаляемаяСтрока);
		//	ДобавитьЭлементВДеревоНаСервере(НовыйОбъект);
		//	
		////также может оказаться, что появилась новая используемая принадлежность, список надо обновить
		ЗаполнитьДеревьяОтборов();
		ЗаполнитьСпискиЦелей();
				
		//КонецЕсли;
	КонецЕсли;
КонецПроцедуры


#КонецОбласти
          
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПереключитьРежимСпискаЦелей(Команда)
	
	РежимСпискаЦелейПоГруппам = Не РежимСпискаЦелейПоГруппам;
	Элементы.ФормаПереключитьРежимСпискаЦелей.Заголовок = ?(Не РежимСпискаЦелейПоГруппам, "По группам", "По принадлежности");
	УправлениеВидимостью();
	
КонецПроцедуры       

&НаКлиенте
Процедура Создать(Команда)
    ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Родитель", 
							?(Не ОтборГруппыТекущая = Неопределено,
							ОтборГруппыТекущая, 
							Неопределено));      
	Если Не Элементы.СписокПоПринадлежности.ТекущиеДанные = Неопределено Тогда
		ПараметрыФормы.Вставить("ПринадлежностьЦели", 
								?(ЭтоНазначениеЦели(Элементы.СписокПоПринадлежности.ТекущиеДанные.Значение),
								Элементы.СписокПоПринадлежности.ТекущиеДанные.Значение, 
								СписокПоПринадлежности.НайтиПоИдентификатору(Элементы.СписокПоПринадлежности.ТекущаяСтрока).ПолучитьРодителя().Значение));		
	ИначеЕсли Не Элементы.Список.ТекущиеДанные = Неопределено  Тогда	
								
		ПараметрыФормы.Вставить("Родитель", 
								?(Элементы.Список.ТекущиеДанные.ЭтоГруппа, 
								Элементы.Список.ТекущиеДанные.Ссылка, 
								Элементы.Список.ТекущиеДанные.Родитель));
	КонецЕсли;							
							
	ОткрытьФорму("Справочник.УБ_Цели.Форма.ФормаЭлемента", ПараметрыФормы, Элементы.СписокПоПринадлежности);
КонецПроцедуры           

&НаКлиенте
Процедура СоздатьГруппу(Команда)   
	ПараметрыФормы = Новый Структура("ЭтоГруппа", Истина);
	ОткрытьФорму("Справочник.УБ_Цели.Форма.ФормаГруппы", ПараметрыФормы, Элементы.ДеревоГрупп);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЭлементКопированием(Команда)  
	
	Если Не Элементы.СписокПоПринадлежности.ТекущиеДанные = Неопределено Тогда 
		ИсходныйЭлемент =  Элементы.СписокПоПринадлежности.ТекущиеДанные.Значение;
		ОткрытьФорму(УБ_ОбщегоНазначенияКлиентВызовСервера.ПолучитьИмяФормыПоСсылке(ИсходныйЭлемент),
		Новый Структура("ЗначениеКопирования", ИсходныйЭлемент), 
		Элементы.СписокПоПринадлежности);
		
	ИначеЕсли Не Элементы.Список.ТекущиеДанные = Неопределено  Тогда
		ИсходныйЭлемент =  Элементы.Список.ТекущиеДанные.Ссылка;	
		Если Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда
			ОткрытьФорму(УБ_ОбщегоНазначенияКлиентВызовСервера.ПолучитьИмяФормыПоСсылке(ИсходныйЭлемент, "ФормаГруппы"),
			Новый Структура("ЗначениеКопирования", ИсходныйЭлемент), 
			Элементы.Список);
		Иначе
			ОткрытьФорму(УБ_ОбщегоНазначенияКлиентВызовСервера.ПолучитьИмяФормыПоСсылке(ИсходныйЭлемент),
			Новый Структура("ЗначениеКопирования", ИсходныйЭлемент), 
			Элементы.Список);
			
		КонецЕсли;
	КонецЕсли;            
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок 

#Область ОбслуживаниеОтборовИерархии

&НаСервере
Процедура ЗаполнитьОтборДереваПринадлежностей(ПринадлежностьТекущейСтроки = Неопределено)
	
	// выбрано дерево, т.к. иначе не построить иерархию разнородных сущностей,
	// в т.ч. "Все"
	
	УстановитьПривилегированныйРежим(Истина);
	ЗаполнитьЭлементПоПринадлежности("ОтборПринадлежности");
	УстановитьПривилегированныйРежим(Ложь);
	
	ИдентификаторСтроки = Неопределено;
	Если ЗначениеЗаполнено(ПредопределенныйОтбор) Тогда
		ИдентификаторСтроки = ИдентификаторСтрокиДереваПоЗначению(ОтборПринадлежности, ПредопределенныйОтбор);	
	ИначеЕсли ПринадлежностьТекущейСтроки <> Неопределено Тогда
		ИдентификаторСтроки = ИдентификаторСтрокиДереваПоЗначению(ОтборПринадлежности, ПринадлежностьТекущейСтроки);
	КонецЕсли;
	
	Если ИдентификаторСтроки <> Неопределено Тогда
		Элементы.ДеревоПринадлежностей.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;
	
КонецПроцедуры  

&НаСервере
Процедура ЗаполнитьОтборДереваГрупп(ГруппаТекущейСтроки = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	Дерево = ДеревоГрупп();
	ЗначениеВРеквизитФормы(Дерево, "ОтборГрупп");
	УстановитьПривилегированныйРежим(Ложь);
	
	ИдентификаторСтроки = Неопределено;
	Если ГруппаТекущейСтроки <> Неопределено Тогда
		ИдентификаторСтроки = ИдентификаторСтрокиДереваПоЗначению(ОтборГрупп, ГруппаТекущейСтроки);
	КонецЕсли;
	
	Если ИдентификаторСтроки <> Неопределено Тогда
		Элементы.ОтборГрупп.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;
	
КонецПроцедуры  

&НаСервере
Функция ДеревоГрупп() 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Цели.Ссылка КАК Значение,
	|	Цели.Наименование КАК Представление,
	|	Цели.ПометкаУдаления КАК ПометкаУдаления,
	|	Цели.ЭтоГруппа КАК ЭтоГруппа, 
	|	ВЫБОР
	|		КОГДА НЕ Цели.ЭтоГруппа
	|			ТОГДА ВЫБОР
	|					КОГДА Цели.ПометкаУдаления
	|						ТОГДА 5
	|					ИНАЧЕ 4
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА Цели.ПометкаУдаления
	|					ТОГДА 2
	|				ИНАЧЕ 1
	|			КОНЕЦ
	|	КОНЕЦ КАК Картинка
	|ИЗ
	|	Справочник.УБ_Цели КАК Цели
	|ГДЕ
	|	Цели.ЭтоГруппа 
	|
	|УПОРЯДОЧИТЬ ПО
	|	Цели.ЭтоГруппа ИЕРАРХИЯ,
	|	Цели.РеквизитДопУпорядочивания,
	|	Цели.Наименование";  
	
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	Если Дерево.Строки.Количество() > 0 Тогда
		СтрокаВсе = Дерево.Строки.Вставить(0);
		СтрокаВсе.Значение = Неопределено;
		СтрокаВсе.Представление = НСтр("ru='<Все>'");
	КонецЕсли;
	
	Возврат Дерево;
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ИдентификаторСтрокиДереваПоЗначению(Коллекция, ИскомоеЗначение)
	
	КоллекцияЭлементов = Коллекция.ПолучитьЭлементы();
	
	Для каждого Элемент Из КоллекцияЭлементов Цикл
		
		Если Элемент.Значение = ИскомоеЗначение Тогда
			Возврат Элемент.ПолучитьИдентификатор();
		КонецЕсли;
		
		Идентификатор = ИдентификаторСтрокиДереваПоЗначению(Элемент, ИскомоеЗначение);
		
		Если Идентификатор <> Неопределено Тогда
			Возврат Идентификатор;
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции


&НаКлиенте
Процедура ОтборПринадлежностиПриАктивизацииСтроки(Элемент)

	Если ОтборИерархияПереключатель <> 1 Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.ДеревоПринадлежностей.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтборПринадлежностиТекущая = Элементы.ДеревоПринадлежностей.ТекущиеДанные.Значение Тогда
		Возврат;
	КонецЕсли;

	Если Элемент = Неопределено Тогда
		ОтборПриАктивизацииСтрокиНаКлиенте();
	Иначе
		ПодключитьОбработчикОжидания("ОтборПриАктивизацииСтрокиНаКлиенте", 0.2, Истина);
	КонецЕсли;
	
	ТекущийЭлемент = Элементы.ДеревоПринадлежностей;

КонецПроцедуры    

&НаКлиенте
Процедура ОтборГруппПриАктивизацииСтроки(Элемент)

	Если ОтборИерархияПереключатель = 0 Тогда
		Если Элементы.ДеревоГрупп.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;	
		Если ОтборГруппыТекущая = Элементы.ДеревоГрупп.ТекущиеДанные.Значение Тогда
			Возврат;
		КонецЕсли;   
	Иначе  
		Если Элементы.ДеревоПринадлежностей.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;	
		Если ОтборПринадлежностиТекущая = Элементы.ДеревоПринадлежностей.ТекущиеДанные.Значение Тогда
			Возврат;
		КонецЕсли; 
	КонецЕсли;

	Если Элемент = Неопределено Тогда
		ОтборПриАктивизацииСтрокиНаКлиенте();
	Иначе
		ПодключитьОбработчикОжидания("ОтборПриАктивизацииСтрокиНаКлиенте", 0.2, Истина);
	КонецЕсли;
	
	ТекущийЭлемент = Элементы.ДеревоГрупп;
	
КонецПроцедуры


&НаСервере
Процедура ОбработкаЗаписиНового(НовыйОбъект, Значение, СтандартнаяОбработка)
	ЗаполнитьДеревьяОтборов();
	ЗаполнитьСпискиЦелей();
КонецПроцедуры

&НаКлиенте
Процедура ОтборИерархияПереключательПриИзменении(Элемент)
    ЗаполнитьДеревьяОтборов();// !!! нужно оптимизировать
	УправлениеВидимостью();	
	ПодключитьОбработчикОжидания("ОтборПриАктивизацииСтрокиНаКлиенте", 0.1, Истина);	
КонецПроцедуры


&НаКлиенте
Процедура ОтборПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
		
	//структуру не перетаскиваем
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	
КонецПроцедуры


//////////////////////////////////////////////

&НаКлиенте
Процедура ОтборПриАктивизацииСтрокиНаКлиенте() 
	
	ПараметрыФормы = Новый Структура("ТекстСообщения", НСтр("ru = 'Подождите...'"));
	ФормаДлительнойОперации = ОткрытьФорму("ОбщаяФорма.ДлительнаяОперация", ПараметрыФормы);
	
	//СохранитьСостояниеДерева();	
	
	Если ОтборИерархияПереключатель = 0 Тогда
		
		ОтборПринадлежностиТекущая = Неопределено;
		Если Элементы.ДеревоГрупп.ТекущиеДанные = Неопределено Тогда
			ФормаДлительнойОперации.Закрыть();
			Возврат;
		КонецЕсли;
		
		ОтборГруппыТекущая = Элементы.ДеревоГрупп.ТекущиеДанные.Значение; 
		
	ИначеЕсли ОтборИерархияПереключатель = 1 Тогда
		
		ОтборГруппыТекущая = Неопределено;
		Если Элементы.ДеревоПринадлежностей.ТекущиеДанные = Неопределено Тогда
			ФормаДлительнойОперации.Закрыть();
			Возврат;
		КонецЕсли;
		
		ОтборПринадлежностиТекущая = Элементы.ДеревоПринадлежностей.ТекущиеДанные.Значение; 
		
	КонецЕсли;
	
	УстановитьОтборСписка(); 
	//Если Не Параметры.РежимВыбора Тогда
	//	ВосстановитьСостояниеДерева();	
	//КонецЕсли;      
	//
	ФормаДлительнойОперации.Закрыть();

КонецПроцедуры   

&НаКлиенте
Процедура СохранитьСостояниеДерева(Дерево = Неопределено, ДеревоНаКлиенте = Неопределено)      
	
	Если Дерево = Неопределено Тогда 
		Если РежимСпискаЦелейПоГруппам Тогда
			Дерево = Список;
	   		ДеревоНаКлиенте = Элементы.Список;
		Иначе               
			Дерево = СписокПоПринадлежности;
			ДеревоНаКлиенте = Элементы.СписокПоПринадлежности;
		КонецЕсли;                                  	
	КонецЕсли;
	
	Если РежимСпискаЦелейПоГруппам Тогда
		//Для каждого Строка Из Дерево.Строки Цикл	//только верхний уровень
		//	ИдентификаторСтроки = Строка.ПолучитьИдентификатор();	
		//	КэшСостоянияДерева.Вставить(Строка.Значение, ДеревоНаКлиенте.Развернут(ИдентификаторСтроки));
		//	СохранитьСостояниеДерева(Строка, ДеревоНаКлиенте);
		//КонецЦикла;
	Иначе
		Для каждого Строка Из Дерево.ПолучитьЭлементы() Цикл
			ИдентификаторСтроки = Строка.ПолучитьИдентификатор();	
			КэшСостоянияДерева.Вставить(Строка.Значение, ДеревоНаКлиенте.Развернут(ИдентификаторСтроки));
			СохранитьСостояниеДерева(Строка, ДеревоНаКлиенте);
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры  

&НаКлиенте                                
Процедура ВосстановитьСостояниеДерева()      
	
	Возврат;
	// сначала добиться, чтобы дерево не сворачивалось вообще
	//Если РежимСпискаЦелейПоГруппам Тогда    
	//	// пока что сохранение состояния для динамического списка не предусмотрено - работают механизмы платформы
	//	Возврат;
	//	Дерево = Список;
	//   	ДеревоНаКлиенте = Элементы.Список;
	//Иначе               
	//	Дерево = СписокПоПринадлежности;
	//	ДеревоНаКлиенте = Элементы.СписокПоПринадлежности;
	//КонецЕсли;                                            

	//Для каждого Строка Из КэшСостоянияДерева Цикл
	//	НайденноеЗначение = ИдентификаторСтрокиДереваПоЗначению(Дерево, Строка.Ключ);
	//	Если ЗначениеЗаполнено(НайденноеЗначение) Тогда
	//		Если Строка.Значение Тогда
	//			 ДеревоНаКлиенте.Развернуть(НайденноеЗначение);		
	//		Иначе
	//			 ДеревоНаКлиенте.Свернуть(НайденноеЗначение);		
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЦикла;
		
КонецПроцедуры     
	
	// Устанавливает отбор списка номенклатуры по выбранной категории.
//
// Параметры:
//  Форма				 - ФормаКлиентскогоПриложения - Форма объекта-владельца, в котором требуется установить отбор номенклатуры по категории.
//  Список				 - ДинамическийСписок - Список на форме.
//  ВыбраннаяПринадлежность	 - СправочникСсылка.ПринадлежностиНоменклатуры - Принадлежность, по которой требуется установить отбор.
//
Процедура УстановитьОтборПоПринадлежности(Форма, Список, ВыбраннаяПринадлежность) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВыбраннаяПринадлежность) Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
			Список.КомпоновщикНастроек.Настройки.Отбор,,
			"ОтборПоПринадлежности");
		Возврат;
		
	КонецЕсли;
	
	ГруппаОтборПоПринадлежности = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		Список.КомпоновщикНастроек.Настройки.Отбор.Элементы,
		"ОтборПоПринадлежности",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтборПоПринадлежности,
		"ПринадлежностьЦели",
		ВидСравненияКомпоновкиДанных.Равно,
		ВыбраннаяПринадлежность,
		"ОтборПоПринадлежности",
		ЗначениеЗаполнено(ВыбраннаяПринадлежность));
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтборПоПринадлежности,
		"ПринадлежностьЦели",
		ВидСравненияКомпоновкиДанных.ВИерархии,
		ВыбраннаяПринадлежность,
		"ОтборПоПринадлежностиВИерархии",
		ЗначениеЗаполнено(ВыбраннаяПринадлежность));
	
КонецПроцедуры

/////////////////////////////////////////////

#КонецОбласти



&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
    
КонецПроцедуры

&НаСервере
Процедура ВывестиПоказателиВАрхивеПриИзмененииНаСервере()
	Если РежимСпискаЦелейПоГруппам Тогда
		УстановитьОтборСписка();	
	Иначе
		// обновить все дерево
		ЗаполнитьЭлементПоПринадлежности("СписокПоПринадлежности");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиПоказателиВАрхивеПриИзменении(Элемент)
	СохранитьСостояниеДерева();
	ВывестиПоказателиВАрхивеПриИзмененииНаСервере();
	ВосстановитьСостояниеДерева();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикисобытийЭлементовТаблицыФормыСписокСписокПоПринадлежности

&НаКлиенте 
Процедура СписокПоПринадлежностиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) 
	Если Не Параметры.РежимВыбора Тогда
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Значение); 
	Иначе            
		ВыбранноеЗначение =  Элемент.ДанныеСтроки(ВыбраннаяСтрока);
		ОповеститьОВыборе(ВыбранноеЗначение.Значение); 
	КонецЕсли;
КонецПроцедуры      

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СписокПоПринадлежностиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
КонецПроцедуры


&НаКлиенте
Процедура СписокПоПринадлежностиОбработкаЗаписиНового(НовыйОбъект, Значение, СтандартнаяОбработка) ЭКспорт
	//ЗаполнитьЭлементПоПринадлежности("СписокПоПринадлежности"); ///!!! пересмотреть
	//СкопироватьДерево("СписокПоПринадлежности");	   
	//ДобавитьЭлементВДеревоНаСервере(НовыйОбъект);
	
	ЗаполнитьДеревьяОтборов();
	ЗаполнитьСпискиЦелей();
	
КонецПроцедуры 

&НаКлиенте
Процедура ДеревоГруппОбработкаЗаписиНового(НовыйОбъект, Значение, СтандартнаяОбработка)
	ЗаполнитьОтборДереваГрупп();
КонецПроцедуры

&НаКлиенте
Процедура ДеревоГруппОбработкаЗапросаОбновления()
	ЗаполнитьОтборДереваГрупп();
КонецПроцедуры

&НаСервере
Процедура ДобавитьЭлементВДеревоНаСервере(НовыйОбъект) 
	
	Дерево = ДанныеФормыВЗначение(СписокПоПринадлежности, Тип("ДеревоЗначений"));
	Строка = Дерево.Строки.Найти(НовыйОбъект.ПринадлежностьЦели,, Истина); 
	НовСтр = Строка.Строки.Добавить();
	НовСтр.Значение = НовыйОбъект;
	НовСтр.Картинка = ?(НовыйОбъект.ПометкаУдаления, 5,4);
	ЗначениеВДанныеФормы(Дерево, СписокПоПринадлежности);
	
	ИдентификаторСтроки = ИдентификаторСтрокиДереваПоЗначению(СписокПоПринадлежности, НовыйОбъект);
		
	Если ИдентификаторСтроки <> Неопределено Тогда
		Элементы.СписокПоПринадлежности.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УправлениеВидимостью()                        
	
	Если Параметры.РежимВыбора и ЗначениеЗаполнено(ПредопределенныйОтбор) Тогда
		Элементы.ОтборИерархияПереключатель.Доступность = Ложь;
		ОтборИерархияПереключатель = 1;
	КонецЕсли;

	Элементы.ДеревоГрупп.Видимость = ОтборИерархияПереключатель = 0;
	Элементы.ДеревоПринадлежностей.Видимость = ОтборИерархияПереключатель = 1;

	Элементы.ФормаПереключитьРежимСпискаЦелей.Заголовок = ?(Не РежимСпискаЦелейПоГруппам, "По группам", "По принадлежности");
	Элементы.Список.Видимость = РежимСпискаЦелейПоГруппам;
	Элементы.СписокПоПринадлежности.Видимость = Не РежимСпискаЦелейПоГруппам;
	
КонецПроцедуры //УправлениеВидимостью

// Заполняет ДеревоЗначений, в зависимости от элемента - используемыми целями или их Принадлежностями
&НаСервере
Процедура ЗаполнитьЭлементПоПринадлежности(ИмяЭлемента)
	
	Если ИмяЭлемента = "СписокПоПринадлежности" и РежимСпискаЦелейПоГруппам Тогда 
		Возврат;
	КонецЕсли;
	Если КомпоновщикНастроек = Неопределено или СхемаКомпоновкиДанных = Неопределено Тогда
		// Получение макета СКД.
		СхемаКомпоновкиДанных =  Справочники.УБ_Цели.ПолучитьМакет("ДеревоПринадлежностей");
		
		 //Инициализация компоновщиков.
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;      
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);	
	КонецЕсли;

	Если Не ВывестиЦелиСтатусом = "Все" Тогда
		
		ГруппаЭлементовОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаЭлементовОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		НовыйЭлементОтбора = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ПолеОтбора = Новый ПолеКомпоновкиДанных("Статус");
	    НовыйЭлементОтбора.ЛевоеЗначение =  ПолеОтбора;
	    НовыйЭлементОтбора.Использование = Истина;
	    НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	    НовыйЭлементОтбора.ПравоеЗначение = ВывестиЦелиСтатусом; 
		
		НовыйЭлементОтбора = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ПолеОтбора = Новый ПолеКомпоновкиДанных("Статус");
	    НовыйЭлементОтбора.ЛевоеЗначение =  ПолеОтбора;
	    НовыйЭлементОтбора.Использование = Истина;
	    НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	    НовыйЭлементОтбора.ПравоеЗначение = Перечисления.УБ_СостоянияПоказателейЭффективности.ПустаяСсылка();
	КонецЕсли;      
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КомпоновщикНастроек.Настройки.Отбор, "ТипЗначенияЦели", "СтруктураПредприятия",
																				ВидСравненияКомпоновкиДанных.Равно, "ТипЗначенияЦели", ИмяЭлемента = "ОтборПринадлежности");	
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, 
													КомпоновщикНастроек.Настройки,,,
													Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
													
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки); 
	
	// Подготовка и заполнение дерева иерархии.
	ДеревоИерархии = Новый ДеревоЗначений;
	
	ПроцессорВывода = Новый  ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ДеревоИерархии);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);    
	
	Если ИмяЭлемента = "ОтборПринадлежности" 
		и Не ЗначениеЗаполнено(ПредопределенныйОтбор) и ДеревоИерархии.Строки.Количество() > 0 Тогда

		СтрокаВсе = ДеревоИерархии.Строки.Вставить(0);
		СтрокаВсе.Значение = Неопределено;
		СтрокаВсе.Представление = НСтр("ru='<Все>'");

		СтрокаВсе = ДеревоИерархии.Строки.Вставить(1);
		СтрокаВсе.Значение = Справочники.УБ_Компании.Компания;
		СтрокаВсе.Представление = НСтр("ru='Компания'");
  	КонецЕсли; 
	
	ЗначениеВРеквизитФормы(ДеревоИерархии, ИмяЭлемента);

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСписка() 

	//7.3.1.2. Ограничения и особенности
	
	//При установке отбора в динамическом списке следует помнить, 
	//что отбор не действует на группы, если для динамического списка выбран режим отображения Иерархический список или Дерево. 
	//	Под «группами» понимается элемент справочника или плана видов характеристик, у которого свойство ЭтоГруппа установлено в значение Истина.	

	Если РежимСпискаЦелейПоГруппам Тогда
		Если Не ВывестиЦелиСтатусом = "Все" Тогда 		
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "СостояниеЦели", ВывестиЦелиСтатусом);
		Иначе
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "СостояниеЦели");
		КонецЕсли;  
		
		Если НЕ ЗначениеЗаполнено(ОтборГруппыТекущая) Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Ссылка");	
		Иначе	
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", ОтборГруппыТекущая,
																				ВидСравненияКомпоновкиДанных.ВИерархии, "Ссылка", ЗначениеЗаполнено(ОтборГруппыТекущая));	
		КонецЕсли;  
		
		Если НЕ ЗначениеЗаполнено(ОтборПринадлежностиТекущая) Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПринадлежностьЦели");
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПринадлежностьЦели",ОтборПринадлежностиТекущая,
																				ВидСравненияКомпоновкиДанных.ВИерархии, "ПринадлежностьЦели", ЗначениеЗаполнено(ОтборПринадлежностиТекущая));	
		КонецЕсли;
	Иначе 
		УстановитьОтборДереваПоПринадлежности();
	КонецЕсли;	

КонецПроцедуры	 

Процедура УдалитьНенужныеРекурсивно(Отборы, Родители, РодителиКУдалению)
	
	Для Каждого ТекРодитель Из Родители Цикл
		
		СтрокаРодителяСоответствуетОтбору = Истина;
		
		Если Отборы.Свойство("ОтборГруппыТекущая") 
			и ТипЗнч( ТекРодитель.Значение) = Тип("СправочникСсылка.УБ_Цели") 
			и Не ТекРодитель.Значение.ПринадлежитЭлементу(ОтборГруппыТекущая) Тогда
		
			СтрокаРодителяСоответствуетОтбору = Ложь;
			
		КонецЕсли; 
		
		Если СтрокаРодителяСоответствуетОтбору и Отборы.Свойство("ОтборПринадлежностиТекущая") Тогда
			Если ТипЗнч(ОтборПринадлежностиТекущая) = Тип("СправочникСсылка.СтруктураПредприятия") 
				и ТипЗнч(ТекРодитель.Значение) = Тип("СправочникСсылка.СтруктураПредприятия") 
				и Не ТекРодитель.Значение.ПринадлежитЭлементу(ОтборПринадлежностиТекущая)
				и Не ТекРодитель.Значение = ОтборПринадлежностиТекущая Тогда
				СтрокаРодителяСоответствуетОтбору = Ложь;
			ИначеЕсли ТипЗнч(ТекРодитель.Значение) = Тип("СправочникСсылка.УБ_Цели") 
				и ОтборПринадлежностиТекущая = Справочники.УБ_Компании.Компания 
				и Не ТекРодитель.Значение.ПринадлежностьЦели	= ОтборПринадлежностиТекущая Тогда
				СтрокаРодителяСоответствуетОтбору = Ложь;
			ИначеЕсли ТипЗнч(ТекРодитель.Значение) = Тип("СправочникСсылка.УБ_Цели") 
				и Не ТекРодитель.Значение.ПринадлежностьЦели	= ОтборПринадлежностиТекущая Тогда
				СтрокаРодителяСоответствуетОтбору = Ложь;
			КонецЕсли;

		КонецЕсли;
		
		Если Не СтрокаРодителяСоответствуетОтбору Тогда
			РодителиКУдалению.Добавить(ТекРодитель);              
			УдалитьНенужныеРекурсивно(Отборы, ТекРодитель.Строки, РодителиКУдалению);
		Иначе
			ОтменитьУдалениеРекурсивно(РодителиКУдалению, ТекРодитель);
			УдалитьНенужныеРекурсивно(Отборы, ТекРодитель.Строки, РодителиКУдалению);
			//всех, кто оказался уровнем выше - не удаляем
		КонецЕсли;		
		
	КонецЦикла;	  
	

КонецПроцедуры     

Процедура ОтменитьУдалениеРекурсивно(РодителиКУдалению, ТекРодитель)
	
	РодительКОтмене = ТекРодитель.Родитель;    
	Если РодительКОтмене = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элемент = РодителиКУдалению.Найти(РодительКОтмене);          
	Если Не Элемент = Неопределено Тогда
		РодителиКУдалению.Удалить(Элемент);
	КонецЕсли;
	ОтменитьУдалениеРекурсивно(РодителиКУдалению, РодительКОтмене)
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СостояниеЦели");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.УБ_СостоянияПоказателейЭффективности.Архивный;
	
	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Список");
	ЗачеркнутыйШрифт = Новый Шрифт(,,,,, Истина);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", ЗачеркнутыйШрифт);
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокПоПринадлежности.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.УБ_СостоянияПоказателейЭффективности.Архивный;
	
	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("СписокПоПринадлежности");
	ЗачеркнутыйШрифт = Новый Шрифт(,,,,, Истина);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", ЗачеркнутыйШрифт);

КонецПроцедуры

Функция ЭтоНазначениеЦели(Значение) Экспорт
	
	Возврат ТипЗнч(Значение) = Тип ("СправочникСсылка.СтруктураПредприятия") 
				или ТипЗнч(Значение) = Тип("СправочникСсылка.УБ_Компании");
		
КонецФункции

#КонецОбласти

#Область ОтборВСпискеПоПринадлежности 

&НаСервере
Процедура УстановитьОтборДереваПоПринадлежности() Экспорт
	
	ИмяДереваИсточника = "СписокПоПринадлежности";
	Отборы = Новый Структура;      
	РодителиКУдалению = Новый Массив;
	
	ВключеноОтборов = 0;
	
	// Надо снять отбор
	ДеревоКопия = РеквизитФормыВЗначение(ИмяКопииДереваЗаказа(ИмяДереваИсточника));
	ДеревоЗаказа = РеквизитФормыВЗначение("СписокПоПринадлежности");
	ДеревоЗаказа = ДеревоКопия.Скопировать(); // Замещаем основное дерево, данными из копии
	
	Если ЗначениеЗаполнено(ОтборГруппыТекущая) Тогда
		Отборы.Вставить("ОтборГруппыТекущая", ОтборГруппыТекущая );
		ВключеноОтборов = ВключеноОтборов+1;																			
	КонецЕсли;  
		
	Если ЗначениеЗаполнено(ОтборПринадлежностиТекущая) Тогда
		Отборы.Вставить("ОтборПринадлежностиТекущая", ОтборПринадлежностиТекущая);
		ВключеноОтборов = ВключеноОтборов+1;																			
	КонецЕсли;
	    
	Если ВключеноОтборов <= 0 Тогда
		ЗначениеВРеквизитФормы(ДеревоЗаказа, "СписокПоПринадлежности"); // Возвращаем данные на форму
		Возврат;
	КонецЕсли;
	
	
	УдалитьНенужныеРекурсивно(Отборы, ДеревоЗаказа.Строки, РодителиКУдалению);
	Для Каждого Родитель Из РодителиКУдалению Цикл
		Попытка                            
			ВладелецУровня = Родитель.Родитель;
			//может оказаться, что строка уже удалена
			Если ЗначениеЗаполнено(ВладелецУровня) Тогда
				ВладелецУровня.Строки.Удалить(Родитель);	
			Иначе
				ДеревоЗаказа.Строки.Удалить(Родитель);		
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЦикла;
	
	
	ЗначениеВРеквизитФормы(ДеревоЗаказа, "СписокПоПринадлежности"); // Передаем на форму, наше обновленное дерево

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Функция ИмяКопииДереваЗаказа(ИмяДереваЗначениеа)
	
	Возврат "Копия"+ИмяДереваЗначениеа;
	
КонецФункции

&НаСервере
Процедура СоздатьНовоеПустоеДеревоКопированием(ИмяДереваЗначениеа)
	
	Если  Не ПолучитьРеквизиты().Найти(ИмяКопииДереваЗаказа(ИмяДереваЗначениеа)) = Неопределено Тогда  
		// Дерево есть, создавать не надо
		Возврат;	
	КонецЕсли; 
	

	// Так как возникло исключение и мы попалю сюда, то копии дерева нету
	ДеревоИсходник = РеквизитФормыВЗначение("СписокПоПринадлежности");
	МассивДобавленныхРеквизитов = Новый Массив;
	НовоеДерево = Новый РеквизитФормы(ИмяКопииДереваЗаказа(ИмяДереваЗначениеа), Новый ОписаниеТипов("ДеревоЗначений"));
	МассивДобавленныхРеквизитов.Добавить(НовоеДерево);
	
	Для Каждого ТекКол Из ДеревоИсходник.Колонки Цикл
		
		Колонка = Новый РеквизитФормы(ТекКол.Имя, ТекКол.ТипЗначения, ИмяКопииДереваЗаказа(ИмяДереваЗначениеа));
		МассивДобавленныхРеквизитов.Добавить(Колонка);
		
	КонецЦикла;
	
	ИзменитьРеквизиты(МассивДобавленныхРеквизитов);
	ДеревоИсходник = Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьДерево(ИмяДереваЗначениеа)
	
	ДеревоЗначение = ЭтотОбъект[ИмяДереваЗначениеа];
	ИмяРеквизитаНазначение = ИмяКопииДереваЗаказа(ИмяДереваЗначениеа);
	СоздатьНовоеПустоеДеревоКопированием(ИмяДереваЗначениеа);
	
	ДеревоКопия = ДанныеФормыВЗначение(ДеревоЗначение, Тип("ДеревоЗначений")).Скопировать();
	ЗначениеВРеквизитФормы(ДеревоКопия, ИмяРеквизитаНазначение);	
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы_ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры


#КонецОбласти


 
КэшСостоянияДерева = Новый Соответствие;
