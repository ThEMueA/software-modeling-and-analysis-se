
use trading_212



CREATE PROCEDURE addWallet
@Id INT,
@Currency INT,
@AccountNum nvarchar(255),
@Funds DECIMAL(18,4)
AS
BEGIN
      INSERT INTO  Wallet(ID,currency,account_num,funds)
	  Values (@Id,@Currency,@AccountNum,@Funds);
END

CREATE PROCEDURE addCard
@Wallet_Id INT,
@Daily_amount DECIMAL(18,4),
@Exp_date DATETIME,
@Pin_code CHAR(6) 
AS
BEGIN
      INSERT INTO  Cards(wallet_ID,daily_amount,exp_date,pin_code)
	  Values (@Wallet_Id,@Daily_amount,@Exp_date,@Pin_code);
END






-- EXEC addWallet 1,3,'acc_num', 0.00;

---DROP PROCEDURE addWallet
---insert one row at a time

CREATE TRIGGER trg_addWalletAndCard_onInsert
ON Users
AFTER INSERT
AS
BEGIN
    DECLARE @NewUserID INT;
	SELECT @NewUserID = user_ID 
	from inserted;

	DECLARE @NewAccountNum NVARCHAR(255);
	SELECT @NewAccountNum = fname + CAST(civil_num AS VARCHAR(10))
	FROM inserted;
	

	DECLARE @date DATETIME;
   set @date = DATEADD(year, 3, GETDATE());


   EXEC addWallet @NewUserID,1,@NewAccountNum,0.00;  
   EXEC addCard  @NewUserID,100.00,@date,'123456'
   END;







   ---function

 CREATE FUNCTION dbo.GetFullName
   (
   @FirstName NVARCHAR(60),
   @LastName NVARCHAR(60)
   )
  returns NVARCHAR(121)
AS
BEGIN
     RETURN @FirstName + ' ' +@LastName;
END;

---------------------------------

CREATE FUNCTION dbo.GetCards
(@User_ID int
)
returns TABLE
AS
RETURN
(
   SELECT*FROM Cards
   WHERE wallet_ID = @User_ID
);


CREATE INDEX IX_Users_Username
ON Users(username);