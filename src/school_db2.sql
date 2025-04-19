USE school_db;

DROP TABLE IF EXISTS section;
DROP TABLE IF EXISTS grade;
DROP TABLE IF EXISTS course;

CREATE TABLE course
(
    course_code VARCHAR(6) PRIMARY KEY NOT NULL,
    course_name VARCHAR(255)           NOT NULL
    #,PRIMARY KEY (course_code) --> también lo podemos hacer así
);

CREATE TABLE section
(
    id          VARCHAR(10) PRIMARY KEY NOT NULL,
    course_code VARCHAR(6)              NOT NULL, #FK
    room_num    INT,
    instructor  VARCHAR(255)            NOT NULL,
    FOREIGN KEY (course_code) REFERENCES course (course_code)
);

CREATE TABLE grade
(
    id           INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    student_name VARCHAR(255)    NOT NULL,
    section_id   VARCHAR(10)     NOT NULL, #FK
    score        INT             NOT NULL,
    FOREIGN KEY (section_id) REFERENCES section (id)
);

-- Insertar datos en course y section
INSERT INTO course (course_code, course_name)
VALUES ('CS101', 'Intro to Java'),
       ('CS103', 'Databases');

INSERT INTO section (id, course_code, room_num, instructor)
VALUES ('CS101-A', 'CS101', 1802, 'Balderez'),
       ('CS101-B', 'CS101', 1650, 'Su'),
       ('CS103-A', 'CS103', 1200, 'Rojas'),
       ('CS103-B', 'CS103', 1208, 'Tonno');

INSERT INTO grade (student_name, section_id, score)
VALUES ('Maya Charlotte', 'CS101-A', 98),
       ('James Fields', 'CS101-A', 82),
       ('Michael Alcocer', 'CS101-B', 65),
       ('Maya Charlotte', 'CS103-A', 89),
       ('Tomas Lacroix', 'CS101-A', 99),
       ('Sara Bisat', 'CS101-A', 87),
       ('James Fields', 'CS101-B', 46),
       ('Helena Sepulvida', 'CS103-A', 72);


## AGREGACIÓN

SELECT student_name
FROM grade
GROUP BY student_name;

SELECT COUNT(*) AS counter
FROM grade;
## contamos el número de filas o "entradas" en mi tabla grade

-- Counter de estudiantes por curso
SELECT section_id, COUNT(*) AS student_counter
FROM grade
GROUP BY section_id;

-- Counter de cursos por estudiante
SELECT student_name, COUNT(*) AS section_counter
FROM grade
GROUP BY student_name;

-- La media de todas las notas
SELECT AVG(score) AS average_score
FROM grade;

-- La media de nota por sección
SELECT section_id, AVG(score) AS average_score
FROM grade
GROUP BY section_id;

-- La media de nota por estudiante
SELECT student_name, AVG(score) AS average_score
FROM grade
GROUP BY student_name;

-- La media de nota por sección, mayor que 80
SELECT section_id, AVG(score) AS average_score
FROM grade
GROUP BY section_id
HAVING AVG(score) > 80;
## <--- HAVING para condiciones con agregación

-- La media de nota para la sección CS101-A
SELECT section_id, AVG(score) AS average_score
FROM grade
WHERE section_id = 'CS101-A'
GROUP BY section_id;

-- Esto no es agregación, es un ejemplo de traerme toda la info de grade cuya nota sea mayor a 75
SELECT *
FROM grade
WHERE score > 75;

-- No agregación, las 3 primeras "entradas" de grade cuya nota es mayor a 50
SELECT *
FROM grade
WHERE score > 50
LIMIT 3;

-- La suma total de notas, el contador de veces que aparece en grade y la media de notas de CS101-B
SELECT section_id, SUM(score) AS score_sum, COUNT(*) AS counter, AVG(score) AS avg_score
FROM grade
WHERE section_id = 'CS101-B'
GROUP BY section_id;

## COUNT(*) --> cuenta todas las filas (rows) "entradas" tengan o no valor nulo en una columna
## COUNT(column_name) --> cuenta solo las filas de dicha columna que NO SEAN NULAS

-- La nota máxima de Maya por sección (solo interesante si tengo más que una nota por estudiante por sección)
SELECT student_name, section_id, MAX(score) AS max_score
FROM grade
WHERE student_name = 'Maya Charlotte'
GROUP BY student_name, section_id;

-- La nota máxima de Maya
SELECT student_name, MAX(score) AS max_score
FROM grade
WHERE student_name = 'Maya Charlotte'
GROUP BY student_name;

-- La nota máxima por sección
SELECT section_id, MAX(score) AS max_score
FROM grade
GROUP BY section_id;


-- La nota mínima por sección
SELECT section_id, MIN(score) AS min_score
FROM grade
GROUP BY section_id;

-- La nota mínima de Maya
SELECT student_name, MIN(score) AS min_score
FROM grade
WHERE student_name = 'Maya Charlotte'
GROUP BY student_name;


## OPERADORES LÓGICOS
## Like --> comparar igualdad parcial

-- Toda la info (las columnas) de grade con section_id que empiece por CS101
SELECT *
FROM grade
WHERE section_id LIKE 'CS101%';
## <- Estoy diciendo que busque section_id que empiece por CS101 y luego lo que sea

-- Toda la info (las columnas) de grade con section_id que empiece por lo que sea, contenga '-' y luego lo que sea
SELECT *
FROM grade
WHERE section_id LIKE '%-%';

-- Toda la info (las columnas) de grade con section_id que empiece por lo que sea y termine por 'B'
SELECT *
FROM grade
WHERE section_id LIKE '%B';

-- Las notas entre unos valores utilizando AND
SELECT *
FROM grade
WHERE score > 85
  AND score < 95;

-- Las notas entre unos valores utilizando BETWEEN
SELECT *
FROM grade
WHERE score BETWEEN 85 AND 95;

-- Las notas mayores a 90 o que el student name contenga 'h'
SELECT *
FROM grade
WHERE score > 90
   OR student_name LIKE '%h%';


## Ordenar y filtrar

-- Traer la info de grade ordenada por score (por defecto es ASCENDENTE - ASC)
SELECT *
FROM grade
ORDER BY score;

-- Traer la info de grade ordenada por score de mayor a menor (DESC)
SELECT *
FROM grade
ORDER BY score DESC;

-- Ordenando por student name (por defecto alfabéticamente)
SELECT *
FROM grade
ORDER BY student_name ASC;

-- Ordenando por student name de Z-A
SELECT *
FROM grade
ORDER BY student_name DESC;

-- Traer los nombres sin nombres de estudiante duplicados
SELECT DISTINCT student_name
FROM grade;
SELECT student_name
FROM grade;

-- Trae la combinación de nombre y nota sin duplicados
SELECT DISTINCT student_name, score
FROM grade;
SELECT student_name, score
FROM grade;



## WHERE -- filtra filas (WHERE score > 10) nunca agregaciones
## HAVING -- filtra AGREGACIONES (HAVING COUNT(*) < 10))

/*El orden de escritura entonces será:
SELECT ...
FROM ... se elige la tabla
WHERE ... se filtran filas individuales
GROUP BY ... se agrupan filas
HAVING ... se filtran grupos o agrupaciones
ORDER BY ... se ordenan los resultados
*/


## UNIONES - JOINS --> para tener la info de las tablas que una

-- INNER JOIN -> devuelve las filas que coincidan en ambas tablas
## SELECT la_columa/s que quiera FROM tabla1 INNER JOIN tabla2 ON tabla2.id = tabla1.tabla2_id

SELECT s.id, s.course_code, g.student_name, s.room_num, s.instructor, g.score
FROM grade g
         INNER JOIN section s ON s.id = g.section_id;


-- La info combinada de grade y section donde el profe es Balderez y la nota del alumno/a es mayor a 80
SELECT s.id, s.course_code, g.student_name, s.room_num, s.instructor, g.score
FROM grade g
         INNER JOIN section s ON s.id = g.section_id
WHERE instructor = 'Balderez'
AND score > 80;


-- LEFT JOIN -> devuelve las filas de la tabla que ponga a la izquierda del join más las coincidencias de la otra
## SELECT la_columa/s que quiera FROM tabla1 LEFT JOIN tabla2 ON tabla2.id = tabla1.tabla2_id

SELECT *
FROM section s
         LEFT JOIN grade g ON g.section_id = s.id;

-- RIGHT JOIN -> devuelve las filas de la tabla que ponga a la DERECHA del join más las coincidencias de la otra
## SELECT la_columa/s que quiera FROM tabla1 RIGHT JOIN tabla2 ON tabla2.id = tabla1.tabla2_id

## Modificamos para que un alumno pueda tener una nota sin ir a una clase solo para ver cómo funcionan los joins
ALTER TABLE grade MODIFY COLUMN section_id VARCHAR(10) NULL;

ALTER TABLE grade ADD COLUMN ejemplo INT; ## <-- Para añadir una columna una vez creada una tabla
ALTER TABLE grade DROP COLUMN ejemplo; ## borrar una columna de una tabla

-- Para probar bien el right join y tener estudiantes que no tengan section_id
INSERT INTO grade (student_name, score) VALUE ('Jaime Pérez', 87);

SELECT *
FROM section s
         RIGHT JOIN grade g ON g.section_id = s.id;

-- Tráeme TODA la info de grade y sus coincidencias con section, donde el instructor sea null
SELECT *
FROM section s
         RIGHT JOIN grade g ON g.section_id = s.id
WHERE s.instructor IS NULL;
