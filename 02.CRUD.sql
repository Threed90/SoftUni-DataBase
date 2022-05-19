USE SoftUni

-- Task 2
SELECT * FROM Departments

-- Task 3
SELECT [Name] FROM Departments

-- Task 4
SELECT FirstName, LastName, Salary FROM Employees

-- Task 5
SELECT FirstName, MiddleName, LastName FROM Employees

-- Task 6
SELECT CONCAT_WS('.', FirstName, LastName) + '@softuni.bg' AS [Full Email Address] FROM Employees

-- Task 7
SELECT DISTINCT Salary FROM Employees

-- Task 8
SELECT *
	FROM Employees
	WHERE JobTitle = 'Sales Representative'

-- Task 9
SELECT
	Firstname,
	Lastname,
	JobTitle
FROM Employees
WHERE Salary BETWEEN 20000 AND 30000

-- Task 10
SELECT
	FirstName + ' ' + ISNULL(Middlename + ' ', '') + LastName AS [Full Name]
FROM Employees
WHERE Salary IN (25000, 14000, 12500,23600)

-- Task 11
SELECT
	Firstname,
	Lastname
FROM Employees
WHERE ManagerID IS NULL

-- Task 12
SELECT
	Firstname,
	Lastname,
	Salary
FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC

-- Task 13
SELECT TOP (5)
	Firstname,
	Lastname
FROM Employees
ORDER BY Salary DESC

-- Task 14
SELECT
	Firstname,
	Lastname
FROM Employees as Emp
WHERE Emp.DepartmentID <> (SELECT TOP (1) Dep.DepartmentID FROM Departments AS Dep WHERE [Name] = 'Marketing')

-- Task 15
SELECT * 
FROM Employees
ORDER BY Salary DESC, FirstName ASC, LastName DESC, MiddleName ASC

-- Task 16
CREATE VIEW V_EmployeesSalaries AS
SELECT
	Firstname,
	Lastname,
	Salary
FROM Employees

SELECT * FROM V_EmployeesSalaries

-- Task 17
CREATE VIEW V_EmployeeNameJobTitle AS
SELECT
	FirstName + ' ' + ISNULL(Middlename, '') + ' ' + LastName AS [Full Name],
	JobTitle
FROM Employees

SELECT * FROM V_EmployeeNameJobTitle

-- Task 18
SELECT DISTINCT JobTitle
FROM Employees

-- Task 19
SELECT TOP (10) *
FROM Projects
ORDER BY StartDate, [Name]

-- Task 20
SELECT TOP(7)
	Firstname,
	Lastname,
	HireDate
FROM Employees
ORDER BY HireDate DESC

-- Task 21
UPDATE Em
SET Em.Salary += Em.Salary * 0.12
FROM Employees AS Em
WHERE Em.DepartmentID IN (SELECT Dep.DepartmentID 
							FROM Departments AS Dep
							WHERE Dep.[Name] IN ('Engineering', 'Tool Design', 'Marketing', 'Information Services'))

SELECT Salary
FROM Employees

-- Task 22
USE [Geography]

SELECT PeakName
FROM Peaks
ORDER BY PeakName ASC

-- Task 23
SELECT TOP (30)
	CountryName,
	[Population]
FROM Countries AS Ctr
WHERE Ctr.ContinentCode = (SELECT Cnt.ContinentCode 
							FROM Continents AS Cnt
							WHERE ContinentName = 'Europe')
ORDER BY [Population] DESC, CountryName ASC

-- Task 24
SELECT
	CountryName,
	CountryCode,
	(CASE
		WHEN CurrencyCode = 'EUR' THEN 'Euro'
		ELSE 'Not Euro'
	END) AS Currency
FROM Countries
ORDER BY CountryName

-- Task 25
USE Diablo

SELECT [Name]
FROM Characters
ORDER BY [Name]
