Функция СменаНаправленияИндикаторовГНЭ(Негатив, Позитив, типПрямой) Экспорт
	Если Не типПрямой Тогда
		Негатив.Заголовок = "▲";
		Позитив.Заголовок = "▼";
		возврат истина;
	Иначе
		Негатив.Заголовок = "▼";
		Позитив.Заголовок = "▲";
		возврат истина;
	КонецЕсли;
	
	возврат ложь;
КонецФункции

Функция СменаЦветаПереключателя(Переключатель, Активный, ЦветАктивного = Неопределено) Экспорт
	Если ЦветАктивного = Неопределено Тогда
		ЦветАктивного = Новый Цвет(0,114,0);
	КонецЕсли;
	
	Если Не Активный Тогда
		Переключатель.ЦветТекстаЗаголовка = Новый Цвет(51,51,51);
	Иначе
		Переключатель.ЦветТекстаЗаголовка = ЦветАктивного;
	КонецЕсли;
	
КонецФункции
