//! zinc

library craftsystem, requires tokenizer
{
    hashtable Craft;
    hashtable CraftTemp;
    integer array meta;
    key itemarray;
    
    function AddCraftWithExternalData()
    {
        local Size = LoadInteger(CraftTemp,itemarray,0);
        
    }
    
    function onInit()
    {
        Craft = InitHashtable();
        CraftTemp = InitHashtable();
    }
}



//! endzinc