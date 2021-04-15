/* create and use database */
CREATE DATABASE ArtBusiness;
USE ArtBusiness;

/* info */
CREATE TABLE self(
	StuID varchar(10) NOT NULL,
	Department varchar(10) NOT NULL,
	SchoolYear int DEFAULT 1,
	Name varchar(10) NOT NULL,
	Gender varchar(10) NOT NULL,
	PRIMARY KEY (StuID)
);

INSERT INTO self VALUE(
	'r09922063',
	'CSIE',
	1,
	'鄭筠庭',
	'Female'
);

SELECT DATABASE();
SELECT * FROM self;

/* create table */
CREATE TABLE exhibitor(
	ExhibitorID int NOT NULL,
	StallNumber int NOT NULL UNIQUE,
	Theme ENUM('fan art', 'video game', 'comic', 'animation', 'movie', 'fashion', 'novel'),
	ExhibitAmount int DEFAULT 1 CHECK (ExhibitAmount>0),
	EventName varchar(30) NOT NULL,
	PRIMARY KEY (ExhibitorID)
);

CREATE TABLE artist(
	ArtistName varchar(30) NOT NULL,
	ArtistAge int NOT NULL CHECK (ArtistAge >= 0),
	Nationality varchar(20) DEFAULT 'America',
	ExhibitorID int,
	PRIMARY KEY (ArtistName),
	FOREIGN KEY (ExhibitorID) REFERENCES exhibitor(ExhibitorID)
);

CREATE TABLE company(
	TaxID int NOT NULL CHECK (TaxID>0),
	Address varchar(200) DEFAULT 'Taipei city',
	CompanyName varchar(30) NOT NULL UNIQUE,
	ExhibitorID int,
	PRIMARY KEY (TaxID),
	FOREIGN KEY (ExhibitorID) REFERENCES exhibitor(ExhibitorID)
);

CREATE TABLE freelancer(
	Income int NOT NULL CHECK (Income >= 0),
	Website text,
	StudioLocation varchar(30) DEFAULT 'work at home',
	ArtistName varchar(30) NOT NULL,
	PRIMARY KEY (ArtistName),
	FOREIGN KEY (ArtistName) REFERENCES artist(ArtistName) ON DELETE CASCADE
);

CREATE TABLE fullTimeArtist(
	Salary int NOT NULL,
	JobTitle varchar(30) NOT NULL,
	WorkingHours int DEFAULT 8,
	ArtistName varchar(30) NOT NULL,
	TaxID int NOT NULL CHECK (TaxID>0),
	PRIMARY KEY (ArtistName),
	FOREIGN KEY (ArtistName) REFERENCES artist(ArtistName) ON DELETE CASCADE,
	FOREIGN KEY (TaxID) REFERENCES company(TaxID)
);

CREATE TABLE animator(
	ArtStyle varchar(30) NOT NULL,
	AnimationSoftware varchar(30) DEFAULT 'Animate CC',
	-- School varchar(30),
	-- Department varchar(50),
	-- Degree ENUM('bachelor', 'associate', 'master', 'doctoral'),
	Education varchar(100),
	ArtistName varchar(30) NOT NULL,
	PRIMARY KEY (ArtistName),
	FOREIGN KEY (ArtistName) REFERENCES artist(ArtistName) ON DELETE CASCADE
);

CREATE TABLE illustrator(
	Expertise varchar(30) NOT NULL,
	DrawingSoftware varchar(30) DEFAULT 'Photoshop',
	RepresentativeWork varchar(30),
	ArtistName varchar(30) NOT NULL,
	PRIMARY KEY (ArtistName),
	FOREIGN KEY (ArtistName) REFERENCES artist(ArtistName) ON DELETE CASCADE
);

CREATE TABLE exhibition(
	EventName varchar(30) NOT NULL,
	StartDate DATE NOT NULL,
	Location varchar(100) DEFAULT 'Taipei EXPO Park',
	PRIMARY KEY (EventName)
);

CREATE TABLE animatedMovie(
	MovieTitle varchar(35) NOT NULL,
	Rating float(3) DEFAULT 10.0 CHECK (10>=Rating>=0),
	Genre ENUM('superhero', 'adventure', 'magic', 'medieval', 'horror', 'scifi', 'comedy', 'musical'),
	PRIMARY KEY (MovieTitle)
);

CREATE TABLE characters(
	CharacterName varchar(40) NOT NULL,
	Gender ENUM('male', 'female', 'others'),
	Height int DEFAULT 170 CHECK (Height>=0),
	MovieTitle varchar(35) NOT NULL, 
	PRIMARY KEY (CharacterName, MovieTitle),
	FOREIGN KEY (MovieTitle) REFERENCES animatedMovie(MovieTitle)
);


CREATE TABLE sponsor(
	TaxID int NOT NULL,
	EventName varchar(30) NOT NULL,
	MoneyAmount int DEFAULT 100,
	PRIMARY KEY (TaxID, EventName),
	FOREIGN KEY (TaxID) REFERENCES company(TaxID) ON DELETE CASCADE,
	FOREIGN KEY (EventName) REFERENCES exhibition(EventName) ON DELETE CASCADE
);

CREATE TABLE attend(
	EventName varchar(30) NOT NULL,
	ExhibitorID int NOT NULL,
	Attendance int DEFAULT 4,
	PRIMARY KEY (ExhibitorID, EventName),
	FOREIGN KEY (EventName) REFERENCES exhibition(EventName),
	FOREIGN KEY (ExhibitorID) REFERENCES exhibitor(ExhibitorID)
);

CREATE TABLE workOn(
	ArtistName varchar(30) NOT NULL,
	MovieTitle varchar(35) NOT NULL,
	JobTitle varchar(35) DEFAULT 'art director',
	PRIMARY KEY (ArtistName, MovieTitle),
	FOREIGN KEY (ArtistName) REFERENCES animator(ArtistName),
	FOREIGN KEY (MovieTitle) REFERENCES animatedMovie(MovieTitle)
);

CREATE TABLE admire(
	Admirer varchar(30) NOT NULL,
	Idol varchar(30) NOT NULL,
	FollowMedia varchar(30) DEFAULT 'Instagram',
	PRIMARY KEY (Admirer, Idol),
	FOREIGN KEY (Admirer) REFERENCES artist(ArtistName),
	FOREIGN KEY (Idol) REFERENCES artist(ArtistName)
);

/* insert */
INSERT INTO exhibitor VALUES
(0, 59, 'fan art', 20, 'Fancy Frontier'),
(1, 138, 'video game', 1, 'Comic World Taiwan'),
(2, 111, 'comic', 13, 'TAIPEI GAME SHOW');

INSERT INTO artist VALUES
('Jaiden Dittfach', 23, 'America', NULL),
('Yiliang', 30, 'Taiwan', 0),
('Norman Auble', 43, 'America', NULL),
('Kota', 25, 'Korea', 1),
('Ivan Chakarov', 35, 'France', NULL),
('Ross Tran', 29, 'China', NULL);

INSERT INTO company VALUES
(123456789, 'P.O. Box 10,000 Lake Buena Vista, FL 32830', 'Disney', 2),
(806423531, '1200 Park Ave, Emeryville, CA 94608', 'Pixar', NULL),
(132667754, 'Frank G. Wells Building 2nd Floor 500 South Buena Vista Street, Burbank, California , United States', 'Marvel Studios', NULL);

INSERT INTO freelancer VALUES
(32000,  'https://www.facebook.com/YiLiang2018/', 'The Pier-2 Art Center', 'Yiliang'),
(85000, 'http://www.bonartstudio.com/', 'Bon art studio', 'Ivan Chakarov'),
(38000, 'https://www.instagram.com/1o8k_/', 'work at home', 'Kota');

INSERT INTO fullTimeArtist VALUES
(45000, 'animator', 11, 'Jaiden Dittfach', 806423531),
(100000, 'art director', 8, 'Norman Auble', 806423531),
(33000, 'UI/UX designer', 10, 'Ross Tran', 123456789);

INSERT INTO animator VALUES
('3D animation', 'Cinema 4D', 'Sheridan College, Multimedia and Animation Arts, bachelor', 'Norman Auble'),
('2D animation', 'Animate CC', 'Gobelins, Arts and Design, master', 'Jaiden Dittfach'),
('stop motion', 'Stop Motion Studio', 'Rubika, Fine Arts, bachelor', 'Kota');

INSERT INTO illustrator VALUES
('character design', 'Photoshop', 'God of War', 'Norman Auble'),
('background art', 'Clip studio', 'The Hobbits', 'Ivan Chakarov'),
('logo design', 'Adobe illustrator', 'Goncha', 'Ross Tran');

INSERT INTO exhibition VALUES
('Comic World Taiwan', '2021-03-27', 'NTU Sports Center'),
('Fancy Frontier', '2021-05-01', 'Taipei EXPO Park'),
('TAIPEI GAME SHOW', '2020-12-23', 'Taipei Nangang Exhibition Center');

INSERT INTO animatedMovie VALUES
('Raya and the Last Dragon', 8.1, 'adventure'),
('Big Hero 6', 7.9, 'superhero'),
('Frozen', 9.5, 'magic'),
('Into the spider verse', 9.3, 'superhero');

INSERT INTO characters VALUES
('Hero', 'male', 160, 'Big Hero 6'),
('Raya', 'female', 170, 'Raya and the Last Dragon'),
('Peter Parker', 'male', 185, 'Into the spider verse');

INSERT INTO sponsor VALUES
(123456789, 'TAIPEI GAME SHOW', 120),
(132667754, 'TAIPEI GAME SHOW', 133),
(132667754, 'Fancy Frontier', 50);

INSERT INTO attend VALUES
('Fancy Frontier', 0, 1),
('Comic World Taiwan', 1, 5),
('TAIPEI GAME SHOW', 2, 2);

INSERT INTO workOn VALUES
('Jaiden Dittfach', 'Big Hero 6', 'art director'),
('Kota', 'Frozen', 'graphic designer'),
('Norman Auble', 'Into the spider verse', 'storyboard');

INSERT INTO admire VALUES
('Yiliang', 'Ross Tran', 'Youtube'),
('Jaiden Dittfach', 'Ross Tran', 'ArtStation'),
('Kota', 'Jaiden Dittfach', 'Facebook');

/* create two views */
CREATE VIEW SalaryStatus AS
SELECT Floor(t1.Salary / (t1.WorkingHours*30)) as HourlyPaid, t2.ArtistName, t2.ArtistAge
	FROM fullTimeArtist as t1
JOIN 
	artist as t2
ON t1.ArtistName = t2.ArtistName;


CREATE VIEW FreelanceIllustrator AS
SELECT freelancer.ArtistName, freelancer.StudioLocation, illustrator.RepresentativeWork
	FROM illustrator
INNER JOIN
	freelancer
ON illustrator.ArtistName = freelancer.ArtistName;


/* select from all tables and views */
SELECT * FROM artist;
SELECT * FROM freelancer;
SELECT * FROM fullTimeArtist;
SELECT * FROM animator;
SELECT * FROM illustrator;
SELECT * FROM company;
SELECT * FROM exhibitor;
SELECT * FROM exhibition;
SELECT * FROM animatedMovie;
SELECT * FROM characters;
SELECT * FROM sponsor;
SELECT * FROM attend;
SELECT * FROM workOn;
SELECT * FROM admire;
SELECT * FROM SalaryStatus;
SELECT * FROM FreelanceIllustrator;

/* drop database */
DROP DATABASE ArtBusiness;