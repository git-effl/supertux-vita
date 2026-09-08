#include <string.h>

void *sceDmacMemcpy(void *dst, const void *src, unsigned int size) {
    return memcpy(dst, src, size);
}

void sceShaccCgExtEnableExtensions(void) {}
void sceShaccCgExtDisableExtensions(void) {}