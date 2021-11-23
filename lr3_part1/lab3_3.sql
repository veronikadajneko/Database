---3_3
---1.  Рефлексивное соединение. Представление отношений родитель-потомок 
--- Требуется представить имя каждого сотрудника таблицы EMP а также имя его руководителя:

SELECT EMPLOYEER.EMPNAME||' worcs for '||MANAGER.EMPNAME as MANAGER_NAME 
FROM EMP EMPLOYEER JOIN EMP MANAGER 
ON EMPLOYEER.MANAGER_ID = MANAGER.EMPNO

-- ALLEN worcs for JOHN KLINTON
-- WARD worcs for JOHN KLINTON
-- JONES worcs for JOHN KLINTON
-- ALEX BOUSH worcs for JOHN KLINTON
-- SMITH worcs for ALEX BOUSH
-- JOHN MARTIN worcs for ALEX BOUSH
-- RICHARD MARTIN worcs for ALEX BOUSH
-- CLARK worcs for ALLEN
-- SCOTT worcs for ALLEN

---2. Иерархический запрос. Требуется представить имя каждого сотрудника таблицы EMP (даже сотрудника, которому не назначен руководитель) и имя его руководителя
SELECT (EMPNAME || ' reports to ' || PRIOR EMPNAME) AS EMP_MANAGER
FROM EMP
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPNO = MANAGER_ID

---3. Представление отношений потомок-родитель-прародитель. Требуется показать иерархию от CLARK до JOHN KLINTON
SELECT LTRIM(SYS_CONNECT_BY_PATH(EMPNAME, ' -> '), ' -> ') AS EMP_TREE
FROM EMP
WHERE EMPNAME = 'JOHN KLINTON'
START WITH EMPNAME = 'CLARK'
CONNECT BY EMPNO = PRIOR MANAGER_ID

---4. Требуется получить результирующее множество, описывающее иерархию всей таблицы:
SELECT (LTRIM(SYS_CONNECT_BY_PATH(EMPNAME, ' -> '), ' -> ')) AS TREE
FROM EMP
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPNO = MANAGER_ID

---5. Требуется показать уровень иерархии каждого сотрудника
SELECT rpad('*', LEVEL, '*') || EMPNAME AS TREE
FROM EMP
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPNO = MANAGER_ID
ORDER BY LEVEL

---6. Требуется найти всех служащих, которые явно или  неявно подчиняются ALLEN
SELECT EMPNAME
FROM EMP
START WITH EMPNAME = 'ALLEN'
CONNECT BY PRIOR EMPNO = MANAGER_ID