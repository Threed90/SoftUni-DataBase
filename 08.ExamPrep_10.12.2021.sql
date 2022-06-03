CREATE DATABASE Airport

USE Airport

-- DB CREATING
CREATE TABLE Passengers(
	Id INT PRIMARY KEY IDENTITY,
	FullName VARCHAR(100) NOT NULL UNIQUE,
	Email VARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE Pilots(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) NOT NULL UNIQUE,
	LastName VARCHAR(30) NOT NULL UNIQUE,
	Age TINYINT NOT NULL CHECK(Age BETWEEN 21 AND 62),
	Rating FLOAT CHECK((Rating >= 0 AND CEILING(Rating) BETWEEN 0 AND 10) OR Rating IS NULL)
)

CREATE TABLE AircraftTypes(
	Id INT PRIMARY KEY IDENTITY,
	TypeName VARCHAR(30)  NOT NULL UNIQUE
)

CREATE TABLE Aircraft(
	Id INT PRIMARY KEY IDENTITY,
	Manufacturer VARCHAR(25) NOT NULL,
	Model VARCHAR(30) NOT NULL,
	[Year] INT NOT NULL,
	FlightHours INT,
	Condition CHAR(1) NOT NULL, -- ?
	TypeId INT FOREIGN KEY REFERENCES AircraftTypes(Id) NOT NULL
)

CREATE TABLE PilotsAircraft(
	AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
	PilotId INT FOREIGN KEY REFERENCES Pilots(Id) NOT NULL,
	CONSTRAINT PK_Aircraft_Pilot PRIMARY KEY(AircraftId,PilotId)
)

CREATE TABLE Airports(
	Id INT PRIMARY KEY IDENTITY,
	AirportName VARCHAR(70) NOT NULL UNIQUE,
	Country VARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE FlightDestinations(
	Id INT PRIMARY KEY IDENTITY,
	AirportId INT FOREIGN KEY REFERENCES Airports(Id) NOT NULL,
	[Start] DATETIME NOT NULL,
	AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL,
	TicketPrice DECIMAL(18,2) NOT NULL DEFAULT(15)
)


-- INSERTS

INSERT INTO Passengers(FullName, Email)
SELECT
	FirstName + ' ' + LastName,
	FirstName + LastName + '@gmail.com'
	FROM Pilots
	WHERE Id BETWEEN 5 AND 15

-- UPDATES
UPDATE Aircraft
SET Condition = 'A'
WHERE Condition IN ('C', 'B') AND
	  (FlightHours IS NULL OR FlightHours <= 100) AND
	  [Year] >= 2013

-- DELETES
DELETE FROM Passengers
WHERE LEN(FullName) <= 10

-- SELECT QUERIES:

-- TASK - AIRCRAFT
SELECT 
		Manufacturer,
		Model,
		FlightHours,
		Condition
	FROM Aircraft
	ORDER BY FlightHours DESC

-- TASK - PILOTS AND AIRCRAFT
SELECT
	p.FirstName,
	p.LastName,
	a.Manufacturer,
	a.Model,
	a.FlightHours
FROM Pilots AS p
JOIN PilotsAircraft AS pa ON p.Id = pa.PilotId
JOIN Aircraft AS a ON a.Id = pa.AircraftId
WHERE FlightHours < 304 AND FlightHours IS NOT NULL
ORDER BY FlightHours DESC, FirstName ASC

-- TASK - TOP 20 FLIGHT DESTINATIONS

SELECT TOP(20)
	fd.Id AS DestinationId,
	fd.[Start],
	p.FullName,
	a.AirportName,
	fd.TicketPrice
FROM Passengers AS p
JOIN FlightDestinations AS fd ON p.Id = fd.PassengerId
JOIN Airports AS a ON fd.AirportId = a.Id
WHERE DAY([Start]) % 2 = 0
ORDER BY TicketPrice DESC, AirportName ASC


-- TASK - NUMBER OF FLIGHTS FOR EACH AIRCRAFT
SELECT
	a.Id AS AircraftId,
	(SELECT a2.Manufacturer FROM Aircraft AS a2 WHERE a.Id = a2.Id) AS Manufacturer,
	AVG(FlightHours) AS FlightHours,
	COUNT(*) AS FlightDestinationsCount,
	ROUND(AVG(TicketPrice), 2) AS AvgPrice
FROM Aircraft AS a
JOIN FlightDestinations AS d ON a.Id = d.AircraftId
GROUP BY a.Id
HAVING COUNT(*) >= 2
ORDER BY COUNT(*) DESC, a.Id

-- TASK - REGULAR PASSENGERS
SELECT
	FullName,
	COUNT(*) AS CountOfAircraft,
	SUM(TicketPrice) AS TotalPayed
FROM Passengers AS p
JOIN FlightDestinations AS d ON p.Id = d.PassengerId
JOIN Aircraft AS a ON a.Id = d.AircraftId
WHERE FullName LIKE '_a%'
GROUP BY FullName
HAVING COUNT(*) > 1
ORDER BY FullName

-- TASK - Full Info for Flight Destinations
SELECT 
		a.AirportName,
		[Start] AS DayTime,
		fd.TicketPrice,
		FullName,
		Manufacturer,
		Model
	FROM FlightDestinations AS fd
	JOIN Airports AS a ON fd.AirportId = a.Id
	JOIN Passengers AS p ON fd.PassengerId = p.Id
	JOIN Aircraft AS ac ON fd.AircraftId = ac.Id
	WHERE TicketPrice > 2500 AND 
		CAST([Start] AS TIME) BETWEEN '6:00' AND '20:00'
	ORDER BY Model

-- Programmability

-- TASK - Find all Destinations by Email Address
CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @numberfFlights INT = (SELECT COUNT(*)
										FROM FlightDestinations AS d
										JOIN Passengers AS p ON d.PassengerId = p.Id
										WHERE p.Email = @email)

	RETURN @numberfFlights;
END

-- TASK - Full Info for Airports

CREATE OR ALTER PROC usp_SearchByAirportName @airportName VARCHAR(70)
AS
SELECT
	AirportName,
	FullName,
	CASE
		WHEN TicketPrice <= 400 THEN 'Low'
		WHEN TicketPrice BETWEEN 401 AND 1500 THEN 'Medium'
		ELSE 'High'
	END AS LevelOfTickerPrice,
	Manufacturer,
	Condition,
	TypeName
FROM Airports AS a
JOIN FlightDestinations AS fd ON fd.AirportId = a.Id
JOIN Passengers AS p ON fd.PassengerId = p.Id
JOIN Aircraft AS ac ON fd.AircraftId = ac.Id
JOIN AircraftTypes AS t ON ac.TypeId = t.Id
WHERE AirportName = @airportName
ORDER BY Manufacturer, FullName

EXEC usp_SearchByAirportName 'Sir Seretse Khama International Airport'