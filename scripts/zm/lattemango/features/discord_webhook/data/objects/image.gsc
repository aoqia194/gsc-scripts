// function: Creates a new image for use in embeds.
// url: string
// proxy_url?: string
// height?: int
// width?: int
image_new(url, proxy_url, height, width)
{
    image = [];

    if (isdefined(url))
    {
        image["url"] = url;

        if (isdefined(proxy_url))
        {
            image["proxy_url"] = proxy_url;
        }

        if (isdefined(height))
        {
            image["height"] = height;
        }

        if (isdefined(width))
        {
            image["width"] = width;
        }
    }

    return image;
}
