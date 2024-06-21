drop database if exists bank_sys;
create database bank_sys;
use bank_sys;

create table bank (
    name varchar(20) primary key,
    address varchar(50) not null,
    phone varchar(20) not null,
    asset double check(asset >= 0)
);

create table department(
    id int primary key auto_increment,
    name varchar(20) not null,
    type varchar(20) not null,
    director varchar(20) not null,
    bank_name varchar(20) not null,
    foreign key(bank_name) references bank(name) on delete cascade
);

create table employee(
    id int primary key auto_increment,
    name varchar(20) not null,
    phone varchar(20) not null,
    address varchar(50) not null,
    employee_date date not null,
    department_id int not null,
    foreign key(department_id) references department(id) on delete cascade
);

create table customer(
    id int primary key auto_increment,
    name varchar(20),
    phone varchar(20),
    address varchar(50),
    employee_id int,
    photo_name varchar(50),
    foreign key(employee_id) references employee(id) on delete cascade
);

create table account(
    id int primary key auto_increment,
    balance double check(balance >= 0),
    create_date date not null,
    bank_name varchar(20) not null,
    customer_id int not null,
    foreign key(bank_name) references bank(name) on delete cascade, 
    foreign key(customer_id) references customer(id) on delete cascade
);

create table loan(
    id int primary key auto_increment,
    amount double check(amount >= 0),
    interest_rate double check(interest_rate >= 0),
    start_date date not null,
    end_date date not null,
    bank_name varchar(20) not null,
    customer_id int not null,
    foreign key(bank_name) references bank(name) on delete cascade,
    foreign key(customer_id) references customer(id) on delete cascade
);

