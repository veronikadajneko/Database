INSERT INTO Учет_успеваемости VALUES
	(78, '8');
INSERT INTO Учет_успеваемости VALUES 
        (79, '9');
INSERT INTO Учет_успеваемости VALUES 
        (80, '9');
INSERT INTO Учет_успеваемости VALUES 
        (81, '10');
INSERT INTO Учет_успеваемости VALUES 
        (82, '9');
	
COMMIT;

INSERT INTO Группа VALUES
	(11, 100000);
INSERT INTO Группа VALUES 
        (22, 100001);
	
COMMIT;

INSERT INTO Студент VALUES
	(1, 'VERONIKA',   'DAINEKO', 78,   11);
INSERT INTO Студент VALUES 
        (2, 'KATE',     'IVANOVA', 79,  11);
INSERT INTO Студент VALUES
	(3, 'ARTEM',        'PUSHKIN', 80,  11);
INSERT INTO Студент VALUES
	(4, 'MASHA',   'PIROGOVA', 81,     22);
INSERT INTO Студент VALUES
	(5, 'MAKSIM',   'PODREZ', 82,     22);
	
COMMIT;

INSERT INTO Учебный_план VALUES
	(45,11);
    INSERT INTO Учебный_план VALUES
	(46,11);
INSERT INTO Учебный_план VALUES
	(47,11);
INSERT INTO Учебный_план VALUES
	(48,22);
	
COMMIT;

INSERT INTO Дисциплина VALUES
	(100, 'MATH',   'F', 5,   45);
INSERT INTO Дисциплина VALUES 
        (200, 'PHISICS',     'B', 10,  48);
INSERT INTO Дисциплина VALUES
	(300, 'BIOLOGY',        'D', 7,  47);
INSERT INTO Дисциплина VALUES
	(400, 'GEOGRAPHY',   'J', 3,     46);
INSERT INTO Дисциплина VALUES
	(500, 'MATH2',   'P', 90,     45);
	
COMMIT;

INSERT INTO Relation_8 VALUES
	(1,100);
    INSERT INTO Relation_8 VALUES
	(2,200);
INSERT INTO Relation_8 VALUES
	(3,300);
INSERT INTO Relation_8 VALUES
	(4,400);
INSERT INTO Relation_8 VALUES
	(5,500);

COMMIT;

INSERT INTO Студент VALUES
	(1, 'VERONIKA',   'DAINEKO', 78,   11);
