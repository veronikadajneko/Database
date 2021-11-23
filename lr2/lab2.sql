CREATE TABLE Студент(
 ID      NUMBER(5),
 Имя    VARCHAR2(15),
 Фамилия VARCHAR2(15),
 Учет_успеваемости_ID NUMBER(5),
 Группа_ID NUMBER(5)
);

ALTER TABLE Студент
ADD CONSTRAINT студент_pk PRIMARY KEY (ID);

CREATE INDEX student_names ON Студент (Имя);

CREATE TABLE  Группа (
 ID      NUMBER(5) PRIMARY KEY,
 Номер      NUMBER(6),
 Учебный_план_ID_1  NUMBER(5)
);

ALTER TABLE Группа
ADD CONSTRAINT Number_format CHECK(Номер BETWEEN 100000 AND 999999);

ALTER TABLE Студент
ADD FOREIGN KEY (Группа_ID) REFERENCES Группа(ID);

CREATE TABLE  Учет_успеваемости (
ID      NUMBER(5) PRIMARY KEY,
Оценки      VARCHAR2(15)
);

ALTER TABLE Учет_успеваемости
ADD CONSTRAINT Grade_Size CHECK(ОЦЕНКИ BETWEEN 0 AND 10);


ALTER TABLE Студент
ADD FOREIGN KEY (Учет_успеваемости_ID) REFERENCES Учет_успеваемости(ID);

CREATE TABLE  Учебный_план (
 ID_1      NUMBER(5) PRIMARY KEY,
 Группа_ID  NUMBER(5)
);

ALTER TABLE Группа
ADD FOREIGN KEY (Учебный_план_ID_1) REFERENCES Учебный_план(ID_1);

ALTER TABLE Учебный_план
ADD FOREIGN KEY (Группа_ID) REFERENCES Группа(ID);

CREATE TABLE  Дисциплина (
 ID_d      NUMBER(5) PRIMARY KEY,
 Название VARCHAR2(15) NOT NULL,
 Преподаватель VARCHAR2(15) NOT NULL,
 Количество_занятий      NUMBER(5),
 Учебный_план_ID_1  NUMBER(5)
);

ALTER TABLE Дисциплина
ADD FOREIGN KEY (Учебный_план_ID_1) REFERENCES Учебный_план(ID_1);

CREATE TABLE  Relation_8 (
 Студент_ID      NUMBER(5),
 Дисциплина_ID_d  NUMBER(5)
);

ALTER TABLE Relation_8
ADD FOREIGN KEY (Студент_ID) REFERENCES Студент(ID);

ALTER TABLE Relation_8
ADD FOREIGN KEY (Дисциплина_ID_d) REFERENCES Дисциплина(ID_d);


CREATE TABLE  Вид_контроля (
 ID      NUMBER(5) PRIMARY KEY,
 Дата_сдачи      DATE,
 Дисциплина_ID_d  NUMBER(5)
);

CREATE TABLE зачет (
   id INTEGER NOT NULL,
   оценка_зачет VARCHAR(15)
);

ALTER TABLE зачет ADD CONSTRAINT зачет_pk PRIMARY KEY ( id );

ALTER TABLE зачет ADD CONSTRAINT grade_зачет CHECK(оценка_зачет in  ('Зачтено', 'Не зачтено', 'Не явился'));

ALTER TABLE зачет
   ADD CONSTRAINT зачет_вид_контроля_fk FOREIGN KEY ( id )
       REFERENCES Вид_контроля ( id );

CREATE TABLE экзамен (
   id INTEGER NOT NULL
);

ALTER TABLE экзамен ADD CONSTRAINT экзамен_pk PRIMARY KEY ( id );

ALTER TABLE экзамен
   ADD CONSTRAINT экзамен_вид_контроля_fk FOREIGN KEY ( id )
       REFERENCES Вид_контроля ( id );

ALTER TABLE Вид_контроля
ADD CONSTRAINT Date_check CHECK(Дата_сдачи BETWEEN to_date('2021-09-01','yyyy-mm-dd') AND to_date('2021-05-31','yyyy-mm-dd'));

ALTER TABLE Вид_контроля
ADD FOREIGN KEY (Дисциплина_ID_d) REFERENCES Дисциплина(ID_d);


CREATE TABLE  Relation_10 (
 Учет_успеваемости_ID      NUMBER(5),
 Вид_контроля_ID  NUMBER(5)
);

ALTER TABLE Relation_10
ADD FOREIGN KEY (Учет_успеваемости_ID) REFERENCES Учет_успеваемости(ID);

ALTER TABLE Relation_10
ADD FOREIGN KEY (Вид_контроля_ID) REFERENCES Вид_контроля(ID);

create sequence mySequence1 increment by 10 start with 100;

DROP TABLE Студент;
DROP TABLE Relation_10;
DROP TABLE Relation_8;
DROP TABLE Вид_контроля;
DROP TABLE Дисциплина;
DROP TABLE Учебный_план;
DROP TABLE Группа;
DROP TABLE Учет_успеваемости;
