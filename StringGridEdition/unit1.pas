unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private

  public

  end;

const
  MAX_WIDTH = 299;   // Максималтная ширина таблицы
  MAX_HEIGHT = 229;  // Максимальная высота таблицы
var
  Form1: TForm1;

  // Делаем матрицу и её размерность глобальными переменными
  // чтобы они были видны во всех функциях -
  // обработчиков нажатия кнопок
  M: TMatrix;
  rows: integer;
  cols: integer;

implementation

{$R *.lfm}

{ TForm1 }

// удобно будет создать процедуру вывода матрицы в объект типа TStringGrid
// 'var table :TStringGrid' т.к. мы будем изменять объект table - записывать в него
// Хотя это не обязательно, работает и без, тупо для приличия делаем так
procedure PrintMatrix(M: TMatrix; rows: integer; cols: integer; var table: TStringGrid);
var
  i,j: integer;
  width_one: integer;
  height_one: integer;
  el_str: string; // строковое представление элемента матрицы
begin
  // перед записью чего-то в таблицу table очищаем её
  table.Clean;

  table.RowCount := rows;  // Число столбцов
  table.ColCount := cols;  // Количестов строк   ТАБЛИЦЫ

  // Чтобы обращаться к атрибутам table без точки
  // Например раньше надо было писать
  // 'table.ColCount' , теперь же достаточно просто 'RowCount'
  with table do
  begin

    {Устанавливаем одинаковую ВЫСОТУ для всех ячеек}
    // Сначала находим сколько пикселей на одну ячейчку
    height_one:= MAX_HEIGHT div RowCount;
    // Дальше установим высоту ВСЕЙ таблицы  на 0
    // Позже обходя столбцы будем прибавливать к высоте ВСЕЙ таблицы
    // Высоту одной строчки. И получится верное соотношение размеров
    // ВСЕЙ таблицы и всех строк(То есть будут видны все строки)
    // ПОПРАВКА: можно сразу было сделать height := MAX_HEIGHT;
    // но суммируя каждый раз height_one, не всегда получается MAX_HEIGHT
    // так как используется целочисленное делени 'MAX_HEIGHT div RowCount'
    // Если сразу написать height := MAX_HEIGHT,
    // то может получится свободное место, не занятое ячейками - а зачем оно?
    height := 0;
    // обходим все строки
    for i:= 0 to RowCount -1 do
    begin
      RowHeights[i] := height_one; // для каждой строки одна и та же высота
      height := height + height_one;
    end;
    // Добавляем 1 пиксель к высоте ВСЕЙ таблицы,
    // чтобы НЕ ПОЯВЛЯЛСЯ вертикальный скролбар
    height := height + 1;

    // Аналогичные действия под ширину

    {Устанавливаем одинаковую ШИРИНУ для всех ячеек}
    // Сначала находим сколько пикселей на одну ячейчку
    width_one:= MAX_WIDTH div ColCount;
    width := 0;
    // обходим все столбцы
    for j:= 0 to ColCount -1 do
    begin
      ColWidths[j] := width_one;   // для каждого столбца одна и та же ширина
      width := width + width_one;
    end;
    // Добавляем 1 пиксель к ширине ВСЕЙ таблицы,
    // чтобы НЕ ПОЯВЛЯЛСЯ горизонтальный скролбар
    width := width + 1;

    // Теперь заполняем таблицу, элементами из матрицы
    for i:=0 to RowCount-1 do
      for j:=0 to ColCount-1 do
      begin
        // Столбцы и строки у ТАБЛИЦЫ нумеруются с нуля,
        // а в матрице с еденицы
        // поэтому обходим с 0 в циклах
        // и обращаемся к элементам МАТРИЦЫ так M[i+1, j+1]
        // Преобразуем число - елемент матрицы в СТРОКУ
        // Ячейки ТАБЛИЦЫ - это строки
        str(M[i+1, j+1], el_str);
        // Еслибы не with приходилось бы обращаться table.Cells
        // Cells - по сути та же матрица - только нашей таблицы table
        // И строки и столбцы у неё нумеруются с 0 - ЗАПОМНИТЕ
        // Также ВАЖНО помнить, что если обращаться к элементу МАТРИЦЫ
        // То мы пишем сначала номер строки потом столбца : M[i,j](если i,j > 1 конешн)
        // Но в Cells нужно СНАЧАЛА передавать номер СТОЛБЦА, и уже ПОТОМ номер СТРОКИ
        // То есть Cells[j,i] - НЕ опечатка
        Cells[j,i] := el_str;
      end;
  end;
end;


{Считываем матрицу из StringGrid}
// 'var' чтобы изменить переменные передавааемые в функцию
// table: TStringGrid без var т.к. мы только считываем оттуда
procedure InputMatrix(var M: TMatrix; var rows: integer; var cols: integer; table:TStringGrid);
var i, j: integer;

begin
  // Задаём размерность Матрицы
  rows := table.RowCount;  // Число столбцов
  cols := table.ColCount;  // Количестов строк МАТРИЦЫ

  // Теперь просто обходя все ячейки ТАБЛИЦЫ
  // Заполняем матрицу
  // здесь для примера мы НЕ ИСПОЛЬЗУЕМ with
  // чтобы показать как ещё можно обращаться к атрибутам table
  for i:=0 to table.RowCount-1 do
      for j:=0 to table.ColCount-1 do
          // Помните в Celss СНАЧАЛА СТОЛБЕЦ, ПОТОМ СТРОКУ
          // Так как ячейка таблицы - ЭТО СТРОКА, а элемент матрицы - ЧИСЛО
          // то строку нужно привести к целому числу
          M[i+1, j+1] := StrToInt(table.Cells[j,i]);

end;

{Нажали 'Ввести матрицу'}
procedure TForm1.Button1Click(Sender: TObject);
begin

  // Получаем размерность матрицы от пользователя
  // InputBox возвращает строку, но ГЛОБАЛЬНЫЕ переменные rows и cols типа integer
  // поэтому преобразуем возвращаем значение в целое число при помощи StrToInt
  rows := StrToInt(InputBox('Размерность матрицы', 'Введите число СТРОК', '5'));
  cols := StrToInt(InputBox('Размерность матрицы', 'Введите число СТОЛБЦОВ', '5'));

  // Теперь так как УЖЕ ЕСТЬ число строк и столбцов
  // Заполняем матрицу
  FillMatrix(M, rows, cols);

  // выводим матрицу в StringGrid1 - исходная матрица
  PrintMatrix(M,rows,cols,StringGrid1);

end;

{Нажали кнопку 'Максимумы ВВЕРХ'}
procedure TForm1.Button2Click(Sender: TObject);
begin
  // Считывам матрицу из StringGrid1 и узнаём число строк и столбцов
   InputMatrix(M, rows, cols, StringGrid1);

  // Передвигаем максимумы в столбцах наверх
  MoveUp(M, rows, cols);

  {Защита - максимумы ВЛЕВО-В НАЧАЛО СТРОКИ}
  // Закомментируйте MoveUp и Расскоментируйте код ниже
  // MoveLeft(M, rows, cols);

  // и выводим полученную матрицу в StringGrid2
  PrintMatrix(M, rows, cols, StringGrid2);
end;

{Нажали кнопку 'Максимумы ВНИЗ'}
procedure TForm1.Button3Click(Sender: TObject);
begin
  // Считывам матрицу из StringGrid1 и узнаём число строк и столбцов
   InputMatrix(M, rows, cols, StringGrid1);

  // Передвигаем максимумы в столбцах вниз
  MoveDown(M, rows, cols);

  {Защита - максимумы ВПРАВО-В КОНЕЦ СТРОКИ}
  // Закомментируйте MoveDown и Расскоментируйте код ниже
  // MoveRight(M, rows, cols);

  // и выводим полученную матрицу в StringGrid2
  PrintMatrix(M, rows, cols, StringGrid2);
end;

{Нажали 'Закрыть' - выход из программы}
procedure TForm1.Button4Click(Sender: TObject);
begin
  close;
end;

end.

