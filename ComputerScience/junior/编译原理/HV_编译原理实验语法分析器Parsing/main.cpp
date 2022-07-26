#include "Parser.h"

int main() {
    //实例化
    Parser parser;
    //打开文件读入语法
    bool inputGrammarIsOpen = parser.openInputGrammar("grammar.txt");
    if (!inputGrammarIsOpen) {
        return -1;
    }
    //文法预处理
    parser.pretreatment();
    parser.printGrammar();//检查预处理结果
    //生成GOTO图
    parser.generateGOTO();
    //关文件
    parser.closeInputGrammar();
    return 0;
}
