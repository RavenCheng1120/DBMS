import mysql.connector
from mysql.connector import Error
import pandas as pd

def connect_To_DB():
	try:
		connection = mysql.connector.connect(
			host='localhost',    # 主機名稱
			database = 'statisticsdb', #資料庫
			user='root',         # 帳號
			password='****')  # 密碼

		cursor = connection.cursor()
		data_insert(cursor, connection)

	except Error as e:
		print("Database connect fail：", e)

	finally:
		if (connection.is_connected()):
			cursor.close()
			connection.close()
			print("connection offline")


def data_insert(cursor, connection):
	cursor.execute("USE statisticsdb")
	cursor.execute("DROP TABLE IF EXISTS Wilconxon_p_table")

	rowData = []
	pData = pd.read_csv('NewWilcoxonTable.csv')
	# print(pData.shape) #(3168, 98)
	for row in pData:
		rowData.append(row)
	rowData = rowData[1:]

	# Create Table: 100 columns
	columnString = "CREATE TABLE Wilconxon_p_table (R_Value FLOAT NOT NULL, "
	for columnName in rowData:
		columnName = columnName.replace(".0", "")
		if columnName != '100':
			columnString += f"N_{columnName} FLOAT, "
		else:
			columnString += f"N_{columnName} FLOAT, PRIMARY KEY (R_Value))"
	cursor.execute(columnString)
	connection.commit()

	for r in pData.iterrows():
		insertString = "INSERT INTO Wilconxon_p_table VALUES ("
		for idx in range(0, pData.shape[1]):
			if idx == pData.shape[1]-1:
				insertString += f"{r[1][idx]})"
			else:
				insertString += f"{r[1][idx]}, "
		cursor.execute(insertString)
		connection.commit()


if __name__ == '__main__':
	connect_To_DB()