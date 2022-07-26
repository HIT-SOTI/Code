/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/22 21:34
 */

#ifndef PARSING_GENERATEEXPRESSION_H
#define PARSING_GENERATEEXPRESSION_H

#include "Symbol.h"
#include <iostream>
#include <vector>

class GenerateExpression {
private:
    Symbol left;//产生式左部，默认
public:
    std::vector<std::vector<Symbol>> rights;    //产生式右部
    //一个左部对应多个产生式，用两层vector来存储

    const Symbol &getLeft() const;

    void setLeft(const Symbol &leftTemp);

    explicit GenerateExpression(Symbol &l);
};

#endif //PARSING_GENERATEEXPRESSION_H
