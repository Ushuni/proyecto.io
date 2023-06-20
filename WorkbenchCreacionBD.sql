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
select * from Tjugadores;

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
select *  from Tusuarios;


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
select * from Tclasificadores_elo_jugadores;

-- Tabla puntuaciones
CREATE TABLE Tpuntuaciones (
  id_equipo INT PRIMARY KEY,
  puntuacion_elo FLOAT,
  partidos_ganados INT,
  partidos_perdidos INT,
  partidos_empatados INT,
  FOREIGN KEY (id_equipo) REFERENCES Tequipos(id_equipo)
);
select * from Tpuntuaciones;

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
                           insert into Tequipos values(15,"Independiente Petrolero","Sucre",65),
                           (16,"CD Real Tomayapo","Tarija",32),
                           (17,"Real Potosi","Potosi",25),
                           (18,"Universitario de Vinto","Cochabamba",19),
                           (19,"Universitario","Sucre",16),
                           (20,"Vaca Diez","Beni",13),
                           (21,"FC Libertad Gran Mamore","Beni",12);
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
-- wilster
INSERT INTO Tjugadores (id_jugador, nombre, edad, equipo_id)
VALUES
(52, 'Giménez Arnaldo Andrés', 36, 5),
(53, 'Poveda Bruno', 19, 5),
(54, 'Bejarano Joel', 27, 5),
(55, 'Castellon Vladimir', 33, 5),
(56, 'Cuellar Mario', 34, 5),
(57, 'Juarez Ariel', 35, 5),
(58, 'Machado Cristhian', 32, 5),
(59, 'Robson', 30, 5),
(60, 'Rodriguez Zegada Luis Francisco', 28, 5),
(61, 'Techera Mathias', 31, 5),
(62, 'Velázquez Julián', 32, 5),
(63, 'Aponte Juan', 31, 5),
(64, 'Cardozo Rudy', 33, 5),
(65, 'Chumacero Alejandro', 32, 5),
(66, 'Esparza Gabriel', 30, 5),
(67, 'Fernandez Adriel', 27, 5),
(68, 'Jonata Machado', 23, 5),
(69, 'Mamani Josue', 22, 5),
(70, 'Martinez Brazeiro Franco Nicolas', 24, 5),
(71, 'Perez Carlos', 24, 5),
(72, 'Rodríguez Carlitos', 18, 5),
(73, 'Suarez Marcelo', 21, 5),
(74, 'Velasquez Jhon', 20, 5),
(75, 'Bianconi Kohl Miguel Antonio', 31, 5),
(76, 'Herrera Jose', 21, 5),
(77, 'Vargas Rodrigo', 28, 5);


-- vaca diez
INSERT INTO Tjugadores (id_jugador, nombre, edad, equipo_id)
VALUES
  (393, 'Peña Israel', 24, 20),
  (78, 'Rodriguez Enzo', 19, 20),
  (79, 'Crecencio Lazaro', 20, 20),
  (80, 'Cruz Drulin', 24, 20),
  (81, 'Esterilla Marlon', 28, 20),
  (82, 'Fernández Joel', 24, 20),
  (83, 'Mizael Monteiro', 22, 20),
  (84, 'Moura David', 23, 20),
  (85, 'Paredes Miguel', 24, 20),
  (86, 'Quiñones Yosimar', 34, 20),
  (87, 'Roca Dico', 26, 20),
  (88, 'Suarez Ricardo', 29, 20),
  (89, 'Borobobo Victor', 30, 20),
  (90, 'Cuadros Diego', 26, 20),
  (91, 'Morales Rodrigo', 29, 20),
  (92, 'Parada Franz', 30, 20),
  (93, 'Randerson', 28, 20),
  (94, 'Randerson Fininho', 28, 20),
  (95, 'Roman Ricardo', 27, 20),
  (96, 'Taborga Pedro', 28, 20),
  (97, 'Briceno Jose', 21, 20),
  (98, 'Ibaguary Alexir', 26, 20),
  (99, 'Juan Teles', 27, 20),
  (100, 'Vogliotti Juan Leandro', 38, 20);


-- u de vinto

INSERT INTO Tjugadores (id_jugador, nombre, edad, equipo_id)
VALUES
    (394, 'Almada Gustavo', 29, 19),
    (102, 'Olivares Raul', 35, 19),
    (103, 'Cuellar Hector', 22, 19),
    (104, 'Lencinas Joaquin', 35, 19),
    (105, 'Mamani Ramiro', 32, 19),
    (106, 'Mercado Alan', 29, 19),
    (107, 'Vila Julio', 27, 19),
    (108, 'Alipaz Jose', 21, 19),
    (109, 'Aviles Flores Mijail Alexander', 35, 19),
    (110, 'Calicho Joel', 27, 19),
    (111, 'Cano Erick', 24, 19),
    (112, 'Castro Raul', 33, 19),
    (113, 'Gimenez Diago', 26, 19),
    (114, 'Laredo Pablo', 29, 19),
    (115, 'Magallanes Juan', 20, 19),
    (116, 'Navarro Diego', 30, 19),
    (117, 'Pinto Jose', 23, 19),
    (118, 'Vidaurre Ivan', 36, 19),
    (119, 'Abrego Victor', 26, 19),
    (120, 'Alvarez William', 27, 19),
    (121, 'Calero Daniel', 24, 19),
    (122, 'Llano Rodrigo', 30, 19),
    (123, 'Monteiro Pedraza Ronaldo', 25, 19),
    (124, 'Ndoutoumo Roy', 28, 19),
    (125, 'Ramallo Denilzon', 25, 19),
    (126, 'Romay Kevin', 29, 19),
    (127, 'Vargas Rodrigo', 33, 19);

-- tomayapo
INSERT INTO Tjugadores (id_jugador, nombre, edad, equipo_id)
VALUES
(128, 'Galindo Pedro', 28, 16),
(129, 'Cabrera Rodrigo', 26, 16),
(130, 'Corulo Leandro', 33, 16),
(131, 'Justiniano Leonardo', 21, 16),
(132, 'Martinez Pedro', 30, 16),
(133, 'Mendez Rivaldo', 20, 16),
(134, 'Padilha Hallysson', 29, 16),
(135, 'Rioja Juan', 35, 16),
(136, 'Azogue Pedro', 28, 16),
(137, 'Galindo Samuel', 31, 16),
(138, 'Ibáñez Javier', 26, 16),
(139, 'Jeffinho', 25, 16),
(140, 'Noble Matias', 26, 16),
(141, 'Thiago', 38, 16),
(142, 'Villamil Sergio', 28, 16),
(143, 'Ali Vega Luis Alberto', 29, 16),
(144, 'Graneros Agustin', 27, 16),
(145, 'Guylherme Nixon', 27, 16),
(146, 'Hernández Mateo', 24, 16),
(147, 'Pariani Diego', 29, 16),
(148, 'Vallejos Yerco', 28, 16);

-- royal pari
INSERT INTO Tjugadores (id_jugador, nombre, edad, equipo_id)
VALUES
(149, 'Arauz Jorge', 28, 4),
(150, 'Mendez Salcedo Diego Armando', 32, 4),
(151, 'Alvarez Eduardo', 20, 4),
(152, 'Anez Carlos', 27, 4),
(153, 'Bejarano Marvin', 35, 4),
(154, 'Capurro Juan', 28, 4),
(155, 'Silva Hugo', 31, 4),
(156, 'Valverde Diego', 19, 4),
(157, 'Virreira Jefferson', 26, 4),
(158, 'Zampiery Juan', 33, 4),
(159, 'Amoroso Joel', 35, 4),
(160, 'Guzmán Brandon', 35, 4),
(161, 'Moreno Andres', 20, 4),
(162, 'Orfano Esteban', 31, 4),
(163, 'Ribera Carlos', 26, 4),
(164, 'Ribera Castillo Juan Alexis', 27, 4),
(165, 'Salvatierra Flores Kevin Francisco', 21, 4),
(166, 'Tomianovic Mirko', 21, 4),
(167, 'Zurita Alexander', 25, 4),
(168, 'Correa Jose', 30, 4),
(169, 'Ribera David', 22, 4),
(170, 'Sellecchia Federico', 28, 4),
(171, 'Suarez Fabricio', 19, 4);

-- real santa cruz
INSERT INTO Tjugadores (id_jugador, nombre, edad, equipo_id)
VALUES
(179, 'Claros de Souza Gustavo Leonardo', 25, 14),
(180, 'Torrez Suarez Alejandro William', 25, 14),
(181, 'Garcia Cesar', 30, 14),
(182, 'López Brian', 23, 14),
(183, 'Orellana Chavarria Juan José', 25, 14),
(184, 'Perez Peredo Julio Cesar', 31, 14),
(185, 'Rodriguez Edemir', 38, 14),
(186, 'Antelo Yncian Walter', 22, 14),
(187, 'Cardenas Imanol', 23, 14),
(188, 'Condarco Luis', 19, 14),
(189, 'De La Rosa Reyvin', 19, 14),
(190, 'Gutierrez Mojica Limberg', 24, 14),
(191, 'Jean Jayro', 24, 14),
(192, 'Lara Jose', 23, 14),
(193, 'Malgor Gerson', 19, 14),
(194, 'Moreno Fabricio', 25, 14),
(195, 'Moreno Palacios Fabricio Jose', 25, 14),
(196, 'Ortiz Jorge', 39, 14),
(197, 'Ovando Mario', 37, 14),
(198, 'Peñaranda Richard', 25, 14),
(199, 'Pozo Samuel', 26, 14),
(200, 'Ruiz Hurtado Hermes Mauricio', 23, 14),
(201, 'Vaca Hurtado Edward', 23, 14),
(202, 'Bravo Jose', 25, 14),
(203, 'Gonzalez Efmamjjasond', 23, 14),
(204, 'Gutierez Angel', 21, 14),
(205, 'Navia Andree', 22, 14),
(206, 'Orozco Quiroga Jorge Nelson', 23, 14),
(207, 'Zoch Mendez Matheo Henrique', 26, 14);

-- real mamore
INSERT INTO Tjugadores (id_jugador, nombre, edad, equipo_id)
VALUES
(208, 'Vaca Marco', 33, 21),
(209, 'Arriaga Jose', 26, 21),
(210, 'Carillo Grovert', 26, 21),
(211, 'Gil Sergio', 25, 21),
(212, 'Montenegro Leonardo', 26, 21),
(213, 'Rodriguez Dieguito', 27, 21),
(214, 'Rodriguez Ronny', 28, 21),
(215, 'Trazie Kadassi', 26, 21),
(216, 'Zazpe Leandro', 29, 21),
(217, 'Barbery Gil Mario Gabriel', 21, 21),
(218, 'Bejarano Amir', 26, 21),
(219, 'Candia Jordy', 27, 21),
(220, 'Fernandez Denilso', 20, 21),
(221, 'Gomez Perez Juan Pablo', 30, 21),
(222, 'Lemos Maximiliano', 29, 21),
(223, 'Milano Mauro', 39, 21),
(224, 'Oni Frank', 33, 21),
(225, 'Orihuela Rodrigo', 19, 21),
(226, 'Taborga Yonathan', 27, 21),
(227, 'Tellez Makerlo', 20, 21),
(228, 'Vargas Jorge', 26, 21),
(229, 'Bejarano Francescoli', 28, 21),
(230, 'Castillo Jose', 40, 21),
(231, 'Medina Alejandro', 26, 21),
(232, 'Mendoza Miguel', 24, 21),
(233, 'Torrez Henry', 28, 21);

-- oriente
INSERT INTO Tjugadores (id_jugador, nombre, edad, equipo_id)
VALUES
(234, 'Quinonez Wilson Daniel', 34, 10),
(235, 'Alvarez Sebastian', 21, 10),
(236, 'Caire Maximiliano', 34, 10),
(237, 'Gutierrez Luis', 38, 10),
(238, 'Mercado Galvez Juan Salvador', 26, 10),
(239, 'Paz Ayrton', 20, 10),
(240, 'Soleto Wilfredo', 27, 10),
(241, 'Ampuero Alejandro', 20, 10),
(242, 'Arabe Cristhian', 31, 10),
(243, 'Berdecio Jamir', 20, 10),
(244, 'Correa Jorge', 30, 10),
(245, 'Gonzales Mejia Franz', 22, 10),
(246, 'Guzman Samuel', 21, 10),
(247, 'Guzmán Alain', 20, 10),
(248, 'Menacho Ricardo', 20, 10),
(249, 'Rojas Daniel', 23, 10),
(250, 'Sanchez Erwin', 30, 10),
(251, 'Sandoval Andre', 23, 10),
(252, 'Sandoval Ricardo', 21, 10),
(253, 'Sandoval Samuel', 20, 10),
(254, 'Sánchez Hector', 26, 10),
(255, 'Vaca Henry', 25, 10),
(256, 'Vargas Fabio', 19, 10),
(257, 'Vargas Javier', 20, 10),
(258, 'Álvarez Cristian', 30, 10),
(259, 'Cristaldo Jonathan Ezequiel', 34, 10),
(260, 'Roca Vivancos Freddy', 23, 10),
(261, 'Saucedo Rodrigo', 24, 10),
(262, 'Sosa Andre', 25, 10),
(263, 'Velasco Jose', 24, 10),
(264, 'Villagra Leonardo', 32, 10),
(265, 'Zeballos Luis', 21, 10);


-- nacional potosi
INSERT INTO Tjugadores (id_jugador, nombre, edad, equipo_id)
VALUES
(266, 'Mustafa Saidt', 33, 7),
(267, 'Salvatierra Gustavo', 31, 7),
(268, 'Anez Oscar', 32, 7),
(269, 'Chiatti Martin', 30, 7),
(270, 'Galain Martin', 34, 7),
(271, 'Leanos Heber', 32, 7),
(272, 'Mancilla Daniel', 32, 7),
(273, 'Ortiz Maximiliano', 33, 7),
(274, 'Saucedo Widen', 26, 7),
(275, 'Torrico Luis', 36, 7),
(276, 'Andia Jorge', 35, 7),
(277, 'Chajtur Molina Mauricio', 26, 7),
(278, 'Cristaldo Gustavo', 33, 7),
(279, 'Cuéllar Víctor', 22, 7),
(280, 'Figueroa Layonel', 23, 7),
(281, 'Guerra Saulo', 30, 7),
(282, 'Nunez Maximiliano', 36, 7),
(283, 'Pavia Mamani Luis Fernando', 23, 7),
(284, 'Torrico Andreas', 18, 7),
(285, 'Hoyos Josue', 30, 7),
(286, 'Prost Martin', 34, 7),
(287, 'Saldias Luis', 26, 7),
(288, 'Tobar Tommy', 36, 7);

-- guabira
INSERT INTO Tjugadores (id_jugador, nombre, edad, equipo_id)
VALUES
(289, 'Arauz Elder', 33, 6),
(290, 'Cuellar Jairo', 23, 6),
(291, 'Chore Aguilera Carlos', 22, 6),
(292, 'Echeverria Santiago', 33, 6),
(293, 'Gonzalez Jorge', 26, 6),
(294, 'Huayhuata Ivan', 34, 6),
(295, 'Ibáñez Jefferson', 28, 6),
(296, 'Meleán Alejandro', 35, 6),
(297, 'Supayabe Fran', 27, 6),
(298, 'Abastoflor Carlos', 21, 6),
(299, 'Fernandez Cristian', 19, 6),
(300, 'Navarro Santos', 32, 6),
(301, 'Rodriguez Hernan Luis', 27, 6),
(302, 'Salvatierra Hugo', 20, 6),
(303, 'Abastoflor Freddy', 30, 6),
(304, 'Alaniz Martin', 30, 6),
(305, 'Bruno Miranda', 25, 6),
(306, 'Cabral Mauricio', 22, 6),
(307, 'Eguez Flores Brahian', 31, 6),
(308, 'Gallegos Sebastian', 31, 6),
(309, 'Montenegro Juan', 26, 6),
(310, 'Padu', 25, 6),
(311, 'Peredo Gustavo', 23, 6),
(312, 'Ruiz Diaz Rodrigo', 24, 6),
(313, 'Vaca Angel', 21, 6);

-- bolivar
INSERT INTO Tjugadores (id_jugador, nombre, edad, equipo_id)
VALUES
(314, 'Cordano Ruben', 24, 3),
(315, 'Lampe Carlos', 36, 3),
(316, 'Bentaberry Varela Bryan Daniel', 26, 3),
(317, 'Ferreyra Nicolas', 30, 3),
(318, 'Haquin Luis', 25, 3),
(319, 'Melgar Carlos Antonio', 28, 3),
(320, 'Rocha Yomar', 19, 3),
(321, 'Sagredo Jesus', 29, 3),
(322, 'Sagredo Jose', 29, 3),
(323, 'Velasco Jhon', 19, 3),
(324, 'Bejarano Diego', 31, 3),
(325, 'Fernandez Roberto', 23, 3),
(326, 'Herrera Jose', 20, 3),
(327, 'Hervías Pablo', 30, 3),
(328, 'Justiniano Leonel', 30, 3),
(329, 'Rodriguez Patricio', 33, 3),
(330, 'Saucedo Fernando', 33, 3),
(331, 'Uzeda Javier', 20, 3),
(332, 'Vaca Ramiro', 23, 3),
(333, 'Villamil Gabriel', 21, 3),
(334, 'Villarroel Miguel', 20, 3),
(335, 'Villarroel Moises', 24, 3),
(336, 'Algaranaz Carmelo', 27, 3),
(337, 'Chavez Cruz Lucas Leonidas', 20, 3),
(338, 'Fernandez Ronnie', 32, 3),
(339, 'Gabriel Poveda', 24, 3);

-- blooming
INSERT INTO Tjugadores (id_jugador, nombre, edad, equipo_id)
VALUES
(340, 'Gutierrez Johan', 26, 9),
(341, 'Uraezana Braulio', 28, 9),
(342, 'Becerra Miguel Angel', 30, 9),
(343, 'Cabrera Abraham', 32, 9),
(344, 'Iago Mendonca', 23, 9),
(345, 'Justiniano Eduardo', 33, 9),
(346, 'Justiniano Guimer', 33, 9),
(347, 'Ribera Oscar', 31, 9),
(348, 'Severiche Saul', 21, 9),
(349, 'Valverde Juan', 32, 9),
(350, 'Villamil Jaime', 30, 9),
(351, 'Arismendi Fernando', 32, 9),
(352, 'Camacho Almanza Daniel Alejandro', 24, 9),
(353, 'Cuellar Orti Ronald', 25, 9),
(354, 'Gomez Miranda Richet', 24, 9),
(355, 'Lovera Jorge', 26, 9),
(356, 'Lujan Pablo', 20, 9),
(357, 'Rafinha', 31, 9),
(358, 'Rodriguez Fernando', 27, 9),
(359, 'Romero Cesar', 21, 9),
(360, 'Siles Omar', 30, 9),
(361, 'Spenhay Richard', 25, 9),
(362, 'Arce Juan', 38, 9),
(363, 'Duran Denilson', 20, 9),
(364, 'Ferrufino Juan', 22, 9),
(365, 'Garzon Samuel', 23, 9),
(366, 'Leo Fenga', 21, 9),
(367, 'Menacho Cesar', 23, 9),
(368, 'Pinto Denis', 27, 9),
(369, 'Rodriguez Gaston', 31, 9),
(370, 'Sinisterra Castillo Jose Luis', 24, 9);

-- aurora
INSERT INTO Tjugadores (id_jugador, nombre, edad, equipo_id)
VALUES
(371, 'Cardenas Luis', 32, 11),
(372, 'Amarilla Nelson Avelino', 35, 11),
(373, 'Ballivian Ramiro', 31, 11),
(374, 'Barboza Luis', 30, 11),
(375, 'Michelli Ezequiel', 32, 11),
(376, 'Sanchez Amilcar', 32, 11),
(377, 'Taboada Caballero Daniel Nicoll', 32, 11),
(378, 'Torrico Jair', 36, 11),
(379, 'Zaracho Sebastian', 24, 11),
(380, 'Aguilar Fernando', 26, 11),
(381, 'Aranibar Brayan', 24, 11),
(382, 'Gomez Maximiliano', 35, 11),
(383, 'Torrico Dario', 22, 11),
(384, 'Torrico Didi', 35, 11),
(385, 'Vaca Oscar', 34, 11),
(386, 'Blanco Oswaldo', 33, 11),
(387, 'Limas Josef', 25, 11),
(388, 'Moruno Sergio', 29, 11),
(389, 'Ramallo Rodrigo', 32, 11),
(390, 'Reinoso Jair', 37, 11),
(391, 'Segovia Jose', 19, 11),
(392, 'Serginho', 38, 11);


select * from Tequipos;
select * from Tjugadores;

select e.nombre, j.nombre from Tjugadores j inner join Tequipos e on j.equipo_id=e.id_equipo order by equipo_id asc;



--
--
--
--

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
insert into Tclasificadores_elo values (3,"2020-05-22",1800,3),
(4,"2020-05-22",1500,4),
(5,"2020-05-22",1500,5),
(6,"2020-05-22",1500,6),
(7,"2020-05-22",1500,7),
(8,"2020-05-22",1500,8),
(9,"2020-05-22",1500,9),
(10,"2020-05-22",1500,10),
(11,"2020-05-22",1900,11),
(12,"2020-05-22",1500,12),
(13,"2020-05-22",1500,13),
(14,"2020-05-22",1500,14),
(15,"2020-05-22",1500,15),
(16,"2020-05-22",1500,16),
(17,"2020-05-22",1500,17),
(18,"2020-05-22",1500,18),
(19,"2020-05-22",1500,19),
(20,"2020-05-22",1500,20),
(21,"2020-05-22",1500,21);

select* from Tclasificadores_elo;
select* from Tjugadores;

-- insertando en Testadicticas_partidos
select * from Testadisticas_partidos;
insert into Testadisticas_partidos values(1,1,2,3,4,"ganado");
-- insertando en Tclasificadores_elo_jugadores
select * from Tclasificadores_elo_jugadores;
insert into Tclasificadores_elo_jugadores values(1,1,"2020-05-22",1500);

INSERT INTO Tclasificadores_elo_jugadores (id_clasificador, id_jugador, fecha_clasificador, puntuacion_elo)
VALUES 
  (2, 2, '2020-01-01', 1400),
  (3, 3, '2020-02-15', 1450),
  (4, 4, '2020-03-10', 1500),
  (5, 5, '2020-04-22', 1550),
  (6, 6, '2020-05-05', 1600),
  (7, 7, '2021-01-10', 1425),
  (8, 8, '2021-02-20', 1475),
  (9, 9, '2021-03-15', 1525),
  (10, 10, '2021-04-05', 1575),
  (11, 11, '2021-05-18', 1425),
  (12, 12, '2022-01-03', 1450),
  (13, 13, '2022-02-14', 1500),
  (14, 14, '2022-03-20', 1550),
  (15, 15, '2022-04-08', 1600),
  (16, 16, '2022-05-23', 1400),
  (17, 17, '2023-01-06', 1450),
  (18, 18, '2023-02-12', 1500),
  (19, 19, '2023-03-18', 1550),
  (20, 20, '2023-04-09', 1600);
  
  INSERT INTO Tclasificadores_elo_jugadores (id_clasificador, id_jugador, fecha_clasificador, puntuacion_elo)
VALUES 
  (30, 30, '2020-01-15', 1400),
  (31, 31, '2020-02-28', 1450),
  (32, 32, '2020-03-22', 1500),
  (33, 33, '2020-04-10', 1550),
  (34, 34, '2020-05-27', 1600),
  (35, 35, '2021-01-12', 1425),
  (36, 36, '2021-02-25', 1475),
  (37, 37, '2021-03-18', 1525),
  (38, 38, '2021-04-07', 1575),
  (39, 39, '2021-05-20', 1425),
  (40, 40, '2022-01-05', 1450),
  (41, 41, '2022-02-18', 1500),
  (42, 42, '2022-03-25', 1550),
  (43, 43, '2022-04-14', 1600),
  (44, 44, '2022-05-29', 1400),
  (45, 45, '2023-01-10', 1450),
  (46, 46, '2023-02-16', 1500),
  (47, 47, '2023-03-22', 1550),
  (48, 48, '2023-04-13', 1600),
  (49, 49, '2023-05-26', 1400),
  (50, 50, '2020-01-20', 1450),
  (51, 51, '2020-02-05', 1500),
  (52, 52, '2020-03-12', 1550),
  (53, 53, '2020-04-28', 1600),
  (54, 54, '2020-05-13', 1425),
  (55, 55, '2021-01-18', 1475),
  (56, 56, '2021-02-28', 1525),
  (57, 57, '2021-03-25', 1575),
  (58, 58, '2021-04-16', 1425),
  (59, 59, '2021-05-29', 1450),
  (60, 60, '2022-01-15', 1500),
  (61, 61, '2022-02-28', 1550),
  (62, 62, '2022-03-25', 1600),
  (63, 63, '2022-04-10', 1400),
  (64, 64, '2022-05-24', 1450),
  (65, 65, '2023-01-15', 1500),
  (66, 66, '2023-02-20', 1550),
  (67, 67, '2023-03-25', 1600),
  (68, 68, '2023-04-12', 1400),
  (69, 69, '2023-05-25', 1450),
  (70, 70, '2020-01-25', 1500),
  (71, 71, '2020-02-10', 1550),
  (72, 72, '2020-03-15', 1600),
  (73, 73, '2020-04-29', 1425),
  (74, 74, '2020-05-17', 1475),
  (75, 75, '2021-01-20', 1525),
  (76, 76, '2021-02-28', 1575),
  (77, 77, '2021-03-26', 1425);
  
   INSERT INTO Tclasificadores_elo_jugadores (id_clasificador, id_jugador, fecha_clasificador, puntuacion_elo)
VALUES 
  (393, 393, '2020-01-15', 1400);
select * from Tequipos;
select * from Tjugadores;


select * from Tclasificadores_elo;

select * from Tclasificadores_elo_jugadores;
delete from Tclasificadores_elo_jugadores where id_clasificador=1;


INSERT INTO Tclasificadores_elo_jugadores (id_clasificador, id_jugador)
SELECT ce.equipo_id, j.id_jugador
FROM Tclasificadores_elo ce
JOIN Tjugadores j ON ce.equipo_id = j.equipo_id;

INSERT INTO Tclasificadores_elo_jugadores (id_clasificador, id_jugador, fecha_clasificador, puntuacion_elo)
SELECT ce.equipo_id, j.id_jugador, '2022-01-01', 1500
FROM Tclasificadores_elo ce
JOIN Tjugadores j ON ce.id_clasificador = j.equipo_id
WHERE ce.fecha_clasificador BETWEEN '2020-01-01' AND '2023-12-31'
  AND ce.puntuacion_elo BETWEEN 1400 AND 1600;

INSERT IGNORE INTO Tclasificadores_elo_jugadores (id_clasificador, id_jugador, fecha_clasificador, puntuacion_elo)
SELECT ce.equipo_id, j.id_jugador, '2023-05-16', ROUND(RAND() * (1600 - 1400) + 1400, 2)
FROM Tclasificadores_elo ce
JOIN Tjugadores j ON ce.equipo_id = j.equipo_id
WHERE ce.fecha_clasificador BETWEEN '2020-01-01' AND '2023-12-31';



-- insertando en Tpuntuaciones
select * from Tpuntuaciones;

insert into Tpuntuaciones values(1,1500,16,7,3);


-- -------------------------------

ALTER TABLE Tjugadores
ADD COLUMN puntuacion_elo FLOAT;
--

CREATE TABLE Tclasificadores_elo_jugadores (
  id_clasificador INT,
  id_jugador INT,
  fecha_clasificador DATE,
  puntuacion_elo FLOAT,
  FOREIGN KEY (id_clasificador) REFERENCES Tclasificadores_elo(id_clasificador),
  FOREIGN KEY (id_jugador) REFERENCES Tjugadores(id_jugador)
);

alter table Tclasificadores_elo_jugadores
add FOREIGN KEY (id_clasificador) REFERENCES Tclasificadores_elo(id_clasificador),
add FOREIGN KEY (id_jugador) REFERENCES Tjugadores(id_jugador);

select * from Tjugadores;
select * from Tusuarios;

