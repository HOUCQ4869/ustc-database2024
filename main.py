import pymysql
from flask import Flask, render_template, request, redirect, url_for, session
import function
from datetime import timedelta
import os

app = Flask(__name__)
app.config['SECRET_KEY'] = os.urandom(24)
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(days=31)


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
        

@app.route('/homepage')
def homepage():
    return render_template('homepage.html')


@app.route("/homepage/bank", methods = (["GET", "POST"]))
def bank():
    if request.method == 'GET':
        return render_template('bank.html')
    else:
        if 'username' not in session:
            return redirect(url_for('login'))
        username = session['username']
        password = session['password']
        conn = pymysql.connect(host='localhost', user=username, password=password, database='bank_sys', charset='utf8')
        BANK = function.bank(conn)
        if 'ADD' in request.form:
            new_name = request.form['new_name']
            new_address = request.form['new_address']
            new_phone = request.form['new_phone']
            new_asset = request.form['new_asset']
            BANK.add_bank(new_name, new_address, new_phone, new_asset)
            return render_template('bank.html')
        elif 'DELETE' in request.form:
            bank_name = request.form['bank_name']
            BANK.delete_bank([bank_name])
            return render_template('bank.html')
        elif 'UPDATE' in request.form:
            old_name = request.form['old_name']
            new_name = request.form['new_name']
            new_address = request.form['new_address']
            new_phone = request.form['new_phone']
            new_asset = request.form['new_asset']
            BANK.update_bank(old_name, new_name, new_address, new_phone, new_asset)
            return render_template('bank.html')
        elif 'QUERY_BANK' in request.form:
            bank_name = request.form['bank_name']
            result = BANK.query_bank([bank_name])
            return render_template('bank.html', query_res=result)
        elif 'QUERY_ASSET' in request.form:
            bank_name = request.form['bank_name']
            result = BANK.query_bank_asset([bank_name])
            return render_template('bank.html', asset_res=result)


@app.route('/homepage/account', methods=['GET', 'POST'])
def account():

    if request.method == 'GET':
        return render_template('account.html')
    else:
        if 'username' not in session:
            return redirect(url_for('login'))
        username = session['username']
        password = session['password']
        conn = pymysql.connect(host='localhost', user=username, password=password, database='bank_sys', charset='utf8')
        ACCOUNT = function.account(conn)
        if 'ADD' in request.form:
            new_id = request.form['new_id']
            new_balance = request.form['new_balance']
            new_create_date = request.form['new_create_date']
            new_bank_name = request.form['new_bank_name']
            new_customer_id = request.form['new_customer_id']
            ACCOUNT.add_account(new_id, new_balance, new_create_date, new_bank_name, new_customer_id)
            return render_template('account.html')
        elif 'DELETE' in request.form:
            account_id = request.form['account_id']
            ACCOUNT.delete_account([account_id])
            return render_template('account.html')
        elif 'UPDATE' in request.form:
            old_id = request.form['old_id']
            new_id = request.form['new_id']
            new_balance = request.form['new_balance']
            new_create_date = request.form['new_create_date']
            new_bank_name = request.form['new_bank_name']
            new_customer_id = request.form['new_customer_id']
            ACCOUNT.update_account(old_id, new_id, new_balance, new_create_date, new_bank_name, new_customer_id)
            return render_template('account.html')
        elif 'TRANSFER' in request.form:
            from_account_id = request.form['from_account_id']
            to_account_id = request.form['to_account_id']
            amount = request.form['amount']
            ACCOUNT.transfer(from_account_id, to_account_id, amount)
            return render_template('account.html')
        elif 'WITHDRAW' in request.form:
            account_id = request.form['account_id']
            amount = request.form['amount']
            ACCOUNT.withdraw(account_id, amount)
            return render_template('account.html')
        elif 'DEPOSIT' in request.form:
            account_id = request.form['account_id']
            amount = request.form['amount']
            ACCOUNT.deposit(account_id, amount)
            return render_template('account.html')
        elif 'QUERY_ACCOUNT' in request.form:
            account_id = request.form['account_id']
            result = ACCOUNT.query_account([account_id])
            return render_template('account.html', query_res=result)
        elif 'QUERY_BALANCE' in request.form:
            account_id = request.form['account_id']
            result = ACCOUNT.query_account_balance([account_id])
            return render_template('account.html', balance_res=result)
        
        

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


@app.route('/homepage/department', methods=['GET', 'POST'])
def department():
    if request.method == 'GET':
        return render_template('department.html')
    else:
        if 'username' not in session:
            return redirect(url_for('login'))
        username = session['username']
        password = session['password']
        conn = pymysql.connect(host='localhost', user=username, password=password, database='bank_sys', charset='utf8')
        DEPARTMENT = function.department(conn)
        if 'ADD' in request.form:
            new_id = request.form['new_id']
            new_name = request.form['new_name']
            new_type = request.form['new_type']
            new_director = request.form['new_director']
            new_bank_name = request.form['new_bank_name']
            DEPARTMENT.add_department(new_id, new_name, new_type, new_director, new_bank_name)
            return render_template('department.html')
        elif 'DELETE' in request.form:
            department_id = request.form['department_id']
            DEPARTMENT.delete_department([department_id])
            return render_template('department.html')
        elif 'UPDATE' in request.form:
            old_id = request.form['old_id']
            new_id = request.form['new_id']
            new_name = request.form['new_name']
            new_type = request.form['new_type']
            new_director = request.form['new_director']
            new_bank_name = request.form['new_bank_name']
            DEPARTMENT.update_department(old_id, new_id, new_name, new_type, new_director, new_bank_name)  
            return render_template('department.html')
        elif 'QUERY_DEPARTMENT' in request.form:
            department_id = request.form['department_id']
            result = DEPARTMENT.query_department([department_id])
            return render_template('department.html', query_res=result)
        


@app.route('/homepage/employee', methods=['GET', 'POST'])
def employee():

    if request.method == 'GET':
        return render_template('employee.html')
    else:
        if 'username' not in session:
            return redirect(url_for('login'))
        username = session['username']
        password = session['password']
        conn = pymysql.connect(host='localhost', user=username, password=password, database='bank_sys', charset='utf8')
        EMPLOYEE = function.employee(conn)
        if 'ADD' in request.form:
            new_id = request.form['new_id']
            new_name = request.form['new_name']
            new_phone = request.form['new_phone']
            new_address = request.form['new_address']
            new_employee_date = request.form['new_employee_date']
            new_department_id = request.form['new_department_id']
            EMPLOYEE.add_employee(new_id, new_name, new_phone, new_address, new_employee_date, new_department_id)
            return render_template('employee.html')
        elif 'DELETE' in request.form:
            employee_id = request.form['employee_id']
            EMPLOYEE.delete_employee([employee_id])
            return render_template('employee.html')
        elif 'UPDATE' in request.form:
            old_id = request.form['old_id']
            new_id = request.form['new_id']
            new_name = request.form['new_name']
            new_phone = request.form['new_phone']
            new_address = request.form['new_address']
            new_employee_date = request.form['new_employee_date']
            new_department_id = request.form['new_department_id']
            EMPLOYEE.update_employee(old_id, new_id, new_name, new_phone, new_address, new_employee_date, new_department_id)
            return render_template('employee.html')
        elif 'QUERY_EMPLOYEE' in request.form:
            employee_id = request.form['employee_id']
            result = EMPLOYEE.query_employee([employee_id])
            return render_template('employee.html', query_res=result)
        elif 'QUERY_DEPARTMENT' in request.form:
            employee_id = request.form['employee_id']
            result = EMPLOYEE.query_employee_department([employee_id])
            return render_template('employee.html', department_res=result)


@app.route('/homepage/loan', methods=['GET', 'POST'])
def loan():

    if request.method == 'GET':
        return render_template('loan.html')
    else:
        if 'username' not in session:
            return redirect(url_for('login'))
        username = session['username']
        password = session['password']
        conn = pymysql.connect(host='localhost', user=username, password=password, database='bank_sys', charset='utf8')
        LOAN = function.loan(conn)
        if 'ADD' in request.form:
            new_id = request.form['new_id']
            new_amount = request.form['new_amount']
            new_interest_rate = request.form['new_interest_rate']
            new_start_date = request.form['new_start_date']
            new_end_date = request.form['new_end_date']
            new_bank_name = request.form['new_bank_name']
            new_customer_id = request.form['new_customer_id']
            LOAN.add_loan(new_id, new_amount, new_interest_rate, new_start_date, new_end_date, new_bank_name, new_customer_id)
            return render_template('loan.html')
        elif 'DELETE' in request.form:
            loan_id = request.form['loan_id']
            LOAN.delete_loan([loan_id])
            return render_template('loan.html')
        elif 'UPDATE' in request.form:
           old_id = request.form['old_id']
           new_id = request.form['new_id']
           new_amount = request.form['new_amount']
           new_interest_rate = request.form['new_interest_rate']
           new_start_date = request.form['new_start_date']
           new_end_date = request.form['new_end_date']
           new_bank_name = request.form['new_bank_name']
           new_customer_id = request.form['new_customer_id']
           LOAN.update_loan(old_id, new_id, new_amount, new_interest_rate, new_start_date, new_end_date, new_bank_name, new_customer_id)
           return render_template('loan.html')
        elif 'QUERY_LOAN' in request.form:
            loan_id = request.form['loan_id']
            result = LOAN.query_loan([loan_id])
            return render_template('loan.html', query_res=result)


if __name__ == '__main__':
    app.run()
