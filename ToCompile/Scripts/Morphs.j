library morphs
{
    hashtable Morphs = null;
    public function IsMorphAbilityId(integer id)->boolean
    {
        return HaveSavedBoolean(Morphs,0,id);
    }
    function onInit()
    {
        Morphs = InitHashtable();
        SaveBoolean(Morphs,0,'Arav',true);
        SaveBoolean(Morphs,0,'A04Y',true);
        SaveBoolean(Morphs,0,'A05D',true);
        SaveBoolean(Morphs,0,'A08U',true);
        SaveBoolean(Morphs,0,'A09E',true);
        SaveBoolean(Morphs,0,'A09Q',true);
        SaveBoolean(Morphs,0,'A0FL',true);
        SaveBoolean(Morphs,0,'A0IW',true);
        SaveBoolean(Morphs,0,'A0LF',true);
        SaveBoolean(Morphs,0,'AM2F',true);
        SaveBoolean(Morphs,0,'Abrf',true);
        SaveBoolean(Morphs,0,'A04A',true);
        SaveBoolean(Morphs,0,'A04W',true);
        SaveBoolean(Morphs,0,'A04X',true);
        SaveBoolean(Morphs,0,'A0G8',true);
        SaveBoolean(Morphs,0,'AMRB',true);
        SaveBoolean(Morphs,0,'Astn',true);
        SaveBoolean(Morphs,0,'A08J',true);
        SaveBoolean(Morphs,0,'A0BH',true);
        SaveBoolean(Morphs,0,'A0CB',true);
        SaveBoolean(Morphs,0,'A0CS',true);
        SaveBoolean(Morphs,0,'A0DR',true);
        SaveBoolean(Morphs,0,'A0JE',true);
        SaveBoolean(Morphs,0,'AMPH',true);
    }

}