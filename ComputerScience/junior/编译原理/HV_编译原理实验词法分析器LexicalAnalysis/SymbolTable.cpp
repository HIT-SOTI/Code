/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/10 09:33
 */

#include "SymbolTable.h"

SymbolTableItem::SymbolTableItem(unsigned int nameTemp) {
    name = nameTemp;
    kind = 0;
    type = 0;
    val = 0;
    address = 0;
    next = nullptr;
}

unsigned int SymbolTableItem::getName() const {
    return name;
}

int SymbolTableItem::getType() const {
    return type;
}

int SymbolTableItem::getKind() const {
    return kind;
}

int SymbolTableItem::getVal() const {
    return val;
}

int SymbolTableItem::getAddress() const {
    return address;
}

//打印一行
void SymbolTableItem::printSymbolTableItem() const {
    std::cout << "(" << name << "\t," << type << "\t," << kind << "\t," << val << "\t," << address << "\t)"
              << std::endl;
}

void SymbolTableItem::outputSymbolTableItem(std::ofstream &file) const {
    file << name << "," << type << "," << kind << "," << val << "," << address << std::endl;
}

//SymbolTableItem::SymbolTableItem(int nameTemp, int addressTemp) {
//
//}