CREATE DATABASE AromaDom
GO
USE AromaDom;
GO

CREATE TABLE dbo.MaterialTypes (
 MaterialTypeId INT IDENTITY(1,1) CONSTRAINT PK_MaterialTypes PRIMARY KEY,
 TypeName NVARCHAR(150) NOT NULL CONSTRAINT UQ_MaterialTypes_TypeName UNIQUE,
 LossPercent DECIMAL(7,4) NOT NULL CONSTRAINT CK_MaterialTypes_Loss CHECK (LossPercent >= 0 AND LossPercent < 100)
);
CREATE TABLE dbo.ProductTypes (
 ProductTypeId INT IDENTITY(1,1) CONSTRAINT PK_ProductTypes PRIMARY KEY,
 TypeName NVARCHAR(150) NOT NULL CONSTRAINT UQ_ProductTypes_TypeName UNIQUE,
 TypeCoefficient DECIMAL(12,6) NOT NULL CONSTRAINT CK_ProductTypes_Coeff CHECK (TypeCoefficient > 0)
);
CREATE TABLE dbo.Units (
 UnitId INT IDENTITY(1,1) CONSTRAINT PK_Units PRIMARY KEY,
 Symbol NVARCHAR(20) NOT NULL CONSTRAINT UQ_Units_Symbol UNIQUE,
 UnitName NVARCHAR(80) NOT NULL
);
CREATE TABLE dbo.Materials (
 MaterialId INT IDENTITY(1,1) CONSTRAINT PK_Materials PRIMARY KEY,
 MaterialName NVARCHAR(250) NOT NULL CONSTRAINT UQ_Materials_Name UNIQUE,
 MaterialTypeId INT NOT NULL CONSTRAINT FK_Materials_Type REFERENCES dbo.MaterialTypes(MaterialTypeId),
 UnitId INT NOT NULL CONSTRAINT FK_Materials_Unit REFERENCES dbo.Units(UnitId),
 UnitPrice DECIMAL(18,2) NOT NULL CONSTRAINT CK_Materials_Price CHECK(UnitPrice >= 0),
 StockQuantity DECIMAL(18,3) NOT NULL CONSTRAINT DF_Materials_Stock DEFAULT 0 CONSTRAINT CK_Materials_Stock CHECK(StockQuantity >= 0),
 MinimumQuantity DECIMAL(18,3) NOT NULL CONSTRAINT DF_Materials_Min DEFAULT 0 CONSTRAINT CK_Materials_Min CHECK(MinimumQuantity >= 0),
 PackageQuantity DECIMAL(18,3) NOT NULL CONSTRAINT CK_Materials_Package CHECK(PackageQuantity > 0),
 IsActive BIT NOT NULL CONSTRAINT DF_Materials_Active DEFAULT 1
);
CREATE TABLE dbo.Products (
 ProductId INT IDENTITY(1,1) CONSTRAINT PK_Products PRIMARY KEY,
 Article NVARCHAR(40) NOT NULL CONSTRAINT UQ_Products_Article UNIQUE,
 ProductName NVARCHAR(250) NOT NULL CONSTRAINT UQ_Products_Name UNIQUE,
 ProductTypeId INT NOT NULL CONSTRAINT FK_Products_Type REFERENCES dbo.ProductTypes(ProductTypeId),
 MinimumPartnerPrice DECIMAL(18,2) NOT NULL CONSTRAINT CK_Products_Price CHECK(MinimumPartnerPrice >= 0),
 IsActive BIT NOT NULL CONSTRAINT DF_Products_Active DEFAULT 1
);
CREATE TABLE dbo.ProductMaterials (
 ProductId INT NOT NULL CONSTRAINT FK_ProductMaterials_Product REFERENCES dbo.Products(ProductId),
 MaterialId INT NOT NULL CONSTRAINT FK_ProductMaterials_Material REFERENCES dbo.Materials(MaterialId),
 QuantityPerUnit DECIMAL(18,5) NOT NULL CONSTRAINT CK_ProductMaterials_Quantity CHECK(QuantityPerUnit > 0),
 CONSTRAINT PK_ProductMaterials PRIMARY KEY(ProductId,MaterialId)
);

--Далее идет импорт, создаете временную таблицу, с помощью мастера импорта добавляете данные во временную таблицу, после чего преобразуете данные и переносите из временной в оригинальную
--Если импорт недоступен откройте VisualStudio Installer и установите "Бизнес Аналитику"