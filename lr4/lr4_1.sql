---1. Поднимите нижнюю границу минимальной заработной платы в таблице JOB до 1000$.
UPDATE JOB
SET MINSALARY = 1000
WHERE MINSALARY < 1000;
--------
---1 row(s) updated.

SELECT MINSALARY FROM JOB;
--------
---MINSALARY
---2500
---7500
---8000
---1500
---1000
---1800
---15000

---2.Поднимите минимальную зарплату в таблице JOB на 10% для всех специальностей, кроме финансового директора.
UPDATE JOB
SET MINSALARY = MINSALARY + MINSALARY*0.1
WHERE JOBNAME != 'FINANCIAL DIRECTOR';
--------
---6 row(s) updated.

SELECT JOBNAME, MINSALARY FROM JOB;
-------
---JOBNAME	MINSALARY
---MANAGER	2750
---FINANCIAL DIRECTOR	7500
---EXECUTIVE DIRECTOR	8800
---SALESMAN	1650
---CLERK	1100
---DRIVER	1980
---PRESIDENT	16500

---3.Поднимите минимальную зарплату в таблице JOB на 10% для клерков и на 20% для финансового директора (одним оператором).
UPDATE JOB
SET MINSALARY = MINSALARY * 
CASE WHEN JOBNAME='CLERK' THEN 1.1
WHEN JOBNAME='FINANCIAL DIRECTOR' THEN 1.2
ELSE 1.0 END
-------
---7 row(s) updated.

SELECT JOBNAME, MINSALARY FROM JOB WHERE JOBNAME IN ('CLERK','FINANCIAL DIRECTOR')
--------
---JOBNAME	MINSALARY
---FINANCIAL DIRECTOR	9000
---CLERK	1210

---4.Установите минимальную зарплату финансового директора равной 90% от зарплаты исполнительного директора.
UPDATE JOB 
SET MINSALARY = 0.9 * (SELECT MINSALARY FROM JOB WHERE JOBNAME = 'EXECUTIVE DIRECTOR')
WHERE JOBNAME = 'FINANCIAL DIRECTOR'
-------------------
---1 row(s) updated.

SELECT JOBNAME, MINSALARY FROM JOB WHERE JOBNAME = 'FINANCIAL DIRECTOR'
---JOBNAME	MINSALARY
---FINANCIAL DIRECTOR	7920

---5. Приведите в таблице EMP имена служащих, начинающиеся на букву ‘J’, к нижнему регистру.
UPDATE EMP SET EMPNAME = LOWER(EMPNAME) WHERE EMPNAME LIKE 'J%'
------------
---3 row(s) updated.

SELECT EMPNAME FROM EMP WHERE EMPNAME LIKE 'j%'
---EMPNAME
---john klinton
---jones
---john martin

---6. Измените в таблице EMP имена служащих, состоящие из двух слов, так, чтобы оба слова в имени начинались с заглавной буквы, а продолжались прописными.
UPDATE EMP
SET EMPNAME = INITCAP(EMPNAME)
WHERE EMPNAME LIKE '%_ _%';
--------------
---4 row(s) updated.

SELECT EMPNAME FROM EMP WHERE EMPNAME LIKE '%_ _%'
---John Klinton
---Alex Boush
---John Martin
---Richard Martin

---7.Приведите в таблице EMP имена служащих к верхнему регистру.
UPDATE EMP SET EMPNAME = UPPER(EMPNAME)
--------------
--10 row(s) updated.


---8. Перенесите отдел исследований (RESEARCH) в тот же город, в котором расположен отдел продаж (SALES).
UPDATE DEPT 
SET DEPTADDR = (SELECT DEPTADDR FROM DEPT WHERE DEPTNAME = 'SALES')
WHERE DEPTNAME = 'RESEARCH'
----------------
---1 row(s) updated.

SELECT DEPTADDR FROM DEPT WHERE DEPTNAME = 'RESEARCH'
---DEPTADDR
---CHICAGO


---9. Добавьте нового сотрудника в таблицу EMP. Его имя и фамилия должны совпадать с 
---Вашими, записанными латинскими буквами согласно паспорту, дата рождения также
---совпадает с Вашей.
INSERT INTO EMP VALUES(
(SELECT MAX(EMPNO) FROM EMP) + 1, 'VERONIKA DAINEKO', to_date('07.06.2001', 'dd.mm.yyyy'),NULL);
----------------
---1 row(s) inserted.

---10.Определите нового сотрудника (см. предыдущее задание) на работу в бухгалтерию
---(отдел ACCOUNTING) начиная с текущей даты.
INSERT INTO CAREER VALUES (1004, (SELECT EMPNO FROM EMP WHERE EMPNAME = 'VERONIKA DAINEKO'), 10, SYSDATE , NULL);
-------------
--- 1 row(s) inserted.


---11. Удалите все записи из таблицы TMP_EMP. Добавьте в нее информацию о
---сотрудниках, которые работают клерками в настоящий момент. 
DELETE FROM TMP_EMP;
CREATE TABLE TMP_EMP AS
SELECT * FROM EMP 
WHERE EMPNO IN (SELECT EMPNO FROM CAREER 
                NATURAL JOIN JOB
                WHERE JOBNAME = 'CLERK' AND ENDDATE IS NULL);
----------
---Table created.

SELECT * FROM TMP_EMP
---EMPNO	EMPNAME	BIRTHDATE	MANAGER_ID
---7369	SMITH	12/17/1948	7789
---791	VERONIKA DAINEKO	06/07/2001	-


---12.Добавьте в таблицу TMP_EMP информацию о тех сотрудниках, которые уже не
---работают на предприятии, а в период работы занимали только одну должность.
INSERT INTO TMP_EMP
SELECT * FROM EMP
WHERE EMPNO IN (SELECT EMPNO FROM CAREER GROUP BY EMPNO HAVING COUNT(ENDDATE) = COUNT(STARTDATE) AND MAX(JOBNO) = MIN(JOBNO));
--------------
-----1 row(s) inserted.

---13.Выполните тот же запрос для тех сотрудников, которые никогда не приступали к
---работе на предприятии.
INSERT INTO TMP_EMP
(SELECT * FROM EMP WHERE EMPNO NOT IN (SELECT EMPNO FROM CAREER));
------------
----4 row(s) inserted.



---14.Удалите все записи из таблицы TMP_JOB и добавьте в нее информацию по тем
---специальностям, которые не используются в настоящий момент на предприятии.
CREATE TABLE TMP_JOB
AS SELECT * FROM JOB;
----Table created.
DELETE FROM TMP_JOB;
---7 row(s) deleted.
INSERT INTO TMP_JOB
SELECT * FROM JOB
WHERE JOBNO NOT IN (SELECT JOBNO FROM CAREER);
---1 row(s) inserted.

---15.Начислите зарплату в размере 120% минимального должностного оклада всем
----сотрудникам, работающим на предприятии. Зарплату начислять по должности,
----занимаемой сотрудником в настоящий момент и отнести ее на прошлый месяц
----относительно текущей даты.
INSERT INTO SALARY
(SELECT CAREER.EMPNO, 
        EXTRACT(MONTH FROM ADD_MONTHS(sysdate, -1)),
        EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE,-1)), 
        (MINSALARY * 1.2)::INTEGER FROM CAREER JOIN JOB USING(JOBNO)
WHERE ENDDATE IS NULL);


---16.Удалите данные о зарплате за прошлый год.
DELETE FROM SALARY
WHERE YEAR = EXTRACT(YEAR FROM SYSDATE) - 1;
------------
---0 row(s) deleted.


---17.Удалите информацию о карьере сотрудников, которые в настоящий момент уже не
----работают на предприятии, но когда-то работали.
DELETE FROM CAREER
WHERE ENDDATE IS NOT NULL;
--------------
---4 row(s) deleted.


---18.Удалите информацию о начисленной зарплате сотрудников, которые в настоящий
----момент уже не работают на предприятии (можно использовать результаты работы
----предыдущего запроса)
DELETE FROM SALARY
WHERE EMPNO IN (SELECT EMPNO FROM CAREER WHERE ENDDATE IS NOT NULL);
------------------
---0 row(s) deleted.



---19.Удалите записи из таблицы EMP для тех сотрудников, которые никогда не
------приступали к работе на предприятии.
DELETE FROM EMP
WHERE EMPNO NOT IN (SELECT EMPNO FROM CAREER);
-----------------
---5 row(s) deleted.