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
    
class account:
    def __init__(self, conn):
        self.conn = conn;

    def add_account(self, new_id, new_balance, new_create_date, new_bank_name, new_customer_id):
        cursor = self.conn.cursor()
        cursor.callproc('add_account', (new_id, new_balance, new_create_date, new_bank_name, new_customer_id))
        self.conn.commit()
        cursor.close()

    def delete_account(self, account_id):
        cursor = self.conn.cursor()
        cursor.callproc('delete_account', account_id)
        self.conn.commit()
        cursor.close()

    def update_account(self, old_id, new_id, new_balance, new_create_date, new_bank_name, new_customer_id):
        cursor = self.conn.cursor()
        cursor.callproc('update_account', (old_id, new_id, new_balance, new_create_date, new_bank_name, new_customer_id))
        self.conn.commit()
        cursor.close()

    def query_account(self, account_id):
        cursor = self.conn.cursor()
        cursor.callproc('query_account', account_id)
        result = cursor.fetchall()
        self.conn.commit()
        cursor.close()
        return result
    
    def query_account_balance(self, account_id):
        cursor = self.conn.cursor()
        cursor.callproc('query_balance', account_id)
        result = cursor.fetchall()
        self.conn.commit()
        cursor.close()
        return result
    
    def transfer(self, from_account_id, to_account_id, amount):
        cursor = self.conn.cursor()
        cursor.callproc('transfer', (from_account_id, to_account_id, amount))
        self.conn.commit()
        cursor.close()

    def withdraw(self, account_id, amount):
        cursor = self.conn.cursor()
        cursor.callproc('withdraw', (account_id, amount))
        self.conn.commit()
        cursor.close()

    def deposit(self, account_id, amount):
        cursor = self.conn.cursor()
        cursor.callproc('deposit', (account_id, amount))
        self.conn.commit()
        cursor.close()

class customer:
    def __init__(self, conn):
        self.conn = conn;

    def add_customer(self, new_id, new_name, new_phone, new_address, new_employee_id, new_photo_name):
        cursor = self.conn.cursor()
        cursor.callproc('add_customer', (new_id, new_name, new_phone, new_address, new_employee_id, new_photo_name))
        self.conn.commit()
        cursor.close()

    def delete_customer(self, customer_id):
        cursor = self.conn.cursor()
        cursor.callproc('delete_customer', customer_id)
        self.conn.commit()
        cursor.close()

    def update_customer(self, old_id, new_id, new_name, new_phone, new_address, new_employee_id, new_photo_name):
        cursor = self.conn.cursor()
        cursor.callproc('update_customer', (old_id, new_id, new_name, new_phone, new_address, new_employee_id, new_photo_name))
        self.conn.commit()
        cursor.close()

    def query_customer(self, customer_id):
        cursor = self.conn.cursor()
        cursor.callproc('query_customer', customer_id)
        result = cursor.fetchall()
        self.conn.commit()
        cursor.close()
        return result
    
    def query_customer_balance(self, customer_id):
        cursor = self.conn.cursor()
        cursor.callproc('query_customer_balance', customer_id)
        result = cursor.fetchall()
        self.conn.commit()
        cursor.close()
        return result
    
class department:
    def __init__(self, conn):
        self.conn = conn;

    def add_department(self, new_id, new_name, new_type, new_director, new_bank_name):
        cursor = self.conn.cursor()
        cursor.callproc('add_department', (new_id, new_name, new_type, new_director, new_bank_name))
        self.conn.commit()
        cursor.close()

    def delete_department(self, department_id):
        cursor = self.conn.cursor()
        cursor.callproc('delete_department', department_id)
        self.conn.commit()
        cursor.close()

    def update_department(self, old_id, new_id, new_name, new_type, new_director, new_bank_name):
        cursor = self.conn.cursor()
        cursor.callproc('update_department', (old_id, new_id, new_name, new_type, new_director, new_bank_name))
        self.conn.commit()
        cursor.close()

    def query_department(self, department_id):
        cursor = self.conn.cursor()
        cursor.callproc('query_department', department_id)
        result = cursor.fetchall()
        self.conn.commit()
        cursor.close()
        return result
    
class employee:
    def __init__(self, conn):
        self.conn = conn;

    def add_employee(self, new_id, new_name, new_phone, new_address, new_employee_date, new_department_id):
        cursor = self.conn.cursor()
        cursor.callproc('add_employee', (new_id, new_name, new_phone, new_address, new_employee_date, new_department_id))
        self.conn.commit()
        cursor.close()

    def delete_employee(self, employee_id):
        cursor = self.conn.cursor()
        cursor.callproc('delete_employee', employee_id)
        self.conn.commit()
        cursor.close()

    def update_employee(self, old_id, new_id, new_name, new_phone, new_address, new_employee_date, new_department_id):
        cursor = self.conn.cursor()
        cursor.callproc('update_employee', (old_id, new_id, new_name, new_phone, new_address, new_employee_date, new_department_id))
        self.conn.commit()
        cursor.close()

    def query_employee(self, employee_id):
        cursor = self.conn.cursor()
        cursor.callproc('query_employee', employee_id)
        result = cursor.fetchall()
        self.conn.commit()
        cursor.close()
        return result
    
    def query_employee_department(self, employee_id):
        cursor = self.conn.cursor()
        cursor.callproc('query_employee_department', employee_id)
        result = cursor.fetchall()
        self.conn.commit()
        cursor.close()
        return result
    
class loan:
    def __init__(self, conn):
        self.conn = conn;

    def add_loan(self, new_id, new_amount, new_interest_rate, new_start_date, new_end_date, new_bank_name, new_customer_id):
        cursor = self.conn.cursor()
        cursor.callproc('add_loan', (new_id, new_amount, new_interest_rate, new_start_date, new_end_date, new_bank_name, new_customer_id))
        self.conn.commit()
        cursor.close()

    def delete_loan(self, loan_id):
        cursor = self.conn.cursor()
        cursor.callproc('delete_loan', loan_id)
        self.conn.commit()
        cursor.close()

    def update_loan(self, old_id, new_id, new_amount, new_interest_rate, new_start_date, new_end_date, new_bank_name, new_customer_id):
        cursor = self.conn.cursor()
        cursor.callproc('update_loan', (old_id, new_id, new_amount, new_interest_rate, new_start_date, new_end_date, new_bank_name, new_customer_id))
        self.conn.commit()
        cursor.close()

    def query_loan(self, loan_id):
        cursor = self.conn.cursor()
        cursor.callproc('query_loan', loan_id)
        result = cursor.fetchall()
        self.conn.commit()
        cursor.close()
        return result
