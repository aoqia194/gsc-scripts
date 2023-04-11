#include scripts\zm\lattemango\util\debugprintf;

post_data(url, data, headers)
{
    request = httppost(url, data, headers);
    request waittill("done", result);

    if (isdefined(result))
    {
        debugprintf("HTTP", "^5POST_RESULT=" + result);
    }
}
