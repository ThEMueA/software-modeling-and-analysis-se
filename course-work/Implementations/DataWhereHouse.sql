create database WeareHouse

use WeareHouse

use master

drop database WeareHouse



CREATE TABLE DimDate(
id INT PRIMARY KEY,
DateValue DATE,
Year_ INT,
Quarter_ INT,
Month_ INT,
Day_ INT,
);


CREATE TABLE DimUser( 
user_ID INT PRIMARY KEY,
username nvarchar(255),
email nvarchar(255),
fname nvarchar(255),
lname nvarchar(255),
civil_num  char(10),
);



CREATE TABLE DimAddress(
ID INT,-- PRIMARY KEY REFERENCES DimUser(user_ID)
country VARCHAR(64) NOT NULL,
);

CREATE TABLE DimTransaction(
ID INT PRIMARY KEY,
userID INT ,-- FOREIGN KEY REFERENCES DimUser(user_ID)
destination nvarchar(255),
created_at int, --foreign key references DimDate(id)
amount DECIMAL(18,4),
currency INT--FOREIGN KEY REFERENCES DimCurrency(ID
);


CREATE TABLE DimAsset(
asset_ID INT PRIMARY KEY,
name nvarchar(255) UNIQUE,
price DECIMAL(18,4),
type varchar(16));
 


CREATE TABLE DimCurrency(
ID INT primary key,
currency VARCHAR(64),
currency_code CHAR(3),
);

CREATE TABLE DimOrders(
ID INT PRIMARY key,
user_ID INT,-- FOREIGN KEY REFERENCES DimUser(user_ID)
asset_ID INT,-- FOREIGN KEY REFERENCES DimAsset(asset_ID)
quantity DECIMAL(18,5),
date_ int);-- foreign key references DimDate(id)





--обем на зделки по даден актив
--Pk ,DimDate, DimActiv, transaction count   taka vseki edin red e istoriq za kakvo se e sluchilo



--trader performance
--Pk ,DimDate,DimActiv, dimUser, dimTransaction pechalbata




--- печалба от договори за промяна на цената
--Dim vreme, Dim aktiv , Dim tranzakcii ,  пресмятаме печалба за фирмата



---най-използвана валута //за регион
--pk dim vreme, Dim user, dim address,Dim transaction, nai chesto sreshtana valuta


--dim date, dim user, dim address, dim transaction, dim asset , dim currency, dim orders
--factite ili gi smqtame tuk ili v servise
--vsichko trqbva da e za momenta

CREATE TABLE FactVolume(
id int primary key,
date_id int,
asset_id int,
order_id int,
order_count int
);
---oreder count se smqta agregatno


CREATE TABLE FactPerformance(
id int primary key,
date_id int,
asset_id int,
transaction_id int,
income decimal(18,5)
);
--dokato ne si realizirash pechalbite/zagubite nqma takiva  v edin moment prodavash v drug kupuvash i razrikata na vsichko tova pokazva,


CREATE TABLE FactCFTincome(
id int primary key,
date_id int,
user_id_ int,
transaction_id int,
asset_id int,
income decimal(18,5)
);
--tocho za tazi v tozi den s tozi asset si na zaguba/pechalba  Atomarno

CREATE TABLE FactCurrency(
id int primary key,
date_id int,
user_id_ int,
address_id int,
transaction_id int,
currency_id int,
);
--v tozi period koq valuta e polzvana nai-mnogo
-- one row one moment one event
--a single fact stores the value f a single fact only  and the facts united make the analisis
--tuk sum slojil atomarni i agregatni



INSERT INTO DimDate (id, DateValue, Year_, Quarter_, Month_, Day_)
VALUES
(1, '2025-12-01', 2025, 4, 12, 1),
(2, '2025-12-02', 2025, 4, 12, 2),
(3, '2025-12-03', 2025, 4, 12, 3);

-- DimUser
INSERT INTO DimUser (user_ID, username, email, fname, lname, civil_num)
VALUES
(1, 'kolyo22', 'bqlka@email.com', 'bqlka', 'K', '1234567890'),
(2, 'Nikol1', 'niki@email.com', 'Niki', 'Shtqh', '2345678901');

-- DimAddress
INSERT INTO DimAddress (ID, country)
VALUES
(1, 'BG'),
(2, 'FR'),
(3, 'BE');

-- DimAsset
INSERT INTO DimAsset (asset_ID, name, price, type)
VALUES
(1, 'APPL', 100.50, 'Stocks'),
(2, 'ORCL', 200.00, 'Stocks');

-- DimCurrency
INSERT INTO DimCurrency (ID, currency, currency_code)
VALUES
(1, 'United States dollar', 'USD'),
(2, 'Great Britain pound', 'GBP'),
(3, 'Euro', 'EUR');

-- DimTransaction
INSERT INTO DimTransaction (ID, userID, destination, created_at, amount, currency)
VALUES
(1, 1, 'XNYS', 1, -1000.00, 1),
(1, 2, 'TSE', 2, 500.00, 2);

-- DimOrders
INSERT INTO DimOrders (ID, user_ID, asset_ID, quantity, date_)
VALUES
(1, 1, 1, 1, 1),
(2, 2, 2, 5, 2);




-- FactVolume
INSERT INTO FactVolume (id, date_id, asset_id, order_id, order_count)
VALUES
(1, 1, 1, 1, 10),
(2, 2, 2, 2, 5);

-- FactPerformance
INSERT INTO FactPerformance (id, date_id, asset_id, transaction_id, income)
VALUES
(1, 1, 1, 1, 50.50),
(2, 2, 2, 2, -10.00);

-- FactCFTincome
INSERT INTO FactCFTincome (id, date_id, user_id_, transaction_id, asset_id, income)
VALUES
(1, 1, 1, 1, 1, 50.50),
(2, 2, 2, 2, 2, -10.00);

-- FactCurrency
INSERT INTO FactCurrency (id, date_id, user_id_, address_id, transaction_id, currency_id)
VALUES
(1, 1, 1, 1, 1, 1),
(2, 2, 2, 2, 2, 2);
