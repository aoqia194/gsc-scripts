// afluffyofox

debugprintf(name, text)
{
    if (isdefined(name))
    {
        printf("^1[" + name + "]:^7 " + text);
    }
    else
    {
        printf("^1[DEBUG]:^7 " + text);
    }
}
