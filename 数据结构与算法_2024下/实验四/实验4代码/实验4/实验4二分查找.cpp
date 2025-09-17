#include <stdio.h>

int binarySearch(int arr[], int l, int r, int x, int *count) {
	while (l <= r) {
		int m = l + (r - l) / 2;
		(*count)++;
		if (arr[m] == x) return m;
		if (arr[m] < x)
			l = m + 1;
		else
			r = m - 1;
	}
	return -1;
}

int main() {
	int n, x;
	scanf("%d", &n);
	int arr[n];
	for (int i = 0; i < n; i++) scanf("%d", &arr[i]);
	scanf("%d", &x);
	int count = 0;
	int result = binarySearch(arr, 0, n - 1, x, &count);
	printf("%d\n%d\n", result, count);
	return 0;
}
