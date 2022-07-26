/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/10 23:44
 */

#include "LexemesTable.h"

//向字符串表中存储词素并返回词素在动态数组的下标
std::vector<std::string>::size_type Lexemes::saveLexeme(const std::string &lexemeString) {
    lexeme.push_back(lexemeString);
    return lexeme.size() - 1;
}

//取出某个下标的词素
std::string Lexemes::getLexemeByIndex(int index) {
    return lexeme[index];
}

//返回某个词素的下标，不存在则返回-2（-1为头节点词素）
int Lexemes::findLexeme(const std::string &lexemeTemp) {
    auto iter = std::find(lexeme.begin(), lexeme.end(), lexemeTemp);
    if (iter == lexeme.end()) {
        return -2;
    } else {
        return int(&*iter - &lexeme[0]);//下标计算
    }
}

//打印字符串表
void Lexemes::printLexemes() {
    std::cout << std::endl << "[Lexemes Table]" << std::endl;
    for (auto iter = lexeme.begin(); iter < lexeme.end(); ++iter) {
        std::cout << "(" << *iter << "\t, " << (*iter).length() << "  " << int(&*iter - &lexeme[0]) << "\t)"
                  << std::endl;
    }
}

void Lexemes::outputLexemes(std::ofstream &file) const {
    file << "[Lexemes Table]" << "," << "," << std::endl;
    file << "LEXEME" << "," << "LENGTH" << "," << "INDEX" << std::endl;
    for (auto iter = lexeme.begin(); iter < lexeme.end(); ++iter) {
        file << *iter << "," << (*iter).length() << "," << int(&*iter - &lexeme[0]) << std::endl;
    }
    std::cout << "Output to Lexemes File Successfully!" << std::endl;
}
