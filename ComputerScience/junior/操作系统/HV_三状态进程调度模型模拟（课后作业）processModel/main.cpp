#include <iostream>
#include <queue>

using namespace std;

typedef struct process {
    int pid;
    int pState;//1就绪，2执行，3等待
} Process;

class processModel {
public:
    queue<Process> blockedQueue;
    queue<Process> readyQueue;
    Process runningProcess{};
    bool hasRunning;//true 有，false 没有
public:
    processModel();

    ~processModel();

    void processDispatch();

    void printState() const;
};

void printQueue(queue<Process> q, int state) {
    //printing content of queue
    while (!q.empty()) {
        if (q.front().pState == state) {
            cout << q.front().pid << " ";
            q.pop();
        } else {
            cout << endl << "Invalid process: " << q.front().pid << endl;
            exit(-1);
        }
    }
    cout << endl;
}

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

processModel::~processModel() {
    //清空队列
    while (!blockedQueue.empty()) {
        blockedQueue.pop();
    }
    while (!readyQueue.empty()) {
        readyQueue.pop();
    }
}

void processModel::processDispatch() {
    int inputNum;
    cout << "============================================" << endl;
    cout << "Input Your Operation: ";
    cin >> inputNum;
    switch (inputNum) {
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
