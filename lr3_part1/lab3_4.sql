---Задача 1
------Требуется используя значения столбца START_DATE получить дату за десять дней до и после приема на работу, 
---пол года до и после приема на работу, 
---год до и после приема на работу сотрудника JOHN KLINTON.
---Рекомендации
------Для вычисления дней используйте стандартное сложение и вычитание, а для операций над месяцами и годами функцию ADD_MONTHS.

SELECT STARTDATE, ENDDATE,(STARTDATE - 10) AS BEFORE_10_DAYS, (ENDDATE + 10) AS AFTER_10_DAYS,
ADD_MONTHS(STARTDATE, -6) AS BEFORE_6_MONTHS, 
ADD_MONTHS(ENDDATE, 6) AS AFTER_6_MONTHS, 
ADD_MONTHS(STARTDATE, -12) AS BEFORE_12_MONTHS, 
ADD_MONTHS(ENDDATE, 12) AS AFTER_12_MONTHS
FROM CAREER WHERE EMPNO = (SELECT EMPNO FROM EMP WHERE EMPNAME = 'JOHN KLINTON')
-----------------
---STARTDATE	ENDDATE	BEFORE_10_DAYS	AFTER_10_DAYS	BEFORE_6_MONTHS	AFTER_6_MONTHS	BEFORE_12_MONTHS	AFTER_12_MONTHS
---10/01/2001	-	09/21/2001	-	04/01/2001	-	10/01/2000	-

---Задача 2 
------Требуется найти разность между двумя датами и представить результат в днях. 
------Вычислите разницу в днях между датами приема на работу сотрудников JOHN MARTIN и ALEX BOUSH.
---Рекомендации
------Используйте два вложенных запроса, чтобы найти значения START_DATE для JOHN MARTIN и ALEX BOUSH, затем вычтите одну дату из другой.
SELECT 
((SELECT STARTDATE 
         FROM CAREER 
         WHERE EMPNO = (SELECT EMPNO FROM EMP WHERE EMPNAME = 'ALEX BOUSH')) - 
(SELECT STARTDATE 
        FROM CAREER 
        WHERE EMPNO = (SELECT EMPNO FROM EMP WHERE EMPNAME = 'JOHN MARTIN'))) AS DAYS
FROM DUAL
-----------------
---DAYS
-----530

---Задача 3
------Требуется найти разность между двумя датами в месяцах и в годах.
---Рекомендации
------Чтобы найти разницу между двумя датами в месяцах используйте функцию MONTHS_BETWEEN.
SELECT 
MONTHS_BETWEEN(SYSDATE, TO_DATE('9-07-1980', 'MM-DD-YYYY')) AS MONTHS_BETWEEN, 
(MONTHS_BETWEEN(SYSDATE, TO_DATE('9-07-1980', 'MM-DD-YYYY')) / 12) AS YEARS_BETWEEN 
FROM DUAL
-----------
---MONTHS_BETWEEN	YEARS_BETWEEN
-----494	       41.1666666666666666666666666666666666667

---Задача 4
------Требуется определить интервал времени в днях между двумя датами. 
------Для каждого сотрудника 20-го отдела найти сколько дней прошло между датой его приема на работу и датой приема на работу следующего сотрудника.
---Рекомендации
------Используйте оконную функцию LEAD OVER.
SELECT STARTDATE, 
      ((LEAD(STARTDATE, 1) OVER (ORDER BY STARTDATE)) - STARTDATE) AS DAYS_BETWEEN 
FROM CAREER 
WHERE DEPTNO = '20'
---------------
---STARTDATE	DAYS_BETWEEN
----07/21/1999	2131
----05/21/2005	-

---Задача 5
-----Требуется подсчитать количество дней в году по столбцу START_DATE.
---Рекомендации
-----Используйте функцию TRUNC для нахождения начала года, а ADD_MONTHS – для нахождения начала следующего года.
SELECT EXTRACT(YEAR FROM STARTDATE) AS YEAR, 
       (ADD_MONTHS(TRUNC(STARTDATE, 'y'), 12) - TRUNC(STARTDATE, 'y')) AS DAYS
FROM CAREER
------------------
---YEAR	DAYS
---1999	365
---2010	365
---2005	365
---2003	365
---1999	365
---2006	365
---2006	365
---2000	366
---2008	366
---2001	365

---Задача 6
-------Требуется разложить текущую дату на день, месяц, год, секунды, минуты, часы. Результаты вернуть в численном виде.
---Рекомендации
-------Используйте функции TO_CHAR и TO_NUMBER; форматы ‘hh24’, ‘mi’, ‘ss’, ‘dd’, ‘mm’, ‘yyyy’ для секунд, минут, часов, дней, месяцев, лет соответственно.
SELECT TO_CHAR(SYSDATE, 'DD.MM.YYYY HH24:MI:SS') AS DATE_CHAR, 
       TO_NUMBER(TO_CHAR(SYSDATE, 'DDMMYYYYHH24MISS')) AS DATE_NUMBER 
FROM DUAL
-------------
---07.11.2021 13:37:57

---Задача 7
------Требуется получить первый и последний дни текущего месяца.
---Рекомендации
------Используйте функцию LAST_DAY.

SELECT TRUNC(LAST_DAY(SYSDATE) - 1, 'mm') AS FIRST_DAY,
       SYSDATE,
       LAST_DAY(SYSDATE) AS LAST_DAY
FROM DUAL
----------
---FIRST_DAY	SYSDATE	LAST_DAY
---11/01/2021	11/07/2021	11/30/2021

---Задача 8 
------Требуется возвратить даты начала и конца каждого из четырех кварталов данного года.
---Рекомендации
------С помощью функции ADD_MONTHS найдите начальную и конечную даты каждого квартала. 
------Для представления квартала, которому соответствует та или иная начальная и конечная даты, используйте псевдостолбец ROWNUM. 
SELECT LEVEL AS QUARTER,
       ADD_MONTHS(trunc(sysdate, 'YEAR'), (LEVEL - 1) * 3) AS QUARTER_START,
       ADD_MONTHS(trunc(sysdate, 'YEAR'), LEVEL * 3) - 1 AS QUARTER_END
FROM DUAL 
CONNECT BY LEVEL <= 4
----------------
---QUARTER	QUARTER_START	QUARTER_END
---1	01/01/2021	03/31/2021
---2	04/01/2021	06/30/2021
---3	07/01/2021	09/30/2021
---4	10/01/2021	12/31/2021

---Задача 9
-------Требуется найти все даты года, соответствующие заданному дню недели. Сформируйте список понедельников текущего года.
SELECT * 
FROM (SELECT (trunc(sysdate, 'YEAR') + LEVEL - 1)  AS DAY 
             FROM DUAL
             CONNECT BY LEVEL <= 366)
WHERE TO_CHAR(DAY, 'fmday') = 'monday'
---------------------
-----DAY
----01/04/2021
----01/11/2021
----01/18/2021
----01/25/2021
----02/01/2021
----02/08/2021
----02/15/2021
----02/22/2021
----03/01/2021
----03/08/2021

---Задача 10
------Требуется создать календарь на текущий месяц. Календарь должен иметь семь столбцов в ширину и пять строк вниз.
---Рекомендации
------Чтобы возвратить все дни текущего месяца используйте рекурсивный оператор CONNECT_BY. 
------Затем разбейте месяц на недели по выбранному дню с помощью выражений CASE и функций MAX.
WITH X AS (SELECT * FROM (SELECT TRUNC(SYSDATE, 'MM') + LEVEL - 1 MONTH_DATE,
                                 TO_CHAR(TRUNC(SYSDATE, 'MM') + LEVEL - 1, 'IW') WEEK_NUMBER,
                                 TO_CHAR(TRUNC(SYSDATE, 'MM') + LEVEL - 1, 'DD') DAY_NUMBER,
                                 TO_NUMBER(TO_CHAR(TRUNC(SYSDATE, 'MM')+ LEVEL - 1, 'D')) WEEK_DAY,
                                 TO_CHAR(TRUNC(SYSDATE, 'MM') + LEVEL - 1, 'MM') CURR_MONTH,
                                 TO_CHAR(SYSDATE, 'MM') MONTH
                          FROM DUAL
                          CONNECT BY LEVEL <=31)      
            WHERE CURR_MONTH = MONTH)

SELECT MAX(CASE WEEK_DAY WHEN 2 THEN DAY_NUMBER END) AS MONDAY,
       MAX(CASE WEEK_DAY WHEN 3 THEN DAY_NUMBER END) AS TUESDAY,
       MAX(CASE WEEK_DAY WHEN 4 THEN DAY_NUMBER END) AS WEDNESDAY,
       MAX(CASE WEEK_DAY WHEN 5 THEN DAY_NUMBER END) AS THURSDAY,
       MAX(CASE WEEK_DAY WHEN 6 THEN DAY_NUMBER END) AS FRIDAY,
       MAX(CASE WEEK_DAY WHEN 7 THEN DAY_NUMBER END) AS SATURDAY,
       MAX(CASE WEEK_DAY WHEN 1 THEN DAY_NUMBER END) AS SUNDAY
FROM X
GROUP BY WEEK_NUMBER
ORDER BY WEEK_NUMBER
---------------------
---MONDAY	TUESDAY	WEDNESDAY	THURSDAY	FRIDAY	SATURDAY	SUNDAY
---01	02	03	04	05	06	07
---08	09	10	11	12	13	14
---15	16	17	18	19	20	21
---22	23	24	25	26	27	28
---29	30	-	-	-	-	-