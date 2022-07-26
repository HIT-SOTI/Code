/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/22 21:49
 */

#ifndef PARSING_ITEM_H
#define PARSING_ITEM_H

class Item {//项
public:
    int wrapperIdx; // 点对应exps第一层的下标（哪个非终结符）
    int expIdx;     // 点对应exps第二层的下标（哪个右部）
    int pos;        // 点在产生式中的位置 (0 位最左边)

    Item(int w, int e, int p);
};

#endif //PARSING_ITEM_H
