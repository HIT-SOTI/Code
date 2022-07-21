# 三状态进程调度模型

> Author: fengclchn@outlook.com
>
> Date: 11/16/2021

[TOC]

## 仓库介绍

### 项目说明

- 本仓库是哈尔滨工业大学（威海）操作系统课程某次课后作业（ZDJ）

- 本仓库地址：https://github.com/HistoneVon/processModel.git

- 作业题目

  ![image-20220721231634647](https://histone-obs.obs.cn-southwest-2.myhuaweicloud.com/noteImg/image-20220721231634647.png)

### 开发环境

* Windows 10 Home
* Jetbrains Clion 2021 **（建议直接使用Clion打开本仓库）**

### 本仓库包含

* 源码：main.cpp
* CMake构建配置：CMakeLists.txt（由Clion生成）
* 程序介绍：见下

## 基本数据结构

```c++
typedef struct process {
    int pid;
    int pState;//1就绪，2执行，3等待
} Process;
```

```c++
queue<Process> blockedQueue;//blocked queue
queue<Process> readyQueue;//ready queue
Process runningProcess{};//running process
```

## 工具函数

### printQueue() 用于打印队列

```c++
void printQueue(queue<Process> q, int state) {
    //printing content of queue
    while (!q.empty()) {
        if (q.front().pState == state) {//用于检验队列中进程状态是否正确
            cout << q.front().pid << " ";
            q.pop();
        } else {
            cout << endl << "Invalid process: " << q.front().pid << endl;
            exit(-1);//出现非法进程则终止程序
        }
    }
    cout << endl;
}
```

## 进程调度类

### 类定义

```c++
class processModel {
public:
    queue<Process> blockedQueue;//阻塞 等待 队列
    queue<Process> readyQueue;//就绪队列
    Process runningProcess{};//执行进程
    bool hasRunning;//是否有进程正在执行的标志位 true 有，false 没有
public:
    processModel();

    ~processModel();

    void processDispatch();

    void printState() const;
};
```

### 类实现

#### processModel() 初始化队列及进程状态

```c++
processModel::processModel() {
    //初始化就绪队列
    for (int i = 0; i < 7; ++i) {
        Process tempProcess = {i + 1, 1};
        readyQueue.push(tempProcess);
    }
    //初始化执行
    hasRunning = true;
    runningProcess.pid = 8;
    runningProcess.pState = 2;
}
```

#### ~processModel() 置空队列

```c++
processModel::~processModel() {
    //清空队列
    while (!blockedQueue.empty()) {
        blockedQueue.pop();
    }
    while (!readyQueue.empty()) {
        readyQueue.pop();
    }
}
```

#### void processDispatch() 进程调度函数

```c++
void processModel::processDispatch() {
    int inputNum;
    cout << "============================================" << endl;
    cout << "Input Your Operation: ";
    cin >> inputNum;
    switch (inputNum) {//根据用户键盘输入进行判断
        case 3:
            if (hasRunning) {
                runningProcess.pState = 3;
                blockedQueue.push(runningProcess);
                hasRunning = false;
            } else {
                cout << "There is no process which is running!" << endl;
            }
            break;
        case 4:
            if (!blockedQueue.empty()) {
                Process tempProcess = blockedQueue.front();
                tempProcess.pState = 1;
                readyQueue.push(tempProcess);
                blockedQueue.pop();
            } else {
                cout << "There is no process which is blocked!" << endl;
            }
            break;
        case 1:
            if (hasRunning) {
                cout << "Processor Occupied" << endl;
            } else {
                if (!readyQueue.empty()) {
                    Process tempProcess = readyQueue.front();
                    tempProcess.pState = 2;
                    runningProcess = tempProcess;
                    readyQueue.pop();
                    hasRunning = true;
                } else {
                    cout << "There is no process which is ready!" << endl;
                }
            }
            break;
        case 2:
            if (hasRunning) {
                runningProcess.pState = 1;
                readyQueue.push(runningProcess);
                hasRunning = false;
            } else {
                cout << "There is no process which is running!" << endl;
            }
            break;
        default:
            cout << "Input Valid!" << endl;
    }
}
```

#### void printState() 打印当前进程状态

```c++
void processModel::printState() const {
    cout << "Running: ";
    if (hasRunning) {
        cout << runningProcess.pid << endl;
    } else {
        cout << endl;
    }
    cout << "Ready: ";
    printQueue(readyQueue, 1);
    cout << "Blocked: ";
    printQueue(blockedQueue, 3);
}
```

## 主函数

```c++
int main() {
    processModel p;
    cout << "The Initial State is: " << endl;
    p.printState();
    while (true) {
        p.processDispatch();
        p.printState();
        cout << "Exit?(Y/n) ";
        string ch;
        cin >> ch;
        if (ch == "Y") {
            break;
        } else if (ch == "n") {
            continue;
        } else {
            cout << "Input Valid!" << endl;
        }
    }
    return 0;
}
```

## 进程调度逻辑

* 执行-3->等待
  * 如果有进程正在执行，则改变该进程的状态为等待，进入等待队列
  * 如果没有进程正在执行，则打印“没有进程正在执行”
* 等待-4->就绪
  * 如果等待队列不为空，则取队头进入就绪队列
  * 如果等待队列为空，则打印”没有等待的进程“
* 就绪-1->执行
  * 如果有执行的进程，则打印”进程占用“
  * 如果没有执行的进程，且就绪队列不为空，则取就绪队列对头执行
  * 如果没有执行的进程，且就绪队列为空，则打印”没有就绪的进程“
* 执行-2->就绪
  * 如果有进程正在执行，则改变该进程的状态为就绪，进入就绪队列
  * 如果没有进程正在执行，则打印“没有进程正在执行”

## 运行结果

![image-20211116150008934](https://histone-obs.obs.cn-southwest-2.myhuaweicloud.com/noteImg/image-20211116150008934.png)