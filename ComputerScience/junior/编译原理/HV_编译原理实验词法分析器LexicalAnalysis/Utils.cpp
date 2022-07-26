/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/13 23:00
 */

#include "Utils.h"

bool isDigits(char c) {
    return c >= '0' && c <= '9';
}

bool isLetter_(char c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c == '_');
}
