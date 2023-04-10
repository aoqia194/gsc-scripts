// function: Creates a new thumbnail for use in embeds.
// url: string
// proxy_url?: string
// height?: int
// width?: int
thumbnail_new(url, proxy_url, height, width)
{
    thumbnail = [];

    if (isdefined(url))
    {
        thumbnail["url"] = url;

        if (isdefined(proxy_url))
        {
            thumbnail["proxy_url"] = proxy_url;
        }

        if (isdefined(height))
        {
            thumbnail["height"] = height;
        }

        if (isdefined(width))
        {
            thumbnail["width"] = width;
        }
    }

    return thumbnail;
}
