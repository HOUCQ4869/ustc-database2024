use bank_sys;
-- 加入新的客户信息
drop procedure if exists add_customer;
delimiter //
create procedure add_customer(
    in new_id int,
    in new_name varchar(20),
    in new_phone varchar(20),
    in new_address varchar(50),
    in new_employee_id int,
    in new_photo_name varchar(50)
)
begin
    if exists(select * from customer where id = new_id) then
        signal sqlstate '45000'
        set message_text = 'Customer already exists';
    else
        insert into customer(id, name, phone, address, employee_id, photo_name) values(new_id, new_name, new_phone, new_address, new_employee_id, new_photo_name);
    end if;
end //
delimiter ;

-- 删除客户信息
drop procedure if exists delete_customer;
delimiter //
create procedure delete_customer(
    in customer_id int
)
begin
    if not exists(select * from customer where id = customer_id) then
        signal sqlstate '45000'
        set message_text = 'Customer does not exist';
    else
		delete from customer where id = customer_id;
    end if;
end //
delimiter ;

-- 修改客户信息
drop procedure if exists update_customer;
delimiter //
create procedure update_customer(
    in old_id int,
    in new_id int,
    in new_name varchar(20),
    in new_phone varchar(20),
    in new_address varchar(50),
    in new_employee_id int,
    in new_photo_name varchar(50)
)
begin
    if not exists(select * from customer where id = old_id) then
        signal sqlstate '45000'
        set message_text = 'Customer does not exist';
    else
        if old_id = new_id then
            update customer set name = new_name, phone = new_phone, address = new_address, employee_id = new_employee_id, photo_name = new_photo_name where id = old_id;
        else
            -- 改变客户id，需要同时修改账户，贷款信息
            update customer set id = new_id, name = new_name, phone = new_phone, address = new_address, employee_id = new_employee_id, photo_name = new_photo_name where id = old_id;
            update account set customer_id = new_id where customer_id = old_id;
            update loan set customer_id = new_id where customer_id = old_id;
        end if;
    end if;
end //
delimiter ;

-- 查询客户信息
drop procedure if exists query_customer;
delimiter //
create procedure query_customer(
    in customer_id int
)
begin
    if not exists(select * from customer where id = customer_id) then
        signal sqlstate '45000'
        set message_text = 'Customer does not exist';
    else
        select * from customer where id = customer_id;
    end if;
end //
delimiter ;

-- 查询客户的账户余额
drop procedure if exists query_customer_balance;
delimiter //
create procedure query_customer_balance(
    in customer_id int
)
begin
    if not exists(select * from customer where id = customer_id) then
        signal sqlstate '45000'
        set message_text = 'Customer does not exist';
    else
        select sum(balance) from account where account.customer_id = customer_id;
    end if;
end //
delimiter ;
