import mysql.connector
from mysql.connector import Error
import pandas as pd

def connect_To_DB():
	try:
		connection = mysql.connector.connect(
			host='localhost',    # 主機名稱
			database = 'statisticsdb', #資料庫
			user='root',         # 帳號
			password='123qweasd')  # 密碼

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
	cursor.execute("DROP TABLE IF EXISTS wilcoxonPTable")

	pData = pd.read_csv('wilcoxonTable.csv')
	pData_transposed = pData.transpose()

	print(pData_transposed.dtypes)


if __name__ == '__main__':
	connect_To_DB()