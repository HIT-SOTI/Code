/**
* @author fengclchn@outlook.com
* @createdBy 冯昶霖
* @date 2022/5/14 10:31
*/

#ifndef LEXICALANALYSIS_TOKEN_H
#define LEXICALANALYSIS_TOKEN_H

#include <vector>
#include <iostream>
#include <fstream>

enum TokenType {
    TOKEN_IDENTIFIER,   //标识符
    TOKEN_KEYWORD,      //关键字
    TOKEN_INT,          //整型
    TOKEN_OPERATOR,     //操作符
    TOKEN_SEPARATOR,    //界限符
};

typedef union tokenValue {
    unsigned int indexIdentifier;   //标识符在符号表中的下标
    unsigned int indexKeyword;      //keyword在集合中的下标
    int valInteger;                 //整型值
    char valOperator[4];            //操作符值
    char valSeparator[4];           //界限符值
} TokenValue;

class Token {
public:
    TokenType type;//token类型
    TokenValue value;//token值
    Token(TokenType type, const TokenValue &value) : type(type), value(value) {}
};

class TokenTable {
private:
    std::vector<Token> tokens;
public:
    //Constructor
    TokenTable() = default;

    //Destructor
    ~TokenTable() = default;

    //存储token
    std::vector<Token>::size_type saveToken(TokenType typeTemp, TokenValue valueTemp);

    //打印Token表
    void printToken();

    //输出Token表
    void outputToken(std::ofstream &file) const;
};

#endif //LEXICALANALYSIS_TOKEN_H
