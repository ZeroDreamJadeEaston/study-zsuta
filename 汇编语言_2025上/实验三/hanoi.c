#include <stdio.h>

// 汉诺塔递归函数
short hanoi(short n, char from, char to, char aux) {
    // 基准情况：只有一个盘子时直接移动
    if (n == 1) {
        printf("Move disk %d from %c to %c\n", n, from, to);
        return 1;
    }

	short count;
    // 递归步骤1：将n-1个盘子从起始柱移动到辅助柱
    count=hanoi(n - 1, from, aux, to);

    // 移动第n个盘子（最大的盘子）
    printf("Move disk %d from %c to %c\n", n, from, to);
    count++;

    // 递归步骤2：将n-1个盘子从辅助柱移动到目标柱
    count+=hanoi(n - 1, aux, to, from);
    return count;
}

int main() {
    int n;
    printf("Please enter the number of disks for the Hanoi Tower:");
    scanf("%d", &n);

    // 验证输入有效性
    if (n < 1) {
        printf("Error: The number of disks must be greater than 0.\n");
        return 1;
    }

    printf("\nHanoi Tower Solution (%d disks):\n", n);
    printf("==========================\n");

    // 调用递归函数
    // A: 起始柱, C: 目标柱, B: 辅助柱
    short count=hanoi(n, 'A', 'C', 'B');

    printf("==========================\n");
	printf("Total moves: %d\n",count );
    return 0;
}
