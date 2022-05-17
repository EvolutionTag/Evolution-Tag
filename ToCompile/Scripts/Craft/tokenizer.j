
library tokenizer
{
    hashtable token;
    integer maxtoken;
    
    public function getToken(integer id)->integer
    {
        if(HaveSavedInteger(token,0,id))
        {
            return LoadInteger(token,0,id);
        }
        return 0;
    }
    public function getId(integer tokenid)->integer
    {
        if(HaveSavedInteger(token,1,tokenid))
        {
            return LoadInteger(token,1,tokenid);
        }
        return 0;
    }
    public function newToken(integer id)->integer
    {
        if(not HaveSavedInteger(token,0,id))
        {
            SaveInteger(token,0,id,maxtoken);
            SaveInteger(token,1,maxtoken,id);
            maxtoken = maxtoken + 1;
        }
        return maxtoken-1
    }
    function onInit()
    {
        token = InitHashtable();
        maxtoken = 1;
    }
}