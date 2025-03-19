use ShoeDB
go
drop table if exists ShoeInventory
go
create table dbo.ShoeInventory (
    ShoeInventoryID int not null identity primary key,
    CustomerName varchar(50) not null constraint ck_ShoeInventory_CustomerName_cannot_blank check(CustomerName <> ''), 
    Age int not null,
    PhoneNumber char(13) not null constraint ck_ShoeInventory_PhoneNumber_cannot_be_blank check (PhoneNumber <> ''),
    DateReceived date not null 
        constraint ck_ShoeInventory_DateReceived_not_before_June_16_2012 check(DateReceived >= '06-16-2012'),
        constraint ck_ShoeInventory_DateDateReceived_not_after_current_date check (DateReceived <= (getdate())),
    DateSold date constraint ck_ShoeInventory_DateSold_not_before_June_16_2012 check(DateSold >= '06-16-2012'),
    SeasonSold as case
            when month(DateSold) between 3 and 5 then 'Spring'
            when month(DateSold) between 6 AND 8 THEN 'Summer'
            when month(DateSold) between 9 AND 11 THEN 'Fall'
            else 'Winter'
        end persisted,
    PriceBought decimal (6,2) not null,
    PriceSold decimal (7,2),
    Company varchar(30) not null constraint ck_ShoeInventory_Company_cannot_be_blank check(Company <> ''),
    Returned bit,
        constraint ck_ShoeInventory_DateSold_cannot_be_before_DateReceived check(DateSold >= DateReceived),
        constraint ck_ShoeInventory_if_DateSold_is_null_then_PriceSold_also check((PriceSold is null and DateSold is null) or (PriceSold is not null and DateSold is not null))
)