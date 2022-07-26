/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/9 23:49
 */

#include "Lexer.h"

//Constructor
Lexer::Lexer() {
    memset(lineCharStr, 0x00, sizeof(char) * 256);
    SymbolTableLength = 0;
}

//Destructor
Lexer::~Lexer() {
    if (inputCode.is_open()) {
        inputCode.close();
    }
    if (outputSymbolTable.is_open()) {
        outputSymbolTable.close();
    }
    if (outputToken.is_open()) {
        outputToken.close();
    }
    if (outputLexemes.is_open()) {
        outputLexemes.close();
    }
    while (symbolTableHead != nullptr) {
        SymbolTableItem *p = symbolTableHead;
        symbolTableHead = symbolTableHead->next;
        delete p;
    }
    std::cout << "Delete Symbol Table Successfully!" << std::endl;
}

//创建符号表
void Lexer::createSymbolTable() {
    //初始化符号表长度
    SymbolTableLength = 0;
    //创建头节点（头节点名称索引默认为-1）
    symbolTableHead = new SymbolTableItem(-1);
    //当前节点指针指向头节点
    symbolTableTail = symbolTableHead;
    symbolTableTemp = symbolTableTail;
    std::cout << "Create Symbol Table Successfully!" << std::endl;
}

//新增符号表项（返回下标）
int Lexer::addSymbolTableItem(SymbolTableItem *newItem) {
    symbolTableTail->next = newItem;
    symbolTableTail = symbolTableTail->next;
    symbolTableTail->next = nullptr;
    symbolTableTemp = symbolTableTail;
    //符号表长度+1
    SymbolTableLength += 1;
    return SymbolTableLength - 1;
}

//返回标识符在符号表中的位置或者即将插入的位置的相反数
int Lexer::findSymbolTableItem(const std::string &symbol) {
    int nameIndex = lexemesTable.findLexeme(symbol);
    std::cout << "[LEXEME](find): " << nameIndex << std::endl;
    if (nameIndex >= 0) {//如果词素表中查到了该词素
        int pos = 0;//第一个有内容的节点为0
        SymbolTableItem *p = symbolTableHead;
        while (p->next != nullptr) {//如果下一节点不是nullptr（本节点不是尾）
            p = p->next;
            if (nameIndex == p->getName()) {//比对符号表name字段与查出来的标识符在字符串表中的索引
                return pos;//如果相等则返回该符号表位置，该位置是标识符在符号表中的位置
            }
            pos++;
        }
    }
    return -1;//没查到返回-1
}

bool Lexer::openInputCode(const std::string &fileName) {
    inputCode.open(fileName);
    if (inputCode) {
        std::cout << "Open Source Successfully!" << std::endl;
        return true;
    } else {
        std::cout << "Open Source Failed." << std::endl;
        return false;
    }
}

bool Lexer::openOutputSymbolTable(const std::string &fileName) {
    outputSymbolTable.open(fileName);
    if (outputSymbolTable) {
        std::cout << "Open Symbol Table File Successfully!" << std::endl;
        return true;
    } else {
        std::cout << "Open Symbol Table File Failed." << std::endl;
        return false;
    }
}

bool Lexer::openOutputToken(const std::string &fileName) {
    outputToken.open(fileName);
    if (outputToken) {
        std::cout << "Open Token File Successfully!" << std::endl;
        return true;
    } else {
        std::cout << "Open Token File Failed." << std::endl;
        return false;
    }
}

bool Lexer::openOutputLexemes(const std::string &fileName) {
    outputLexemes.open(fileName);
    if (outputLexemes) {
        std::cout << "Open Lexemes File Successfully!" << std::endl;
        return true;
    } else {
        std::cout << "Open Lexemes File Failed." << std::endl;
        return false;
    }
}


void Lexer::outputSymbolTableToFile() {
    outputSymbolTable << "[Symbol Table]" << std::endl;
    outputSymbolTable << "INDEX IN LEXEMES" << "," << "TYPE" << "," << "KIND" << "," << "VALUE" << "," << "ADDRESS"
                      << std::endl;
    SymbolTableItem *p = symbolTableHead;
    while (p->next) {//如果下一节点不是nullptr（本节点不是尾）
        p = p->next;
        p->outputSymbolTableItem(outputSymbolTable);
    }
    std::cout << "Output to Symbol Table File Successfully!" << std::endl;
}

void Lexer::outputTokenToFile() {
    tokenTable.outputToken(outputToken);
}

void Lexer::outputLexemesToFile() {
    lexemesTable.outputLexemes(outputLexemes);
}


void Lexer::closeInputCode() {
    if (inputCode.is_open()) {
        inputCode.close();
        std::cout << "Close Source Successfully!" << std::endl;
    }
}

void Lexer::closeOutputSymbolTable() {
    if (outputSymbolTable.is_open()) {
        outputSymbolTable.close();
        std::cout << "Close Symbol Table File Successfully!" << std::endl;
    }
}

void Lexer::closeOutputToken() {
    if (outputToken.is_open()) {
        outputToken.close();
        std::cout << "Close Token File Successfully!" << std::endl;
    }
}

void Lexer::closeOutputLexemes() {
    if (outputLexemes.is_open()) {
        outputLexemes.close();
        std::cout << "Close Lexemes File Successfully!" << std::endl;
    }
}

//自动机
int Lexer::FA() {
    if (!inputCode) {
        std::cout << "Source is not Open." << std::endl;
        return -1;
    }
    lineCurrent = 0;//初始行号为0
    //读文件循环
    while (getline(inputCode, lineString)) {
        strcpy(lineCharStr, lineString.c_str());
        std::cout << "[Get Line](" << lineCurrent << "): " << lineString << std::endl;
        lineCurrent++;
        lexemeBegin = 0;
        lexemeForward = 0;
        stateFA = 0;
        //自动机循环
        while (true) {
            switch (stateFA) {
                //开始状态
                case 0:
                    forward_c = lineCharStr[lexemeForward];
                    std::cout << "[State](0): " << forward_c << std::endl;
                    //排除空字符循环
                    while (forward_c == ' ' || forward_c == '\t') {
                        lexemeForward++;
                        lexemeBegin++;
                        forward_c = lineCharStr[lexemeForward];
                        std::cout << "[State](0) real forward_c: " << forward_c << std::endl;
                    }
                    //Digit
                    if (isDigits(forward_c)) {
                        stateFA = 20;//进入判断数字的状态
                    } else if (isLetter_(forward_c)) {
                        stateFA = 22;//进入判断字母下划线的状态
                    } else {
                        switch (forward_c) {
                            case '<':
                                stateFA = 1;
                                break;
                            case '=':
                                stateFA = 4;
                                break;
                            case '>':
                                stateFA = 7;
                                break;
                            case '!':
                                stateFA = 10;
                                break;
                            case '+':
                                stateFA = 12;
                                break;
                            case '-':
                                stateFA = 13;
                                break;
                            case '*':
                                stateFA = 14;
                                break;
                            case '/':
                                stateFA = 15;
                                break;
                            case '(':
                                stateFA = 16;
                                break;
                            case ')':
                                stateFA = 17;
                                break;
                            case ';':
                                stateFA = 18;
                                break;
                            case '\'':
                                stateFA = 19;
                                break;
                            case '\0':
                                stateFA = 100;//读到每行结尾则清空行缓冲区
                                memset(lineCharStr, 0x00, sizeof(char) * 256);
                                std::cout << "[State](0): " << "Return" << std::endl;
                                break;
                            default:
                                std::cout << "[Error]:Error at Line " << lineCurrent << " : " << lineCharStr
                                          << std::endl;
                                exit(-1);
                        }
                    }
                    break;
                case 1://输入了<
                    lexemeForward++;
                    forward_c = lineCharStr[lexemeForward];
                    std::cout << "[State](1): " << forward_c << std::endl;
                    switch (forward_c) {
                        case '=':
                            stateFA = 2;
                            break;
                        default:
                            stateFA = 3;
                    }
                    break;
                case 4://输入了=
                    lexemeForward++;
                    forward_c = lineCharStr[lexemeForward];
                    std::cout << "[State](4): " << forward_c << std::endl;
                    switch (forward_c) {
                        case '=':
                            stateFA = 5;
                            break;
                        default:
                            stateFA = 6;
                    }
                    break;
                case 7://输入了>
                    lexemeForward++;
                    forward_c = lineCharStr[lexemeForward];
                    std::cout << "[State](7): " << forward_c << std::endl;
                    switch (forward_c) {
                        case '=':
                            stateFA = 8;
                            break;
                        default:
                            stateFA = 9;
                    }
                    break;
                case 10://输入了!
                    lexemeForward++;
                    forward_c = lineCharStr[lexemeForward];
                    std::cout << "[State](10): " << forward_c << std::endl;
                    switch (forward_c) {
                        case '=':
                            stateFA = 11;
                            break;
                        default:
                            std::cout << "[Error]:Error at Line " << lineCurrent << " : " << lineCharStr << std::endl;
                            lexemeBegin = lexemeForward;
                            stateFA = 0;//TODO 这里为啥这样写
                    }
                    break;
                    /*运算符*/
                case 3://识别<
                case 9://识别>
                    lexemeForward--; //先回退一步
                case 2://识别<=
                case 5://识别==
                case 8://识别>=
                case 11://识别!=
                case 12://识别 +
                case 13://识别 -
                case 14://识别 *
                case 15://识别 /
                {
                    std::cout << "[State](*): " << "OPERATOR" << std::endl;
                    std::cout << "[State](*): " << lineCharStr[lexemeForward] << std::endl;
                    //存token
                    TokenValue tokenValueTemp;
                    memset(tokenValueTemp.valOperator, 0x00, sizeof(char) * 4);
                    for (int i = 0; i <= lexemeForward - lexemeBegin; ++i) {
                        tokenValueTemp.valOperator[i] = lineCharStr[lexemeBegin + i];
                    }
                    lexemeForward++;
                    tokenValueTemp.valOperator[lexemeForward - lexemeBegin] = '\0';
                    std::cout << "[OPERATOR]: " << tokenValueTemp.valOperator << std::endl;
                    tokenTable.saveToken(TOKEN_OPERATOR, tokenValueTemp);
                    //恢复初态
                    stateFA = 0;
                    lexemeBegin = lexemeForward;
                    break;
                }
                    /*界限符*/
                case 6://识别=
                    lexemeForward--; //先回退一步
                case 16://识别 (
                case 17://识别 )
                case 18://识别 ;
                case 19://识别 '
                {
                    std::cout << "[State](*): " << "SEPARATOR" << std::endl;
                    std::cout << "[State](*): " << lineCharStr[lexemeForward] << std::endl;
                    //存token
                    TokenValue tokenValueTemp;
                    memset(tokenValueTemp.valSeparator, 0x00, sizeof(char) * 4);
                    for (int i = 0; i <= lexemeForward - lexemeBegin; ++i) {
                        tokenValueTemp.valSeparator[i] = lineCharStr[lexemeBegin + i];
                    }
                    lexemeForward++;
                    tokenValueTemp.valSeparator[lexemeForward - lexemeBegin] = '\0';
                    std::cout << "[SEPARATOR]: " << tokenValueTemp.valSeparator << std::endl;
                    tokenTable.saveToken(TOKEN_SEPARATOR, tokenValueTemp);
                    //恢复初态
                    stateFA = 0;
                    lexemeBegin = lexemeForward;
                    break;
                }
                    /*数字循环*/
                case 20:
                    while (isDigits(forward_c)) {//循环直至不是数字
                        lexemeForward++;
                        forward_c = lineCharStr[lexemeForward];
                        std::cout << "[State](20): " << forward_c << std::endl;
                    }
                    stateFA = 21;
                    break;
                    /*数字常量识别*/
                case 21: {
                    std::cout << "[State](*): " << "INTEGER" << std::endl;
                    lexemeForward--;//数字 指针回退
                    std::cout << "[State](21): " << lineCharStr[lexemeForward] << std::endl;
                    //存token
                    TokenValue tokenValueTemp;
                    char valIntegerTemp[16];
                    memset(valIntegerTemp, 0x00, sizeof(char) * 16);
                    for (int i = 0; i <= lexemeForward - lexemeBegin; ++i) {
                        valIntegerTemp[i] = lineCharStr[lexemeBegin + i];
                    }
                    lexemeForward++;
                    valIntegerTemp[lexemeForward - lexemeBegin] = '\0';//数字字符
                    char *strPtr;//其余字符
                    tokenValueTemp.valInteger = int(strtol(valIntegerTemp, &strPtr, 10));
                    if (*strPtr != '\0') {//如果余下字符不是\0开头则
                        std::cout << "[Error]:Error in integer at " << lineCurrent << " : " << lineCharStr << std::endl;
                        exit(-1);
                    }
                    std::cout << "[INTEGER]: " << tokenValueTemp.valInteger << std::endl;
                    tokenTable.saveToken(TOKEN_INT, tokenValueTemp);
                    //恢复初态
                    stateFA = 0;
                    lexemeBegin = lexemeForward;
                    break;
                }
                    /*字母循环*/
                case 22:
                    while (isLetter_(forward_c)) {//循环直至不是数字
                        lexemeForward++;
                        forward_c = lineCharStr[lexemeForward];
                        std::cout << "[State](22): " << forward_c << std::endl;
                    }
                    stateFA = 23;
                    break;
                    /*字母下划线识别*/
                case 23: {
                    std::cout << "[State](*): " << "LETTER_" << std::endl;
                    lexemeForward--;
                    std::cout << "[State](23): " << lineCharStr[lexemeForward] << std::endl;
                    //存token
                    TokenValue tokenValueTemp;
                    char valLetterTemp[256];
                    memset(valLetterTemp, 0x00, sizeof(char) * 256);
                    for (int i = 0; i <= lexemeForward - lexemeBegin; ++i) {
                        valLetterTemp[i] = lineCharStr[lexemeBegin + i];
                    }
                    lexemeForward++;//为了添加\0也为下一次循环重置指针
                    valLetterTemp[lexemeForward - lexemeBegin] = '\0';
                    /*关键字识别*/
                    isKeyword = false;
                    for (int i = 0; i < 6; ++i) {
                        if (strcmp(valLetterTemp, keywords[i]) == 0) {//是关键字
                            isKeyword = true;
                            tokenValueTemp.indexKeyword = i;//是关键字在关键字表中的下标
                            std::cout << "[KEYWORD]: " << valLetterTemp << tokenValueTemp.indexKeyword << std::endl;
                            tokenTable.saveToken(TOKEN_KEYWORD, tokenValueTemp);
                        }
                    }
                    if (isKeyword) {
                        std::cout << "[Letter_](*): " << "KEYWORD" << std::endl;
                    } else {
                        std::cout << "[Letter_](*): " << "IDENTIFIER" << std::endl;
                    }
                    /*标识符识别*/
                    std::string valLetterTempString = valLetterTemp;
                    if (!isKeyword) {
                        int indexFind = findSymbolTableItem(valLetterTempString);
                        std::cout << "[SYMBOL](find): " << valLetterTempString << " " << indexFind << std::endl;
                        if (indexFind < 0) {
                            //向字符串表中存
                            unsigned int indexLexeme = lexemesTable.saveLexeme(valLetterTempString);
                            std::cout << "[LEXEME](add): " << indexLexeme << std::endl;
                            std::cout << "[LEXEME](length): " << indexLexeme + 1 << std::endl;
                            //创建符号表节点
                            auto *newSymbol = new SymbolTableItem(indexLexeme);
                            //向符号表插入节点
                            indexFind = addSymbolTableItem(newSymbol);
                            //符号表长度+1
                            //SymbolTableLength++;//已在增加链表中处理
                            std::cout << "[SYMBOL](add): " << newSymbol->getName() << std::endl;
                            std::cout << "[SYMBOL](length): " << SymbolTableLength << std::endl;
                        }
                        tokenValueTemp.indexIdentifier = indexFind;//标识符在符号表中的下标
                        std::cout << "[IDENTIFIER]: " << valLetterTemp << tokenValueTemp.indexIdentifier << std::endl;
                        tokenTable.saveToken(TOKEN_IDENTIFIER, tokenValueTemp);
                    }
                    //恢复初态
                    stateFA = 0;
                    lexemeBegin = lexemeForward;
                    break;
                }
//                case 100:
//                    stateFA = 100;
//                    break;
//                default:
//                    stateFA = 100;
            }
            if (stateFA == 100)
                break;
        }
    }
    return 0;
}

void Lexer::printSymbolTable() {
    std::cout << std::endl << "[Symbol Table]" << std::endl;
    SymbolTableItem *p = symbolTableHead;
    while (p->next) {//如果下一节点不是nullptr（本节点不是尾）
        p = p->next;
        p->printSymbolTableItem();
    }
}






