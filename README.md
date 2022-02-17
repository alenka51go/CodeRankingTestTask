# CodeRankingTestTask
Тестовое задание для проекта "Ранжирование фрагментов кода"

**Задание 1.**
Определить сколько раз в двоичном коде `/bin/grep` встречается вызов функции `malloc`.

Решение: для дизассемблирования исполняемого файла подходит утилита `objdump` с ключем `-d`.
Для определения количества раз вызова функции `malloc` в двоичном коде `/bin/grep`: 

`objdump -D /bin/grep | grep malloc`

Пример вывода представлен в файле `grepMalloc`.
Заметим, что каждый вызов функции - инструкция `call`, первая строка в примере - непосредственное объявление функции `malloc`, вторая - комменатарий.

С поомщью утилиты `wc` с ключом `-l` можем узнать, что количество вызово функции `malloc` - 19.

**Задание 2.**
