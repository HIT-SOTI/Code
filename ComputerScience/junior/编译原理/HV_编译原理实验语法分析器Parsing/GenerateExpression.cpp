/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/22 21:34
 */

#include "GenerateExpression.h"

GenerateExpression::GenerateExpression(Symbol &l) : left(l) {}

void GenerateExpression::setLeft(const Symbol &leftTemp) {
    GenerateExpression::left = leftTemp;
}

const Symbol &GenerateExpression::getLeft() const {
    return left;
}
