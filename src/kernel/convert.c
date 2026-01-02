void charToHex(char c,char *hex)
{
    char low = c & 0x0f;
    char high = (c >> 4) & 0x0f;

    if (high < 0xa)
    {
        hex[0] = 0x30 + high;
    }
    else
    {
        hex[0] = 0x37 + high;
    }

    if (low < 0xa)
    {
        hex[1] = 0x30 + low;
    }
    else
    {
        hex[1] = 0x37 + low;
    }

    hex[2] =0x0;


}