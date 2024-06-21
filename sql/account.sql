use bank_sys;
-- 加入新的账户信息
drop procedure if exists add_account;
delimiter //
create procedure add_account(
    in new_id int,
    in new_balance double,
    in new_create_date date,
    in new_bank_name varchar(20),
    in new_customer_id int
)
begin
    if exists(select * from account where id = new_id) then
        signal sqlstate '45000'
        set message_text = 'Account already exists';
    else
        insert into account(id, balance, create_date, bank_name, customer_id) values(new_id, new_balance, new_create_date, new_bank_name, new_customer_id);
    end if;
end //
delimiter ;

-- 删除账户信息
drop procedure if exists delete_account;
delimiter //
create procedure delete_account(
    in account_id int
)
begin
    if not exists(select * from account where id = account_id) then
        signal sqlstate '45000'
        set message_text = 'Account does not exist';
    else
        delete from account where id = account_id;
    end if;
end //
delimiter ;

-- 修改账户信息
drop procedure if exists update_account;
delimiter //
create procedure update_account(
    in old_id int,
    in new_id int,
    in new_balance double,
    in new_create_date date,
    in new_bank_name varchar(20),
    in new_customer_id int
)
begin
    if not exists(select * from account where id = old_id) then
        signal sqlstate '45000'
        set message_text = 'Account does not exist';
    else
        update account set id = new_id, balance = new_balance, create_date = new_create_date, bank_name = new_bank_name, customer_id = new_customer_id where id = old_id;
    end if;
end //
delimiter ;

-- 查询账户信息
drop procedure if exists query_account;
delimiter //
create procedure query_account(
    in account_id int
)
begin
    select * from account where id = account_id;
end //
delimiter ;

-- 查询账户余额
drop procedure if exists query_balance;
delimiter //
create procedure query_balance(
    in account_id int
)
begin
    select balance from account where id = account_id;
end //
delimiter ;

-- 转账
drop procedure if exists transfer;
delimiter //
create procedure transfer(
    in from_account_id int,
    in to_account_id int,
    in amount double
)
begin        
    declare from_balance double;
    declare to_balance double;
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;
    select balance into from_balance from account where id = from_account_id;
    select balance into to_balance from account where id = to_account_id;
    if from_balance < amount then
        signal sqlstate '45000'
        set message_text = 'Insufficient balance';
    else
        update account set balance = from_balance - amount where id = from_account_id;
        update account set balance = to_balance + amount where id = to_account_id;
        -- select 'Transfer success';
    end if; 
    commit;
end //
delimiter ;

-- 取钱
drop procedure if exists withdraw;
delimiter //
create procedure withdraw(
    in account_id int,
    in amount double
)
begin
    declare account_balance double;
    select balance into account_balance from account where id = account_id;
    if account_balance < amount then
        signal sqlstate '45000'
        set message_text = 'Insufficient balance';
    else
        update account set balance = account_balance - amount where id = account_id;
    end if;
end //
delimiter ;

-- 存钱
drop procedure if exists deposit;
delimiter //
create procedure deposit(
    in account_id int,
    in amount double
)
begin
    declare account_balance double;
    select balance into account_balance from account where id = account_id;
    update account set balance = account_balance + amount where id = account_id;
end //
delimiter ;


-- 触发器，增加账户触发银行资产增加
drop trigger if exists add_account_trigger;
delimiter //
create trigger add_account_trigger
after insert on account
for each row
begin
    update bank set asset = asset + new.balance where name = new.bank_name;
end //
delimiter ;

-- 触发器，删除账户触发银行资产减少
drop trigger if exists delete_account_trigger;
delimiter //
create trigger delete_account_trigger
after delete on account
for each row
begin
    update bank set asset = asset - old.balance where name = old.bank_name;
end //
delimiter ;

-- 触发器，修改账户余额触发银行资产变化，即存取钱
drop trigger if exists update_account_trigger;
delimiter //
create trigger update_account_trigger
after update on account
for each row
begin
    update bank set asset = asset + new.balance - old.balance where name = new.bank_name;
end //
delimiter ;