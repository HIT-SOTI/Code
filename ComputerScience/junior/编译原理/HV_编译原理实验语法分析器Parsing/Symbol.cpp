/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/22 20:41
 */

#include "Symbol.h"

//bool Symbol::operator==(Symbol &A) {
//    return this->name == A.name;
//}
//
//bool Symbol::operator!=(Symbol &A) {
//    return this->name != A.name;
//}

Symbol::Symbol(const std::string &n, int t) {
    name = n;
    type = t;
}

void Symbol::setName(const std::string &nameTemp) {
    Symbol::name = nameTemp;
}

void Symbol::setType(int typeTemp) {
    Symbol::type = typeTemp;
}

const std::string &Symbol::getName() const {
    return name;
}

int Symbol::getType() const {
    return type;
}

bool operator==(Symbol &A, Symbol &B) {
    return A.name == B.name;
}

bool operator!=(Symbol &A, Symbol &B) {
    return A.name != B.name;
}

