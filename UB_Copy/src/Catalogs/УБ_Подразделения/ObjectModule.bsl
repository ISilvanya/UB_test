#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Расформировано Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Подразделение", Ссылка);
		Запрос.УстановитьПараметр("ДатаРасформирования", ДатаРасформирования);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ШтатноеРасписание.Наименование КАК ПозицияШтатногоРасписания,
		|	ШтатноеРасписание.Ссылка
		|ИЗ
		|	Справочник.УБ_ШтатноеРасписание КАК ШтатноеРасписание
		|ГДЕ
		|	ШтатноеРасписание.Подразделение = &Подразделение                
		|	И НЕ(ШтатноеРасписание.Закрыта
		|				И ШтатноеРасписание.ДатаЗакрытия <= &ДатаРасформирования)";
		
		Результат = Запрос.Выполнить();
		
		Если Не Результат.Пустой() Тогда
			
			ТекстСообщения = НСтр("ru = 'Подразделение ""%1"" не может быть расформировано, т.к. на %2 оно используется в актуальных позициях штатного расписания:';
								  |en = 'The ""%1"" department cannot be disbanded as it is used in relevant staff list positions for %2: '");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстСообщения, Ссылка, Формат(Ссылка.ДатаРасформирования, "ДЛФ=DD"));
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.Расформировано", , Отказ);
			
			Выборка = Результат.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				ТекстСообщения = "- " + НСтр("ru = 'позиция';
											 |en = 'position'") + " ""%1""";
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстСообщения, Выборка.ПозицияШтатногоРасписания);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Выборка.Ссылка, "Объект.Расформировано", , Отказ);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Сформировано Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаСоздания");	
	КонецЕсли;
	
	Если Не Расформировано Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаРасформирования");	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
