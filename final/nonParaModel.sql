# source /Users/patty/GraduateFiles/DBMS/Homework/final/nonParaModel.sql

/***** create and use database *****/
-- CREATE DATABASE statisticsdb;
-- USE statisticsdb;

-- CREATE TABLE conditionA (
--     UserNum int NOT NULL,
--     Enjoyment int NOT NULL,
--     Realism int NOT NULL,
--     Immersion int NOT NULL,
--     PRIMARY KEY (UserNum)
-- );

-- CREATE TABLE conditionB (
--     UserNum int NOT NULL,
--     Enjoyment int NOT NULL,
--     Realism int NOT NULL,
--     Immersion int NOT NULL,
--     PRIMARY KEY (UserNum)
-- );

-- CREATE TABLE conditionC (
--     UserNum int NOT NULL,
--     Enjoyment int NOT NULL,
--     Realism int NOT NULL,
--     Immersion int NOT NULL,
--     PRIMARY KEY (UserNum)
-- );

-- INSERT INTO conditionA
-- VALUES
-- (0, 2, 1, 2),
-- (1, 3, 3, 4),
-- (2, 4, 4, 4),
-- (3, 4, 3, 3),
-- (4, 3, 3, 3),
-- (5, 3, 1, 1),
-- (6, 4, 4, 4),
-- (7, 2, 5, 4),
-- (8, 5, 6, 7),
-- (9, 3, 3, 3),
-- (10, 4, 4, 4),
-- (11, 4, 1, 1);

-- INSERT INTO conditionB
-- VALUES
-- (0, 5, 5, 6),
-- (1, 4, 4, 4),
-- (2, 1, 2, 3),
-- (3, 5, 5, 5),
-- (4, 4, 5, 5),
-- (5, 4, 2, 2),
-- (6, 5, 4, 4),
-- (7, 1, 5, 6),
-- (8, 2, 5, 5),
-- (9, 5, 6, 6),
-- (10, 7, 7, 7),
-- (11, 4, 3, 3);

-- INSERT INTO conditionC
-- VALUES
-- (0, 6, 6, 6),
-- (1, 6, 6, 6),
-- (2, 6, 5, 6),
-- (3, 6, 6, 6),
-- (4, 6, 6, 6),
-- (5, 5, 6, 6),
-- (6, 6, 6, 6),
-- (7, 4, 3, 5),
-- (8, 4, 5, 7),
-- (9, 7, 6, 6),
-- (10, 7, 6, 6),
-- (11, 5, 3, 3);

/***** Store Function and Store Procedure *****/
-- Calculate difference between two values
DELIMITER //
CREATE FUNCTION Diff(param1 float, param2 float) RETURNS float DETERMINISTIC
	BEGIN
	DECLARE difference float;
	SET difference = param2 - param1;
	RETURN difference;
	END //

-- Wilconxon algorithm
DROP PROCEDURE IF EXISTS `Wilcoxon`//
CREATE PROCEDURE `Wilcoxon`(IN uid varchar(25), IN table1 varchar(25), IN table2 varchar(25), IN columnName1 varchar(25), IN columnName2 varchar(25))
	BEGIN
		-- set up variables
		DECLARE totalRowNumber INT DEFAULT 1;
		DECLARE negativeM FLOAT DEFAULT 0;
		DECLARE positiveM FLOAT DEFAULT 0;
		DECLARE rValue FLOAT DEFAULT 0;
		DECLARE pColumnName varchar(20);

		DROP TEMPORARY TABLE IF EXISTS `TempTable`;
		DROP TABLE IF EXISTS `RankTable`;
		CREATE TABLE RankTable(
			UserID int NOT NULL,
			Difference float,
			Absolute float,
			Ranking float,
			PRIMARY KEY(UserID)
		);

		-- Get difference between column1 and column2
		SET @statement1 = CONCAT('CREATE TEMPORARY TABLE TempTable SELECT t1.', uid ,' AS UserID, t1.', columnName1, ' AS column1, t2.', columnName2, ' AS column2, Diff(t1.', columnName1, ', t2.', columnName2, ') AS difference FROM ', table1, ' AS t1, ', table2, ' AS t2 WHERE t1.', uid ,' = t2.', uid ,';');
		PREPARE stmt1 FROM @statement1;
		EXECUTE stmt1;
		DEALLOCATE PREPARE stmt1;

		-- Get absolute difference value & remove 0
		INSERT INTO RankTable(UserID, Difference, Absolute)
		SELECT UserID, Difference, ABS(Difference)
		FROM TempTable
		WHERE ABS(Difference) > 0;

		DROP TEMPORARY TABLE TempTable;

		ALTER TABLE RankTable ORDER BY Absolute ASC;

		--  count rows
		SELECT COUNT(*)
		INTO totalRowNumber
		FROM RankTable;

		SELECT totalRowNumber;

		-- Set default rank
		SET @var:=0;
		UPDATE RankTable SET Ranking=(@var:=@var+1) ORDER BY Absolute ASC;
		ALTER TABLE RankTable AUTO_INCREMENT=1; 


		-- Group the same value together for the ranking
		CREATE TEMPORARY TABLE TempTable
		SELECT rt.Absolute AS AbsoluteGroup, COUNT(rt.Absolute) AS Total, SUM(rt.Ranking)/COUNT(rt.Absolute) AS TiedRank
		FROM RankTable AS rt
		GROUP BY rt.Absolute
		ORDER BY AbsoluteGroup;

		-- SELECT * FROM TempTable;

		-- Update the ranking
		UPDATE RankTable AS rt, (SELECT * FROM TempTable) AS tempt
		SET rt.Ranking = tempt.TiedRank
		WHERE tempt.AbsoluteGroup = rt.Absolute;

		-- SELECT * FROM RankTable ORDER BY Absolute ASC;

		-- Select ranking if its difference is negative (M-)
		SELECT SUM(rt.Ranking) INTO negativeM
		FROM RankTable AS rt
		WHERE rt.Difference < 0;

		-- Select ranking if its difference is positive (M+)
		SELECT SUM(rt.Ranking) INTO positiveM
		FROM RankTable AS rt
		WHERE rt.Difference > 0;

		-- Choose the smaller number as R
		IF positiveM > negativeM THEN
			SET rValue = negativeM;
		ELSEIF positiveM <= negativeM THEN
			SET rValue = positiveM;
		END IF;

		SELECT rValue; 

		SET pColumnName = concat('N', '_', CAST(totalRowNumber AS CHAR(5)));
		SET @prepS = CONCAT('SELECT Min(', pColumnName, ') AS p FROM Wilconxon_p_table WHERE R_Value > ', rValue);
		PREPARE stmt FROM @prepS;
		EXECUTE stmt;

		-- SELECT Min(pColumnName)
		-- FROM Wilconxon_p_table
		-- WHERE R_Value > rValue;
		
		DROP TEMPORARY TABLE TempTable;
		DROP TABLE RankTable;
	END//


DELIMITER //
CREATE FUNCTION RankRow(col1 float, col2 float, col3 float) RETURNS float DETERMINISTIC
	BEGIN
	DECLARE rankNumber float;
		IF col1 < col2 THEN
			IF col1 < col3 THEN
				SET rankNumber = 1;
			ELSEIF col1 > col3 THEN
				SET rankNumber = 2;
			ELSEIF col1 = col3 THEN
				SET rankNumber = 1.5;
			END IF;
		ELSEIF col1 > col2 THEN
			IF col1 < col3 THEN
				SET rankNumber = 2;
			ELSEIF col1 > col3 THEN
				SET rankNumber = 3;
			ELSEIF col1 = col3 THEN
				SET rankNumber = 2.5;
			END IF;
		ELSEIF col1 = col2 THEN
			IF col1 < col3 THEN
				SET rankNumber = 1.5;
			ELSEIF col1 > col3 THEN
				SET rankNumber = 2.5;
			ELSEIF col1 = col3 THEN
				SET rankNumber = 2;
			END IF;
		END IF;
	RETURN rankNumber;
	END //

-- Friedman's ANOVA
DROP PROCEDURE IF EXISTS `Friedman`//
CREATE PROCEDURE `Friedman`(IN uid varchar(25), IN table1 varchar(25), IN table2 varchar(25), IN table3 varchar(25), IN columnName1 varchar(25), IN columnName2 varchar(25), IN columnName3 varchar(25))
	BEGIN
		DECLARE sumCol1 FLOAT DEFAULT 0;
		DECLARE sumCol2 FLOAT DEFAULT 0;
		DECLARE sumCol3 FLOAT DEFAULT 0;
		DECLARE powSum FLOAT DEFAULT 0;

		DECLARE cValue FLOAT DEFAULT 0;
		DECLARE tValue1 FLOAT DEFAULT 0;
		DECLARE tValue2 FLOAT DEFAULT 0;
		DECLARE tempValue FLOAT DEFAULT 0;
		DECLARE totalRowNumber INT DEFAULT 1;

		DROP TEMPORARY TABLE IF EXISTS `TempTable`;
		DROP TABLE IF EXISTS `RankTable`;
		CREATE TABLE RankTable(
			UserID int NOT NULL,
			Ranking1 float DEFAULT 1,
			Ranking2 float DEFAULT 2,
			Ranking3 float DEFAULT 3,
			PRIMARY KEY(UserID)
		);

		-- Get difference between column1 and column2
		SET @statement2 = CONCAT('CREATE TEMPORARY TABLE TempTable SELECT t1.', uid ,' AS UserID, t1.', columnName1, ' AS column1, t2.', columnName2, ' AS column2, t3.', columnName3, ' AS column3 FROM ', table1, ' AS t1, ', table2, ' AS t2, ', table3, ' AS t3 WHERE t1.', uid ,' = t2.', uid ,' AND t1.', uid ,' = t3.', uid ,';');
		PREPARE stmt2 FROM @statement2;
		EXECUTE stmt2;
		DEALLOCATE PREPARE stmt2;

		-- Rank each row: 1-3
		INSERT INTO RankTable(UserID, Ranking1, Ranking2, Ranking3)
		SELECT UserID, RankRow(column1, column2, column3) AS r1, RankRow(column2, column1, column3) AS r2, RankRow(column3, column2, column1) AS r3
		FROM TempTable;

		SELECT * FROM RankTable;

		-- summed rank in each column
		SELECT SUM(Ranking1), SUM(Ranking2), SUM(Ranking3)
		INTO sumCol1, sumCol2, sumCol3
		FROM RankTable; 

		-- quadratic sum of all ranks: A
		SELECT SUM(POWER(Ranking1, 2)+ POWER(Ranking2, 2)+POWER(Ranking3, 2))
		INTO powSum
		FROM RankTable; 

		--  count rows: B
		SELECT COUNT(*)
		INTO totalRowNumber
		FROM RankTable;

		-- calculate C
		SET cValue = (totalRowNumber * 3 * POWER(3+1, 2))/4;
		-- calculate T1
		SET tempValue = POWER(sumCol1-totalRowNumber*(3+1)/2, 2) + POWER(sumCol2-totalRowNumber*(3+1)/2, 2) + POWER(sumCol3-totalRowNumber*(3+1)/2, 2);
		SET tValue1 = ((3-1) * tempValue) /(powSum-cValue);
		-- calculate T2 using T1
		SET tValue2 = ((totalRowNumber-1)*tValue1) / (totalRowNumber*(3-1) - tValue1);

		SELECT tValue2 AS T2;

		DROP TEMPORARY TABLE TempTable;
		DROP TABLE RankTable;
	END//
DELIMITER ;


/***** main *****/
CALL Wilcoxon('UserNum', 'conditionB', 'conditionC', 'Immersion', 'Immersion');
-- CALL Friedman('UserNum', 'conditionA', 'conditionB', 'conditionC', 'Enjoyment', 'Enjoyment', 'Enjoyment');


/***** drop database *****/
-- DROP DATABASE statisticsdb;