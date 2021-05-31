import mysql.connector
from mysql.connector import Error
from mysql.connector.cursor import MySQLCursorPrepared
import csv

def connect_to_DB():
	try:
		connection = mysql.connector.connect(
			host='localhost',    # 主機名稱
			database = 'DB_class', #資料庫
			user='root',         # 帳號
			password='****')  # 密碼

		cursor = connection.cursor()
		cursor_prep = connection.cursor(cursor_class=MySQLCursorPrepared)
		# cursor.execute("CREATE DATABASE DB_class") # Create database
		cursor.execute("USE DB_class")
		cursor.execute("DROP TABLE IF EXISTS student")
		cursor.execute("CREATE TABLE student (StuID INT NOT NULL, 身份 varchar(10), 系所 varchar(10), 學號 varchar(10), 姓名 varchar(10), 年級 varchar(10), PRIMARY KEY (StuID))")

		# --- Task #1 ---
		data_insert(cursor, connection)
		# --- Task #2 ---
		print("Task #2")
		my_data = show_self(cursor, connection)
		print()
		# --- Task #3 ---
		print("Task #3")
		show_peer(cursor, connection, my_data)
		print()
		# --- Task #4 ---
		print("Task #4")
		total_number = count_total(cursor, connection)
		print()
		# --- Task #5 ---
		print("Task #5")
		specific_ID = 'r09921000'
		select_specific(cursor, connection, specific_ID)
		print()
		# --- Task #6 ---
		print("Task #6")
		update_value(cursor, connection)
		print()
		# --- Task #7 ---
		print("Task #7")
		students_list = [[-1, '旁聽生', '歷史系', 'b09900201', '小花', '一年級'], 
			[-1, '校內生', '歷史系', 'b06900332', '小草', '四年級'], 
			[-1, '校內生', '機械系', 'b06502055', '小天', '四年級']]
		new_students(cursor, connection, students_list, total_number)
		print()
		# --- Task #8 ---
		print("Task #8")
		statement = "SELECT * FROM student WHERE 學號 = %s"
		search_ID_list = ['b09900201', 'b06900332', 'b06502055']
		show_new_student(cursor_prep, connection, statement, search_ID_list)
		print()

		# cursor.execute("DROP DATABASE DB_class") # Delete database

	except Error as e:
		print("Database connect fail：", e)

	finally:
		if (connection.is_connected()):
			cursor.close()
			connection.close()
			print("connection offline")

# Put csv file data into database
def data_insert(cursor, connection):
	with open('EE5178_student_data.csv', newline='') as csv_file:
		rows = csv.reader(csv_file)
		next(rows) # skip the header

		for row in rows:
			insert_string = "INSERT INTO student VALUES (%s, %s, %s, %s, %s, %s)"
			data_string = []
			# Replace "\xa0" with blank
			for attribute in range(len(row)):
				row[attribute] = row[attribute].replace("\xa0", "")
				if attribute == 0:
					row[attribute] = int(row[attribute])
				data_string.append(row[attribute])
			cursor.execute(insert_string, tuple(data_string))
			connection.commit()

		# fetches all rows from the last executed statement
		# cursor.execute("SELECT * FROM student")
		# result = cursor.fetchall()
		# for i in result:
		# 	print(i)

def show_self(cursor, connection):
	cursor.execute("SELECT * FROM student WHERE 學號 = 'r09922063'")
	result = cursor.fetchone()
	print(result)
	return result

def show_peer(cursor, connection, my_result):
	my_department = my_result[2]
	my_year = my_result[5]
	cursor.execute("SELECT * FROM student WHERE 系所 = %s AND 年級 = %s AND 學號 != 'r09922063'", (my_department, my_year))
	result = cursor.fetchall()
	for i in result:
		print(i)

def count_total(cursor, connection):
	cursor.execute("SELECT COUNT(*) AS NumberOfPeople FROM student")
	number = int(cursor.fetchone()[0])
	print(number)
	return number

def select_specific(cursor, connection, specific_ID):
	cursor.execute("SELECT * FROM student WHERE 學號 = %s", (specific_ID,))
	print(cursor.fetchone())

def update_value(cursor, connection):
	cursor.execute("UPDATE student SET 身份 = '特優生' WHERE 學號 = 'r09922063'")
	connection.commit()
	cursor.execute("SELECT * FROM student WHERE 學號 = 'r09922063'")
	print(cursor.fetchone())

def new_students(cursor, connection, students_list, number_of_student):
	for stu in students_list:
		stu[0] = number_of_student
		number_of_student += 1
		insert_string = "INSERT INTO student VALUES (%s, %s, %s, %s, %s, %s)"
		data_string = []
		for attribute in range(len(stu)):
			data_string.append(stu[attribute])
		cursor.execute(insert_string, tuple(data_string))
		connection.commit()

	cursor.execute("SELECT * FROM student WHERE StuID > 84")
	result = cursor.fetchall()
	for i in result:
		print(i)

def show_new_student(cursor_prep, connection, statement, ID_list):
	cursor_prep.execute(statement)
	for student_id in ID_list:
		cursor_prep.execute(statement, (student_id,))
		print(cursor_prep.fetchone())
		connection.commit()

if __name__ == '__main__':
	connect_to_DB()