/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <curl/curl.h>

int main(int argc, char *argv[])
{
    CURL *curl;

    (void)argc;
    (void)argv;

    curl = curl_easy_init();
    if (!curl) {
        return 1;
    }

    curl_easy_setopt(curl, CURLOPT_URL, "http://example.com/");
    curl_easy_perform(curl);

    curl_easy_cleanup(curl);
    return 0;
}
