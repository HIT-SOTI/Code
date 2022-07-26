/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/10 23:44
 */

#ifndef LEXICALANALYSIS_LEXEMESTABLE_H
#define LEXICALANALYSIS_LEXEMESTABLE_H

#include <vector>
#include <string>
#include <iostream>
#include <algorithm>
#include <fstream>

class Lexemes {
private:
    //使用STL vector容器模拟字符串表
    std::vector<std::string> lexeme; //词素
public:
    //Constructor
    Lexemes() = default;

    //Destructor
    ~Lexemes() = default;

    //向字符串表中存储词素并返回词素在动态数组的下标
    std::vector<std::string>::size_type saveLexeme(const std::string &lexemeString);

    //取出某个下标的词素
    std::string getLexemeByIndex(int index);

    //返回某个词素的下标，不存在则返回-2（-1为头节点词素）
    int findLexeme(const std::string &lexemeTemp);

    //打印字符串表
    void printLexemes();

    //导出字符串表
    void outputLexemes(std::ofstream &file) const;
};

#endif //LEXICALANALYSIS_LEXEMESTABLE_H
