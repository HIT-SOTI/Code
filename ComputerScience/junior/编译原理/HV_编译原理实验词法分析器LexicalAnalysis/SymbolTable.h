/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/10 09:33
 */

#ifndef LEXICALANALYSIS_SYMBOLTABLE_H
#define LEXICALANALYSIS_SYMBOLTABLE_H

#include <iostream>
#include <fstream>

/*符号表节点*/
class SymbolTableItem {
private:
    unsigned int name;  // lexemes下标
    int type;           // 0:int 1:float 2:bool 3:char
    int kind;           // 0:simple var 1:const 2:array 3:function
    int val;            // 数值，由于不含小数点，故是整型
    int address;        // 地址
public:
    SymbolTableItem *next;//下一节点

    //Constructor
    explicit SymbolTableItem(unsigned int nameTemp);

    unsigned int getName() const;

    int getType() const;

    int getKind() const;

    int getVal() const;

    int getAddress() const;

    //打印一行
    void printSymbolTableItem() const;

    //输出一行至文件
    void outputSymbolTableItem(std::ofstream& file) const;
//    SymbolTableItem(int nameTemp,int addressTemp);
};

#endif //LEXICALANALYSIS_SYMBOLTABLE_H
