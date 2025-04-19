## Ejercicios SQL paso a paso (con soluciones ocultas)

> Puedes usar este MD como una guía de repaso o ejercicios interactivos para practicar SQL paso a paso. ¡Haz clic en los
> desplegables para comprobar tus respuestas!


---

### 1. Crear las tablas necesarias

Vamos a crear una base de datos para un **torneo de videojuegos** 🎮. Las entidades serán:

- `game` con columnas: `game_code`, `game_name`
- `match` con columnas: `id`, `game_code`, `room_number`, `host`
- `scoreboard` con columnas: `id`, `player_name`, `match_id`, `score`

<details>
<summary>Solución</summary>

```sql
CREATE TABLE game
(
    game_code VARCHAR(6) PRIMARY KEY NOT NULL,
    game_name VARCHAR(255)           NOT NULL
);

CREATE TABLE match
(
    id          VARCHAR(10) PRIMARY KEY NOT NULL,
    game_code   VARCHAR(6)              NOT NULL,
    room_number INT,
    host        VARCHAR(255)            NOT NULL,
    FOREIGN KEY (game_code) REFERENCES game (game_code)
);

CREATE TABLE scoreboard
(
    id          INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    player_name VARCHAR(255)    NOT NULL,
    match_id    VARCHAR(10),
    score       INT             NOT NULL,
    FOREIGN KEY (match_id) REFERENCES match (id)
);
```

</details>

---

### 2. Insertar datos en las tablas

Inserta los siguientes datos en las tablas `game`, `match` y `scoreboard`.

```sql
INSERT INTO game (game_code, game_name)
VALUES ('VG101', 'Super Kart'),
       ('VG202', 'Battle Royale');

INSERT INTO match (id, game_code, room_number, host)
VALUES ('VG101-A', 'VG101', 10, 'Carlos'),
       ('VG101-B', 'VG101', 11, 'Lucía'),
       ('VG202-A', 'VG202', 20, 'Andrés'),
       ('VG202-B', 'VG202', 21, 'Elena');

INSERT INTO scoreboard (player_name, match_id, score)
VALUES ('Alex', 'VG101-A', 98),
       ('Jordan', 'VG101-A', 82),
       ('Casey', 'VG101-B', 65),
       ('Alex', 'VG202-A', 89),
       ('Taylor', 'VG101-A', 99),
       ('Morgan', 'VG101-A', 87),
       ('Jordan', 'VG101-B', 46),
       ('Riley', 'VG202-A', 72);
```

---

### 3. Consultas con agregación (GROUP BY, COUNT, AVG, etc.)

- Muestra la cantidad de jugadores por partida (match).

<details>
<summary>Solución</summary>

```sql
SELECT match_id, COUNT(*) AS player_count
FROM scoreboard
GROUP BY match_id;
```

</details>

- Muestra el promedio de puntuación por jugador.

<details>
<summary>Solución</summary>

```sql
SELECT player_name, AVG(score) AS avg_score
FROM scoreboard
GROUP BY player_name;
```

</details>

- Muestra las partidas con media de puntuación mayor a 80.

<details>
<summary>Solución</summary>

```sql
SELECT match_id, AVG(score) AS avg_score
FROM scoreboard
GROUP BY match_id
HAVING AVG(score) > 80;
```

</details>

---

### 4. Consultas con operadores lógicos y patrones (LIKE, BETWEEN, AND, OR)

- Jugadores con puntuaciones entre 85 y 95:

<details>
<summary>Solución</summary>

```sql
SELECT *
FROM scoreboard
WHERE score BETWEEN 85 AND 95;
```

</details>

- Jugadores cuyo nombre contiene "y" o cuya puntuación sea mayor a 90:

<details>
<summary>Solución</summary>

```sql
SELECT *
FROM scoreboard
WHERE player_name LIKE '%y%'
   OR score > 90;
```

</details>

---

### 5. Ordenar resultados (ORDER BY)

- Muestra los jugadores ordenados por puntuación de mayor a menor:

<details>
<summary>Solución</summary>

```sql
SELECT *
FROM scoreboard
ORDER BY score DESC;
```

</details>

---

### 6. Joins (INNER JOIN, LEFT JOIN, RIGHT JOIN)

- Muestra la información combinada de `scoreboard` y `match`:

<details>
<summary>Solución</summary>

```sql
SELECT s.player_name, s.score, m.id, m.game_code, m.host
FROM scoreboard s
         INNER JOIN match m ON m.id = s.match_id;
```

</details>

- Muestra toda la información de `match` y sus coincidencias con `scoreboard` (LEFT JOIN):

<details>
<summary>Solución</summary>

```sql
SELECT *
FROM match m
         LEFT JOIN scoreboard s ON s.match_id = m.id;
```

</details>

---
