-- TASK 1
SELECT
	Firstname,
	Lastname
FROM Employees
WHERE FirstName LIKE 'Sa%'

-- TASK 2
SELECT
	Firstname,
	Lastname
FROM Employees
WHERE LastName LIKE '%ei%'

-- TASK 3
SELECT
	Firstname
FROM Employees
WHERE DepartmentID IN (3, 10) AND 
	  YEAR(Hiredate) BETWEEN 1995 AND 2005

-- TASK 4
SELECT
	Firstname,
	Lastname
FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

-- TASK 5
SELECT
	[Name]
FROM Towns
WHERE LEN([Name]) IN (5,6)
ORDER BY [Name]

-- TASK 6
SELECT
	TownID,
	[Name]
FROM Towns
WHERE LEFT([Name], 1) IN ('M', 'K', 'B', 'E')
ORDER BY [Name]

-- TASK 7
SELECT
	TownID,
	[Name]
FROM Towns
WHERE LEFT([Name], 1) NOT IN ('R', 'B', 'D')
ORDER BY [Name]

-- TASK 8
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT
	Firstname,
	Lastname
FROM Employees
WHERE YEAR(Hiredate) > 2000

SELECT * FROM V_EmployeesHiredAfter2000

-- TASK 9
SELECT
	Firstname,
	Lastname
FROM Employees
WHERE LEN(LastName) = 5

-- TASK 10 AND 11
SELECT *
FROM (SELECT 
		EmployeeID,
		Firstname,
		Lastname,
		Salary,
		DENSE_RANK() OVER (
			PARTITION BY Salary
			ORDER BY EmployeeID ASC) AS [Rank]
	  FROM Employees) AS rt
WHERE rt.Salary BETWEEN 10000 AND 50000 AND rt.[Rank] = 2
ORDER BY Salary DESC

-- TASK 12
SELECT 
	CountryName AS [Country Name],
	IsoCode AS [ISO Code]
FROM Countries
WHERE CountryName LIKE '%a%a%a%'
ORDER BY IsoCode

-- TASK 13
SELECT 
	PeakName,
	RiverName,
	LOWER(PeakName + SUBSTRING(Rivername, 2, LEN(Rivername) - 1)) AS Mix
FROM Peaks
INNER JOIN Rivers ON RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY Mix

-- TASK 14
SELECT TOP(50)
	[Name],
	FORMAT([Start], 'yyyy-MM-dd') AS [Start]
FROM Games
WHERE YEAR([Start]) IN (2011, 2012)
ORDER BY [Start], [Name]

-- TASK 15
SELECT 
	Username,
	SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email) - CHARINDEX('@', Email)) AS [Email Provider]
FROM Users
ORDER BY [Email Provider] ASC, Username

-- TASK 16
SELECT
	Username,
	IpAddress
FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

-- TASK 17
SELECT *
	FROM (SELECT
		[Name],
		(CASE 
		WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
		WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
		WHEN DATEPART(HOUR, [Start]) BETWEEN 18 AND 23 THEN 'Evening'
		END) AS [Part of the Day],
		(CASE
		WHEN Duration <= 3 THEN 'Extra Short'
		WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
		WHEN Duration >= 7 THEN 'Long'
		ELSE 'Extra Long'
		END) AS Duration
	FROM Games) AS tdb
ORDER BY [Name], Duration, [Part of the Day]

-- TASK 18
SELECT 
	ProductName,
	OrderDate,
	DATEADD(day, 3, OrderDate) AS [Pay Due],
	DATEADD(month, 1, OrderDate) AS [Deliver Due]
FROM Orders

-- TASK 19
CREATE TABLE People(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	Birthdate DATETIME2 NOT NULL
)

INSERT INTO People
VALUES 
	('Victor', '2000-12-07 00:00:00.000'),
	('Steven', '1992-09-10 00:00:00.000'),
	('Stephen', '1910-09-19 00:00:00.000'),
	('John', '2010-01-06 00:00:00.000')

SELECT
	[Name],
	DATEDIFF(year, Birthdate, GETDATE()) AS [Age in Years],
	DATEDIFF(month, Birthdate, GETDATE()) AS [Age in Months],
	DATEDIFF(day, Birthdate, GETDATE()) AS [Age in Days],
	DATEDIFF(minute, Birthdate, GETDATE()) AS [Age in Minutes]
INTO PersonAges
FROM People
