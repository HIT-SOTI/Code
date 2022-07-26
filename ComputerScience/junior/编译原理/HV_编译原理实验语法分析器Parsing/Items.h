/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/22 22:03
 */

#ifndef PARSING_ITEMS_H
#define PARSING_ITEMS_H

#include "Item.h"
#include "Direction.h"
#include <vector>

class Items {//项集
public:
    int id;                             //项集编号
    std::vector<Item> kernelItems;      //内核项
    std::vector<Item> nonKernelItems;   //非内核项
    std::vector<Direction> directions;  //项集出方向项集下标
public:
    friend bool operator==(Items &A, Items &B);

    void setId(int idTemp);
};


#endif //PARSING_ITEMS_H
