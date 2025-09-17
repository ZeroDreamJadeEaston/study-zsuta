#define MAX_SIZE 50
short prime[MAX_SIZE] = {0};
short count = 0;
int main() {
	short num = 2;
	while (num <= 100) {
		short i = 2;
		short num_2 = num / 2;
		while (i <= num_2) {
			if (num % i == 0) {
				break;
			}
			i++;
		}
		if (i > num_2) {
			prime[count] = num;
			count++;
		}
		num++;
	}
	return 0;
}
