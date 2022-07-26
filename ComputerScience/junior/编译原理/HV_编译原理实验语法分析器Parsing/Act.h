/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/22 23:32
 */

#ifndef PARSING_ACT_H
#define PARSING_ACT_H

class Act {//编译器动作（Action表内容）
    int type;   //0 移入 1 规约
    int state;  //移入进入哪个状态 or 规约对应表达式的第一个编号
    int expIdx; //规约对应表达式的第二个编号
};

#endif //PARSING_ACT_H
