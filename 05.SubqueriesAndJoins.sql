-- TASK 1
SELECT TOP(5)
	EmployeeID,
	JobTitle,
	e.AddressID,
	AddressText
FROM Employees AS e
JOIN Addresses AS a ON a.AddressID = e.AddressID
ORDER BY AddressID

-- TASK 2
SELECT TOP(50)
	FirstName,
	LastName,
	t.[Name],
	a.AddressText
FROM Employees AS e
	JOIN Addresses AS a ON a.AddressID = e.AddressID
	JOIN Towns AS t ON t.TownID = a.TownID
ORDER BY FirstName ASC, LastName ASC

-- TASK 3
SELECT 
	EmployeeID,
	FirstName,
	LastName,
	d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE d.[Name] = 'Sales'
ORDER BY EmployeeID

-- TASK 4
SELECT TOP(5)
	EmployeeID,
	FirstName,
	Salary,
	d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE Salary > 15000
ORDER BY e.DepartmentID

-- TASK 5
SELECT TOP(3)
	EmployeeID,
	FirstName
FROM Employees
WHERE EmployeeID NOT IN (SELECT DISTINCT  
								EmployeeID
						 FROM EmployeesProjects)
ORDER BY EmployeeID

-- TASK 6
SELECT
	FirstName,
	LastName,
	HireDate,
	d.[Name] AS DeptName
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE HireDate > '1999-01-01' AND d.[Name] IN ('Sales', 'Finance')
ORDER BY HireDate


-- TASK 7
SELECT TOP(5)
	e.EmployeeID,
	FirstName,
	p.[Name] AS ProjectName
FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE p.StartDate > '2002-08-13' AND p.EndDate IS NULL
ORDER BY e.EmployeeID

-- TASK 8
SELECT
	e.EmployeeID,
	FirstName,
	(CASE
		WHEN YEAR(p.StartDate) >= 2005 THEN NULL
		ELSE p.[Name]
	END) AS ProjectName
FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE e.EmployeeID = 24

-- TASK 9
SELECT
	e1.EmployeeID,
	e1.FirstName,
	e1.ManagerID,
	(SELECT TOP(1) FirstName FROM Employees AS e2 WHERE e2.EmployeeID = e1.ManagerID) AS ManagerName
FROM Employees AS e1
WHERE ManagerID IN (3,7)
ORDER BY EmployeeID

-- TASK 10
SELECT TOP(50)
	e1.EmployeeID,
	e1.FirstName + ' ' + e1.LastName AS EmployeeName,
	e2.FirstName + ' ' + e2.LastName AS ManagerName,
	d.[Name] AS DepartmentName
FROM Employees AS e1
JOIN Employees AS e2 ON e1.ManagerID = e2.EmployeeID
JOIN Departments AS d ON e1.DepartmentID = d.DepartmentID
ORDER BY e1.EmployeeID

-- TASK 11
SELECT MIN(AvgSalary) AS MinAverageSalary
FROM (SELECT 
		  AVG(Salary) AS AvgSalary
	  FROM Employees AS e
	  JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
	  GROUP BY d.[Name]) AS AvgTable

-- TASK 12
USE [Geography]

SELECT 
	c.CountryCode,
	m.MountainRange,
	p.PeakName,
	p.Elevation
FROM Countries AS c
JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
JOIN Mountains AS m ON m.Id = mc.MountainId
JOIN Peaks AS p ON p.MountainId = m.Id
WHERE c.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

-- TASK 13
SELECT 
	c.CountryCode,
	COUNT(*) AS MountainRanges
FROM Countries AS c
JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
JOIN Mountains AS m ON mc.MountainId = m.Id
WHERE CountryName IN ('United States', 'Russia', 'Bulgaria')
GROUP BY c.CountryCode

-- TASK 14
SELECT TOP(5)
	c.CountryName,
	r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
JOIN Continents AS cs ON c.ContinentCode = cs.ContinentCode
WHERE cs.ContinentName = 'Africa'
ORDER BY c.CountryName

-- TASK 15
SELECT 
	ContinentCode,
	CurrencyCode,
	CurrencyUsage
FROM (SELECT
		  ContinentCode,
		  CurrencyCode,
		  DENSE_RANK() OVER (PARTITION BY ContinentCode ORDER BY COUNT(*) DESC) AS Ranking,
		  COUNT(*) AS CurrencyUsage
	  FROM Countries
	  GROUP BY ContinentCode, CurrencyCode) AS RankedTable
WHERE Ranking = 1 AND CurrencyUsage > 1
ORDER BY ContinentCode, CurrencyCode


-- “¿—  16
SELECT COUNT(*)
FROM Countries AS c
WHERE c.CountryCode NOT IN (SELECT mc.CountryCode FROM MountainsCountries AS mc)

-- TASK 17
SELECT TOP(5)
	c.CountryName,
	MAX(p.Elevation) AS HighestPeakElevation,
	MAX(r.[Length]) AS LongestRiverLength
FROM Countries AS c
JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
JOIN Rivers AS r ON cr.RiverId = r.Id
JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
JOIN Mountains AS m ON mc.MountainId = m.Id
JOIN Peaks AS p ON p.MountainId = m.Id
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, CountryName

-- TASK 18
SELECT TOP(5)
	rt.CountryName AS Country,
	(CASE
		WHEN PeakName IS NULL THEN '(no highest peak)'
		ELSE PeakName
	END) AS [Highest Peak Name],
	(CASE
		WHEN Elevation IS NULL THEN 0
		ELSE Elevation
	END) AS [Highest Peak Elevation],
	(CASE
		WHEN MountainRange IS NULL THEN '(no mountain)'
		ELSE MountainRange
	END) AS Mountain
FROM (SELECT 
		   c.CountryName,
		   DENSE_RANK() OVER (PARTITION BY c.CountryName ORDER BY p.Elevation DESC) AS Ranking,
		   p.Elevation,
		   p.PeakName,
		   m.MountainRange
	   FROM Countries AS c
	   LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
	   LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
	   LEFT JOIN Peaks AS p ON p.MountainId = m.Id) AS rt
WHERE Ranking = 1
ORDER BY Country, [Highest Peak Name]
