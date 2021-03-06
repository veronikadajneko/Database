
-- пример 3.5.1.
-- запрос для демонстраации рекурсивной связи
-- в запросе отображаются сведения о студентах
-- находящихся в одной группе
SELECT DISTINCT s1.Имя || ' starosta ' || s2.Имя
    FROM Студент s1 INNER JOIN Студент s2
        ON s1.ID = s2.starosta;


-- пример 3.5.2.
-- пример использования конструкции CASE, формат - simple CASE
-- В этом запросе определяется название предмета
-- по имени преподавателя
SELECT ID_d, Преподаватель, Количество_занятий, 
	   CASE Преподаватель
		  WHEN 'F' THEN 'MATH'
		  WHEN 'B' THEN 'PHISICS'
		  WHEN 'D' THEN 'BIOLOGY'
          WHEN 'J' THEN 'GEOGRAPHY'
	   ELSE 'MATH2'
	   END AS ПРЕДМЕТ
	   FROM Дисциплина;
---ID_D	ПРЕПОДАВАТЕЛЬ	КОЛИЧЕСТВО_ЗАНЯТИЙ	ПРЕДМЕТ
---100	F	5	MATH
---200	B	10	PHISICS
---300	D	7	BIOLOGY
---400	J	3	GEOGRAPHY
---500	P	90	MATH2

-- пример 3.5.3.
-- пример использования конструкции CASE, формат - searched CASE
-- В этом запросе определяется хорошая или плохая оценка
SELECT Учет_успеваемости.ОЦЕНКИ, Студент.Имя,
	   CASE
		  WHEN ОЦЕНКИ < 9 THEN 'Плохая оценка'
		  WHEN ОЦЕНКИ BETWEEN 9 AND 10 THEN 'Хорошая оценка'
	   END AS Оценка
	   FROM Учет_успеваемости INNER JOIN Студент ON (Учет_успеваемости.ID = Студент.Учет_успеваемости_ID);
---ОЦЕНКИ	ИМЯ	ОЦЕНКА
---8	VERONIKA	Плохая оценка
---9	KATE	Хорошая оценка
---9	ARTEM	Хорошая оценка
---10	MASHA	Хорошая оценка
---9	MAKSIM	Хорошая оценка

-- опорный запрос: 
-- пример 3.5.4.
-- пример запроса с использованием конструкции WITH.
-- выводится список поставщиков, у которых наибольшее количество поставок

-- опорный запрос: 
WITH CNT_GOODS AS (
  SELECT COUNT(*) AS QD, Группа_ID FROM Студент
  GROUP BY Группа_ID
)
-- рекурсивный запрос - использует результат опорного запроса в качестве источника данных
SELECT Студент.Имя, Группа_ID
  FROM Студент JOIN CNT_GOODS C USING (Группа_ID)
  WHERE C.QD = (SELECT MIN(QD) FROM CNT_GOODS);

---ИМЯ	ГРУППА_ID
---MASHA	22
---MAKSIM	22


-- пример 3.5.5.
-- пример запроса с использованием встроенного представления.
-- выводится список поставщиков, у которых количество поставок превышает 3
SELECT Студент.Имя, C.QD
  FROM Студент JOIN ( SELECT COUNT(*) AS QD, Группа_ID FROM Студент
  GROUP BY Группа_ID) C USING (Группа_ID)
  WHERE C.QD != 1;
---ИМЯ	QD
---VERONIKA	3
---KATE	3
---ARTEM	3
---MASHA	2

-- пример 3.5.6.
-- пример использования некоррелированного подзапроса
SELECT Имя, Учет_успеваемости_ID
FROM Студент WHERE Учет_успеваемости_ID IN (SELECT ID FROM Учет_успеваемости WHERE Оценки IN ('8','10'))
ИМЯ	УЧЕТ_УСПЕВАЕМОСТИ_ID
--VERONIKA	78
---MASHA	81

-- пример 3.5.7.
-- пример использования коррелированного подзапроса
SELECT Студент.Имя, Студент.Учет_успеваемости_ID, Учет_успеваемости.Оценки
FROM Студент JOIN Учет_успеваемости ON (Учет_успеваемости.ID = Студент.Учет_успеваемости_ID)
WHERE Студент.Учет_успеваемости_ID > (SELECT AVG(ID) FROM Учет_успеваемости)

-- пример 3.5.8.
-- пример запроса с использованием функции NULLIF
SELECT Студент.Имя, NULLIF(Группа_ID, 22) FROM Студент;
---VERONIKA	11
---KATE	11
---ARTEM	11
---MASHA	-
---MAKSIM	-

SELECT NVL2(Имя, 'Имя', 'n/a')
from Студент;

INSERT INTO Студент VALUES
	(8, '','ээ', 78, 11);

---NVL2(ИМЯ,'ИМЯ','N/A')
---n/a
---Имя
---Имя
---Имя
---Имя
---Имя

SELECT ID
  FROM (
        SELECT * FROM Учет_успеваемости
          ORDER BY ID DESC
        )
WHERE ROWNUM <= 3;
---ID
---82
---81
---80


SELECT Группа_ID, COUNT(*) FROM Учебный_план GROUP BY ROLLUP(Группа_ID)
---ГРУППА_ID	COUNT(*)
---11	3
---22	1
--- -	4

-- пример 3.5.12.
-- пример использовния оператора MERGE
-- в архивную таблицу добавляются сведения о выполненных и отмененных заказах

-- создание архивной таблицы
CREATE TABLE ARC_STUDENT
(
  ID NUMBER(4),
  NAME VARCHAR2(100),
  SURNAME VARCHAR2(100),
  ID_1 NUMBER(4),
  GROUP_ID NUMBER(4)
);

-- перенос данных в архивную таблицу с помощью оператора MERGE
MERGE INTO ARC_STUDENT A
USING (
SELECT S.ID,
       S.Имя,
       S.Фамилия,
       S.Учет_успеваемости_ID,
       S.Группа_ID
    FROM Студент S
    WHERE S.Учет_успеваемости_ID IN (80,82)
) Z
ON (A.ID = Z.ID)
WHEN MATCHED THEN
-- существующие данны заменяются
  UPDATE SET A.NAME = Z.Имя, A.SURNAME = Z.Фамилия, A.ID_1 = Z.Учет_успеваемости_ID, A.GROUP_ID = Z.Группа_ID
-- новые данные добавляются в архив
WHEN NOT MATCHED THEN
  INSERT (A.ID,A.NAME, A.SURNAME, A.ID_1, A.GROUP_ID)
  VALUES (Z.ID, Z.Имя, Z.Фамилия, Z.Учет_успеваемости_ID, Z.Группа_ID);
---  2 row(s) updated.

---0.09 seconds