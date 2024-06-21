use bank_sys;

-- 加入新的银行信息
drop procedure if exists add_bank;
delimiter //
create procedure add_bank(
    in new_name varchar(20),
    in new_address varchar(50),
    in new_phone varchar(20),
    in new_asset double
)
begin
    if exists(select * from bank where name = new_name) then
        signal sqlstate '45000'
        set message_text = 'Bank already exists';
    else
        insert into bank(name, address, phone, asset) values(new_name, new_address, new_phone, new_asset);
    end if;
end //
delimiter ;

-- 删除银行信息，意味着删除该银行名下的所有部门、员工、客户、账户、贷款信息
drop procedure if exists delete_bank;
delimiter //
create procedure delete_bank(
    in bank_name varchar(20)
)
begin
    if not exists(select * from bank where name = bank_name) then
        signal sqlstate '45000'
        set message_text = 'Bank does not exist';
    else
        delete from bank where name = bank_name;
    end if;
end //
delimiter ;

-- 修改银行信息
drop procedure if exists update_bank;
delimiter //
create procedure update_bank(
    in old_name varchar(20),
    in new_name varchar(20),
    in new_address varchar(50),
    in new_phone varchar(20),
    in new_asset double
)
begin
    if not exists(select * from bank where name = old_name) then
        signal sqlstate '45000'
        set message_text = 'Bank does not exist';
    else
        if old_name = new_name then
            update bank set address = new_address, phone = new_phone, asset = new_asset where name = old_name;
        else
            -- 改变银行名，需要同时修改部门，账户，贷款信息
            -- 比如合并两个银行时
            update bank set name = new_name, address = new_address, phone = new_phone, asset = new_asset where name = old_name;
            update department set bank_name = new_name where bank_name = old_name;
            update account set bank_name = new_name where bank_name = old_name;
            update loan set bank_name = new_name where bank_name = old_name;
		end if;
    end if;
end //
delimiter ;

-- 查询银行信息
drop procedure if exists query_bank;
delimiter //
create procedure query_bank(
    in bank_name varchar(20)
)
begin
    if not exists(select * from bank where name = bank_name) then
        signal sqlstate '45000'
        set message_text = 'Bank does not exist';
    else
        select * from bank where name = bank_name;
    end if;
end //
delimiter ;

-- 查询银行资产
drop procedure if exists get_bank_asset;
delimiter //
create procedure get_bank_asset(
    in bank_name varchar(20)
)
begin
    if not exists(select * from bank where name = bank_name) then
        signal sqlstate '45000'
        set message_text = 'Bank does not exist';
    else
        select asset from bank where name = bank_name;
    end if;
end //
delimiter ;