# 图形界面类
import tkinter  # 使用Tkinter前需要先导入
from tkinter import ttk

from EMSQL.searchSQL import searchSQL


class searchWindow:
    def __init__(self):
        # 数据库
        self.search = searchSQL()  # 实例化数据库查询类
        self.search.connectDB()  # 连接数据库
        # 字体
        self.customFont = ('SimSun', 11)
        # 窗口
        self.mainWindow = tkinter.Tk()  # 实例化窗口
        self.mainWindow.title("Embedded SQL EXP")  # 窗口名称
        self.mainWindow.geometry("570x290")  # 窗口大小
        # 变量
        self.addressVar = tkinter.StringVar()
        self.addressVar.set("")
        # 容器
        self.mainFrame = tkinter.Frame(self.mainWindow)  # 实例化父容器
        self.mainFrame.pack()
        self.answerFrame = tkinter.ttk.LabelFrame(self.mainFrame, text="结果显示列表", padding=(5, 5, 5, 5))  # 显示列表容器
        self.operationFrame = tkinter.ttk.LabelFrame(self.mainFrame, text="查询操作", padding=(5, 5, 5, 5))  # 操作容器
        self.operationFrame.pack(side=tkinter.TOP, fill=tkinter.X)
        self.answerFrame.pack(side=tkinter.BOTTOM, fill=tkinter.X)  # 相对布局
        # 结果列表
        columns = ['sno', 'sname', 'ssex', 'sage', 'saddr']
        self.answerList = ttk.Treeview(
            master=self.answerFrame,
            height=8,
            columns=columns,
            show="headings"
        )
        self.answerList.heading(column='sno', text="学号", anchor="w")
        self.answerList.heading(column='sname', text="姓名", anchor="w")
        self.answerList.heading(column='ssex', text="性别", anchor="w")
        self.answerList.heading(column='sage', text="年龄", anchor="w")
        self.answerList.heading(column='saddr', text="地址", anchor="w")
        self.answerList.column('sno', width=150, minwidth=100, anchor='s')
        self.answerList.column('sname', width=100, minwidth=100, anchor='s')
        self.answerList.column('ssex', width=40, minwidth=40, anchor='s')
        self.answerList.column('sage', width=40, minwidth=40, anchor='s')
        self.answerList.column('saddr', width=200, minwidth=100, anchor='s')
        self.answerList.grid(row=0, column=0)  # 表格布局
        # 输入label
        self.addressLabel = tkinter.Label(self.operationFrame, text="输入家庭地址", font=self.customFont)
        self.addressLabel.grid(row=0, column=0)  # 表格布局
        # 输入框
        self.addressEntry = tkinter.Entry(self.operationFrame, textvariable=self.addressVar, width=50)
        self.addressEntry.grid(row=0, column=1)  # 表格布局
        # 按钮
        self.searchButton = tkinter.Button(self.operationFrame, text="查询", font=self.customFont, width=8, height=1,
                                           command=self.searchAddress)
        self.searchButton.grid(row=0, column=2)  # 表格布局
        # 打开窗口
        self.mainWindow.mainloop()

    def insertToTable(self, info):
        for data in info:
            self.answerList.insert("", tkinter.END, values=data)

    def clearTable(self):
        obj = self.answerList.get_children()  # 获取所有对象
        for o in obj:
            self.answerList.delete(o)  # 删除对象

    def searchAddress(self):
        self.search.openCursor()  # 打开游标
        address = self.addressVar.get()  # 获取输入的字符串
        queryset = self.search.searchCustom("*", "s", ["saddr LIKE \'%" + address + "%\'"])
        # print(queryset)
        self.clearTable()
        self.insertToTable(queryset)


instance = searchWindow()
