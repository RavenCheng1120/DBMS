-- CREATE DATABASE StatisticsDB;
-- USE StatisticsDB;

CREATE TABLE normal (
    UserNum int NOT NULL,
    Pretest int NOT NULL,
    Midtest int NOT NULL,
    Posttest int NOT NULL,
    PRIMARY KEY (UserNum)
);

CREATE TABLE conditionA (
    UserNum int NOT NULL,
    Enjoyment int NOT NULL,
    Realism int NOT NULL,
    Immersion int NOT NULL,
    PRIMARY KEY (UserNum)
);

CREATE TABLE conditionB (
    UserNum int NOT NULL,
    Enjoyment int NOT NULL,
    Realism int NOT NULL,
    Immersion int NOT NULL,
    PRIMARY KEY (UserNum)
);

CREATE TABLE conditionC (
    UserNum int NOT NULL,
    Enjoyment int NOT NULL,
    Realism int NOT NULL,
    Immersion int NOT NULL,
    PRIMARY KEY (UserNum)
);

INSERT INTO normal
VALUES 
(0, 52, 50, 40),
(1, 56, 54, 52),
(2, 51, 50, 37),
(3, 49, 41, 32),
(4, 52, 49, 32),
(5, 53, 46, 33),
(6, 60, 55, 33),
(7, 39, 37, 36),
(8, 52, 48, 33),
(9, 52, 55, 46),
(10, 45, 53, 41),
(11, 52, 48, 32),
(12, 48, 45, 31),
(13, 57, 56, 38),
(14, 55, 54, 30),
(15, 50, 47, 40),
(16, 57, 53, 30),
(17, 60, 58, 35),
(18, 70, 64, 46),
(19, 64, 62, 51),
(20, 51, 62, 43),
(21, 37, 36, 34),
(22, 40, 35, 56),
(23, 67, 62, 42),
(24, 58, 58, 31),
(25, 64, 60, 43),
(26, 50, 47, 31),
(27, 40, 36, 42),
(28, 50, 46, 44),
(29, 52, 49, 42),
(30, 60, 58, 42),
(31, 69, 65, 58),
(32, 45, 44, 42),
(33, 62, 61, 52),
(34, 55, 42, 44),
(35, 58, 64, 62),
(36, 50, 55, 54),
(37, 59, 55, 58),
(38, 53, 64, 63),
(39, 51, 41, 31);

INSERT INTO conditionA
VALUES
(0, 2, 1, 2),
(1, 3, 3, 4),
(2, 4, 4, 4),
(3, 4, 3, 3),
(4, 3, 3, 3),
(5, 3, 1, 1),
(6, 4, 4, 4),
(7, 2, 5, 4),
(8, 5, 6, 7),
(9, 3, 3, 3),
(10, 4, 4, 4),
(11, 4, 1, 1);

INSERT INTO conditionB
VALUES
(0, 5, 5, 6),
(1, 4, 4, 4),
(2, 1, 2, 3),
(3, 5, 5, 5),
(4, 4, 5, 5),
(5, 4, 2, 2),
(6, 5, 4, 4),
(7, 1, 5, 6),
(8, 2, 5, 5),
(9, 5, 6, 6),
(10, 7, 7, 7),
(11, 4, 3, 3);

INSERT INTO conditionC
VALUES
(0, 6, 6, 6),
(1, 6, 6, 6),
(2, 6, 5, 6),
(3, 6, 6, 6),
(4, 6, 6, 6),
(5, 5, 6, 6),
(6, 6, 6, 6),
(7, 4, 3, 5),
(8, 4, 5, 7),
(9, 7, 6, 6),
(10, 7, 6, 6),
(11, 5, 3, 3);

# SELECT * FROM normal;
# SELECT * FROM conditionA;
# SELECT * FROM conditionB;
# SELECT * FROM conditionC;

# DROP DATABASE StatisticsDB;