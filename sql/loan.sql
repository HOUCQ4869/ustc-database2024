use bank_sys;

-- 加入新的贷款信息
drop procedure if exists add_loan;
delimiter //
create procedure add_loan(
    in new_id int,
    in new_amount double,
    in new_interest_rate double,
    in new_start_date date,
    in new_end_date date,
    in new_bank_name varchar(20),
    in new_customer_id int
)
begin
    if exists(select * from loan where id = new_id) then
        signal sqlstate '45000'
        set message_text = 'Loan already exists';
    else
        insert into loan(id, amount, interest_rate, start_date, end_date, bank_name, customer_id) values(new_id, new_amount, new_interest_rate, new_start_date, new_end_date, new_bank_name, new_customer_id);
    end if;
end //
delimiter ;

-- 删除贷款信息
drop procedure if exists delete_loan;
delimiter //
create procedure delete_loan(
    in loan_id int
)
begin
    if not exists(select * from loan where id = loan_id) then
        signal sqlstate '45000'
        set message_text = 'Loan does not exist';
    else
        delete from loan where id = loan_id;
    end if;
end //
delimiter ;

-- 修改贷款信息
drop procedure if exists update_loan;
delimiter //
create procedure update_loan(
    in old_id int,
    in new_id int,
    in new_amount double,
    in new_interest_rate double,
    in new_start_date date,
    in new_end_date date,
    in new_bank_name varchar(20),
    in new_customer_id int
)
begin
    if not exists(select * from loan where id = old_id) then
        signal sqlstate '45000'
        set message_text = 'Loan does not exist';
    else
        update loan set id = new_id, amount = new_amount, interest_rate = new_interest_rate, start_date = new_start_date, end_date = new_end_date, bank_name = new_bank_name, customer_id = new_customer_id where id = old_id;
    end if;
end //
delimiter ;

-- 查询贷款信息
drop procedure if exists query_loan;
delimiter //
create procedure query_loan(
    in loan_id int
)
begin
    select * from loan where id = loan_id;
end //
delimiter ;


-- 考虑使用账户进行贷款和还款，而非现金，增加触发器

-- 触发器，增加贷款时，银行资产减少，贷款人账户余额增加
drop trigger if exists add_loan_trigger;
delimiter //
create trigger add_loan_trigger
after insert on loan
for each row
begin
    if new.amount > (select asset from bank where name = new.bank_name) then
        signal sqlstate '45000'
        set message_text = 'Bank asset is not enough';
    else 
        update bank set asset = asset - new.amount where name = new.bank_name;
        update account set balance = balance + new.amount where customer_id = new.customer_id;
    end if;
end //
delimiter ;

-- 触发器，删除贷款时，银行资产增加，贷款人账户余额减少
drop trigger if exists delete_loan_trigger;
delimiter //
create trigger delete_loan_trigger
after delete on loan
for each row
begin
    if old.amount > (select balance from account where customer_id = old.customer_id) then
        signal sqlstate '45000'
        set message_text = 'Account balance is not enough';
    else
        update bank set asset = asset + old.amount where name = old.bank_name;
        update account set balance = balance - old.amount where customer_id = old.customer_id;
    end if;
end //
delimiter ;

-- 触发器，贷款金额变化时，银行资产变化，贷款人账户余额变化
drop trigger if exists update_loan_trigger;
delimiter //
create trigger update_loan_trigger
after update on loan
for each row
begin
    if new.amount > old.amount then
        if new.amount - old.amount > (select asset from bank where name = new.bank_name) then
            signal sqlstate '45000'
            set message_text = 'Bank asset is not enough';
        else
            update bank set asset = asset - (new.amount - old.amount) where name = new.bank_name;
            update account set balance = balance + (new.amount - old.amount) where customer_id = new.customer_id;
        end if;
    else
        update bank set asset = asset + (old.amount - new.amount) where name = new.bank_name;
        update account set balance = balance - (old.amount - new.amount) where customer_id = new.customer_id;
    end if;
end //
delimiter ;