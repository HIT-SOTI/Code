/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/26 00:05
 */

#include "Utils.h"

void closure(std::vector<GenerateExpression> &exps, Items &items) {
    //求出非内核项
    std::queue<Item> q;//访问队列
    std::unordered_set<std::string> visited;// 被访问过非终结符集合
    for (auto &kernelItem: items.kernelItems) {//将内核项按顺序加入队列
        q.push(kernelItem);
    }
    while (!q.empty()) {//队列空退出
        Item item = q.front();//获得头部
        q.pop();//头部出队
        int wrapperIdx = item.wrapperIdx;//获得头部的参数
        int expIdx = item.expIdx;
        int pos = item.pos;
        if (pos == exps[wrapperIdx].rights[expIdx].size()) {
            //点已经移动到了最后一个，size总比下标大1，而点若在最后一个，相对下标正好是size，尽管这个下标对应的元素并不存在
            continue;
        }
        std::string name = exps[wrapperIdx].rights[expIdx][pos].getName();
        if (visited.find(name) != visited.end()) {
            //已经找了
            continue;
        }
        if (!isupper(name[0])) {
            //不是非终结符
            continue;
        }
        visited.insert(name);//如果不是最后一个位置，且未寻到过，且是非终结符，则加入visited
        for (int j = 0; j < exps.size(); ++j) {
            if (exps[j].getLeft().getName() == name) {//遍历产生式寻找，如果找到左部为该非终结符的
                for (int k = 0; k < exps[j].rights.size(); ++k) {//遍历每一个右部
                    Item itemTemp(j, k, 0);//对每一个右部生成一个项
                    if (exps[j].rights[k][0].getName() == "@") {//空语句直接作为内核项
                        itemTemp.pos = 1;//如果右部是epsilon，则点直接在epsilon右侧
                        items.kernelItems.push_back(itemTemp);//作为内核项，D'->epsilon为内核项
                    } else {
                        items.nonKernelItems.push_back(itemTemp);//如果不是内核项，直接添加至项集，此时点在此非内核项右部的最左边
                    }
                    q.push(itemTemp);//将该项加入队列以便下轮循环分析
                }
                break;
            }
        }
    }
}

void getAllNames(std::vector<GenerateExpression> &exps, Items &items, std::vector<std::string> &names) {
    //内核项
    for (auto &kernelItem: items.kernelItems) {
        int wrapperIdx = kernelItem.wrapperIdx;
        int expIdx = kernelItem.expIdx;
        int pos = kernelItem.pos;
        if (exps[wrapperIdx].rights[expIdx].size() == pos) {//点移动到了最后
            continue;
        }
        bool flag = false;//标记是否已在names中记录
        for (auto &name: names) {
            if (name == exps[wrapperIdx].rights[expIdx][pos].getName()) {
                //pos指的是点的位置，将该位置作为下标，所对应的符号总是点后的符号
                flag = true;//已记录
                break;
            }
        }
        if (!flag) {//没记录就向names中存入
            names.push_back(exps[wrapperIdx].rights[expIdx][pos].getName());
        }
    }
    //非内核项
    for (auto &nonKernelItem: items.nonKernelItems) {
        int wrapperIdx = nonKernelItem.wrapperIdx;
        int expIdx = nonKernelItem.expIdx;
        int pos = nonKernelItem.pos;
        if (exps[wrapperIdx].rights[expIdx].size() == pos) {//点移动到了最后
            continue;
        }
        bool flag = false;
        for (auto &name: names) {
            if (name == exps[wrapperIdx].rights[expIdx][pos].getName()) {
                flag = true;
                break;
            }
        }
        if (!flag) {
            names.push_back(exps[wrapperIdx].rights[expIdx][pos].getName());
        }
    }
}

Items goTo(std::vector<GenerateExpression> &exps, Items &items, const std::string &name) {
    Items res;
    for (auto &kernelItem: items.kernelItems) {
        int wrapperIdx = kernelItem.wrapperIdx;
        int expIdx = kernelItem.expIdx;
        int pos = kernelItem.pos;
        if (exps[wrapperIdx].rights[expIdx].size() == pos) {// 点移动到了最后
            continue;
        }
        if (exps[wrapperIdx].rights[expIdx][pos].getName() == name) {
            //res.kernelItems.push_back(Item(wrapperIdx,expIdx,pos+1));
            res.kernelItems.emplace_back(wrapperIdx, expIdx, pos + 1);// 向右移动了一个单位
        }
    }
    for (auto &nonKernelItem: items.nonKernelItems) {
        int wrapperIdx = nonKernelItem.wrapperIdx;
        int expIdx = nonKernelItem.expIdx;
        int pos = nonKernelItem.pos;
        if (exps[wrapperIdx].rights[expIdx][pos].getName() == name) {
            res.kernelItems.emplace_back(wrapperIdx, expIdx, pos + 1);// 向右移动了一个单位
        }
    }
    return res;
}

void getFirst(std::vector<GenerateExpression> &exps,
              std::unordered_map<Symbol, std::vector<Symbol>, customHashFunc, customCmpFunc> &first) {
    auto *emptySym = new Symbol("@", 0);//空字符串 后边有用
    //终结符first初始化
    for (auto &exp: exps) {
        for (auto &right: exp.rights) {
            for (auto symTemp: right) {
                // std::vector<Symbol>::iterator e = std::find(first[symTemp].begin(),
                //                                               first[symTemp].end(),
                //                                               symTemp);
                // 不知find为何不行，替换为下边的语句
                std::vector<Symbol>::iterator e;
                for (e = first[symTemp].begin(); e < first[symTemp].end(); ++e) {
                    if (*e == symTemp) {//遍历symTemp的first集，如果找到与symTemp相同的符号（即是本身的）
                        break;//则退出（此时有终结符和非终结符两种）
                    }
                }
                if (symTemp.getType() == 0 &&//终结符
                    first[symTemp].end() == e) {//且目前不在symTemp的first集合中
                    first[symTemp].push_back(symTemp);//加入first
                }
            }
        }
    }
    //遍历产生式
    while (true) {
        bool flag = true;//产生标记
        for (auto &exp: exps) {
            Symbol symLeft = exp.getLeft();
            for (auto &right: exp.rights) {
                bool emptyFlag = true;
                for (auto symRight: right) {
                    std::vector<Symbol>::iterator e;
                    for (e = first[symLeft].begin(); e < first[symLeft].end(); ++e) {
                        if (*e == symRight) {
                            break;
                        }
                    }
                    //同样find不能用，用笨办法
                    if (symRight.getType() == 0 &&
                        e == first[symLeft].end() &&
                        *emptySym != symRight) {
                        //终结符
                        first[symLeft].push_back(symRight);
                        flag = false;
                        emptyFlag = false;
                        break;
                    } else if (*emptySym != symRight) {
                        for (int l = 0; l < first[symRight].size(); ++l) {
                            std::vector<Symbol>::iterator f;
                            for (f = first[symLeft].begin(); f < first[symLeft].end(); ++f) {
                                if (*f == first[symRight][l]) {
                                    break;
                                }
                            }
                            if (f == first[symLeft].end() &&
                                *emptySym != first[symRight][l] &&
                                *emptySym != first[symRight][l]) {
                                first[symLeft].push_back(first[symRight][l]);
                                flag = false;
                            }
                        }
                        std::vector<Symbol>::iterator g;
                        for (g = first[symRight].begin(); g < first[symRight].end(); ++g) {
                            if (*g == *emptySym) {
                                break;
                            }
                        }
                        if (g == first[symRight].end()) {
                            emptyFlag = false;
                            break;
                        }
                    }
                }
                std::vector<Symbol>::iterator h;
                for (h = first[symLeft].begin(); h < first[symLeft].end(); ++h) {
                    if (*h == *emptySym) {
                        break;
                    }
                }
                if (emptyFlag &&
                    h == first[symLeft].end()) {
                    first[symLeft].push_back(*emptySym);
                    flag = false;
                }
            }
        }
        if (flag) {
            break;// 没有一轮新加入的就算法结束
        }
    }
}
