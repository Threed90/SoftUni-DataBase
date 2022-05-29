-- TASK 1
SELECT COUNT(*)
FROM WizzardDeposits

-- TASK 2
SELECT MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits

-- TASK 3
SELECT
	DepositGroup,
	MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits
GROUP BY DepositGroup

-- TASK 4
SELECT TOP(2)
	DepositGroup
FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize) ASC

-- TASK 5
SELECT
	DepositGroup,
	SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
GROUP BY DepositGroup

-- TASK 6
SELECT
	DepositGroup,
	SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

-- TASK 7
SELECT
	DepositGroup,
	SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC

-- TASK 8
SELECT
	DepositGroup,
	MagicWandCreator,
	MIN(DepositCharge) AS MinDepositCharge
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

-- TASK 9
SELECT 
	AgeGroup,
	COUNT(*)
FROM(SELECT 
		CASE
			WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
			WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
			WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
			WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
			WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
			WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
			ELSE '[61+]'
		END AS AgeGroup
	FROM WizzardDeposits) AS #TempTable
GROUP BY AgeGroup

-- TASK 10
SELECT
	LEFT(FirstName, 1) AS FirstLetter
FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName, 1)
ORDER BY FirstLetter

-- TASK 11
SELECT 
	DepositGroup,
	IsDepositExpired,
	AVG(DepositInterest)
FROM WizzardDeposits
WHERE DepositStartDate > '1985-01-01'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

-- TASK 12
SELECT 
	ABS(SUM(wd1.DepositAmount - wd2.DepositAmount)) AS SumDifference
FROM (SELECT 
			DepositAmount,
			ROW_NUMBER() OVER (ORDER BY Id) AS RowNum
		FROM WizzardDeposits) AS wd1
RIGHT JOIN (SELECT 
				DepositAmount,
				ROW_NUMBER() OVER (ORDER BY Id) AS RowNum
			FROM WizzardDeposits) AS wd2
	ON wd1.RowNum = wd2.RowNum + 1

-- TASK 13
USE SoftUni

SELECT 
	DepartmentID,
	SUM(Salary)
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

-- TASK 14
SELECT 
	DepartmentID,
	MIN(Salary)
FROM Employees
WHERE HireDate > '2000-01-01' AND DepartmentID IN (2, 5, 7)
GROUP BY DepartmentID
ORDER BY DepartmentID

-- TASK 15
SELECT * 
INTO ChosenEmploees
FROM Employees
WHERE Salary > 30000

DELETE FROM ChosenEmploees
WHERE ManagerID = 42

UPDATE ChosenEmploees
SET Salary += 5000
WHERE DepartmentID = 1

SELECT 
	DepartmentID,
	AVG(Salary)
FROM ChosenEmploees
GROUP BY DepartmentID

-- TASK 16
SELECT
	DepartmentID,
	MAX(Salary) AS AverageSalary
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

-- TASK 17
SELECT
	COUNT(Salary) AS [Count]
FROM Employees
WHERE ManagerID IS NULL

-- TASK 18

SELECT 
	DepartmentID,
	MAX(Salary) AS ThirdHighestSalary
FROM (SELECT
			DepartmentID,
			Salary,
			DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
		FROM Employees) AS #TempTable
WHERE SalaryRank = 3
GROUP BY DepartmentID

-- TASK 19
SELECT TOP(10)
	FirstName,
	LastName,
	DepartmentID
FROM Employees AS e1
WHERE Salary > (SELECT AVG(Salary)
				FROM Employees 
				GROUP BY DepartmentID
				HAVING DepartmentID = e1.DepartmentID)
ORDER BY DepartmentID