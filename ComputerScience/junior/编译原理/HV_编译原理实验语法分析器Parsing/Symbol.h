/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/22 20:41
 */

#ifndef PARSING_SYMBOL_H
#define PARSING_SYMBOL_H

#include <string>

class Symbol {//文法符号
private:
    std::string name;   //符号名
    int type;           //0 终结符 1 非终结符
public:
    Symbol(const std::string &n, int t);

    friend bool operator==(Symbol &A, Symbol &B);

    friend bool operator!=(Symbol &A, Symbol &B);

//    bool operator==(Symbol &A);

//    bool operator!=(Symbol &A);

    void setName(const std::string &nameTemp);

    void setType(int typeTemp);

    const std::string &getName() const;

    int getType() const;
};

#endif //PARSING_SYMBOL_H
