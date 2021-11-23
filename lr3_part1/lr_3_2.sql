---1. Найти имена сотрудников, получивших за годы начисления зарплаты минимальную зарплату.
SELECT EMPNAME FROM EMP 
WHERE EMPNO = 
    (SELECT EMPNO FROM SALARY WHERE SALVALUE = (SELECT MIN(SALVALUE)FROM SALARY))
------------
---EMPNAME
---JOHN KLINTON

---2. Найти имена сотрудников, работавших или работающих в тех же отделах, в которых работал или работает сотрудник с именем RICHARD MARTIN.
SELECT DISTINCT EMPNAME FROM EMP INNER JOIN CAREER ON (EMP.EMPNO = CAREER.EMPNO)
WHERE CAREER.DEPTNO IN (SELECT CAREER.DEPTNO FROM CAREER WHERE EMPNO  = (SELECT EMPNO FROM EMP WHERE EMPNAME = 'RICHARD MARTIN')) AND EMP.EMPNAME != 'RICHARD MARTIN'
--------
---EMPNAME
---ALLEN

---3. Найти имена сотрудников, работавших или работающих в тех же отделах и должностях, что и сотрудник 'RICHARD MARTIN'.
SELECT DISTINCT EMPNAME FROM EMP INNER JOIN CAREER ON (EMP.EMPNO = CAREER.EMPNO)
WHERE CAREER.DEPTNO IN (SELECT CAREER.DEPTNO FROM CAREER WHERE EMPNO  = (SELECT EMPNO FROM EMP WHERE EMPNAME = 'RICHARD MARTIN')) AND EMP.EMPNAME != 'RICHARD MARTIN'
AND CAREER.JOBNO IN (SELECT CAREER.JOBNO FROM CAREER WHERE EMPNO = (SELECT EMPNO FROM EMP WHERE EMPNAME = 'RICHARD MARTIN'))
---------
----no data found

---4. Найти сведения о номерах сотрудников, получивших за какой-либо месяц зарплату большую, чем средняя зарплата   за 2007 г. или большую чем средняя зарплата за 2008г.
SELECT EMPNO FROM SALARY
WHERE SALVALUE > ANY(SELECT AVG(SALVALUE) FROM SALARY WHERE YEAR IN ('2007', '2008'))

---5. Найти сведения о номерах сотрудников, получивших зарплату за какой-либо месяц большую, чем средние зарплаты за все годы начислений.
SELECT EMPNO FROM SALARY
WHERE SALVALUE > ALL(SELECT AVG(SALVALUE) FROM SALARY GROUP BY YEAR)
------
---EMPNO
---7499

---6. Определить годы, в которые начисленная средняя зарплата была больше средней зарплаты за все годы начислений.
SELECT YEAR FROM SALARY
GROUP BY YEAR
HAVING AVG(SALVALUE) > (SELECT AVG(SALVALUE) FROM SALARY)
-------
---YEAR
---2010
---2015
---2016

---7. Определить номера отделов, в которых работали или работают сотрудники, имеющие начисления зарплаты. 
SELECT DISTINCT DEPTNO FROM CAREER WHERE EMPNO = ANY(SELECT DISTINCT EMPNO FROM SALARY) AND DEPTNO IS NOT NULL
----------
--     40
--     30
--     10
--     20

---8. Определить номера отделов, в которых работали или работают сотрудники, имеющие начисления зарплаты.
SELECT DISTINCT DEPTNO FROM CAREER WHERE EXISTS(SELECT * FROM SALARY WHERE SALARY.EMPNO = CAREER.EMPNO) AND DEPTNO IS NOT NULL
----------
--     40
--     30
--     10
--     20

---9. Определить номера отделов, для сотрудников которых не начислялась зарплата.
SELECT DISTINCT DEPTNO FROM CAREER WHERE NOT EXISTS(SELECT * FROM SALARY WHERE SALARY.EMPNO = CAREER.EMPNO) AND DEPTNO IS NOT NULL
----------
--     10
--     20

---10. Вывести сведения о карьере сотрудников с указанием названий и адресов отделов вместо номеров отделов.
SELECT EMPNO, JOBNO, STARTDATE, ENDDATE, DEPT.DEPTNAME, DEPT.DEPTADDR FROM CAREER INNER JOIN DEPT ON (DEPT.DEPTNO = CAREER.DEPTNO)
---EMPNO	JOBNO	STARTDATE	ENDDATE	DEPTNAME	DEPTADDR
---7698	1004	05/21/1999	06/01/1999	ACCOUNTING	NEW YORK
---7698	1003	06/01/2010	-	ACCOUNTING	NEW YORK
---7369	1003	05/21/2005	-	RESEARCH	DALLAS
---7499	1001	01/02/2003	12/31/2005	SALES	CHICAGO
---7654	1004	07/21/1999	06/01/2004	RESEARCH	DALLAS
---7499	1002	06/01/2006	10/25/2008	SALES	CHICAGO
---7369	1004	07/01/2000	-	SALES	CHICAGO
---7499	1001	01/01/2008	-	ACCOUNTING	NEW YORK
---7789	1005	01/01/2001	-	OPERATIONS	BOSTON
---7790	1006	10/01/2001	-	OPERATIONS	BOSTON

---11. Определить целую часть средних зарплат,  по годам начисления.
SELECT YEAR, CAST(AVG(SALVALUE) AS INT) FROM SALARY
GROUP BY YEAR

-- 2009 |  650
-- 2016 | 3329
-- 2008 | 1913
-- 2015 | 3100
-- 2010 | 8083
-- 2007 | 2519

---12. Разделите сотрудников на возрастные группы: A) возраст 20-30 лет; B) 31-40 лет; C) 41-50;    D) 51-60 или возраст не определён.
SELECT EMPNO, EMPNAME,
    CASE
        WHEN (2021 - EXTRACT(YEAR FROM BIRTHDATE))  BETWEEN 20 AND 30 THEN '20 to 30'
        WHEN (2021 - EXTRACT(YEAR FROM BIRTHDATE))  < 41 THEN '31 to 40'
        WHEN (2021 - EXTRACT(YEAR FROM BIRTHDATE))  < 51 THEN '41 to 50'
        WHEN (2021 - EXTRACT(YEAR FROM BIRTHDATE))  < 61 THEN '51 to 60'
        ELSE 'not defined' 
    END  
FROM EMP
-------------
---7790	JOHN KLINTON	41 to 50
---7499	ALLEN	51 to 60
---7521	WARD	not defined
---7566	JONES	41 to 50
---7789	ALEX BOUSH	31 to 40
---7369	SMITH	not defined
---7654	JOHN MARTIN	not defined
---7698	RICHARD MARTIN	31 to 40
---7782	CLARK	not defined
---7788	SCOTT	31 to 40

---13. Перекодируйте номера отделов, добавив перед номером отдела буквы BI для номеров <=20,  буквы  LN для номеров >=30.
SELECT 
      CASE 
            WHEN DEPTNO <= 20 THEN 'BI' || DEPTNO
            WHEN DEPTNO >= 30 THEN 'LN' || DEPTNO
            ELSE TO_CHAR(DEPTNO)
      END
FROM DEPT

-- BI10
-- BI20     
-- LN30     
-- LN40 

---14. Выдать информацию о сотрудниках из таблицы EMP, заменив отсутствие данного о дате рождения  датой '01-01-1000'.
SELECT EMPNAME, COALESCE(BIRTHDATE, to_date('01-01-1000', 'dd-mm-yyyy')) FROM EMP
------
---CLARK	01/01/1000