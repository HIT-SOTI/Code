/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/23 08:48
 */

#include "Parser.h"

Parser::Parser() {
    //为指针申请空间（笨办法，临时变量）
    Symbol symTemp(" ", 0);
    expStart = new GenerateExpression(symTemp);
    symbolStart = new Symbol(" ", 0);
}

Parser::~Parser() {
    if (inputGrammar.is_open()) {
        inputGrammar.close();
    }
}

void Parser::pretreatment() {
    /*增广文法*/
    //创建增广文法开始符，用EE表示
    Symbol expStartLeft("EE", 1);
    //存入左部
    expStart->setLeft(expStartLeft);
    //创建右部
    symbolStart->setName("P");
    symbolStart->setType(1);
    //右部第一个产生式
    rightStart.push_back(*symbolStart);
    //存入右部
    expStart->rights.push_back(rightStart);
    //增广文法产生式存入
    exps.push_back(*expStart);

    /*循环读入语法文件每一行*/
    while (getline(inputGrammar, lineString)) {
        bool firstFlag = true;//第一个字符为左部 标记
        int p1 = 0, p2 = 0;//设置双指针找到子串
        int leftIdx = -1;//产生式下标
        std::vector<Symbol> expRight;//产生式右部
        for (int i = 0; i < lineString.size(); ++i) {//遍历每一个字符
            if (lineString[i] == ' ') {//找到一个空格（即存在分割）
                p2 = i;
                if (firstFlag) {//如果式子是左部的处理方法
                    std::string leftExp = lineString.substr(p1, p2 - p1);//左部子串
                    if (!isupper(leftExp[0])) {//非大写
                        std::cout << "[Error]:Left is not Upper Symbol!" << std::endl;
                        exit(-1);//错误退出
                    }
                    //找到一样的左部
                    for (int j = 0; j < exps.size(); ++j) {
                        if (exps[j].getLeft().getName() == leftExp) {
                            leftIdx = j;
                            break;
                        }
                    }
                    if (leftIdx == -1) {//如果找不到一样的左部
                        leftIdx = int(exps.size());//新增一个左部的索引
                        Symbol leftTemp(leftExp, 1);//新增一个左部
                        GenerateExpression expTemp(leftTemp);
                        exps.push_back(expTemp);//新增一个产生式实例
                    }
                    firstFlag = false;//如果找到了左部，那么本行剩余的都不是左部
                } else {//如果是右部
                    std::string rightTemp = lineString.substr(p1, p2 - p1);//右部的一个
                    Symbol symbolTemp_1(rightTemp, int(isupper(rightTemp[0])));//生成一个右部符号
                    if (symbolTemp_1.getName() == "|") {//如果符号是｜
                        exps[leftIdx].rights.push_back(expRight);//证明一个产生式生成
                        expRight.clear();//清空单右部容器
                    } else {
                        expRight.push_back(symbolTemp_1);//右部容器中存入一个符号
                    }
                }
                p1 = p2 + 1;//指针右移
            } else if (i == lineString.size() - 1) {// grammar.txt 产生式最后一个符号不为|
                p2 = i;//找不到空格字符且是最后一个字符
                // （文法文件中最后一个字符不是空，故实际上处理最后一个字符因为最后一个字符后不是空，所以按上一个条件无法处理）
                std::string rightEnd = lineString.substr(p1, p2 - p1 + 1);
                Symbol symbolTemp_2(rightEnd, int(isupper(rightEnd[0])));
                expRight.push_back(symbolTemp_2);
                exps[leftIdx].rights.push_back(expRight);
            }
        }
    }
}

bool Parser::openInputGrammar(const std::string &fileName) {
    inputGrammar.open(fileName);
    if (inputGrammar) {
        std::cout << "Open Grammar Successfully!" << std::endl;
        return true;
    } else {
        std::cout << "Open Grammar Failed." << std::endl;
        return false;
    }
}

void Parser::closeInputGrammar() {
    if (inputGrammar.is_open()) {
        inputGrammar.close();
        std::cout << "Close Grammar Successfully!" << std::endl;
    }
}

void Parser::printGrammar() {
    std::cout << "[Grammar Read-in]" << std::endl;
    for (auto &exp: exps) {
        std::cout << exp.getLeft().getName() << " -> ";
        for (int j = 0; j < exp.rights.size(); ++j) {
            for (auto &k: exp.rights[j]) {
                std::cout << k.getName() << " ";
            }
            if (j != exp.rights.size() - 1) {
                std::cout << "| ";
            }
        }
        std::cout << std::endl;
    }
}

void Parser::generateGOTO() {
    //最开始的一项
    Items items0;
    Item itemStart(0, 0, 0);
    items0.kernelItems.push_back(itemStart);
    closure(exps, items0);//获取第一项集的非内核项
    items0.setId(0);//第一项集编号为0
    QItems.push(items0);//加入队列，以便循环分析
    allItems.push_back(items0);//加入项集族
    int count = 1;//项集数 也是allItems的下标，初始化为1（也是下一项集的下标），0下标是初始项集
    while (!QItems.empty()) {
        Items items = QItems.front();
        QItems.pop();
        std::vector<std::string> names;//所有的符号名字
        getAllNames(exps, items, names);//获取第一项 所有点的下一项符号名字
        for (auto &name: names) {
            if (name == "@") {//如果下一项是空，则直接不管，进入下一字符的判断
                continue;
            }
            Items items1 = goTo(exps, items, name);//求出当前项集接收name[i]后的下一项集
            bool flag = false;//项集族中是否有下一项集的标记
            for (auto &allItem: allItems) {
                if (allItem == items1) {//（已重载）如果下一项集和已有的某个项集内核项相同
                    flag = true;
                    Symbol nameTemp(name, int(isupper(name[0])));//创建接受的符号，如果是大写则为非终结符
                    //allItems[items.id].directions.push_back(Direction(allItems[j].id, nameTemp));
                    allItems[items.id].directions.emplace_back(allItem.id, nameTemp);//创建路径至已有的项集
                    break;
                }
            }
            if (!flag) {//如果项集不在已有项集族中
                closure(exps, items1);//求该项集内核项闭包（求非内核项并存入）
                items1.id = count++;//项集数 也是allItems的下标，赋值后+1
                QItems.push(items1);//将新项集加入队列以供后续判断
                Symbol nameTemp(name, int(isupper(name[0])));
                //allItems[items.id].directions.push_back(Direction(items1.id,nameTemp));
                allItems[items.id].directions.emplace_back(items1.id, nameTemp);//当前项集的出度+1，指向新的项集
                allItems.push_back(items1);//将该项集加入项集族
            }
        }
    }
}

void Parser::generateFIRSTAndFOLLOW() {
    follow[expStart->getLeft()].push_back(*endSym);//开始符号follow集为"$"
}
