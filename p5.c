#include <openssl/md5.h>
#include <stdio.h>
#include <string.h>

int main(int argc, const char *argv[]) {
	unsigned char buf[MD5_DIGEST_LENGTH] = {0};
	unsigned int generated_chars = 0;
	unsigned long int counter = 0;
	char answer[9] = {0};
	unsigned char answered = 0;
	while (answered != 0xFF) {
		counter++;
		char input_buf[500] = {0};
		sprintf(input_buf, "%s%lu", argv[1], counter);
		(void) MD5((unsigned const char *)input_buf, strlen(input_buf), buf);
		if (buf[0] == 0 && buf[1] == 0 && (buf[2] & 0xF0) == 0) {
			if (buf[2] < 8 && !(answered & (1 << buf[2]))) {
				// set the answered bit
				answered |= 1 << buf[2];
				char l[2] = {0};
				sprintf(l, "%x", buf[3] >> 4);
				answer[buf[2]] = l[0];
				printf("%x %x\n", buf[2], buf[3] >> 4);
			}
		}
	}
	printf("%s", answer);
	return 0;
}
