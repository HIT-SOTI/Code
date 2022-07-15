import traceback

import pymysql  # 导入模块


class searchSQL:
    def __init__(self):
        self.db = None  # 数据库
        self.cursor = None  # 游标
        self.error = None  # 错误

    def __del__(self):
        if self.cursor is not None:
            self.cursor.close()
        if self.db is not None:
            self.db.close()

    # 连接数据库
    def connectDB(self):
        try:
            self.db = pymysql.connect(host='localhost',
                                      port=3306,
                                      user='root',
                                      passwd='',
                                      db='embeddedsql',
                                      charset='utf8')  # 本机数据库连接
        except Exception as e:
            print(e)
            self.error = e
            traceback.print_exc()

    # 打开游标
    def openCursor(self):
        self.cursor = self.db.cursor()

    # 关闭游标
    def closeCursor(self):
        self.cursor.close()

    # 查询测试
    def searchTest(self):
        sql = "SELECT * FROM s"
        self.cursor.execute(sql)
        data = self.cursor.fetchall()
        for i in data:
            print(i)

    # 自定义查询
    def searchCustom(self, fields, table, condition):
        sql = "SELECT "
        if fields == "*":
            sql += fields
            sql += " "
        else:
            fieldsTemp = ""
            for i in fields:
                fieldsTemp += i
                fieldsTemp += " "
            sql += fieldsTemp
        sql += " FROM "
        sql += table
        if condition is not None:
            sql += " "
            sql += " WHERE "
            for i in range(len(condition)):
                sql += condition[i]
                if i == len(condition) - 1:
                    break
                sql += " AND "
        print(sql)
        try:
            self.cursor.execute(sql)
            data = self.cursor.fetchall()
            # for i in data:
            #     print(i)
            return data
        except Exception as e:
            print(e)
            self.error = e
            traceback.print_exc()


# s = searchSQL()
# s.connectDB()
# s.openCursor()
# s.searchTest()
