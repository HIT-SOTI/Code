/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/23 08:48
 */

#ifndef PARSING_PARSER_H
#define PARSING_PARSER_H

#include "GenerateExpression.h"
#include "Item.h"
#include "Items.h"
#include "Utils.h"
#include <iostream>
#include <fstream>
#include <vector>
#include <unordered_map>

class Parser {
private:
    /*文件*/
    std::ifstream inputGrammar;             //语法输入
    /*语法分析器*/
    /* 1.文法预处理 */
    std::string lineString;                 //读出的一行语法
    std::vector<GenerateExpression> exps;   //所有产生式
    //增广文法
    GenerateExpression *expStart;           //增广文法开始符
    std::vector<Symbol> rightStart;         //增广文法首产生式右部第一个式子（实际上只有一个式子）
    Symbol *symbolStart;                    //原文法首符号
    /* 2.求闭包 生成GOTO图 */
    std::vector<Items> allItems;            //项集族
    std::queue<Items> QItems;               //所有项集队列
    /* 3.求FIRST和FOLLOW */
    std::unordered_map<Symbol, std::vector<Symbol>, customHashFunc, customCmpFunc> first;//FIRST
    std::unordered_map<Symbol, std::vector<Symbol>, customHashFunc, customCmpFunc> follow;//FOLLOW
    Symbol *endSym = new Symbol("$", 0);//follow集初始化
public:
    Parser();

    ~Parser();

    /* 文件操作 */
    bool openInputGrammar(const std::string &fileName);

    void closeInputGrammar();

    /* 1.文法预处理（读文件 增广文法） */
    void pretreatment();

    void printGrammar();//输出检查

    /* 2.求闭包 生成GOTO图（需要用到前面的exps即所有产生式）*/
    void generateGOTO();

    /* 3.求FIRST和FOLLOW */
    void generateFIRSTAndFOLLOW();
};

#endif //PARSING_PARSER_H
