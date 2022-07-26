/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/22 22:06
 */

#ifndef PARSING_DIRECTION_H
#define PARSING_DIRECTION_H

#include "Symbol.h"
#include <string>

class Direction {
private:
    int state;  //转移到的状态
    Symbol name;//接受的符号
public:
    Direction(int s, Symbol& name);
};

#endif //PARSING_DIRECTION_H
