CREATE DATABASE RelationDB

GO

USE RelationDB

GO
-- TASK 1

CREATE TABLE Passports(
	PassportID INT PRIMARY KEY IDENTITY(101,1),
	PassportNumber VARCHAR(15) NOT NULL
);

CREATE TABLE Persons(
	PersonID INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	Salary DECIMAL(12,2) NOT NULL,
	PassportID INT FOREIGN KEY REFERENCES Passports(PassportID)
)

GO

INSERT INTO Passports(PassportNumber)
VALUES
	('N34FG21B'), ('K65LO4R7'), ('ZE657QP2');

INSERT INTO Persons(FirstName, Salary, PassportID)
VALUES
	('Roberto', 43300.00, 102),
	('Tom', 56100.00, 103),
	('Yana', 60200.00, 101);


ALTER TABLE Persons
ADD CONSTRAINT UQ_PassportID UNIQUE(PassportID);

-- TASK 2
CREATE TABLE Manufacturers(
	ManufacturerID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(20) NOT NULL,
	EstablishedOn VARCHAR(15) NOT NULL
)

CREATE TABLE Models(
	ModelID INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(20) NOT NULL,
	ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

GO

INSERT INTO Manufacturers([Name], EstablishedOn)
VALUES
	('BMW', '07/03/1916'),
	('Tesla', '01/01/2003'),
	('Lada', '01/05/1966');

INSERT INTO Models([Name], ManufacturerID)
VALUES
	('X1', 1),
	('i6', 1),
	('Model S', 2),
	('Model X', 2),
	('Model 3', 2),
	('Nova', 3)

-- TASK 3

CREATE TABLE Students(
	StudentID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Exams(
	ExamID INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE StudentsExams(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	ExamID INT FOREIGN KEY REFERENCES Exams(ExamID),
	CONSTRAINT PK_StudentsExams PRIMARY KEY(StudentID, ExamID)
)

INSERT INTO Students([Name])
VALUES ('Mila'), ('Toni'), ('Ron')

INSERT INTO Exams([Name])
VALUES('SpringMVC'), ('Neo4j'), ('Oracle 11g')

INSERT INTO StudentsExams
VALUES (1, 101), (1, 102), (2, 101), (3, 103), (2, 102), (2, 103)

-- TASK 4

CREATE TABLE Teachers(
	TeacherID INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(50) NOT NULL,
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers
VALUES
	('John', NULL),
	('Maya', 106),
	('Silvia', 106),
	('Ted', 105),
	('Mark', 101),
	('Greta', 101)

-- TASK 5

CREATE TABLE Cities(
	CityID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Customers(
	CustomerID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	Birthday DATE,
	CityID INT FOREIGN KEY REFERENCES Cities(CityID) NOT NULL
)

CREATE TABLE ItemTypes(
	ItemTypeID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Items(
	ItemID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID) NOT NULL
)

CREATE TABLE Orders(
	OrderID INT PRIMARY KEY IDENTITY,
	CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID) NOT NULL
)

CREATE TABLE OrderItems(
	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID) NOT NULL,
	ItemID INT FOREIGN KEY REFERENCES Items(ItemID) NOT NULL,
	CONSTRAINT PK_OrderItem PRIMARY KEY (OrderID, ItemID)
)

-- TASK 6
CREATE DATABASE StudentsRelationDB;
GO
USE StudentsRelationDB
GO

CREATE TABLE Majors(
	MajorID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)


CREATE TABLE Students(
	StudentID INT PRIMARY KEY IDENTITY,
	StudentNumber VARCHAR(20) NOT NULL,
	StudentName NVARCHAR(50) NOT NULL,
	MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)

CREATE TABLE Subjects(
	SubjectID INT PRIMARY KEY IDENTITY,
	SubjectName NVARCHAR(100) NOT NULL
)

CREATE TABLE Agenda(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
	CONSTRAINT PK_Agenda_StudentSubject PRIMARY KEY (StudentID, SubjectID)
)

CREATE TABLE Payments(
	PaymentID INT PRIMARY KEY IDENTITY,
	PaymentDate DATE NOT NULL,
	PaymentAmount DECIMAL(18,4) NOT NULL,
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)

-- TASK 9
GO
USE [Geography]
GO

SELECT
	MountainRange,
	PeakName,
	Elevation
FROM Peaks AS p
JOIN Mountains AS m ON m.Id = p.MountainId
WHERE MountainRange = 'Rila'
ORDER BY Elevation DESC