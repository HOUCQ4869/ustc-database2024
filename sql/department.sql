use bank_sys;

-- 加入新的部门信息
drop procedure if exists add_department;
delimiter //
create procedure add_department(
    in new_id int,
    in new_name varchar(20),
    in new_type varchar(20),
    in new_director varchar(20),
    in new_bank_name varchar(20)
)
begin
    if exists(select * from department where id = new_id) then
        signal sqlstate '45000'
        set message_text = 'Department already exists';
    else
        insert into department(id, name, type, director, bank_name) values(new_id, new_name, new_type, new_director, new_bank_name);
    end if;
end //
delimiter ;

-- 删除部门信息
drop procedure if exists delete_department;
delimiter //
create procedure delete_department(
    in department_id int
)
begin
    if not exists(select * from department where id = department_id) then
        signal sqlstate '45000'
        set message_text = 'Department does not exist';
    else
        delete from department where id = department_id;
    end if;
end //
delimiter ;

-- 修改部门信息
drop procedure if exists update_department;
delimiter //
create procedure update_department(
    in old_id int,
    in new_id int,
    in new_name varchar(20),
    in new_type varchar(20),
    in new_director varchar(20),
    in new_bank_name varchar(20)
)
begin
    if not exists(select * from department where id = old_id) then
        signal sqlstate '45000'
        set message_text = 'Department does not exist';
    else
        if old_id = new_id then
            update department set name = new_name, type = new_type, director = new_director, bank_name = new_bank_name where id = old_id;
        else
            -- 改变部门id，需要同时修改员工信息
            update department set id = new_id, name = new_name, type = new_type, director = new_director, bank_name = new_bank_name where id = old_id;
            update employee set department_id = new_id where department_id = old_id;
        end if;
    end if;
end //
delimiter ;

-- 查询部门信息
drop procedure if exists query_department;
delimiter //
create procedure query_department(
    in department_id int
)
begin
    if not exists(select * from department where id = department_id) then
        signal sqlstate '45000'
        set message_text = 'Department does not exist';
    else
        select * from department where id = department_id;
    end if;
end //
delimiter ;
