#include "Lexer.h"

int main(int argc, char *argv[]) {
    //读源码
    if (argc != 2) {
        std::cout << "[Error]:No File Input or Unexpected Parameters." << std::endl;
        return -1;
    }
    //实例化
    Lexer lexer;
    bool inputCodeIsOpen = lexer.openInputCode(argv[1]);
    if (!inputCodeIsOpen) {
        return -1;
    }
    //创建符号表
    lexer.createSymbolTable();
    //自动机
    lexer.FA();
    //打印结果
    lexer.printSymbolTable();
    lexer.lexemesTable.printLexemes();
    lexer.tokenTable.printToken();
    //输出至文件
    lexer.openOutputSymbolTable("SymbolTable.csv");
    lexer.outputSymbolTableToFile();
    lexer.openOutputToken("Tokens.csv");
    lexer.outputTokenToFile();
    lexer.openOutputLexemes("Lexemes.csv");
    lexer.outputLexemesToFile();
    //关文件
    lexer.closeInputCode();
    lexer.closeOutputSymbolTable();
    lexer.closeOutputToken();
    lexer.closeOutputLexemes();
    return 0;
}
