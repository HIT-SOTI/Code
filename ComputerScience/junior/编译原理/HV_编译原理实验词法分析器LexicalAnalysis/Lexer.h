/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/9 23:49
 */

#ifndef LEXICALANALYSIS_LEXER_H
#define LEXICALANALYSIS_LEXER_H

#include "SymbolTable.h"
#include "LexemesTable.h"
#include "Token.h"
#include "Utils.h"
#include "Keywords.h"
#include <fstream>
#include <iostream>
#include <cstring>

//char keywords[6][8] = {"if", "else", "while", "do", "int", "float"};//关键字集合
//char keywords[][8] = {"if", "else", "while", "do", "int", "float"};

class Lexer {
private:
    /*符号表*/
    SymbolTableItem *symbolTableHead = nullptr;//头节点
    SymbolTableItem *symbolTableTemp = nullptr;//当前节点
    SymbolTableItem *symbolTableTail = nullptr;//尾节点
    int SymbolTableLength = 0;
    /*文件*/
    std::ifstream inputCode;//读入源文件
    std::ofstream outputSymbolTable;//输出符号表
    std::ofstream outputToken;//输出Token
    std::ofstream outputLexemes;//输出字符串表
    /*语法分析器*/
    std::string lineString; //读出的一行代码
    int lineCurrent = 0;           //行号，用于提供出错信息
    int lexemeBegin = 0;    //当前词素开始处
    int lexemeForward = 0;        //一直向前扫描，直到发现某个模式被匹配为止
    char forward_c = 0;         //下一个字符
    char lineCharStr[256] = "";  //一行的c字符串
    int stateFA = 0;          //FA状态
    bool isKeyword = false; //是关键字标志位
public:
    /*字符串表（词素表）*/
    Lexemes lexemesTable;
    /*TOKEN*/
    TokenTable tokenTable;

    //Constructor
    Lexer();

    //Destructor
    ~Lexer();

    /*文件操作*/
    bool openInputCode(const std::string &fileName);

    bool openOutputSymbolTable(const std::string &fileName);

    bool openOutputToken(const std::string &fileName);

    bool openOutputLexemes(const std::string &fileName);

    void closeInputCode();

    void closeOutputSymbolTable();

    void closeOutputToken();

    void closeOutputLexemes();

    void outputSymbolTableToFile();

    void outputTokenToFile();

    void outputLexemesToFile();

    /*符号表操作*/
    //创建符号表
    void createSymbolTable();

    //新增符号表项（返回下标）
    int addSymbolTableItem(SymbolTableItem *newItem);

    //返回标识符在符号表中的位置或者即将插入的位置的相反数
    int findSymbolTableItem(const std::string &symbol);

    //自动机
    int FA();

    //打印符号表
    void printSymbolTable();
};

#endif //LEXICALANALYSIS_LEXER_H
