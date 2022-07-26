/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/26 00:05
 */

#ifndef PARSING_UTILS_H
#define PARSING_UTILS_H

#include "GenerateExpression.h"
#include "Symbol.h"
#include "Item.h"
#include "Items.h"
#include <string>
#include <algorithm>
#include <vector>
#include <queue>
#include <unordered_set>
#include <unordered_map>

struct customHashFunc {
    size_t operator()(const Symbol &key) const {
        return std::hash<std::string>()(key.getName());
    }
};

struct customCmpFunc {
    bool operator()(const Symbol &lSym, const Symbol &rSym) const {
        return lSym.getName() == rSym.getName() && lSym.getType() == rSym.getType();
    }
};

/*
 * @proc 求出items所有非内核项，并且填入项集items
 * @params exps:所有生成式 items:内核项已经填好的项集
 * @return void
*/
void closure(std::vector<GenerateExpression> &exps,
             Items &items);

/*
 * @proc 求出项集所有下一项（点的下一个符号）名称，放到names里面
 * @params exps:所有生成式 items:所求项集 names:为符号名称
 * @return void
*/
void getAllNames(std::vector<GenerateExpression> &exps,
                 Items &items,
                 std::vector<std::string> &names);

/*
 * @proc 求出项集items接收到name符号进入的下一个项集
 * @params exps:所有生成式 items:源项集 name:接收到的符号名称
 * @return 下一个项集，已经包含所有内核项
*/
Items goTo(std::vector<GenerateExpression> &exps,
           Items &items,
           const std::string &name);

/*
 * @proc 求出first集合，放到first中
 * @params exps:所有生成式 first:first集合(引用类型)
 * @返回值 void
*/
void getFirst(std::vector<GenerateExpression> &exps,
              std::unordered_map<Symbol, std::vector<Symbol>, customHashFunc, customCmpFunc> &first);

#endif //PARSING_UTILS_H
