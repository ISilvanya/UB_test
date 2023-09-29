//	
//&НаСервере
//Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//	
//	НастройкиОтчета = Отчет.КомпоновщикНастроек.Настройки;
//	парПериод =  НастройкиОтчета.ПараметрыДанных.Элементы.Найти("Период");//Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Период");
//	Если НЕ парПериод = Неопределено Тогда
//		Если ТипЗнч(парПериод.Значение) = Тип("Дата") 
//			Или ТипЗнч(парПериод.Значение) = Тип("СтандартнаяДатаНачала") Тогда
//			Дата = Дата(парПериод.Значение);
//			Если Дата = '00010101' Тогда
//				парПериод.Значение = ТекущаяДатаСеанса();
//			КонецЕсли;
//		КонецЕсли;
//	КонецЕсли;
//	
//	Если ТипЗнч(парПериод.Значение) = Тип("СтандартнаяДатаНачала") Тогда
//		Отчет.ДатаОтчета = парПериод.Значение.Дата;
//	Иначе
//	   	Отчет.ДатаОтчета= парПериод.Значение;				
//	КонецЕсли; 

//КонецПроцедуры     



//&НаКлиенте
//Процедура ПараметрыПриИзменении(Элемент)
//	
//	НастройкиОтчета = Отчет.КомпоновщикНастроек.Настройки;
//	//парПериод = Отчет.НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
//	парПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
//	Если ЗначениеЗаполнено(Отчет.ДатаОтчета) Тогда
//		//Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Период", Отчет.ДатаОтчета);
//		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("Период", Отчет.ДатаОтчета);
//	КонецЕсли;

//	Если ЗначениеЗаполнено(Отчет.ДетализироватьДоСотрудников) Тогда
//		//Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ДетализироватьДоСотрудников", Отчет.ДетализироватьДоСотрудников);
//		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ДетализироватьДоСотрудников", Отчет.ДетализироватьДоСотрудников);
//	КонецЕсли;

//	парОрганизация = НастройкиОтчета.Отбор.Элементы.Получить(0);
//	Если ЗначениеЗаполнено(Организация) Тогда
//		парОрганизация.ПравоеЗначение = Организация;
//		парОрганизация.Использование = Истина;
//	Иначе
//		парОрганизация.Использование = Ложь; 
//	КонецЕсли;

//	парПодразделение = НастройкиОтчета.Отбор.Элементы.Получить(1);
//	Если ЗначениеЗаполнено(Подразделение) Тогда
//		парПодразделение.ПравоеЗначение = Подразделение;
//		парПодразделение.Использование = Истина;
//	Иначе 
//		СписокСвязанныхРеквизитов = "Подразделение";
//		Подразделение = УБ_ОбщегоНазначенияКлиентВызовСервера.ЗначениеРеквизитаПоУмолчанию("Подразделение");
//		парПодразделение.Использование = Ложь; 
//	КонецЕсли;
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ОчиститьОтборы(Команда)
//	Организация = Неопределено;
//	Подразделение = Неопределено;
//	УстановитьТипЗначенияСвязанныхРеквизитовПоУмолчаниюНаСервере();
//	Отчет.Глубина = 50;
//	ПараметрыПриИзменении("");
//КонецПроцедуры                                                                                          

//&НаСервере
//Процедура УстановитьТипЗначенияСвязанныхРеквизитовПоУмолчаниюНаСервере()
//	СписокСвязанныхРеквизитов = "Подразделение";
//	УБ_ОбщегоНазначения.УстановитьТипЗначенияСвязанныхРеквизитовПоУмолчанию(ЭтотОбъект, СписокСвязанныхРеквизитов);
//КонецПроцедуры

//&НаСервере
//Процедура ПередЗагрузкойВариантаНаСервере(Настройки)
//	
//	парПериод = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
//	Отчет.ДатаОтчета = парПериод.Значение;	
//	
//	парДетализироватьДоСотрудников = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДетализироватьДоСотрудников"));
//	Если НЕ парДетализироватьДоСотрудников = Неопределено Тогда
//		Отчет.ДетализироватьДоСотрудников = парДетализироватьДоСотрудников.Значение;		
//	КонецЕсли;
//	
//	парОрганизация = Настройки.Отбор.Элементы.Получить(0);
//	Если парОрганизация.Использование = Истина Тогда
//		Организация = парОрганизация.ПравоеЗначение;
//	КонецЕсли;

//	СписокСвязанныхРеквизитов = "Подразделение";
//	УБ_ОбщегоНазначения.УстановитьТипЗначенияСвязанныхРеквизитовПоУмолчанию(ЭтотОбъект, СписокСвязанныхРеквизитов);

//	парПодразделение = Настройки.Отбор.Элементы.Получить(1);
//	Если парПодразделение.Использование Тогда
//		Подразделение	= парПодразделение.ПравоеЗначение
//	КонецЕсли;

//КонецПроцедуры
