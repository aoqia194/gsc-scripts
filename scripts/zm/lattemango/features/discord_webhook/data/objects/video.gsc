// function: Creates a new video for use in embeds.
// url?: string
// proxy_url?: string
// height?: int
// width?: int
video_new(url, proxy_url, height, width)
{
    video = [];

    if (isdefined(url))
    {
        video["url"] = url;
    }

    if (isdefined(proxy_url))
    {
        video["proxy_url"] = proxy_url;
    }

    if (isdefined(height))
    {
        video["height"] = height;
    }

    if (isdefined(width))
    {
        video["width"] = width;
    }

    return video;
}
