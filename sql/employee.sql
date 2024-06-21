use bank_sys;

-- 加入新的员工信息
drop procedure if exists add_employee;
delimiter //
create procedure add_employee(
    in new_id int,
    in new_name varchar(20),
    in new_phone varchar(20),
    in new_address varchar(50),
    in new_employee_date date,
    in new_department_id int
)
begin
    if exists(select * from employee where id = new_id) then
        signal sqlstate '45000'
        set message_text = 'Employee already exists';
    else
        insert into employee(id, name, phone, address, employee_date, department_id) values(new_id, new_name, new_phone, new_address, new_employee_date, new_department_id);
    end if;
end //
delimiter ;

-- 删除员工信息
drop procedure if exists delete_employee;
delimiter //
create procedure delete_employee(
    in employee_id int
)
begin
    if not exists(select * from employee where id = employee_id) then
        signal sqlstate '45000'
        set message_text = 'Employee does not exist';
    else
        delete from employee where id = employee_id;
    end if;
end //
delimiter ;

-- 修改员工信息
drop procedure if exists update_employee;
delimiter //
create procedure update_employee(
    in old_id int,
    in new_id int,
    in new_name varchar(20),
    in new_phone varchar(20),
    in new_address varchar(50),
    in new_employee_date date,
    in new_department_id int
)
begin
    if not exists(select * from employee where id = old_id) then
        signal sqlstate '45000'
        set message_text = 'Employee does not exist';
    else
        if old_id = new_id then
            update employee set name = new_name, phone = new_phone, address = new_address, employee_date = new_employee_date, department_id = new_department_id where id = old_id;
        else
            -- 改变员工id，需要同时修改客户信息
            update employee set id = new_id, name = new_name, phone = new_phone, address = new_address, employee_date = new_employee_date, department_id = new_department_id where id = old_id;
            update customer set employee_id = new_id where employee_id = old_id;
        end if;
    end if;
end //
delimiter ;

-- 查询员工信息
drop procedure if exists query_employee;
delimiter //
create procedure query_employee(
    in employee_id int
)
begin
    if not exists(select * from employee where id = employee_id) then
        signal sqlstate '45000'
        set message_text = 'Employee does not exist';
    else
        select * from employee where id = employee_id;
    end if;
end //
delimiter ;

-- 查询员工的部门信息
drop procedure if exists query_employee_department;
delimiter //
create procedure query_employee_department(
    in employee_id int
)
begin
    if not exists(select * from employee where id = employee_id) then
        signal sqlstate '45000'
        set message_text = 'Employee does not exist';
    else
        select * from department where id = (select department_id from employee where id = employee_id);
    end if;
end //
delimiter ;
