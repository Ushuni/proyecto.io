-- Crear la base de datos
CREATE DATABASE DBRedDeportivaELO;
USE DBRedDeportivaELO;


-- Tabla equipos
CREATE TABLE Tequipos (
  id_equipo INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  ciudad VARCHAR(50),
  puntos INT
);

-- Tabla jugadores
CREATE TABLE Tjugadores (
  id_jugador INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  edad INT,
  equipo_id INT,
  FOREIGN KEY (equipo_id) REFERENCES Tequipos(id_equipo)
);
-- Tabla roles
CREATE TABLE Troles (
  id_rol INT PRIMARY KEY,
  nombre VARCHAR(50)
);
-- Tabla usuarios
CREATE TABLE Tusuarios (
  id_usuario INT PRIMARY KEY AUTO_INCREMENT,
  id_rol INT,
  nombre VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL,
  tipo VARCHAR(255),
  password VARCHAR(50) NOT NULL,
  FOREIGN KEY (id_rol) REFERENCES Troles(id_rol)
);
-- Tabla periodistas
CREATE TABLE Tperiodistas (
  id_periodista INT PRIMARY KEY AUTO_INCREMENT,
  id_usuario INT,
  id_equipo INT,
  nombre VARCHAR(50) NOT NULL,
  especialidad VARCHAR(50),
  FOREIGN KEY (id_usuario) REFERENCES Tusuarios(id_usuario),
  FOREIGN KEY (id_equipo) REFERENCES Tequipos(id_equipo)
);

-- Tabla partidos
CREATE TABLE Tpartidos (
  id_partido INT PRIMARY KEY AUTO_INCREMENT,
  equipo_local_id INT,
  equipo_visitante_id INT,
  fecha DATE,
  goles_local INT,
  goles_visitante INT,
  resultado VARCHAR(10),
  fecha_partido DATE,
  FOREIGN KEY (equipo_local_id) REFERENCES Tequipos(id_equipo),
  FOREIGN KEY (equipo_visitante_id) REFERENCES Tequipos(id_equipo)
);

-- Tabla clasificadores_elo
CREATE TABLE Tclasificadores_elo (
  id_clasificador INT PRIMARY KEY AUTO_INCREMENT,
  fecha_clasificador DATE,
  puntuacion_elo FLOAT,
  equipo_id INT,
  FOREIGN KEY (equipo_id) REFERENCES Tequipos(id_equipo)
);

-- Tabla estadisticas_partidos
CREATE TABLE Testadisticas_partidos (
  id_partido INT PRIMARY KEY,
  id_equipo_local INT,
  id_equipo_visitante INT,
  goles_local INT,
  goles_visitante INT,
  resultado VARCHAR(10),
  FOREIGN KEY (id_partido) REFERENCES Tpartidos(id_partido),
  FOREIGN KEY (id_equipo_local) REFERENCES Tequipos(id_equipo),
  FOREIGN KEY (id_equipo_visitante) REFERENCES Tequipos(id_equipo)
);

-- Tabla clasificadores_elo_jugadores
CREATE TABLE Tclasificadores_elo_jugadores (
  id_clasificador INT PRIMARY KEY,
  id_jugador INT,
  fecha_clasificador DATE,
  puntuacion_elo FLOAT,
  FOREIGN KEY (id_clasificador) REFERENCES Tclasificadores_elo(id_clasificador),
  FOREIGN KEY (id_jugador) REFERENCES Tjugadores(id_jugador)
);

-- Tabla puntuaciones
CREATE TABLE Tpuntuaciones (
  id_equipo INT PRIMARY KEY,
  puntuacion_elo FLOAT,
  partidos_ganados INT,
  partidos_perdidos INT,
  partidos_empatados INT,
  FOREIGN KEY (id_equipo) REFERENCES Tequipos(id_equipo)
);
