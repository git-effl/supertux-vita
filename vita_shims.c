#include <string.h>
#include <stddef.h>

void *sceDmacMemcpy(void *dst, const void *src, unsigned int size) {
    return memcpy(dst, src, size);
}

void sceShaccCgExtEnableExtensions(void) {}
void sceShaccCgExtDisableExtensions(void) {}

// Compatibility shims for legacy OpenSSL symbols expected by libcurl.a
void *EVP_MD_CTX_create(void) { return NULL; }
void EVP_MD_CTX_destroy(void *ctx) { (void)ctx; }
void *UI_OpenSSL(void) { return NULL; }
long SSLeay(void) { return 0; }
void EVP_cleanup(void) {}
void ENGINE_cleanup(void) {}
void ERR_free_strings(void) {}
void CONF_modules_free(void) {}
void SSL_COMP_free_compression_methods(void) {}
void SSL_load_error_strings(void) {}
int SSL_library_init(void) { return 1; }
void OPENSSL_add_all_algorithms_noconf(void) {}
void *SSLv23_client_method(void) { return NULL; }

int sk_num(const void *st) { (void)st; return 0; }
void *sk_value(const void *st, int n) { (void)st; (void)n; return NULL; }
void sk_pop_free(void *st, void (*func)(void *)) { (void)st; (void)func; }
void *sk_pop(void *st) { (void)st; return NULL; }
