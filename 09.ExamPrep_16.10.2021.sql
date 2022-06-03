CREATE DATABASE CigarShop
GO
USE CigarShop
GO

-- TASK DDL
CREATE TABLE Sizes(
	Id INT PRIMARY KEY IDENTITY,
	[Length] INT CHECK([Length] BETWEEN 10 AND 25) NOT NULL,
	RingRange DECIMAL(18,2) CHECK(RingRange BETWEEN 1.5 AND 7.5) NOT NULL
)

CREATE TABLE Tastes(
	Id INT PRIMARY KEY IDENTITY,
	TasteType VARCHAR(20) NOT NULL,
	TasteStrength VARCHAR(15) NOT NULL,
	ImageURL NVARCHAR(100) NOT NULL
)

CREATE TABLE Brands(
	Id INT PRIMARY KEY IDENTITY,
	BrandName VARCHAR(30) NOT NULL UNIQUE,
	BrandDescription VARCHAR(MAX)
)

CREATE TABLE Cigars(
	Id INT PRIMARY KEY IDENTITY,
	CigarName VARCHAR(80) NOT NULL,
	BrandId INT FOREIGN KEY REFERENCES Brands(Id) NOT NULL,
	TastId INT FOREIGN KEY REFERENCES Tastes(Id) NOT NULL,
	SizeId INT FOREIGN KEY REFERENCES Sizes(Id) NOT NULL,
	PriceForSingleCigar MONEY NOT NULL, -- OR DECIMAL MAYBE
	ImageURL NVARCHAR(100) NOT NULL
)

CREATE TABLE Addresses(
	Id INT PRIMARY KEY IDENTITY,
	Town VARCHAR(30) NOT NULL,
	Country NVARCHAR(30) NOT NULL,
	Streat NVARCHAR(100) NOT NULL,
	ZIP VARCHAR(20) NOT NULL
)

CREATE TABLE Clients(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Email NVARCHAR(50) NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL
)

CREATE TABLE ClientsCigars(
	ClientId INT FOREIGN KEY REFERENCES Clients(Id) NOT NULL,
	CigarId INT FOREIGN KEY REFERENCES Cigars(Id) NOT NULL,
	CONSTRAINT PK_Client_Cigar PRIMARY KEY(ClientId, CigarId)
)



-- INSERTS
INSERT INTO Cigars(CigarName, BrandId, TastId, SizeId, PriceForSingleCigar, ImageURL)
VALUES
	('COHIBA ROBUSTO', 9, 1, 5, 15.50, 'cohiba-robusto-stick_18.jpg'),
	('COHIBA SIGLO I', 9, 1, 10, 410.00, 'cohiba-siglo-i-stick_12.jpg'),
	('HOYO DE MONTERREY LE HOYO DU MAIRE', 14, 5, 11, 7.50, 'hoyo-du-maire-stick_17.jpg'),
	('HOYO DE MONTERREY LE HOYO DE SAN JUAN', 14, 4, 15, 32.00, 'hoyo-de-san-juan-stick_20.jpg'),
	('TRINIDAD COLONIALES', 2, 3, 8, 85.21, 'trinidad-coloniales-stick_30.jpg')

INSERT INTO Addresses(Town, Country, Streat, ZIP)
VALUES
	('Sofia', 'Bulgaria', '18 Bul. Vasil levski', '1000'),
	('Athens', 'Greece', '4342 McDonald Avenue', '10435'),
	('Zagreb', 'Croatia', '4333 Lauren Drive', '10000')

-- UPDATE
UPDATE Cigars
SET PriceForSingleCigar += PriceForSingleCigar * 0.2
WHERE TastId = (SELECT TOP(1) Id FROM Tastes WHERE TasteType = 'Spicy')

UPDATE Brands
SET BrandDescription = 'New description'
WHERE BrandDescription IS NULL

-- DELETE
ALTER TABLE Clients
ALTER COLUMN AddressId INT 

UPDATE Clients
SET AddressId = NULL
WHERE AddressId IN (SELECT Id FROM Addresses WHERE Country LIKE 'C%')

DELETE FROM Addresses
WHERE Country LIKE 'C%'

-- SELECTS:

-- TASK 5.Cigars by Price
SELECT 
	CigarName,
	PriceForSingleCigar,
	ImageURL
FROM Cigars
ORDER BY PriceForSingleCigar, CigarName DESC

-- TASK 6.Cigars by Taste
SELECT
	c.Id,
	CigarName,
	PriceForSingleCigar,
	TasteType,
	TasteStrength
FROM Cigars AS c
JOIN Tastes AS t ON c.TastId = t.Id
WHERE t.TasteType IN ('Earthy', 'Woody')
ORDER BY PriceForSingleCigar DESC

-- TASK 7.Clients without Cigars

SELECT
	Id,
	CONCAT(FirstName, ' ', LastName) AS ClientName,
	Email
FROM Clients
WHERE Id NOT IN (SELECT ClientId
					FROM ClientsCigars)
ORDER BY ClientName

-- TASK 8.First 5 Cigars
SELECT TOP(5)
	CigarName,
	PriceForSingleCigar,
	ImageURL
FROM Cigars AS c
JOIN Sizes AS s ON c.SizeId = s.Id
WHERE [Length] >= 12 AND 
	  (CigarName LIKE '%ci%' OR 
	  PriceForSingleCigar > 50) AND 
	  RingRange > 2.55
ORDER BY CigarName ASC, PriceForSingleCigar DESC

-- TASK 9.Clients with ZIP Codes
SELECT
	CONCAT(FirstName, ' ', LastName) AS FullName,
	Country,
	ZIP,
	CONCAT('$', MAX(PriceForSingleCigar)) AS CigarPrice
FROM Clients AS c
JOIN Addresses AS a ON c.AddressId = a.Id
JOIN ClientsCigars AS cg ON c.Id = cg.ClientId
JOIN Cigars AS cr ON cg.CigarId = cr.Id
WHERE ISNUMERIC(ZIP) = 1
GROUP BY FirstName, LastName, Country, ZIP
ORDER BY FullName

-- TASK 10.Cigars by Size

SELECT 
	LastName,
	AVG([Length]) AS CiagrLength,
	CEILING(AVG(RingRange)) AS CiagrRingRange
FROM Clients AS c
JOIN ClientsCigars AS cg ON c.Id = cg.ClientId
JOIN  Cigars AS cig ON cig.Id = cg.CigarId
JOIN Sizes AS s ON cig.SizeId = s.Id
GROUP BY LastName
ORDER BY CiagrLength DESC

-- TASK 11.Client with Cigars
CREATE FUNCTION udf_ClientWithCigars(@name NVARCHAR(30)) 
RETURNS INT
AS
BEGIN
	DECLARE @clientId INT = (SELECT TOP(1) Id FROM Clients WHERE FirstName = @name);

	DECLARE @result INT = (SELECT COUNT(*) FROM ClientsCigars WHERE ClientId = @clientId);
	RETURN @result;
END

SELECT dbo.udf_ClientWithCigars('Betty')

-- TASK 12.Search for Cigar with Specific Taste
CREATE OR ALTER PROC usp_SearchByTaste @taste VARCHAR(20)
AS
BEGIN
	DECLARE @tasteId INT = (SELECT TOP(1) Id FROM Tastes WHERE TasteType = @taste);

	SELECT
		CigarName,
		CONCAT('$' ,PriceForSingleCigar) AS Price,
		@taste AS TasteType,
		BrandName, 
		CONCAT([Length], ' cm') AS CigarLength,
		CONCAT(RingRange, ' cm') AS CigarRingRange
	FROM Cigars AS c
	JOIN Brands AS b ON c.BrandId = b.Id
	JOIN Sizes AS s ON c.SizeId = s.Id
	WHERE TastId = @tasteId
	ORDER BY CigarLength, CigarRingRange DESC
END

EXEC usp_SearchByTaste 'Woody'