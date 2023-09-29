
Функция КадровыеДанныеСотрудников(Знач Сотрудник, ДатаНачала = '00010101') Экспорт
	Возврат  УБ_КадровыйУчет.КадровыеДанныеСотрудников(Сотрудник, ДатаНачала);
КонецФункции  

//Возвращает значение конкретного реквизита кадровых данных
//Исключает передачу таблицы значений на клиент
Функция КадровыеДанныеСотрудниковЗначениеРеквизита(Знач Сотрудник, ДатаНачала = '00010101', Реквизит) Экспорт
	КадровыеДанные = УБ_КадровыйУчет.КадровыеДанныеСотрудников(Сотрудник, ДатаНачала);
	Если КадровыеДанные.Количество() Тогда
		ТекущиеКадровыеДанные = КадровыеДанные[0];
		Возврат ТекущиеКадровыеДанные[Реквизит];
	КонецЕсли;
	
	Возврат Неопределено;

КонецФункции

Функция ДействующиеРуководителиПодразделений(Период, Подразделения) Экспорт
	Возврат	УБ_КадровыйУчет.ДействующиеРуководителиПодразделений(Период, Подразделения);
КонецФункции

