CREATE DATABASE ReportService
GO
USE ReportService
GO

-- DDL

CREATE TABLE Users(
	Id INT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(50) NOT NULL,
	[Name] VARCHAR(50),
	Birthdate DATETIME2,
	Age INT CHECK(Age BETWEEN 14 AND 110),
	Email VARCHAR(50) NOT NULL
)

CREATE TABLE Departments(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(25),
	LastName VARCHAR(25),
	Birthdate DATETIME2,
	Age INT CHECK(Age BETWEEN 18 AND 110),
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
)

CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL
)

CREATE TABLE [Status](
	Id INT PRIMARY KEY IDENTITY,
	[Label] VARCHAR(30) NOT NULL
)

CREATE TABLE Reports(
	Id INT PRImARY KEY IDENTITY,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	StatusId INT FOREIGN KEY REFERENCES [Status](Id) NOT NULL,
	OpenDate DATETIME2 NOT NULL,
	CloseDate DATETIME2,
	[Description] VARCHAR(200) NOT NULL,
	UserId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id)
)

-- INSERT
INSERT INTO Employees(FirstName, LastName, Birthdate, DepartmentId)
VALUES
	('Marlo', 'O''Malley', '1958-9-21', 1),
	('Niki', 'Stanaghan', '1969-11-26', 4),
	('Ayrton', 'Senna', '1960-03-21', 9),
	('Ronnie', 'Peterson', '1944-02-14', 9),
	('Giovanna', 'Amati', '1959-07-20', 5)

INSERT INTO Reports(CategoryId, StatusId, OpenDate, CloseDate, [Description], UserId, EmployeeId)
VALUES
	(1,	1,	'2017-04-13', NULL,		'Stuck Road on Str.133',	6,	2),
	(6,	3,	'2015-09-05',	'2015-12-06',	'Charity trail running',	3,	5),
	(14,	2,	'2015-09-07', NULL,		'Falling bricks on Str.58',	5,	2),
	(4,	3,	'2017-07-03',	'2017-07-06',	'Cut off streetlight on Str.11',	1,	1)

-- UPDATE
UPDATE Reports
SET CloseDate = GETDATE()
WHERE CloseDate IS NULL

-- DELETE
DELETE FROM Reports
WHERE StatusId = 4

-- TASK 5.Unassigned Reports
SELECT
		[Description],
		FORMAT(OpenDate, 'dd-MM-yyyy') AS OpenDate
	FROM Reports AS r
	WHERE EmployeeId IS NULL
	ORDER BY r.OpenDate, [Description] ASC

-- TASK 6.Reports & Categories
SELECT
	[Description],
	c.[Name] AS CategoryName
FROM Reports AS r
JOIN Categories AS c ON r.CategoryId = c.Id
ORDER BY [Description], CategoryName

-- TASK 7.Most Reported Category
SELECT TOP(5)
	[Name] AS CategoryName,
	COUNT(*) AS ReportsNumber
FROM Reports AS r
JOIN Categories AS c ON r.CategoryId = c.Id
GROUP BY [Name]
ORDER BY COUNT(*) DESC

-- TASK 8.Birthday Report
SELECT 
	Username,
	c.[Name] AS CategoryName
FROM Reports AS r
JOIN Categories AS c ON r.CategoryId = c.Id
JOIN Users AS u ON r.UserId = u.Id
WHERE MONTH(u.Birthdate) = MONTH(r.OpenDate) AND DAY(u.Birthdate) = DAY(r.OpenDate)
ORDER BY Username, CategoryName

-- TASK 9.Users per Employee 
SELECT
	CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
	COUNT(r.UserId) AS UsersCount
FROM Reports AS r
RIGHT JOIN Employees AS e ON r.EmployeeId = e.Id
LEFT JOIN Users AS u ON r.UserId = u.Id
GROUP BY FirstName, LastName
ORDER BY UsersCount DESC, FullName


-- TASK 10.Full Info
SELECT 
	CASE
		WHEN e.FirstName IS NULL OR e.LastName IS NULL THEN 'None'
		ELSE CONCAT(e.FirstName, ' ', e.LastName) 
	END AS Employee,
	ISNULL(d.[Name], 'None') AS Department,
	ISNULL(c.[Name], 'None') AS Category,
	ISNULL(r.[Description], 'None') AS [Description],
	ISNULL(FORMAT(r.OpenDate, 'dd.MM.yyyy'), 'None') AS OpenDate,
	ISNULL(s.[Label], 'None') AS [Status],
	ISNULL(u.[Name], 'None') AS [User]
FROM Reports AS r
LEFT JOIN Employees AS e ON e.Id = r.EmployeeId
LEFT JOIN Departments AS d ON d.Id = e.DepartmentId
LEFT JOIN Categories AS c ON r.CategoryId = c.Id
LEFT JOIN [Status] AS s ON s.Id = r.StatusId
LEFT JOIN Users AS u ON u.Id = r.UserId
ORDER BY e.FirstName DESC, 
		 e.LastName DESC,
		 Department ASC, 
		 Category ASC, 
		 [Description] ASC, 
		 r.OpenDate ASC,
		 [Status] ASC,
		 [User] ASC

-- “¿—  11.Hours to Complete
CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME2, @EndDate DATETIME2)
RETURNS INT
AS
BEGIN
	DECLARE @hours INT = 0;

	IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL
	BEGIN
	 SET @hours = DATEDIFF(hour, @StartDate, @EndDate);
	END

	RETURN @hours;
END

-- TASK 12.Assign Employee
CREATE PROC usp_AssignEmployeeToReport @EmployeeId INT, @ReportId INT
AS
BEGIN
	DECLARE @categoryId INT = (SELECT TOP(1) CategoryId
								FROM Reports
								WHERE Id = @ReportId);
	DECLARE @categoryDepId INT = (SELECT TOP(1)
									DepartmentId
									FROM Categories
									WHERE Id = @categoryId);
	DECLARE @employeeDepId INT = (SELECT TOP(1) DepartmentId
									FROM Employees
									WHERE Id = @EmployeeId);

	IF(@categoryDepId <> @employeeDepId)
		THROW 50001, 'Employee doesn''t belong to the appropriate department!', 1;
	ELSE
		BEGIN
			UPDATE Reports
			SET EmployeeId = @EmployeeId
			WHERE @categoryDepId = @employeeDepId
		END


END
