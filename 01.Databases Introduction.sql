-- Task 1
USE master;

GO

CREATE DATABASE Minions

GO

USE Minions;

GO

-- Task 2
CREATE TABLE Minions(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(40) NOT NULL,
	Age INT
);

GO
-- Task 3
CREATE TABLE Towns(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(40) NOT NULL
);

ALTER TABLE Minions
ADD TownId INT 

GO

ALTER TABLE Minions
ADD CONSTRAINT FK_TownId FOREIGN KEY(TownId) REFERENCES Towns(Id)

GO
-- Task 4 (task request non-identity column for ids, but there is with auto-increment ids)
INSERT INTO Towns([Name])
VALUES
	('Sofia'),
	('Plovdiv'),
	('Varna');

INSERT INTO Minions([Name], Age, TownId)
VALUES
	('Kevin', 22, 1 ),
	('Bob', 15, 3),
	('Steward', NULL, 2);


GO
-- Task 5
TRUNCATE TABLE Minions;

GO
-- Task 6
DROP TABLE Minions;
DROP TABLE Towns;

GO
-- Task 7
CREATE TABLE People(
	Id INT IDENTITY NOT NULL,
	[Name] NVARCHAR(200) NOT NULL,
	[Picture] VARBINARY(MAX),
	Height DECIMAL(10,2),
	[Weight] DECIMAL(10,2),
	Gender CHAR(1),
	Birthdate DATE NOT NULL,
	Biography NVARCHAR(MAX),
	CONSTRAINT PK_People_Table PRIMARY KEY CLUSTERED (Id),
	CONSTRAINT CHK_Pic_Size CHECK(DATALENGTH(Picture) <= 2097152),
	CONSTRAINT CHK_Gender_Sing CHECK(Gender = 'f' OR Gender = 'm')
);

INSERT INTO People([Name], Picture, Height, [Weight], Gender, Birthdate, Biography)
VALUES
	('Peter', null, 168, 65, 'm', '1998-02-15', null),
	('Gosho', null, 178, 82, 'm', '1990-12-28', null),
	('Pesho', null, 170, 72, 'm', '2002-04-12', null),
	('Tosho', null, 170, 72, 'm', '2002-04-12', null),
	('Maria', null, 170, 72, 'f', '2002-04-12', null);

GO
-- Task 8
CREATE TABLE Users(
	Id BIGINT IDENTITY NOT NULL,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY,
	LastLoginTime DATETIME2 NOT NULL,
	IsDeleted BIT DEFAULT(0),
	CONSTRAINT PK_UserId PRIMARY KEY(Id),
	CONSTRAINT CHK_User_PictureSize CHECK(DATALENGTH(ProfilePicture) <= 921600),
	CONSTRAINT UQ_User_Username UNIQUE(Username)
);

INSERT INTO Users(Username, [Password], ProfilePicture, LastLoginTime, IsDeleted)
VALUES
	('userName1', 'fsdfsdgdfg', null, '2022-05-12 12:53:20', 0),
	('userName2', 'fsdfsdgdfg', null, '2022-05-12 12:53:10', 0),
	('userName3', 'fsdfsdgdfg', null, '2022-05-12 12:53:50', 1),
	('userName4', 'fsdfsdgdfg', null, '2022-05-12 12:53:30', 0),
	('userName5', 'fsdfsdgdfg', null, '2022-05-12 12:53:40', 0);
	
GO
-- Task 9
ALTER TABLE Users
DROP CONSTRAINT PK_UserId;

ALTER TABLE Users
ADD CONSTRAINT CPK_UserId_Username PRIMARY KEY(Id, Username);

-- Task 10
ALTER TABLE Users
ADD CONSTRAINT CHK_PassLen CHECK(LEN([Password]) >= 5);


-- Task 11
ALTER TABLE Users
ADD CONSTRAINT DF_LastLoginTime DEFAULT GETDATE() FOR LastLoginTime -- returns datetime

ALTER TABLE Users
DROP CONSTRAINT DF_LastLoginTime

ALTER TABLE Users
ADD CONSTRAINT DF_LastLoginTime DEFAULT SYSDATETIME() FOR LastLoginTime -- returns datetime2

-- Task 12

ALTER TABLE Users
DROP CONSTRAINT CPK_UserId_Username;

ALTER TABLE Users
ADD CONSTRAINT PK_UserId PRIMARY KEY(Id);

ALTER TABLE Users
ADD CONSTRAINT CHK_UsernameMinLen CHECK(LEN(Username) >= 3);

GO
-- Task 13
CREATE DATABASE Movies

GO

USE Movies

GO

CREATE TABLE Directors(
	Id INT PRIMARY KEY IDENTITY,
	DirectorName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(MAX)
);

CREATE TABLE Genres(
	Id INT PRIMARY KEY IDENTITY,
	GenreName NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(Max)
);

CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(max)
);

CREATE TABLE Movies(
	Id INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(60) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id) NOT NULL,
	CopyrightYear INT NOT NULL CHECK(CopyrightYear >= 1900),
	[Length] TIME(0) NOT NULL,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id),
	CategoryId INT FOREIGN KEY REFERENCES Categories(id),
	Rating INT,
	Notes NVARCHAR(MAX)
);

INSERT INTO Directors (DirectorName, Notes)
VALUES
	('Ida Lupino', 'Ida Lupino had a fascinating career. She began as a child actress in the 30s before co-founding an independent production company where you wrote, directed and produced her own films. Needless to say, this was basically unheard of in 1950s Hollywood.'),
	('Christopher Nolan', 'Best known for his cerebral, often nonlinear story-telling'),
	('Susanne Bier', 'Known for In a Better World (2010), After the Wedding (2006) and Brothers (2004).'),
	('Kathryn Bigelow', 'Director of The Hurt Locker'),
	('Ridley Scott', 'His reputation remains solidly intact.');


INSERT INTO Genres (GenreName)
VALUES ('Drama'),('History'),('Thriller'),('Romance'),('Sci-Fi');


INSERT INTO Categories (CategoryName)
VALUES ('R'),('PG-13'),('PG-18'),('Avoid at all cost'),('Hmmmm');


INSERT INTO Movies (Title, DirectorId, CopyrightYear, [Length], GenreId, CategoryId, Rating, Notes)
VALUES
	('Gladiator', 5, 2000, '01:30:56', 1, 1, 8, NULL),
	('The Prestige', 2, 2006, '01:30:56', 5, 2, 8, 'One of my favourite movies'),
	('The Hurt Locker', 4, 2008, '01:30:56', 3, 1, 7, NULL),
	('After the Wedding', 3, 2006, '01:30:56', 1, 1, 7, 'Amazing performance from everyone'),
	('Äçèôò', 1, 2008, '01:30:56', 1, 1, 7, NULL);


GO

-- Task 14

CREATE DATABASE CarRental;

GO

USE CarRental;

GO

CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NVARCHAR(100) NOT NULL, 
	DailyRate DECIMAL(10,2) NOT NULL, 
	WeeklyRate DECIMAL(14,2) NOT NULL, 
	MonthlyRate DECIMAL(18,2) NOT NULL, 
	WeekendRate DECIMAL(10,2) NOT NULL
)

CREATE TABLE Cars(
	Id INT PRIMARY KEY IDENTITY, 
	PlateNumber VARCHAR(15) NOT NULL, 
	Manufacturer NVARCHAR(30) NOT NULL, 
	Model NVARCHAR(30) NOT NULL, 
	CarYear INT NOT NULL, 
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id), 
	Doors TINYINT NOT NULL, 
	Picture VARBINARY(MAX), 
	Condition NVARCHAR(50), 
	Available BIT DEFAULT(1)
)

CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY, 
	FirstName NVARCHAR(50) NOT NULL, 
	LastName NVARCHAR(50) NOT NULL, 
	Title NVARCHAR(50) NOT NULL, 
	Notes NVARCHAR(Max)
)

CREATE TABLE Customers(
	Id INT PRIMARY KEY IDENTITY, 
	DriverLicenceNumber VARCHAR(20) NOT NULL, 
	FullName NVARCHAR(255) NOT NULL, 
	[Address] NVARCHAR(255) NOT NULL, 
	City NVARCHAR(50) NOT NULL, 
	ZIPCode NVARCHAR(100) NOT NULL, 
	Notes NVARCHAR(Max)
)

CREATE TABLE RentalOrders(
	Id INT PRIMARY KEY IDENTITY, 
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id), 
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id), 
	CarId INT FOREIGN KEY REFERENCES Cars(Id), 
	TankLevel DECIMAL(10,4) NOT NULL, 
	KilometrageStart DECIMAL(16,4) NOT NULL, 
	KilometrageEnd DECIMAL(16,4), 
	TotalKilometrage DECIMAL(16,4), 
	StartDate DATE NOT NULL, 
	EndDate DATE NOT NULL, 
	TotalDays INT NOT NULL, 
	RateApplied DECIMAL(18,2) NOT NULL, 
	TaxRate DECIMAL(18,2) NOT NULL, 
	OrderStatus VARCHAR(10) NOT NULL, 
	Notes NVARCHAR(Max)
);

INSERT INTO Categories(CategoryName ,DailyRate ,WeeklyRate ,MonthlyRate ,WeekendRate)
VALUES
	('luxury', 250.75, 1253.75, 6770.25, 520.20),
	('tourist', 30.20, 150.90, 350.50, 42.50),
	('economical', 10.50, 30.50, 120.80, 15.00);

INSERT INTO Cars(PlateNumber ,Manufacturer ,Model ,CarYear ,CategoryId ,Doors ,Picture ,Condition ,Available)
VALUES
	('BA1575FF', 'Volkswagen', 'Beetle Cabriolet', 2022, 2, 2, NULL, 'new', 1),
	('BA1578FF', 'Renault', 'Clio', 2016, 3, 4, NULL, 'good', 0),
	('BA9976FF', 'Bugatti', 'Chiron', 2022, 1, 2, NULL, 'new', 1)

INSERT INTO Employees(FirstName ,LastName ,Title ,Notes)
VALUES
	('Pesho', 'Peshev', 'Does not know what to put', NULL),
	('Gosho', 'Peshev', 'Does not know what to put', NULL),
	('Maria', 'Krimson', 'Does not know what to put', NULL)

INSERT INTO Customers(DriverLicenceNumber ,FullName ,[Address] ,City ,ZIPCode ,Notes)
VALUES
	('AB12345CD', 'Customer Number One', 'some address', 'Burgas', '7500', NULL),
	('AB12345CDD', 'Customer Number Two', 'some address', 'Plovdiv', '0000', NULL),
	('AB12345CDF', 'Customer Number Tree', 'some address', 'Sofia', '7900', NULL)

INSERT INTO RentalOrders(EmployeeId ,CustomerId ,CarId ,TankLevel ,KilometrageStart ,KilometrageEnd ,TotalKilometrage ,StartDate ,EndDate ,TotalDays ,RateApplied ,TaxRate ,OrderStatus ,Notes)
VALUES
	(1,1,1,120.20, 1200.500, NULL, 15000, '2022-05-10', '2022-05-15', 5, 600.20, 500, 'progress', null),
	(2,2,2,120.20, 1200.500, NULL, 15000, '2022-05-10', '2022-05-15', 5, 600.20, 500, 'progress', null),
	(3,3,3,120.20, 1200.500, NULL, 15000, '2022-05-10', '2022-05-15', 5, 600.20, 500, 'progress', null)

GO

-- Task 15
CREATE DATABASE Hotel;

GO

USE Hotel

GO

CREATE TABLE Employees(
	Id INT PRIMARY KEY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Title NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(max)
)

INSERT INTO Employees(Id,FirstName,LastName,Title)
VALUES
	(1,'First','Employee','Manager'),
	(2,'Second','Employee','Manager'),
	(3,'Third','Employee','Manager')

CREATE TABLE Customers(
	AccountNumber INT PRIMARY KEY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(50),
	EmergencyName NVARCHAR(50) NOT NULL,
	EmergencyNumber VARCHAR(50),
	Notes NVARCHAR(max)
)

INSERT INTO Customers(AccountNumber,FirstName,LastName,EmergencyName,EmergencyNumber)
VALUES
	(1,'First','Customer','Em1',11111),
	(2,'Second','Customer','Em2',22222),
	(3,'Third','Customer','Em3',33333)

CREATE TABLE RoomStatus(
	RoomStatus VARCHAR(50) PRIMARY KEY CHECK(RoomStatus='Free' OR RoomStatus='In use' OR RoomStatus='Reserved') NOT NULL,
	Notes NVARCHAR(max)
)


INSERT INTO RoomStatus(RoomStatus)
VALUES
	('Free'),('In use'),('Reserved')

CREATE TABLE RoomTypes(
	RoomType NVARCHAR(50) NOT NULL PRIMARY KEY,
	Notes NVARCHAR(max)
)

INSERT INTO RoomTypes(RoomType)
VALUES 
	('Luxory'),('Casual'),('Misery')

CREATE TABLE BedTypes(
	BedType NVARCHAR(50) PRIMARY KEY NOT NULL,
	Notes NVARCHAR(max)
)

INSERT INTO BedTypes(BedType)
VALUES 
	('Single'),('Double'),('King')

CREATE TABLE Rooms(
	RoomNumber INT PRIMARY KEY NOT NULL,
	RoomType NVARCHAR(50) FOREIGN KEY REFERENCES RoomTypes(RoomType) NOT NULL,
	BedType NVARCHAR(50) FOREIGN KEY REFERENCES BedTypes(BedType) NOT NULL,
	Rate DECIMAL(15,2) NOT NULL,
	RoomStatus VARCHAR(50) FOREIGN KEY REFERENCES RoomStatus(RoomStatus) NOT NULL,
	Notes NVARCHAR(max)
)

INSERT INTO Rooms(RoomNumber, RoomType,BedType,Rate,RoomStatus)
VALUES
	(1,'Luxory','King',100,'Reserved'),
	(2,'Casual','Double',50,'In use'),
	(3,'Misery','Single',19,'Free')

CREATE TABLE Payments (
	Id INT PRIMARY KEY NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	PaymentDate DATE NOT NULL,
	AccountNumber INT NOT NULL,
	FirstDateOccupied DATE NOT NULL,
	LastDateOccupied DATE NOT NULL,
	TotalDays INT,
	AmountCharged DECIMAL(15,2) NOT NULL,
	TaxRate DECIMAL(15,2) NOT NULL,
	TaxAmount DECIMAL(15,2) NOT NULL,
	PaymentTotal DECIMAL(15,2) NOT NULL,
	CHECK(TaxAmount = TotalDays * TaxRate),
	CHECK(TotalDays = DATEDIFF(DAY, FirstDateOccupied,LastDateOccupied))
)

INSERT INTO Payments(Id,EmployeeId,PaymentDate, AccountNumber,FirstDateOccupied,LastDateOccupied,TotalDays,
					 AmountCharged,TaxRate,TaxAmount,PaymentTotal)
VALUES
	(1,1,'10-05-2015',1,'10-05-2015','10-10-2015',5,75,50,250,75),
	(2,3,'10-11-2015',1,'12-15-2015','12-25-2015',10,100,50,500,100),
	(3,2,'12-23-2015',1,'12-23-2015','12-24-2015',1,75,75,75,75)

CREATE TABLE Occupancies(
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	DateOccupied DATE NOT NULL,
	AccountNumber INT NOT NULL,
	RoomNumber INT NOT NULL,
	RateApplied DECIMAL(10, 2),
	PhoneCharge VARCHAR(50) NOT NULL,
	Notes NVARCHAR(MAX)
)

INSERT INTO Occupancies(EmployeeId,DateOccupied,AccountNumber,RoomNumber,PhoneCharge)
VALUES
	(2,'08-24-2012',3,1,'088 88 888 888'),
	(3,'06-15-2015',2,3,'088 88 555 555'),
	(1,'05-12-1016',1,2,'088 88 555 333')


-- Task 16

GO

CREATE DATABASE SoftUni

GO

USE SoftUni

GO

CREATE TABLE Towns(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Addresses(
	Id INT PRIMARY KEY IDENTITY,
	AddressText NVARCHAR(255) NOT NULL,
	TownId INT FOREIGN KEY REFERENCES Towns(Id)
)

CREATE TABLE Departments(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY, 
	FirstName NVARCHAR(60) NOT NULL, 
	MiddleName NVARCHAR(60), 
	LastName NVARCHAR(60) NOT NULL, 
	JobTitle NVARCHAR(40) NOT NULL, 
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id), 
	HireDate VARCHAR(15) NOT NULL, 
	Salary DECIMAL (12,2) NOT NULL, 
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)

-- Task 18

INSERT INTO Towns
VALUES
	('Sofia'), ('Plovdiv'), ('Varna'), ('Burgas')

INSERT INTO Departments
VALUES
	('Engineering'), ('Sales'), ('Marketing'), ('Software Development'), ('Quality Assurance')

INSERT INTO Employees(FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary, AddressId)
VALUES
	('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '01/02/2013', 3500.00, NULL),
	('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1,	'02/03/2004', 4000.00, NULL),
	('Maria', 'Petrova', 'Ivanova',	'Intern', 5, '28/08/2016', 525.25, NULL),
	('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '09/12/2007', 3000.00, NULL),
	('Peter', 'Pan', 'Pan', 'Intern', 3, '28/08/2016', 599.88, NULL)

-- Task 19

SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

-- Task 20

SELECT * 
	FROM Towns
	ORDER BY [Name] ASC

SELECT *
	FROM Departments
	ORDER BY [Name] ASC

SELECT *
	FROM Employees	
	ORDER BY Salary DESC

-- Task 21

SELECT [Name] 
	FROM Towns
	ORDER BY [Name] ASC

SELECT [Name] 
	FROM Departments
	ORDER BY [Name] ASC

SELECT	
	FirstName, 
	LastName, 
	JobTitle, 
	Salary
FROM Employees	
	ORDER BY Salary DESC

-- Task 22
UPDATE Employees
SET Salary += (Salary*0.1)

SELECT Salary FROM Employees

-- Task 23

GO
USE Hotel
GO
-- Note: There is constraint, so update statement will not work for current DB, but will work for Homework Judge Test system:
-- Constraint need to be dropped before execution of the update operation...

UPDATE Payments
SET TaxRate -= (TaxRate*0.03)

SELECT TaxRate FROM Payments

-- Task 24

DELETE FROM Rooms
DELETE FROM RoomStatus
DELETE FROM BedTypes
DELETE FROM RoomTypes

DELETE FROM Payments
DELETE FROM Occupancies
DELETE FROM Employees

DELETE FROM Customers

