// function: This function overrides the webhook's avatar image.
// data: array (HTTP)
// avatar_url: string
avatar_set(data, avatar_url)
{
    data["avatar_url"] = avatar_url;
    return data;
}
