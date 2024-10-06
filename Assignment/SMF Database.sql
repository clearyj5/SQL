DROP DATABASE IF EXISTS smf_db;
CREATE DATABASE smf_db; 
USE smf_db;

SET NAMES utf8 ;
SET character_set_client = utf8mb4 ;

CREATE TABLE `Sectors` (
  `Sector ID` int(2) NOT NULL AUTO_INCREMENT,
  `Sector Name` varchar(25) NOT NULL UNIQUE,
  PRIMARY KEY (`Sector ID`)
);

INSERT INTO `Sectors` VALUES (1, "Committee");
INSERT INTO `Sectors` VALUES (DEFAULT, "Energy");
INSERT INTO `Sectors` VALUES (DEFAULT, "Discretionary");
INSERT INTO `Sectors` VALUES (DEFAULT, "Technology - Softare");
INSERT INTO `Sectors` VALUES (DEFAULT, "Technology - Hardware");

CREATE TABLE `Roles` (
  `Code` varchar(4) NOT NULL UNIQUE,
  `Name` varchar(50) NOT NULL UNIQUE,
  PRIMARY KEY (`Code`)
);
INSERT INTO `Roles` VALUES ("CTO", "Chief Technology Officer");
INSERT INTO `Roles` VALUES ("CEO", "Chief Executive Officer");
INSERT INTO `Roles` VALUES ("HWIB", "Head of Women in Business");
INSERT INTO `Roles` VALUES ("COO", "Chief Operating Officer");
INSERT INTO `Roles` VALUES ("HAI", "Head of Alternative Investments");
INSERT INTO `Roles` VALUES ("SM", "Sector Manager");
INSERT INTO `Roles` VALUES ("SA", "Senior Analyst");
INSERT INTO `Roles` VALUES ("JA", "Junior Analyst");

CREATE TABLE `Years` (
  `Year` int(1) NOT NULL UNIQUE,
  `Name` varchar(20) NOT NULL UNIQUE,
  PRIMARY KEY (`Year`),
  CHECK (`Year` < 6)
);
INSERT INTO `Years` VALUES (1, "Junior Fresh");
INSERT INTO `Years` VALUES (2, "Senior Fresh");
INSERT INTO `Years` VALUES (3, "Junior Sophister");
INSERT INTO `Years` VALUES (4, "Senior Sophister");
INSERT INTO `Years` VALUES (5, "Other");

CREATE TABLE `Sponsors` (
  `Sponsor ID` int(2) NOT NULL AUTO_INCREMENT,
  `Name` varchar(30) NOT NULL,
  PRIMARY KEY (`Sponsor ID`)
);
INSERT INTO `Sponsors` VALUES (1, "PWC");
INSERT INTO `Sponsors` VALUES (DEFAULT, "Elkstone");
INSERT INTO `Sponsors` VALUES (DEFAULT, "Davy");
INSERT INTO `Sponsors` VALUES (DEFAULT, "Setanta");
INSERT INTO `Sponsors` VALUES (DEFAULT, "Arthur Cox");

CREATE TABLE `Members` (
  `Member ID` int(4) NOT NULL AUTO_INCREMENT,
  `Name` varchar(30) NOT NULL,
  `Role` varchar(20) NOT NULL ,
  `Sector`int(2) NOT NULL ,
  `Year` int(1) NOT NULL ,
  FOREIGN KEY `fk_Role` (`Role`) REFERENCES Roles(`Code`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY `fk_Sector` (`Sector`) REFERENCES Sectors(`Sector ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY `fk_Year` (`Year`) REFERENCES Years(`Year`) ON DELETE CASCADE ON UPDATE CASCADE,  
  PRIMARY KEY (`Member ID`)
);

ALTER TABLE `Members` ADD `Email` varchar(50) NOT NULL UNIQUE AFTER `Year`;
ALTER TABLE `Members` ADD CONSTRAINT CHECK (`Email` LIKE '%@tcd.ie');

INSERT INTO `Members` VALUES (1, "Jack", "CTO", "1", 4, "jack@tcd.ie");
INSERT INTO `Members` VALUES (DEFAULT, "Ciaran", "CEO", "1", 4, "ciaran@tcd.ie");
INSERT INTO `Members` VALUES (DEFAULT, "Will", "CEO", "1", 4, "will@tcd.ie");
INSERT INTO `Members` VALUES (DEFAULT, "Lucy", "HWIB", "1", 4, "skellucy3@tcd.ie");
INSERT INTO `Members` VALUES (DEFAULT, "Jane", "HAI", "1", 4, "hayesnj@tcd.ie");
INSERT INTO `Members` VALUES (DEFAULT, "Aoife", "COO", "1", 4, "mulaoife@tcd.ie");
INSERT INTO `Members` VALUES (DEFAULT, "Jim", "SM", "3", 3, "jim1@tcd.ie");
INSERT INTO `Members` VALUES (DEFAULT, "John", "SM", "2", 3, "John2@tcd.ie");
INSERT INTO `Members` VALUES (DEFAULT, "Joe", "SM", "4", 2, "Joe3@tcd.ie");
INSERT INTO `Members` VALUES (DEFAULT, "James", "SA", "3", 1, "James4@tcd.ie");
INSERT INTO `Members` VALUES (DEFAULT, "Mike", "JA", "3", 1, "Mike5@tcd.ie");
INSERT INTO `Members` VALUES (DEFAULT, "Bahman", "JA", "2", 2, "Bahman6@tcd.ie");
INSERT INTO `Members` VALUES (DEFAULT, "Alessio", "JA", "4", 1, "Alessio7@tcd.ie");

CREATE TABLE `Holdings` (
  `Ticker` varchar(6) NOT NULL UNIQUE,
  `Company Name` varchar(30) NOT NULL,
  `Sector`int(2) NOT NULL,
  FOREIGN KEY (Sector) REFERENCES Sectors(`Sector ID`),
  PRIMARY KEY (`Ticker`)
);
INSERT INTO `Holdings` VALUES ("LVMH", "Moet, Hennessy, Louis Vuitton", "3");
INSERT INTO `Holdings` VALUES ("NKE", "Nike Inc", "3");
INSERT INTO `Holdings` VALUES ("RYA", "Ryanair Holdings PLC", "3");
INSERT INTO `Holdings` VALUES ("LNG", "Cheniere Energy", "2");
INSERT INTO `Holdings` VALUES ("DUK", "Duke Energy", "2");
INSERT INTO `Holdings` VALUES ("MSFT", "Microsoft", "4");
INSERT INTO `Holdings` VALUES ("AAPL", "Apple Inc", "4");
INSERT INTO `Holdings` VALUES ("SIE", "Siemens", "5");

CREATE TABLE `Meetings` (
	`Sector` int(2) NOT NULL,
    `Day` varchar(9) NOT NULL,
    `Time` time NOT NULL,
    `Room` varchar(10) NOT NULL,
    PRIMARY KEY (Sector),
    FOREIGN KEY (Sector) REFERENCES Sectors(`Sector ID`)
);
INSERT INTO `Meetings` VALUES ("1", "Wednesday", "19:00", "Board Room");
INSERT INTO `Meetings` VALUES ("2", "Tuesday", "19:00", "B134");
INSERT INTO `Meetings` VALUES ("3", "Thursday", "18:00", "B129");
INSERT INTO `Meetings` VALUES ("4", "Tuesday", "19:00", "B130");
INSERT INTO `Meetings` VALUES ("5", "Monday", "17:00", "B125");

CREATE TABLE `Events` (
	`Event ID` varchar(5) NOT NULL UNIQUE,
    `Event Name` varchar(40) NOT NULL,
    `Date` date NOT NULL,
    `Sponsor` int(2) NOT NULL,
    PRIMARY KEY(`Event ID`),
    FOREIGN KEY(`Sponsor`) REFERENCES Sponsors(`Sponsor ID`)
);

DROP TRIGGER IF EXISTS `Verify Event Date`;
delimiter //
CREATE TRIGGER `Verify Event Date` BEFORE INSERT 
ON `Events`
FOR EACH ROW
IF NEW.`Date` >= curdate() THEN
SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = "Input Date is invalid, cannot be a future date.";
END IF; 
//

INSERT INTO `Events` VALUES ("LPC", "Leadership Perspectives Conference", "2022-03-03", "1");
INSERT INTO `Events` VALUES ("WIB", "Women in Business Conference", "2022-02-05", "3");
INSERT INTO `Events` VALUES ("GS1", "Guest Speaker", "2021-11-28", "5");
INSERT INTO `Events` VALUES ("EDU1", "Educlass", "2021-12-03", "4");
INSERT INTO `Events` VALUES ("AIC", "Alternative Investments Conference", "2021-10-26", "2");
INSERT INTO `Events` VALUES ("GS2", "Guest Speaker", "2021-10-12", "1");
INSERT INTO `Events` VALUES ("EDU2", "Educlass", "2021-9-30", "1");
INSERT INTO `Events` VALUES ("EDU3", "Educlass", "2021-9-15", "3");

CREATE TABLE `Event Organisers` (
	`Event ID` varchar(5) NOT NULL,
    `Organiser` varchar(4) NOT NULL,
    FOREIGN KEY(`Event ID`) REFERENCES `Events`(`Event ID`),
    FOREIGN KEY(`Organiser`) REFERENCES Roles(`Code`),
    PRIMARY KEY(`Event ID`, `Organiser`)
);
INSERT INTO `Event Organisers` VALUES ("LPC", "CEO");
INSERT INTO `Event Organisers` VALUES ("LPC", "COO");
INSERT INTO `Event Organisers` VALUES ("WIB", "HWIB");
INSERT INTO `Event Organisers` VALUES ("WIB", "COO");
INSERT INTO `Event Organisers` VALUES ("GS1", "COO");
INSERT INTO `Event Organisers` VALUES ("EDU1", "COO");
INSERT INTO `Event Organisers` VALUES ("AIC", "HAI");
INSERT INTO `Event Organisers` VALUES ("AIC", "COO");
INSERT INTO `Event Organisers` VALUES ("GS2", "COO");
INSERT INTO `Event Organisers` VALUES ("EDU2", "COO");
INSERT INTO `Event Organisers` VALUES ("EDU3", "COO");

DELIMITER $$
CREATE FUNCTION SponsorLevel(
	no_events int
) 
RETURNS VARCHAR(8)
DETERMINISTIC
BEGIN
    DECLARE sponsorLevel VARCHAR(8);
    IF no_events > 2 THEN
		SET sponsorLevel = 'PLATINUM';
    ELSEIF no_events = 2 THEN
        SET sponsorLevel = 'GOLD';
    ELSEIF no_events < 2 THEN
        SET sponsorLevel = 'SILVER';
    END IF;
	RETURN (sponsorLevel);
END$$
DELIMITER ;

DROP VIEW IF EXISTS `Committee Members`;
CREATE VIEW `Committee Members` 
AS
SELECT `Member ID`, `Name`, `Role`, `Year`, `Email` FROM `Members` WHERE `Sector` = 1;

DROP VIEW IF EXISTS `Energy Sector`;
CREATE VIEW `Energy Sector` 
AS
SELECT `Member ID`, `Name`, `Role`, `Year`, `Email` FROM `Members` WHERE `Sector` = 2;

DROP VIEW IF EXISTS `Consumer Discretionary Sector`;
CREATE VIEW `Consumer Discretionary Sector` 
AS
SELECT `Member ID`, `Name`, `Role`, `Year`, `Email` FROM `Members` WHERE `Sector` = 3;

DROP VIEW IF EXISTS `Technology Software Sector`;
CREATE VIEW `Technology Software Sector` 
AS
SELECT `Member ID`, `Name`, `Role`, `Year`, `Email` FROM `Members` WHERE `Sector` = 4;

DROP VIEW IF EXISTS `Technology Hardware Sector`;
CREATE VIEW `Technology Hardware Sector` 
AS
SELECT `Member ID`, `Name`, `Role`, `Year`, `Email` FROM `Members` WHERE `Sector` = 5;

DROP VIEW IF EXISTS `Number of Members by Sector`;
CREATE VIEW `Number of Members by Sector` 
AS
SELECT `Sectors`.`Sector Name`, COUNT(*) AS `Number of Members` 
FROM `Members`
INNER JOIN `Sectors` ON `Sectors`.`Sector ID` = `Members`.`Sector`
GROUP BY `Sector`;

DROP VIEW IF EXISTS `Number of Holdings by Sector`;
CREATE VIEW `Number of Holdings by Sector` 
AS
SELECT `Sectors`.`Sector Name`, COUNT(*) AS `Number of Holdings` 
FROM `Holdings`
INNER JOIN `Sectors` ON `Sectors`.`Sector ID` = `Holdings`.`Sector`
GROUP BY `Sector`;

DROP VIEW IF EXISTS `Number of Events by Sponsor`;
CREATE VIEW `Number of Events by Sponsor` 
AS
SELECT `Sponsors`.`Sponsor ID`, `Sponsors`.`Name`, COUNT(*) AS `Number of Events` 
FROM `Events`
INNER JOIN `Sponsors` ON `Sponsors`.`Sponsor ID` = `Events`.`Sponsor`
GROUP BY `Sponsor`;

SELECT `Sponsors`.`Name` AS `Event Sponsor`, `Events`.`Event Name`, `Events`.`Date`
FROM `Sponsors`
INNER JOIN `Events` ON `Events`.`Sponsor` = `Sponsors`.`Sponsor ID`;

DELIMITER //
CREATE PROCEDURE getSponsorLevels()
BEGIN
	SELECT `Sponsor ID`, `Name`, SponsorLevel(`Number of Events`) AS `Sponsor Level`
    FROM smf_db.`number of events by sponsor`;
END //
DELIMITER ;

DROP ROLE IF EXISTS committee_member@'%';
CREATE ROLE committee_member@'%';
GRANT SELECT ON smf_db.* TO committee_member;
GRANT INSERT,DELETE,UPDATE ON smf_db.`Members` TO committee_member;

DROP USER IF EXISTS Lucy@'%';
CREATE USER Lucy@'%' IDENTIFIED BY "smf123";
GRANT committee_member TO Lucy@'%';

DROP USER IF EXISTS Jane@'%';
CREATE USER Jane@'%' IDENTIFIED BY "smf123";
GRANT committee_member TO Jane@'%';

DROP USER IF EXISTS Aoife@'%';
CREATE USER Aoife@'%' IDENTIFIED BY "smf123";
GRANT committee_member TO Aoife@'%';


DROP ROLE IF EXISTS all_access@'%';
CREATE ROLE all_access@'%';
GRANT SELECT ON smf_db.* TO all_access;
GRANT INSERT,DELETE,UPDATE ON smf_db.* TO all_access;

DROP USER IF EXISTS Jack@'%';
CREATE USER Jack@'%' IDENTIFIED BY "smf123!";
GRANT all_access TO Jack@'%';

DROP USER IF EXISTS Ciaran@'%';
CREATE USER Ciaran@'%' IDENTIFIED BY "smf123!";
GRANT all_access TO Ciaran@'%';

DROP USER IF EXISTS Will@'%';
CREATE USER Will@'%' IDENTIFIED BY "smf123!";
GRANT all_access TO Will@'%';
