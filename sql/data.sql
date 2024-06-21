use bank_sys;

-- 进行数据插入
insert into bank(name, address, phone, asset) values('中国银行', '北京市', '010-12345678', 10000000);
insert into bank(name, address, phone, asset) values('中国工商银行', '北京市', '010-87654321', 20000000);
insert into bank(name, address, phone, asset) values('中国建设银行', '北京市', '010-13579246', 30000000);

insert into department(name, type, director, bank_name) values('人事部', '直属', '张三', '中国银行');
insert into department(name, type, director, bank_name) values('财务部', '直属', '李四', '中国工商银行');
insert into department(name, type, director, bank_name) values('市场部', '直属', '王五', '中国建设银行');
insert into department(name, type, director, bank_name) values('保卫部', '附属', '赵六', '中国银行');
insert into department(name, type, director, bank_name) values('宣传部', '附属', '孙七', '中国工商银行');
insert into department(name, type, director, bank_name) values('后勤部', '附属', '周八', '中国建设银行');
insert into department(name, type, director, bank_name) values('行政部', '直属', '吴九', '中国银行');
insert into department(name, type, director, bank_name) values('审计部', '直属', '郑十', '中国工商银行');
insert into department(name, type, director, bank_name) values('监察部', '直属', '钱十一', '中国建设银行');



insert into employee(name, phone, address, employee_date, department_id) values('张三', '010-12345678', '北京市', '2020-01-01', 1);
insert into employee(name, phone, address, employee_date, department_id) values('李四', '010-87654321', '北京市', '2020-01-01', 2);
insert into employee(name, phone, address, employee_date, department_id) values('王五', '010-13579246', '北京市', '2020-01-01', 3);
insert into employee(name, phone, address, employee_date, department_id) values('赵六', '010-12345678', '北京市', '2020-01-01', 4);
insert into employee(name, phone, address, employee_date, department_id) values('孙七', '010-87654321', '北京市', '2020-01-01', 5);
insert into employee(name, phone, address, employee_date, department_id) values('周八', '010-13579246', '北京市', '2020-01-01', 6);
insert into employee(name, phone, address, employee_date, department_id) values('吴九', '010-12345678', '北京市', '2020-01-01', 7);
insert into employee(name, phone, address, employee_date, department_id) values('郑十', '010-87654321', '北京市', '2020-01-01', 8);
insert into employee(name, phone, address, employee_date, department_id) values('钱十一', '010-13579246', '北京市', '2020-01-01', 9);
insert into employee(name, phone, address, employee_date, department_id) values('孙十二', '010-13579246', '北京市', '2020-01-01', 1);
insert into employee(name, phone, address, employee_date, department_id) values('周十三', '010-13579246', '北京市', '2020-01-01', 2);
insert into employee(name, phone, address, employee_date, department_id) values('吴十四', '010-12345678', '北京市', '2020-01-01', 3);
insert into employee(name, phone, address, employee_date, department_id) values('郑十五', '010-87654321', '北京市', '2020-01-01', 4);
insert into employee(name, phone, address, employee_date, department_id) values('钱十六', '010-13579246', '北京市', '2020-01-01', 5);
insert into employee(name, phone, address, employee_date, department_id) values('孙十七', '010-13579246', '北京市', '2020-01-01', 6);
insert into employee(name, phone, address, employee_date, department_id) values('周十八', '010-13579246', '北京市', '2020-01-01', 7);
insert into employee(name, phone, address, employee_date, department_id) values('吴十九', '010-12345678', '北京市', '2020-01-01', 8);
insert into employee(name, phone, address, employee_date, department_id) values('郑二十', '010-87654321', '北京市', '2020-01-01', 9);

insert into customer(name, phone, address, employee_id, photo_name) values('张三', '010-12345678', '北京市', 1, 'zhangsan.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('李四', '010-87654321', '北京市', 2, 'lisi.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('王五', '010-13579246', '北京市', 3, 'wangwu.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('赵六', '010-12345678', '北京市', 4, 'zhaoliu.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('孙七', '010-87654321', '北京市', 5, 'sunqi.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('周八', '010-13579246', '北京市', 6, 'zhouba.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('吴九', '010-12345678', '北京市', 7, 'wujiu.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('郑十', '010-87654321', '北京市', 8, 'zhengshi.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('钱十一', '010-13579246', '北京市', 9, 'qianshiyi.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('孙十二', '010-13579246', '北京市', 1, 'sunshier.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('周十三', '010-13579246', '北京市', 2, 'zhousan.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('吴十四', '010-12345678', '北京市', 3, 'wushi.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('郑十五', '010-87654321', '北京市', 4, 'zhengwu.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('钱十六', '010-13579246', '北京市', 5, 'qianshiliu.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('孙十七', '010-13579246', '北京市', 6, 'sunshiqi.jpg');
insert into customer(name, phone, address, employee_id, photo_name) values('周十八', '010-13579246', '北京市', 7, 'zhouba.jpg');


insert into account(balance, create_date, bank_name, customer_id) values(1000, '2020-01-01', '中国银行', 1);
insert into account(balance, create_date, bank_name, customer_id) values(2000, '2020-01-01', '中国工商银行', 2);
insert into account(balance, create_date, bank_name, customer_id) values(3000, '2020-01-01', '中国建设银行', 3);
insert into account(balance, create_date, bank_name, customer_id) values(4000, '2020-01-01', '中国银行', 4);
insert into account(balance, create_date, bank_name, customer_id) values(5000, '2020-01-01', '中国工商银行', 5);
insert into account(balance, create_date, bank_name, customer_id) values(6000, '2020-01-01', '中国建设银行', 6);
insert into account(balance, create_date, bank_name, customer_id) values(7000, '2020-01-01', '中国银行', 7);
insert into account(balance, create_date, bank_name, customer_id) values(8000, '2020-01-01', '中国工商银行', 8);
insert into account(balance, create_date, bank_name, customer_id) values(9000, '2020-01-01', '中国建设银行', 9);
insert into account(balance, create_date, bank_name, customer_id) values(10000, '2020-01-01', '中国银行', 10);
insert into account(balance, create_date, bank_name, customer_id) values(11000, '2020-01-01', '中国工商银行', 11);
insert into account(balance, create_date, bank_name, customer_id) values(12000, '2020-01-01', '中国建设银行', 12);

insert into loan(amount, interest_rate, start_date, end_date, bank_name, customer_id) values(1000, 0.01, '2020-01-01', '2020-12-31', '中国银行', 1);
insert into loan(amount, interest_rate, start_date, end_date, bank_name, customer_id) values(2000, 0.02, '2020-01-01', '2020-12-31', '中国工商银行', 5);
insert into loan(amount, interest_rate, start_date, end_date, bank_name, customer_id) values(3000, 0.03, '2020-01-01', '2020-12-31', '中国建设银行', 9);