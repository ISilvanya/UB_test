
#Область ПрограммныйИнтерфейс

Функция СоздатьНовуюВерсиюГрейда(Грейд, ПараметрыЗаполнения, Регистратор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВерсииГрейдов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.УБ_ВерсииГрейдов КАК ВерсииГрейдов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УБ_ВерсииГрейдов КАК РегистрСведений
		|		ПО ВерсииГрейдов.Ссылка = РегистрСведений.ВерсияГрейда
		|ГДЕ
		|	ВерсииГрейдов.Владелец = &Грейд
		|	И ВерсииГрейдов.ДатаВерсии = &ДатаВерсии
		|	И (РегистрСведений.Регистратор = &Регистратор
		|		ИЛИ РегистрСведений.Статус ЕСТЬ NULL)";
	
	Запрос.УстановитьПараметр("Грейд", Грейд);
	Запрос.УстановитьПараметр("ДатаВерсии", ПараметрыЗаполнения.ДатаВерсии);
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		ОбновитьДанныеВерсииГрейда(Выборка.Ссылка, ПараметрыЗаполнения);
		
		Возврат Выборка.Ссылка;
		
	КонецЕсли;
	
	Наименование = СтандартноеНаименованиеВерсииГрейда(ПараметрыЗаполнения.ДатаВерсии);
	
	ВерсияГрейдаОбъект = Справочники.УБ_ВерсииГрейдов.СоздатьЭлемент();
	ВерсияГрейдаОбъект.Владелец = Грейд;
	ВерсияГрейдаОбъект.Наименование = Наименование;
	ЗаполнитьЗначенияСвойств(ВерсияГрейдаОбъект, ПараметрыЗаполнения);
	
	ВерсияГрейдаОбъект.Записать();
	
	Возврат ВерсияГрейдаОбъект.Ссылка;
	
КонецФункции

Процедура ОбновитьДанныеВерсииГрейда(ВерсияГрейда, ПараметрыЗаполнения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВерсииГрейдов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.УБ_ВерсииГрейдов КАК ВерсииГрейдов
		|ГДЕ
		|	ВерсииГрейдов.Ссылка = &Ссылка
		|	И ВерсииГрейдов.ДатаВерсии = &ДатаВерсии
		|	И ВерсииГрейдов.ВАрхиве = &ВАрхиве";
	
	Запрос.УстановитьПараметр("Ссылка", ВерсияГрейда);
	Запрос.УстановитьПараметр("ДатаВерсии", ПараметрыЗаполнения.ДатаВерсии);
	Запрос.УстановитьПараметр("ВАрхиве", ПараметрыЗаполнения.ВАрхиве);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		
		НовоеНаименование = СтандартноеНаименованиеВерсииГрейда(ПараметрыЗаполнения.ДатаВерсии);
		
		ВерсияГрейдаОбъект = ВерсияГрейда.ПолучитьОбъект();
		ВерсияГрейдаОбъект.Наименование = НовоеНаименование;
		ЗаполнитьЗначенияСвойств(ВерсияГрейдаОбъект, ПараметрыЗаполнения);
		ВерсияГрейдаОбъект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПараметрыЗаполненияВерсииГрейда() Экспорт
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ДатаВерсии");
	ПараметрыЗаполнения.Вставить("ВАрхиве", Ложь);
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтандартноеНаименованиеВерсииГрейда(ДатаВерсии = '00010101')
	
	ШаблонНаименования = НСтр("ru = 'от &ДатаВерсии'");
	
	Если ЗначениеЗаполнено(ДатаВерсии) Тогда
		НаименованиеВерсии = СтрЗаменить(ШаблонНаименования, "&ДатаВерсии", Формат(ДатаВерсии, "ДФ=dd.MM.yyyy"));
	Иначе
		НаименованиеВерсии = НСтр("ru = '<не утверждена>'");
	КонецЕсли;
	
	Возврат НаименованиеВерсии;
	  
КонецФункции

Функция РазрешитьПоместитьГрейдВАрхив(МодельПланирования, Грейд) Экспорт
	
	Разрешить = ЕстьРаботающиеСотрудникиГрейда(МодельПланирования, Грейд);
	Возврат Разрешить;
		
КонецФункции

Функция ЕстьРаботающиеСотрудникиГрейда(МодельПланирования, Грейд)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УБ_МоделиПланированияСотрудниковСрезПоследних.МодельПланированияЭффективности КАК МодельПланированияЭффективности,
	               |	УБ_МоделиПланированияСотрудниковСрезПоследних.Грейд КАК Грейд,
	               |	УБ_МоделиПланированияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник
	               |ИЗ
	               |	РегистрСведений.УБ_МоделиПланированияСотрудников.СрезПоследних КАК УБ_МоделиПланированияСотрудниковСрезПоследних
	               |ГДЕ
	               |	УБ_МоделиПланированияСотрудниковСрезПоследних.МодельПланированияЭффективности = &МодельПланированияЭффективности
	               |	И УБ_МоделиПланированияСотрудниковСрезПоследних.Грейд = &Грейд";
	Запрос.УстановитьПараметр("МодельПланированияЭффективности",МодельПланирования);
	Запрос.УстановитьПараметр("Грейд",Грейд);
	Результат = Запрос.Выполнить().Выгрузить();
	МассивСотрудников = Результат.ВыгрузитьКолонку("Сотрудник");

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УБ_КадроваяИсторияСотрудниковСрезПоследних.Организация КАК Организация,
	               |	УБ_КадроваяИсторияСотрудниковСрезПоследних.Подразделение КАК Подразделение,
	               |	УБ_КадроваяИсторияСотрудниковСрезПоследних.Должность КАК Должность,
	               |	УБ_КадроваяИсторияСотрудниковСрезПоследних.ДолжностьПоШтатномуРасписанию КАК ДолжностьПоШтатномуРасписанию,
	               |	УБ_КадроваяИсторияСотрудниковСрезПоследних.ВидСобытия КАК ВидСобытия,
	               |	УБ_КадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник
	               |ИЗ
	               |	РегистрСведений.УБ_КадроваяИсторияСотрудников.СрезПоследних КАК УБ_КадроваяИсторияСотрудниковСрезПоследних
	               |ГДЕ
	               |	УБ_КадроваяИсторияСотрудниковСрезПоследних.ДолжностьПоШтатномуРасписанию.МодельПланирования = &МодельПланирования
	               |	И УБ_КадроваяИсторияСотрудниковСрезПоследних.Сотрудник В(&МассивСотрудников)
	               |	И УБ_КадроваяИсторияСотрудниковСрезПоследних.ВидСобытия <> &Увольнение";
	Запрос.УстановитьПараметр("МассивСотрудников", МассивСотрудников);
	Запрос.УстановитьПараметр("МодельПланирования",МодельПланирования);
	Запрос.УстановитьПараметр("Увольнение",Перечисления.УБ_ВидыКадровыхСобытий.Увольнение);
	Результат1 = Запрос.Выполнить().Выгрузить();
	Если Результат1.Количество() = 0 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;		
	
КонецФункции

#КонецОбласти
