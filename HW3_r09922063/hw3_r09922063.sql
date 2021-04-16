/***** create and use database *****/
CREATE DATABASE ArtBusiness;
USE ArtBusiness;

/***** info *****/
CREATE TABLE self(
	StuID varchar(10) NOT NULL,
	Department varchar(10) NOT NULL,
	SchoolYear int DEFAULT 1,
	Name varchar(10) NOT NULL,
	PRIMARY KEY (StuID)
);

INSERT INTO self VALUE('r09922063', '資工所', 1, '鄭筠庭');

SELECT DATABASE();
SELECT * FROM self;



/***** table creation and insertion *****/
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



INSERT INTO exhibitor VALUES
(0, 59, 'fan art', 20, 'Fancy Frontier 40'),
(1, 138, 'video game', 1, 'Comic World Taiwan 54'),
(2, 111, 'comic', 13, 'TAIPEI GAME SHOW 2021');

INSERT INTO artist VALUES
('Jaiden Dittfach', 23, 'America', NULL),
('Yiliang', 30, 'Taiwan', 0),
('Norman Auble', 43, 'America', NULL),
('Kota', 25, 'Korea', 1),
('Ivan Chakarov', 35, 'France', NULL),
('Ross Tran', 29, 'China', NULL),
('Mike Judge', 19, 'America', NULL);

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
(40000, 'junior animator', 8, 'Mike Judge', 132667754),
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
('Comic World Taiwan 54', '2021-03-27', 'NTU Sports Center'),
('Fancy Frontier 40', '2021-05-01', 'Taipei EXPO Park'),
('TAIPEI GAME SHOW 2021', '2020-12-23', 'Taipei Nangang Exhibition Center');

INSERT INTO animatedMovie VALUES
('Raya and the Last Dragon', 8.1, 'adventure'),
('Big Hero 6', 7.9, 'superhero'),
('Frozen', 9.5, 'magic'),
('Into the spider verse', 9.3, 'superhero');

INSERT INTO characters VALUES
('Hero', 'male', 155, 'Big Hero 6'),
('Raya', 'female', 170, 'Raya and the Last Dragon'),
('Peter Parker', 'male', 185, 'Into the spider verse'),
('White', 'others', 80, 'Big Hero 6'),
('White', 'male', 190, 'Frozen'),
('Anna', 'female', 168, 'Frozen');

INSERT INTO sponsor VALUES
(123456789, 'TAIPEI GAME SHOW 2021', 120),
(132667754, 'TAIPEI GAME SHOW 2021', 133),
(132667754, 'Fancy Frontier 40', 50);

INSERT INTO attend VALUES
('Fancy Frontier 40', 0, 1),
('Comic World Taiwan 54', 1, 5),
('TAIPEI GAME SHOW 2021', 2, 2);

INSERT INTO workOn VALUES
('Jaiden Dittfach', 'Big Hero 6', 'art director'),
('Kota', 'Frozen', 'graphic designer'),
('Norman Auble', 'Into the spider verse', 'storyboard');

INSERT INTO admire VALUES
('Yiliang', 'Ross Tran', 'Youtube'),
('Jaiden Dittfach', 'Ross Tran', 'ArtStation'),
('Kota', 'Jaiden Dittfach', 'Facebook');




/***** homework 3 commands *****/
/* basic select */
SELECT ArtistName FROM artist
Where (Nationality = 'America' AND ArtistAge = 43) OR (ArtistAge NOT BETWEEN 26 AND 50);

/* basic projection */
SELECT ArtistName, JobTitle, WorkingHours FROM fullTimeArtist;

/* basic rename */
SELECT ArtistName AS Name, ArtStyle AS ArtGenre, AnimationSoftware AS CommonlyUsedSoftware FROM animator
Where (ArtistName = 'Jaiden Dittfach') OR (AnimationSoftware = 'Stop Motion Studio');

/* union */
SELECT ArtistName, AnimationSoftware AS CommonlyUsedSoftware FROM animator
UNION
SELECT ArtistName, DrawingSoftware AS CommonlyUsedSoftware FROM illustrator;

/* equijoin */
SELECT freelancer.ArtistName, freelancer.Income, freelancer.StudioLocation, illustrator.RepresentativeWork, illustrator.Expertise
FROM freelancer
	JOIN illustrator
ON freelancer.ArtistName = illustrator.ArtistName;

/* natural join */
SELECT *
FROM exhibitor
NATURAL JOIN company;

/* theta join */
SELECT freelancer.ArtistName AS ArtistWithLowPay, freelancer.Income, fullTimeArtist.ArtistName AS ArtistWithHighPay, fullTimeArtist.Salary
FROM freelancer, fullTimeArtist
WHERE freelancer.Income < fullTimeArtist.Salary
ORDER BY freelancer.ArtistName;

/* three table join */
SELECT artist.ArtistName, animator.ArtStyle, fullTimeArtist.JobTitle, fullTimeArtist.Salary
FROM artist
    INNER JOIN fullTimeArtist ON artist.ArtistName = fullTimeArtist.ArtistName
    INNER JOIN animator ON artist.ArtistName  = animator.ArtistName 
ORDER BY artist.ArtistName;

/* aggregate */
SELECT Nationality, COUNT(*) AS NumberOfPeople, MAX(ArtistAge) AS OldestAge, MIN(Salary) AS MinimalSalary
FROM artist
	NATURAL JOIN fullTimeArtist
GROUP BY Nationality;

/* aggregate 2 */
SELECT characters.Gender, COUNT(*) AS NumberOfPeople, cast(AVG(characters.Height) as decimal(10,2)) AS AverageHeight, cast(SUM(animatedMovie.Rating) as decimal(10,2)) AS TotalMovieRating
FROM animatedMovie
	NATURAL JOIN characters
GROUP BY characters.Gender
	HAVING NumberOfPeople > 1;

/* in */
/* in 2 */
/* correlated nested query */
/* correlated nested query 2 */
/* bonus 1 */
/* bonus 2 */
/* bonus 3 */

/***** drop database *****/
DROP DATABASE ArtBusiness;