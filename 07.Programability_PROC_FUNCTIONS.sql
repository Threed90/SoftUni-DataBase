-- TASK 1
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000 
AS
SELECT 
	FirstName,
	LastName
FROM Employees
WHERE Salary > 35000

exec usp_GetEmployeesSalaryAbove35000 

-- TASK 2
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber @Number DECIMAL(18,4)
AS
SELECT
	FirstName,
	LastName
FROM Employees
WHERE Salary >= @Number

exec usp_GetEmployeesSalaryAboveNumber @Number = 48100

-- TASK 3
CREATE PROCEDURE usp_GetTownsStartingWith @StartWith NVARCHAR(10)
AS
SELECT
	[Name] AS Town
FROM Towns
WHERE LEFT([Name], LEN(@StartWith)) = @StartWith

exec usp_GetTownsStartingWith @StartWith = 'b'

-- TASK 4
CREATE PROCEDURE usp_GetEmployeesFromTown @TownName VARCHAR(50)
AS
SELECT
	FirstName,
	LastName
FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
JOIN Towns AS t ON a.TownID = t.TownID
WHERE t.[Name] = @TownName

exec usp_GetEmployeesFromTown @TownName = 'Sofia'

-- TASK 5
CREATE OR ALTER FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
RETURNS VARCHAR(8)
AS
BEGIN
	DECLARE @result VARCHAR(8);
	IF(@salary < 30000)
	BEGIN
		SET @result = 'Low';
	END
	ELSE IF(@salary BETWEEN 30000 AND 50000)
	BEGIN
		SET @result = 'Average';
	END
	ELSE
	BEGIN
		SET @result = 'High';
	END

	RETURN @result;
END

SELECT [dbo].[ufn_GetSalaryLevel](13500)

-- TASK 6
CREATE PROCEDURE usp_EmployeesBySalaryLevel @SalaryLevel VARCHAR(10)
AS
	IF @SalaryLevel NOT IN ('high', 'average', 'low')
		THROW 50001, 'There are 3 options: high, low or average', 1
SELECT
	FirstName,
	LastName
FROm Employees
WHERE [dbo].[ufn_GetSalaryLevel](Salary) = @SalaryLevel

exec usp_EmployeesBySalaryLevel @SalaryLevel = 'high'

-- TASK 7

CREATE OR ALTER FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(20), @word VARCHAR(20)) 
RETURNS BIT
AS
BEGIN
	DECLARE @i INT = 1;
	DECLARE @Checker BIT = 0;

	WHILE @i <= LEN(@word)
	BEGIN
		DECLARE @SetLetter CHAR(1) = SUBSTRING(@word, @i, 1);

		DECLARE @j INT = 1;

		WHILE @j <= LEN(@setOfLetters)
		BEGIN
			DECLARE @WordLetter CHAR(1) = SUBSTRING(@setOfLetters, @j, 1);

			IF @SetLetter = @WordLetter
			BEGIN
				SET @Checker = 1;
				BREAK;
			END
			SET @j += 1;
			SET @Checker = 0;
		END

		IF(@Checker = 0)
			RETURN 0;
		SET @i +=1;
	END

	RETURN 1;
END

SELECT dbo.ufn_IsWordComprised('oistmiahf', 'gfdgfdgfd')


-- TASK 8
CREATE OR ALTER PROC usp_DeleteEmployeesFromDepartment @departmentID INT
AS
	DELETE FROM EmployeesProjects
		WHERE EmployeeID IN (SELECT EmployeeID 
								FROM Employees 
								WHERE DepartmentID = @departmentId)

	UPDATE Employees
	SET ManagerID = NULL
	WHERE DepartmentID = @departmentId 
	   OR ManagerID IN (SELECT EmployeeID 
								FROM Employees 
								WHERE DepartmentID = @departmentId)

	ALTER TABLE Departments
	ALTER COLUMN ManagerID INT;

	ALTER TABLE Employees
	ALTER COLUMN DepartmentID INT;

	UPDATE Departments
	SET ManagerID = NULL
	WHERE ManagerID IN (SELECT EmployeeID 
								FROM Employees 
								WHERE DepartmentID = @departmentId)

	DELETE FROM Employees
	WHERE DepartmentID = @departmentId;
	DELETE FROM Departments
	WHERE DepartmentID = @departmentId;

	SELECT COUNT(EmployeeID)
		FROM Employees 
		WHERE DepartmentID = @departmentId


exec usp_DeleteEmployeesFromDepartment 10

-- TASK 9
USE Bank;

CREATE PROC usp_GetHoldersFullName 
AS
SELECT
	CONCAT(FirstName, ' ', LastName) As [Full Name]
FROM AccountHolders


exec usp_GetHoldersFullName

-- TASK 10
CREATE PROC usp_GetHoldersWithBalanceHigherThan  @Number MONEY
AS
SELECT
	FirstName,
	LastName
FROM AccountHolders AS ah
WHERE @Number < (SELECT SUM(Balance)
					FROM Accounts
					WHERE ah.Id = AccountHolderId)
ORDER BY FirstName, LastName

exec usp_GetHoldersWithBalanceHigherThan 10000

-- TASK 11
CREATE FUNCTION ufn_CalculateFutureValue(@sum DECIMAL(18,4), @yearlyInterestRate FLOAT, @year INT)
RETURNS DECIMAL(18,4)
AS
BEGIN
	DECLARE @result DECIMAL(18,4) = @sum * POWER((1 + @yearlyInterestRate), @year);
	RETURN @result;
END

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)

-- TASK 12

CREATE OR ALTER PROC usp_CalculateFutureValueForAccount @accountId INT, @interest FLOAT
AS
SELECT
	ah.Id AS [Account Id],
	FirstName,
	LastName,
	a.Balance AS [Current Balance],
	dbo.ufn_CalculateFutureValue(a.Balance, @interest, 5) AS [Balance in 5 years]
FROM AccountHolders AS ah
LEFT JOIN Accounts AS a ON ah.Id = a.AccountHolderId
WHERE a.Id = @accountId


exec usp_CalculateFutureValueForAccount 1, 0.1

-- TASK 13

USE Diablo;

CREATE FUNCTION ufn_CashInUsersGames(@gameName NVARCHAR(50))
RETURNS TABLE
AS
	RETURN 
		SELECT
			SUM(Cash) AS SumCash
		  FROM (SELECT
					ROW_NUMBER() OVER (ORDER BY Cash DESC) AS [Rank],
					Cash
				FROM UsersGames
				WHERE GameId = (SELECT 
									Id
								FROM Games
								WHERE [Name] = @gameName)) AS #RankedTable
			WHERE [Rank] % 2 <> 0

SELECT * FROM dbo.ufn_CashInUsersGames('Love in a mist')


-- TASK 14
USE Bank

CREATE TABLE Logs(
	LogId INT PRIMARY KEY IDENTITY,
	AccountId INT NOT NULL,
	OldSum MONEY NOT NULL,
	NewSum MONEY NOT NULL
)

CREATE TRIGGER tr_ChangeAccSumLog
ON Accounts
FOR UPDATE
AS
INSERT INTO Logs
SELECT
		d.Id, d.Balance, i.Balance
	FROM deleted AS d
	JOIN inserted as i ON d.Id = i.Id

-- TEST THE TRIGGER:
UPDATE Accounts
SET Balance += 100
WHERE AccountHolderId = 2

-- TASK 15
CREATE TABLE NotificationEmails(
	Id INT PRIMARY KEY IDENTITY,
	Recipient INT NOT NULL,
	[Subject] VARCHAR(50) NOT NULL,
	[Body] VARCHAR(100) NOT NULL
)

CREATE OR ALTER TRIGGER tr_NotificationForNewRecord 
ON Logs
FOR INSERT
AS
INSERT INTO NotificationEmails
SELECT
	AccountId,
	'Balance change for account: ' + CAST(AccountId AS VARCHAR),
	'On ' + FORMAT(GETDATE(), 'MMM dd yyyy h:mmtt') + ' your balance was changed from ' + FORMAT(OldSum, 'N2') + ' to ' + FORMAT(NewSum, 'N2') + '.'
	FROM inserted

-- TASK 16

CREATE PROC usp_DepositMoney @AccountId INT, @MoneyAmount MONEY
AS
UPDATE Accounts
SET Balance += @MoneyAmount
WHERE Id = @AccountId

-- TASK 17
CREATE PROC usp_WithdrawMoney @AccountId INT, @MoneyAmount MONEY
AS
UPDATE Accounts
SET Balance -= @MoneyAmount
WHERE @MoneyAmount > 0 AND @AccountId = Id AND Balance >= @MoneyAmount

-- TASK 18
CREATE PROC usp_TransferMoney @SenderId INT, @ReceiverId INT, @Amount MONEY
AS
BEGIN TRAN
	BEGIN TRY
		DECLARE @SenderAmount MONEY = (SELECT TOP(1) Balance FROM Accounts WHERE Id = @SenderId);
	
		IF @SenderAmount >= @Amount
		BEGIN
			exec usp_WithdrawMoney @SenderId, @Amount;
			exec usp_DepositMoney @ReceiverId, @Amount;
		END
		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
	END CATCH

-- TASK 20
USE Diablo

-- Variant 1:
DECLARE @userID INT = (SELECT Id FROM Users WHERE Username = 'Stamat');
DECLARE @gameID INT = (SELECT Id FROM Games WHERE [Name] = 'Safflower');
DECLARE @userGameID INT = (SELECT Id FROM UsersGames WHERE UserId = @userID AND GameId = @gameID);
DECLARE @userCash MONEY = (SELECT Cash FROM UsersGames WHERE Id = @userGameID AND UserId = @userID AND GameId = @gameID);
DECLARE @itemCashTotal MONEY;

BEGIN TRANSACTION
	SET @itemCashTotal = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN 11 AND 12);
	
	IF(@userCash - @itemCashTotal >= 0)
	BEGIN
		INSERT INTO UserGameItems(ItemId, UserGameId)
		SELECT Id, @userGameID
			FROM Items
			WHERE MinLevel BETWEEN 11 AND 12

			UPDATE UsersGames
			SET Cash -= @itemCashTotal
			WHERE Id = @userGameID;

			COMMIT
	END
	--ELSE
	--BEGIN
	--	ROLLBACK
	--END

SET @userCash = (SELECT Cash FROM UsersGames WHERE Id = @userGameID);

BEGIN TRANSACTION
	SET @itemCashTotal = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN 19 AND 21);
	
	IF(@userCash - @itemCashTotal >= 0)
	BEGIN
		INSERT INTO UserGameItems(ItemId, UserGameId)
		SELECT Id, @userGameID
			FROM Items
			WHERE MinLevel BETWEEN 19 AND 21

			UPDATE UsersGames
			SET Cash -= @itemCashTotal
			WHERE Id = @userGameID;

			COMMIT
	END
	--ELSE
	--BEGIN
	--	ROLLBACK
	--END

SELECT [Name] AS [Item Name]
FROM Items
WHERE Id IN (SELECT ItemId FROM UserGameItems WHERE UserGameId = @userGameID)
ORDER BY [Name]

-- Variant 2:
DECLARE @userGameId INT = (SELECT TOP(1) ug.Id
								FROM Users AS u
								JOIN UsersGames AS ug ON u.Id = ug.UserId
								JOIN Games AS g ON ug.GameId = g.Id
								WHERE Username = 'Stamat' AND g.[Name] = 'Safflower')
	DECLARE @userId INT = (SELECT TOP(1) Id FROM Users WHERE [Username] = 'Stamat');
	DECLARE @gameId INT = (SELECT TOP(1) Id FROM Games WHERE [Name] = 'Safflower');

BEGIN TRAN
	BEGIN TRY
		DECLARE @itemId INT = 11;
		WHILE @itemId <= 12
		BEGIN
			DECLARE @currentCash MONEY = (SELECT TOP(1) Cash FROM UsersGames WHERE UserId = @userId AND GameId = @gameId);
			DECLARE @itemPrice MONEY = (SELECT Sum(Price) FROM dbo.Items WHERE MinLevel = @itemId);
			IF  @currentCash >= @itemPrice
				BEGIN
					UPDATE UsersGames
					SET Cash -= @itemPrice
					WHERE GameId = @gameId AND UserId = @userId

					INSERT INTO UserGameItems
						SELECT
							Id, 
							@userGameId
						FROM dbo.Items
						WHERE MinLevel BETWEEN 19 AND 21
				END
			ELSE THROW 51000, 'Not enough money!', 1;

			SET @itemId += 1;
			SET @itemPrice = (SELECT Sum(Price) FROM dbo.Items WHERE MinLevel = @itemId);
		END
		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		ROLLBACK;
	END CATCH
	
BEGIN TRAN
	BEGIN TRY
		SET @itemId = 19;
		SET @itemPrice = (SELECT Sum(Price) FROM dbo.Items WHERE MinLevel = @itemId);
		WHILE @itemId <= 21
		BEGIN
			IF  @currentCash >= @itemPrice
				BEGIN
					UPDATE UsersGames
					SET Cash -= @itemPrice
					WHERE GameId = @gameId AND UserId = @userId

					INSERT INTO UserGameItems
						SELECT
							Id, 
							@userGameId
						FROM dbo.Items
						WHERE MinLevel BETWEEN 19 AND 21
				END
			ELSE THROW 51000, 'Not enough money!', 1;

			SET @itemId += 1;
			SET @itemPrice = (SELECT Sum(Price) FROM dbo.Items WHERE MinLevel = @itemId);
		END
		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		ROLLBACK;
	END CATCH

SELECT 
		[Name] AS [Item Name]
	FROM dbo.Items
	WHERE Id IN (SELECT ItemId FROM UserGameItems WHERE UserGameId = @userGameId)
ORDER BY [Name]

-- TASK 21

CREATE PROC usp_AssignProject @emloyeeId INT, @projectID INT
AS
BEGIN 
	BEGIN TRAN
	DECLARE @projectNumber INT = (SELECT COUNT(*) 
									FROM EmployeesProjects 
									WHERE EmployeeID = @emloyeeId)

	IF @projectNumber >= 3
	BEGIN
		ROLLBACK;
		THROW 50001, 'The employee has too many projects!', 1
	END
	ELSE
	BEGIN
		INSERT INTO EmployeesProjects
		VALUES (@emloyeeId, @projectID);
		COMMIT;
	END
END

-- TASK 22
CREATE TABLE Deleted_Employees(
	EmployeeId INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	MiddleName VARCHAR(50),
	JobTitle VARCHAR(50) NOT NULL,
	DepartmentId INT NOT NULL,
	Salary MONEY NOT NULL
)



CREATE TRIGGER tr_DeletedEmployees 
ON Employees
AFTER DELETE
AS
INSERT INTO Deleted_Employees
SELECT
	FirstName, LastName, MiddleName, JobTitle, DepartmentID, Salary
	FROM deleted