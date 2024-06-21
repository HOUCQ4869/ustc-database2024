<div style="text-align:center;font-size:2em;font-weight:bold">中国科学技术大学计算机学院</div>

<br>

<div style="text-align:center;font-size:2em;font-weight:bold">《数据库系统实验报告》</div>
<br>

<div align=center>
<img src="./src/logo.png" style="zoom: 50%;" />
</div>


<div style="display: flex;flex-direction: column;align-items: center;font-size:2em">
<div>
<p>实验题目：银行管理系统</p>
<p>学生姓名：侯超群</p>
<p>学生学号：PB21111618</p>
<p>完成时间：2024年6月21日</p>
</div>
</div>


<div style="page-break-after:always"></div>

## 需求分析

* 银行管理系统，主要由银行、银行部门、员工、客户、账户以及贷款六个实体组成，其中银行拥有数个部门，各员工分属各部门；员工负责维护客户，银行负责给客户开户和发放贷款；
* 银行属性有名称、地址、联系电话、资产；
* 银行部门属性有部门号、名称、类型、主管；
* 员工属性有员工号、姓名、联系电话、住址、雇佣时间；
* 账户属性有账户余额、账户号、开户支行、开户时间；
* 客户属性有姓名、身份证号、联系电话、住址、照片名；
* 贷款属性有贷款号、贷款金额、利率、贷款日期、还款日期；

## 总体设计

#### 系统模块结构

* 使用B/S架构，python+flask框架；
* 前端：采用Flask框架，通过获取用户在网页的操作进行交互；
* 后端：Mysql数据库，通过存储过程，触发器，事务，函数等实现对数据的增删改查管理；
* 服务器：通过处理网页请求并传至数据库，实现前后端交互；

#### 系统工作流程

* 用户在网页操作增删改查等命令，网页通过提交表单等操作将命令传回服务器，服务器调用封装后的函数，操作数据库管理系统，并获取相应的返回值，通过服务器传参至网页并显示结果；

#### 数据库设计

* ER图
![](er.jpg)

* 模式分解
  + 每个实体对应一个表，且主键为相应的ID标识，除了bank表中银行名称作为主键；
  + 银行部门，账户，贷款中有银行名称作为外键约束；员工中有部门ID作为外键约束；客户中有员工ID作为外键约束；同时账户，贷款中还有客户ID作为外键约束；
  + 显然，各个表中各项属性均直接依赖于主键，因此是满足3NF模式的；

* 存储过程、触发器、事务等设计思路
  + 存储过程、函数用于实现增删改查各项操作，通过对存储过程的调用实现对数据库的操作；
  + 触发器主要在账户和贷款中进行实现，由于涉及到银行资产的变化，采用触发器，当账户或者贷款表发生变化时，记录相应的金额变化并触发银行表中资产的变化；
  + 事务主要用于账户的转账操作，为了保证转账的原子性操作，采取事务进行金额的改动；


## 核心代码解析

#### 仓库地址

https://github.com/HOUCQ4869/ustc-database2024

#### 目录
~~~
│  function.py-----------------------将存储过程封装成相应函数
│  main.py---------------------------与网页实现交互，并调用已封装的函数实现后端操作
│
├─sql
│      account.sql-------------------账户表相应存储过程及触发器
│      bank.sql----------------------银行表
│      creat_table.sql---------------创建并初始化各表
│      customer.sql
│      data.sql----------------------测试数据
│      department.sql
│      employee.sql
│      loan.sql
│      test.sql----------------------测试文件，用于debug
│
├─static
│  │  favicon.png--------------------网页导航栏图片
│  │  style.css----------------------网页样式
│  │
│  ├─images--------------------------网页插图
│  │      avatar.png
│  │
│  └─test----------------------------各用户头像
│          lisi.jpg
│          new.jpg
│          sunqi.jpg
│          wangwu.jpg
│          wujiu.jpg
│          zhangsan.jpg
│          zhaoliu.jpg
│          zhengshi.jpg
│
├─templates--------------------------各网页
│      account.html
│      bank.html
│      customer.html
│      department.html
│      employee.html
│      homepage.html
│      loan.html
│      login.html
│
└─__pycache__
        function.cpython-311.pyc
~~~

#### 后端实现
* **按照前述的ER图进行相应的设计各个表，为了实现对应的增删改查操作，创建相应的存储过程**
* **以bank表为例，增删改查的存储过程创建如下：**
  + 增加银行，判断是否存在，不存在则插入新银行相应的信息；
  ~~~mysql
    // sql\bank.sql
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
  ~~~

  + 删除银行，由于在创建表中实现了级联删除，直接删除即可；
  ~~~mysql
    // sql\bank.sql
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
  ~~~
  + 更新银行，判断主键是否修改再按情况更新表即可；
  ~~~mysql
    // sql\bank.sql
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
  ~~~
  + 查询银行，直接查询；同时还有银行的各个属性可以查询，如银行资产，同样创建了相应的存储过程等待调用，在此不做赘述；
  ~~~mysql
    // sql\bank.sql
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
  ~~~
* **其余表的增删改查操作同理，除此之外账户表中还有对应的存钱、取钱存储过程如下：**
  + 取钱，即类似于更新账户操作；存钱同理；
  ~~~mysql
    // sql\account.sql
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
  ~~~
* **在账户的转账操作中采取了事务实现，如下：**
  ~~~mysql
    // mysql\account.sql
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
  ~~~
* **最后是触发器的实现，以银行资产相应的触发器为例：**
  + 账户表变化，计算余额变化并更新到银行资产中；贷款表中触发器同理，不做赘述；
  ~~~mysql
    // sql\account.sql
    drop trigger if exists update_account_trigger;
    delimiter //
    create trigger update_account_trigger
    after update on account
    for each row
    begin
        update bank set asset = asset + new.balance - old.balance where name = new.bank_name;
    end //
    delimiter ;
  ~~~

#### 前后端交互
* **通过python实现mysql操作，将各个存储过程在function.py中封装成函数并用于前端调用；**
* 以bank为例：调用前需要初始化，以与数据库建立相应连接，开启连接后通过cursor.callproc调用存储过程，并传入相应参数，若是查询操作，则返回相应结果，最后提交并关闭连接；其余类似，不做赘述；
  ~~~python
    class bank:
        def __init__(self, conn):
            self.conn = conn;

        def add_bank(self, new_name, new_address, new_phone, new_asset):
            cursor = self.conn.cursor()
            cursor.callproc('add_bank', (new_name, new_address, new_phone, new_asset))
            self.conn.commit()
            cursor.close()

        def delete_bank(self, bank_name):
            cursor = self.conn.cursor()
            cursor.callproc('delete_bank', bank_name)
            self.conn.commit()
            cursor.close()

        def update_bank(self, old_name, new_name, new_address, new_phone, new_asset):
            cursor = self.conn.cursor()
            cursor.callproc('update_bank', (old_name, new_name, new_address, new_phone, new_asset))
            self.conn.commit()
            cursor.close()

        def query_bank(self, bank_name):
            cursor = self.conn.cursor()
            cursor.callproc('query_bank', bank_name)
            result = cursor.fetchall()
            self.conn.commit()
            cursor.close()
            return result

        
        def query_bank_asset(self, bank_name):
            cursor = self.conn.cursor()
            cursor.callproc('get_bank_asset', bank_name)
            result = cursor.fetchall()
            self.conn.commit()
            cursor.close()
            return result
  ~~~


#### 前端实现
* **前端采用flask框架实现，实现了登录，主页，各模块管理页面，以及前端网页与服务器的交互操作；**
* **以登录界面为例：**
  + 默认为进入的首页，并通过网页端返回的请求，接收对应的username,password，并尝试与数据库进行连接，成功则前往主页；
  ~~~python
    // main.py
    @app.route('/', methods=['GET', 'POST'])
    def loginpage():
        if request.method == 'GET':
            return render_template('login.html')
        else:
            user = request.form['username']
            password = request.form['password']
            conn = pymysql.connect(host='localhost', user=user, password=password, database='bank_sys', charset='utf8')
        
            if (conn == None):
                return render_template("login.html", res=-1)
            else:
                session['username'] = user
                session['password'] = password
                return redirect(url_for('homepage'))
  ~~~
  + 如下是对应的html页面，第一次写前端难免有些简陋，除了相关的链接及渲染的图片外，主体是username及password的提交表单，将相应请求传至服务器端；
  ~~~html
    // templates\login.html
    <!doctype html>
    <html lang="zh-CN">
    <head>
        <link rel="icon" href="{{ url_for('static', filename='favicon.ico') }}">
        <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}" type="text/css">
    </head>
    <body>
        <div class="header">
            <h1 class="logo">login
            </h1>
            <img alt="Avatar" class="avatar" src="{{ url_for('static', filename='images/avatar.png') }}">
            <ul class="nav">
                <li><a href="https://houcq4869.github.io/">My blog</a></li>
                <li><a href="">About</a></li>
                <li><a href="https://github.com/HOUCQ4869">Github</a></li>
            </ul>
        </div>
        <br>
        <form method="post">
            <h1>
                <p align="center">Welcome to my bank_sys</p>
            </h1>
            <br>
            <br>
            <br>
            <br>
            <p align="center">
                <label for="username">Username</label>
                <input type="text" name="username" id="username" required>
                <br>
                <br>
                <label for="password">Password</label>
                <input type="password" name="password" id="password" required>
                <br>
                <br>
                <br>
                <input class="submit" type="submit" value="Log In">
            </p>
        </form>
        <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

        <div class="footer">
            <p>© 2024 bank_system create by houcq</p>
        </div>

    </body>

    </html>
  ~~~
* **主页界面简单设置了其余各个模块的导航链接，以及相应的css美化；**
* **由于customer包含对于图片的管理，以customer界面为例概述各个模块前端的实现：**
  + 与登录界面类似，通过接收网页请求，由于登录界面将cookie保存到session中，首先判断是否存在，不然则需要重新登陆；之后则与数据库建立相应链接，判断是哪种操作，并获取相应的值，通过调用function.py中封装的函数实现对数据库的更新；如果是查询操作，通过将函数返回的值再次传参到网页中，显示给用户；
  ~~~python
    // main.py
    @app.route("/homepage/customer", methods = (["GET", "POST"]))
    def customer():
        if request.method == 'GET':
            return render_template('customer.html')
        else:
            if 'username' not in session:
                return redirect(url_for('login'))
            username = session['username']
            password = session['password']
            conn = pymysql.connect(host='localhost', user=username, password=password, database='bank_sys', charset='utf8')
            CUSTOMER = function.customer(conn)
            if 'ADD' in request.form:
                new_id = request.form['new_id']
                new_name = request.form['new_name']
                new_phone = request.form['new_phone']
                new_address = request.form['new_address']
                new_employee_id = request.form['new_employee_id']
                new_photo_name = request.form['new_photo_name']
                CUSTOMER.add_customer(new_id, new_name, new_phone, new_address, new_employee_id, new_photo_name)
                return render_template('customer.html')
            elif 'DELETE' in request.form:
                customer_id = request.form['customer_id']
                CUSTOMER.delete_customer([customer_id])
                return render_template('customer.html')
            elif 'UPDATE' in request.form:
                old_id = request.form['old_id']
                new_id = request.form['new_id']
                new_name = request.form['new_name']
                new_phone = request.form['new_phone']
                new_address = request.form['new_address']
                new_employee_id = request.form['new_employee_id']
                new_photo_name = request.form['new_photo_name']
                CUSTOMER.update_customer(old_id, new_id, new_name, new_phone, new_address, new_employee_id, new_photo_name)
                return render_template('customer.html')
            elif 'QUERY_CUSTOMER' in request.form:
                customer_id = request.form['customer_id']
                result = CUSTOMER.query_customer([customer_id])
                return render_template('customer.html', query_res=result)
            elif 'QUERY_BALANCE' in request.form:
                customer_id = request.form['customer_id']
                result = CUSTOMER.query_customer_balance([customer_id])
                return render_template('customer.html', balance_res=result)

  ~~~
  + 如下是对应的html页面实现，通过将页面分割为左右两侧显示更美观，类似与登录界面，通过提交表单的形式输入相应的值，查询结果显示在最后，通过{query_res}得到传参来的返回值；对于图片管理，通过获取的图片名查询在static文件夹中的客户照片，更新或者添加时同样通过该静态文件获取；
  ~~~html
    // templates\customer.html
    <!DOCTYPE html>
    <html lang="zh-CN">
    <head>
        <link rel="icon" href="{{ url_for('static', filename='favicon.png') }}">
        <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}" type="text/css">
        <meta charset="UTF-8">
        <title>customer manage</title>
    </head>
    <body>
        <div class="header">
            <h1 class="logo">customer manage
            </h1>
            <img alt="Avatar" class="avatar" src="{{ url_for('static', filename='images/avatar.png') }}">
            <ul class="nav">
                <li><a href="/homepage">Return</a></li>
                <li><a href="https://houcq4869.github.io/">My blog</a></li>
                <li><a href="">About</a></li>
                <li><a href="https://github.com/HOUCQ4869">Github</a></li>
            </ul>
        </div>
        <div class="wrap">
            <div class="left">
                <h2>Add</h2><br>
                <form method="post">
                    <label for="new_id">new_id:</label>
                    <input type="text" id="new_id" name="new_id" required>
                    <br>
                    <label for="new_name">new_name:</label>
                    <input type="text" id="new_name" name="new_name" required>
                    <br>
                    <label for="new_phone">new_phone:</label>
                    <input type="text" id="new_phone" name="new_phone" required>
                    <br>
                    <label for="new_address">new_address:</label>
                    <input type="text" id="new_address" name="new_address" required>
                    <br>
                    <label for="new_employee_id">new_employee_id:</label>
                    <input type="text" id="new_employee_id" name="new_employee_id" required>
                    <br>
                    <label for="new_photo_name">new_photo_name:</label>
                    <input type="text" id="new_photo_name" name="new_photo_name" required>
                    <br><br>
                    <p align="center">
                        <input class="submit" type="submit" name="ADD" value="enter">
                    </p>
                </form>
            </div>
            <div class="right">
                <h2>Update</h2><br>
                <form method="post">
                    <label for="old_id">old_id:</label>
                    <input type="text" id="old_id" name="old_id" required>
                    <br>
                    <label for="new_id">new_id:</label>
                    <input type="text" id="new_id" name="new_id" required>
                    <br>
                    <label for="new_name">new_name:</label>
                    <input type="text" id="new_name" name="new_name" required>
                    <br>
                    <label for="new_phone">new_phone:</label>
                    <input type="text" id="new_phone" name="new_phone" required>
                    <br>
                    <label for="new_address">new_address:</label>
                    <input type="text" id="new_address" name="new_address" required>
                    <br>
                    <label for="new_employee_id">new_employee_id:</label>
                    <input type="text" id="new_employee_id" name="new_employee_id" required>
                    <br>
                    <label for="new_photo_name">new_photo_name:</label>
                    <input type="text" id="new_photo_name" name="new_photo_name" required>
                    <br><br>
                    <p align="center">
                        <input class="submit" type="submit" name="UPDATE" value="enter">
                    </p>
                </form>
            </div>
        </div>
        <div class="wrap">
            <div class="left">
                <h2>Delete</h2><br>
                <form id="deleteForm" method="post">
                    <label for="customer_id">customer_id:</label>
                    <input type="text" id="customer_id" name="customer_id" required>
                    <br><br>
                    <p align="center">
                        <input class="submit" type="submit" name="DELETE" value="enter">
                    </p>
                </form>
            </div>
            <div class="right">
                <h2>Query</h2><br>
                <h3>message</h3>
                <form method="post">
                    <label for="customer_id">customer_id:</label>
                    <input type="text" id="customer_id" name="customer_id" required>
                    <br><br>
                    <p align="center">
                        <input class="submit" type="submit" name="QUERY_CUSTOMER" value="enter">
                    </p>
                </form>
                <br>
                <h3>balance</h3>
                <form method="post">
                    <label for="customer_id">customer_id:</label>
                    <input type="text" id="customer_id" name="customer_id" required>
                    <br><br>
                    <p align="center">
                        <input class="submit" type="submit" name="QUERY_BALANCE" value="enter">
                    </p>
                </form>
            </div>
        </div>
        <div>
            <h2>Query result</h2>
            <div class="wrap">
                <div class="left">
                    {% for item in query_res %}
                    <h3>
                        <p align="center">id: {{item[0]}}</p>
                        <p align="center">name: {{item[1]}}</p>
                        <p align="center">phone: {{item[2]}}</p>
                        <p align="center">address: {{item[3]}}</p>
                        <p align="center">employee_id: {{item[4]}}</p>
                    </h3>
                    <img src="{{ url_for('static', filename='test/' + item[5]) }}" alt="photo" width="100" height="100">
                    {% endfor %}
                </div>
                <div class="right">
                    {% for item in balance_res %}
                    <h3>
                        <p align="center">balance: {{item[0]}}</p>
                    </h3>
                    {% endfor %}
                </div>
            </div>
        </div>
        <div class="footer">
            <p>© 2024 bank_system create by houcq</p>
        </div>
    </body>
    </html>
  ~~~

## 实验与测试

#### 依赖

* 所需的库如下，pymysql用于操作mysql，flask用于web框架，function即自定义的相关函数库，timedelta及os库用于密钥的生成及更新；
  ~~~python
    import pymysql
    from flask import Flask, render_template, request, redirect, url_for, session
    import function
    from datetime import timedelta
    import os
  ~~~
* 实验环境即windows

#### 部署

* 代码运行步骤
  + 创建表及存储过程等sql文件执行后，直接运行main.py即可；

#### 实验结果

* 页面展示：如登录界面，主页（未显示完全）及用户管理界面；
![](page_1.png)
![](page_2.png)
![](page_3.png)

* 增删改查：由于检查实验过程中已经测试，在此演示在更新时同时对于图片的管理；
  + 查询用户1的信息如下：
    ![](page_4.png)
  + 更新用户1的头像信息后如下：
    ![](page_5.png)
  + 删除用户1后查询如下：由于未进行错误处理，报错属于正常；
    ![](page_6.png)
  + 最后再增加用户1，查询如下：
    ![](page_7.png)

* 触发器演示，例如添加账户时，查询对应银行的资产变化；
  + 以中国银行为例，先查询银行信息如下：
    ![](page_8.png)
  + 添加账户22及相应的1000余额如下：
    ![](page_9.png)
  + 再次查询银行信息如下： 
    ![](page_10.png)

* 事务演示，首先查询用户2，3的余额，并进行转账操作，再次查询验证：
  + 初始余额如下：
    ![](page_11.png)
    ![](page_12.png)
  + 转账操作如下：
    ![](page_13.png)
  + 验证余额如下：
    ![](page_14.png)
    ![](page_15.png)
