#ifndef _JELLYFISH_H_
#define _JELLYFISH_H_

/* #include <stdbool.h> - not supported in msvc */
#include <stdlib.h>
#include <float.h>

/*
 * "Fix" for stdbool.h missing in msvc.
 */
typedef int bool;
#define false 0
#define true 1

/*
 * Fix for some syntactical differences between gcc and msvc
 */
#ifndef __GNUC__
#  ifdef _MSC_VER
#    define inline __inline
#    define isnan _isnan
#    define alloca _alloca
#    define INFINITY (DBL_MAX+DBL_MAX)
#    define NaN (INFINITY-INFINITY)
#  else
#    define inline /* */
#    define NaN (0.0 / 0.0)
#  endif
#else
#  define NaN (0.0 / 0.0)
#endif

#ifndef MIN
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#endif

double jaro_winkler(const char *str1, const char *str2, bool long_tolerance);
double jaro_distance(const char *str1, const char *str2);

unsigned hamming_distance(const char *str1, const char *str2);

int levenshtein_distance(const char *str1, const char *str2);

int damerau_levenshtein_distance(const char *str1, const char *str2);

char* soundex(const char *str);

char* metaphone(const char *str);

char *nysiis(const char *str);

char* match_rating_codex(const char *str);
int match_rating_comparison(const char *str1, const char *str2);

struct stemmer;
extern struct stemmer * create_stemmer(void);
extern void free_stemmer(struct stemmer * z);
extern int stem(struct stemmer * z, char * b, int k);

#endif
