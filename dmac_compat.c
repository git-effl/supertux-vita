#include <string.h>

void *sceDmacMemcpy(void *dst, const void *src, unsigned int size) {
    return memcpy(dst, src, size);
}

void *sceDmacMemset(void *dst, int c, unsigned int size) {
    return memset(dst, c, size);
}