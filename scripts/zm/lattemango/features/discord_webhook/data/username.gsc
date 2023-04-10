// function: This overrides the webhook's username.
// data: array
// username: string
username_set(data, username)
{
    data["username"] = username;
    return data;
}
