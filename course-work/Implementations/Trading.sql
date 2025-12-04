CREATE DATABASE trading_212
use trading_212

use master
drop database trading_212


CREATE TABLE Users (
  user_ID INT IDENTITY(1,1) PRIMARY KEY,
  username nvarchar(255) NOT NULL,
  email nvarchar(255) NOT NULL UNIQUE,
  fname nvarchar(255)	NOT NULL,
  lname nvarchar(255)  NOT NULL,
	birthdate DATETIME  NOT NULL,
	phone_num varchar(15) NOT NULL,
	civil_num  char(10) NOT NULL UNIQUE,
    idcard_num varchar(128) NOT NULL UNIQUE
);



CREATE TABLE Portfolio(
ID	INT PRIMARY KEY REFERENCES Users(user_ID),
profit DECIMAL(18, 4),
risk_index  varchar(12) NOT NULL CHECK (risk_index IN ('Low','Moderate','High','Very High')),
type_ varchar(12)	not null CHECK(type_ in('Guest','Demo','Invest','ISA','CFD','Admin')),
currency INT FOREIGN KEY REFERENCES Currency(ID),
history_log_path NVARCHAR(255) NOT NULL --blob storage path
);


CREATE TABLE Comment(
comment_ID	INT IDENTITY(1,1) PRIMARY KEY,
content nvarchar(1024)	NOT NULL,
created_date DATETIME DEFAULT GETDATE(),
likes INT NOT NULL,
dislikes INT NOT NULL,
parent_comment_id INT NULL FOREIGN KEY REFERENCES Comment(comment_ID) ,
userID INT FOREIGN KEY REFERENCES Users(user_ID)
);

CREATE TABLE API_key(
ID INT IDENTITY(1,1) PRIMARY KEY,
key_token nvarchar(255) NOT NULL,
created_at DATETIME DEFAULT GETDATE(),
exp_date DATETIME NOT NULL,
userID INT FOREIGN KEY REFERENCES Users(user_ID),
permission varchar(30)NOT NULL CHECK(permission IN('GET','PUT/POST','REMOVE','FULL ACCESS'))
);

CREATE TABLE Address_Doc(
ID INT PRIMARY KEY REFERENCES Users(user_ID),
date DATETIME DEFAULT GETDATE(),
validated BIT NOT NULL DEFAULT 0,
country VARCHAR(64) NOT NULL,
doc_path NVARCHAR(255) NOT NULL, --blob storage path


);

CREATE TABLE Transactions(
ID INT PRIMARY KEY IDENTITY(1,1),
userID INT FOREIGN KEY REFERENCES Users(user_ID),
source nvarchar(255) not null,  --reference wallet (acount number)
destination nvarchar(255) not null,
created_at DATETIME default GETDATE(),
amount DECIMAL(18,4) NOT NULL,
status varchar(32) not null check (status IN('created','pending','compleated','failed')),
currency INT FOREIGN KEY REFERENCES Currency(ID),

);

CREATE TABLE Wallet(
ID INT PRIMARY KEY REFERENCES Users(user_ID),
currency INT FOREIGN KEY REFERENCES Currency(ID),
account_num nvarchar(255)NOT NULL UNIQUE,
funds DECIMAL(18,4) NOT NULL CHECK (funds >= 0)
);

CREATE TABLE Cards(
card_ID INT PRIMARY KEY IDENTITY(1,1),
wallet_ID INT REFERENCES Wallet(ID),
daily_amount DECIMAL(18,4)NULL,
exp_date DATETIME NOT NULL,
pin_code CHAR(6) NOT NULL
);

CREATE TABLE Owned_assets(
wallet_ID INT FOREIGN KEY REFERENCES Wallet(ID),
asset_ID INT FOREIGN KEY REFERENCES Asset(asset_ID),
quantity DECIMAL(18,5) NOT NULL CHECK (QUANTITY > 0),
PRIMARY KEY(wallet_ID,asset_ID)

);



CREATE TABLE Asset(
asset_ID INT PRIMARY KEY IDENTITY(1,1),
name nvarchar(255) UNIQUE NOT NULL,
price DECIMAL(18,4) NOT NULL,
type varchar(16) CHECK(type IN('commodities','stocks','CFD','cryptocurrencies'))
);

CREATE TABLE Orders(
ID INT PRIMARY KEY IDENTITY(1,1),
user_ID INT FOREIGN KEY REFERENCES Users(user_ID),
asset_ID INT FOREIGN KEY REFERENCES Asset(asset_ID),
quantity DECIMAL(18,5) NOT NULL CHECK (QUANTITY > 0),
date DATETIME DEFAULT GETDATE()
);


CREATE TABLE Currency(
ID INT PRIMARY KEY IDENTITY(1,1),
currency VARCHAR(64),
currency_code CHAR(3),
);
