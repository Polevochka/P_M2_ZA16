unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private

  public

  end;

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

// удобно будет создать процедуру вывода матрицы в объект типа TMemo
// 'var mem:TMemo' так как мы будем изменять объект Memo - записывать в него
// Хотя это не обязательно, работает и без, тупо для приличия делаем так
procedure PrintMatrix(M: TMatrix; rows: integer; cols: integer; var mem: TMemo);
var
  // строковое представление одного числа
  el_str: string;
  // вспомогательная строка, чтобы добавить элементы матрицы
  // то есть это сумма строковых представлений каждого элемента(el_str) матрциы
  tmp_str: string;
  // переменные для циклов обхода матрицы
  i,j: integer;
begin
  // перед записью чего-то в Memo очищаем его
  mem.Clear;

  // сначала мы будем собирать строку из элементов матрицы,
  // лежащих на i-ой строчке
  // Потом добавляем эту строку в Memo через Append
  for i:=1 to rows do
  begin
    // присваиваем пустую строку про обработке каждой строки матрицы
    // То есть обработали одну строку, очистили переменную, обработать другую
    // иначе элементы с другой (предыдущей) строки будут выводиться и в новой строке
    tmp_str:='';
    for j:=1 to cols do
    begin
      // преобразуем елемент матрицы в строку
      // число 4 - так же как и в writeln - ширина поля под число
      // чтобы не замарачиваться с пробелами при выводе
      str(M[i,j]:4, el_str);
      // по одному элементы i-ой строки собираем в одну строку
      tmp_str := tmp_str + el_str;
    end;
    // собрали одну строку, теперь добавляем её в Memo
    mem.Append(tmp_str);

  end;
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
  randomize; // для генератора случайных чисел
  FillMatrix(M, rows, cols);

  // выводим матрицу в Memo1 - исходная матрица
  PrintMatrix(M,rows,cols,Memo1);

end;

{Нажали кнопку 'Максимумы ВВЕРХ'}
procedure TForm1.Button2Click(Sender: TObject);
begin

  // Т.к. Мы задали значения переменным M, rows, cols в {Ввести матрицу}
  // А они ГЛОБАЛЬНЫЕ - то есть видны во всех процедурах
  // И их можно испоользовать здесь

  // Передвигаем максимумы в столбцах наверх
  MoveUp(M, rows, cols);

  {Защита - максимумы ВЛЕВО-В НАЧАЛО СТРОКИ}
  // Закомментируйте MoveUp и Расскоментируйте код ниже
  // MoveLeft(M, rows, cols);

  // и выводим полученную матрицу в Memo2
  PrintMatrix(M, rows, cols, Memo2);
end;

{Нажали кнопку 'Максимумы ВНИЗ'}
procedure TForm1.Button3Click(Sender: TObject);
begin
  // Т.к. Мы задали значения переменным M, rows, cols в {Ввести матрицу}
  // А они ГЛОБАЛЬНЫЕ - то есть видны во всех процедурах
  // И их можно испоользовать здесь

  // Передвигаем максимумы в столбцах вниз
  MoveDown(M, rows, cols);

  {Защита - максимумы ВПРАВО-В КОНЕЦ СТРОКИ}
  // Закомментируйте MoveDown и Расскоментируйте код ниже
  // MoveRight(M, rows, cols);

  // и выводим полученную матрицу в Memo2
  PrintMatrix(M, rows, cols, Memo2);
end;

{Нажали 'Закрыть' - выход из программы}
procedure TForm1.Button4Click(Sender: TObject);
begin
  close;
end;

end.

