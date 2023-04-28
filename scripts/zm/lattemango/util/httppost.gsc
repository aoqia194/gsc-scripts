// afluffyofox

#include scripts\zm\afluffyofox\util\debugprintf;

send_post_request(url, data, headers)
{
    request = httppost(url, data, headers);
    request waittill("done", result);

    if (isdefined(result))
    {
        debugprintf("HTTP", "^5====== POST REQUEST RESULT BELOW ======\n^7" + result + "\n^5====== POST REQUEST RESULT ABOVE ======");
    }
}
