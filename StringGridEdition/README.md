# Реализаци с двумя StringGrid

## Примеры работы программы

#### Передвижение максимумов столбцов наверх
![Image alt](https://github.com/Polevochka/P_M2_ZA16/raw/master/StringGridEdition/img/1.png)

#### Передвижение максимумов столбцов вниз
![Image alt](https://github.com/Polevochka/P_M2_ZA16/raw/master/StringGridEdition/img/2.png)

### Возможна дополнительная задача
    Например, Когда пользователь сам изменяет таблицу(StringGrid) с исходной матрицей,
    то внесённые изменения должны отразиться на Результирущей матрице
    То есть мы должны считать данные из ЫекштпПкшв1 и потом обрабатывать матрицу

#### Сначала надо дать возможность пользователю изменять StringGrid1(Уже выставлено, но нужно знать как это делать)
    Для это выделяем на макете формы StringGrid1, дальше идём в 'Испектор Объектов' на вкладку 'Свойства',
    Потом ищем поле 'Options' и делаем два быстрых щелчка мышкой, чтобы открыть выпадающий список
    и напротив поля 'goEditing' ставим флажок.
![Image alt](https://github.com/Polevochka/P_M2_ZA16/raw/master/StringGridEdition/img/lol.png)

##### Пример: Заменим рандомный елемент в левой матрице на 444 - теперь это самое большое число в 3-ем столбце
![Image alt](https://github.com/Polevochka/P_M2_ZA16/raw/master/StringGridEdition/img/4.png)
##### И нажмём на 'Максимумы ВНИЗ'
    Из скрина видно, что всё верно и число 444 переместилось вниз
![Image alt](https://github.com/Polevochka/P_M2_ZA16/raw/master/StringGridEdition/img/4.png)
