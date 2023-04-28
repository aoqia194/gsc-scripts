// afluffyofox

// function: This overrides the webhook's username.
// data: array
// username: string
set_username(data, username)
{
    data["username"] = username;
    return data;
}
