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
  id_rol INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50)
);
select * from Troles;
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

-- INSERTANDO DATOS EN APERTURA-2020

-- INSERTANDO DATOS Troles 
insert into Troles values(1,"Periodista");
insert into Troles values(2,"Administrador");
select*from Troles;

-- INSERTANDO DATOS Tusuarios
insert into Tusuarios values(1,1,"gonzalo","nigomi@gmail.com","analista","gonza1");
insert into Tusuarios values(2,1,"marcelo","marcelo@gmail.com","periodista","marce1");
select*from Tusuarios;

-- insertando datos en los equipos
select*from Tequipos;
insert into Tequipos values(1, "Always Ready", "El Alto", 51),
						   (2, "The Strongest", "La Paz", 50),
						   (3, "Bolivar", "La Paz", 49),
						   (4, "Royal Pari", "Santa Cruz", 46),
						   (5, "Jorge Wilstermann", "Cochabamba", 42),
						   (6, "Guabira", "Santa Cruz", 42),
						   (7, "Nacional Potosi", "Potosi", 39),
						   (8, "CA Palmaflor", "Cochabamba", 38),
						   (9, "Blooming", "Santa Cruz", 38),
						   (10, "Oriente Petrolero", "Santa Cruz", 30),
						   (11, "Aurora", "El Alto", 23),
						   (12, "Real Potosi", "Potosi", 23),
						   (13, "San Jose", "Oruro", 23),
						   (14, "Real Santa Cruz", "Santa Cruz", 23);
-- insertando en Tjugadores
select * from Tjugadores;
-- always
insert into Tjugadores values(1,"Carlos Emilio Lampe Porras",32,1),
(2,"CPedro Domingo Galindo Suheito",24,1),
(3,"Edemir Rodruiguez Mercado",32,1),
(4,"Nelson Cabrera",37,1),
(5,"Marcos Barrera",36,1),
(6,"Anderson Reyes",25,1),
(7,"Marc Enoumba",27,1),
(8,"Juan Orellana",22,1),
(9,"Eduardo Puña",34,1),
(10,"Víctor Melgar",32,1),
(11,"Josué Mamani",19,1),
(12,"Fernando Saucedo",30,1),
(13,"Samuel Galindo",32,1),
(14,"Cristhian Árabe",32,1),
(15,"Juan Adrián",24,1),
(16,"Junior Romay",26,1),
(17,"Milton Garzón",19,1),
(18,"Javier Sanguinetti",29,1),
(19,"Rodrigo Ramallo",29,1),
(20,"Marcos Ovejero ",33,1);
-- tigre
insert into Tjugadores values(30,"Henry Vaca",22,2),
(31,"Daniel Vaca",41,2),
(32,"Diego Zamora",26,2),
(33,"Gonzalo Castillo",29,2),
(34,"Gabriel Valverde",30,2),
(35,"Luis Martelli",34,2),
(36,"José Sagredo",26,2),
(37,"Luis Demiquel",20,2),
(38,"Marvin Bejarano",32,2),
(39,"Diego Wayar",26,2),
(40,"Maximiliano Ortiz",30,2),
(41,"Raúl Castro",30,2),
(42,"Franz Gonzales",20,2),
(43,"Jhasmani Campos",32,2),
(44,"Willie Barbosa",27,2),
(45,"Ramiro Vaca",20,2),
(46,"Jeyson Chura",18,2),
(47,"Gabriel Sotomayor",20,2),
(48,"Carlos Añez",24,2),
(49,"Jair Reinoso",33,2),
(50,"Rolando Blackburn",35,2),
(51,"Harold Reina ",29,2);

-- insertando en Tperiodistas
insert into Tperiodistas values (1,2,1,"marcelo","videoanalista");
select * from Tperiodistas;

-- insertando en Tpartidos
select * from Tpartidos;
insert into Tpartidos values(1,1,2,"2020-05-23",3,4,"ganador","2020-05-23");

-- insertando en Tclasificadores_elo
select * from Tclasificadores_elo;
insert into Tclasificadores_elo values (1,"2020-05-22",1500,1);
insert into Tclasificadores_elo values (2,"2020-05-22",1500,2);
select* from Tclasificadores_elo;

-- insertando en Testadicticas_partidos
select * from Testadisticas_partidos;
insert into Testadisticas_partidos values(1,1,2,3,4,"ganado");
-- insertando en Tclasificadores_elo_jugadores
select * from Tclasificadores_elo_jugadores;
insert into Tclasificadores_elo_jugadores values(1,1,"2020-05-22",1500);

-- insertando en Tpuntuaciones
select * from Tpuntuaciones;

insert into Tpuntuaciones values(1,1500,16,7,3);
