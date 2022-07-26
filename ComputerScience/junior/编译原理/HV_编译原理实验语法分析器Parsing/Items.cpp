/**
 * @author fengclchn@outlook.com
 * @createdBy 冯昶霖
 * @date 2022/5/22 22:03
 */

#include "Items.h"
#include <deque>

bool operator==(Items &A, Items &B) {
    //项集内核项相同即为同一项集
    if (A.kernelItems.size() != B.kernelItems.size()) {
        return false;
    }
    const int n = int(A.kernelItems.size());
    std::deque<bool> visited(n, false);
    for (int i = 0; i < n; ++i) {
        bool flag = false;
        for (int j = 0; j < n; ++j) {
            if (!visited[j] && A.kernelItems[i].wrapperIdx == B.kernelItems[j].wrapperIdx
                && A.kernelItems[i].expIdx == B.kernelItems[j].expIdx
                && A.kernelItems[i].pos == B.kernelItems[j].pos) {
                visited[i] = true;
                flag = true;
            }
        }
        if (!flag) {
            return false;
        }
    }
    return true;
}


void Items::setId(int idTemp) {
    Items::id = idTemp;
}