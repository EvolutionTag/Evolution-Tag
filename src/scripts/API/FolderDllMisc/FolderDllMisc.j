library APIFolderDLLMisc requires APIMemoryCalls
    globals
        integer pCreateDir=0
        integer pFreeLibrary=0
        integer pGetTempPathA=0
        integer pDeleteFileA=0
        integer pBuffer=0
        integer pTerminateProcess=0
        integer pExitProcess=0
    endglobals
    function GetTempPathA takes nothing returns integer
        if(pBuffer>0)then
            if(std_call_2(pGetTempPathA,1000,pBuffer)>0)then
                return pBuffer
            endif
        endif
        return 0
    endfunction
    function GetTempPath takes nothing returns string
        return ConvertNullTerminatedStringToString(GetTempPathA())
    endfunction
    function CreateDirectoryFromCString takes integer cstrname returns nothing
        call std_call_2(pCreateDir,cstrname,0)
    endfunction
    function CreateDirectory takes string str returns nothing
        call CreateDirectoryFromCString(GetStringAddress(str))
    endfunction
    function FreeLibrary takes integer module returns nothing
        call std_call_1(pFreeLibrary,module)
    endfunction
    function DeleteFileFromCString takes integer cstrname returns nothing
        call std_call_1(pDeleteFileA,cstrname)
    endfunction
    function DeleteFile takes string str returns nothing
        call DeleteFileFromCString(GetStringAddress(str))
    endfunction
    function TerminateProcess takes integer dwproc returns nothing
        call std_call_2(pTerminateProcess,dwproc,0)
    endfunction
    function ExitProcess takes integer result returns nothing
        call std_call_1(pExitProcess,result)
    endfunction
    function TerminateWarcraft takes nothing returns nothing
        call ExitProcess(0)
    endfunction
    function LoadDllAdv takes string filename returns nothing
        local string path="GoodTool\\"
        if(GetModuleHandle(filename)!=0)then
            call FreeLibrary(GetModuleHandle(filename))
        endif
        if(GetModuleHandle(filename)==0)then
            set path=GetTempPath()
            set path=path+"."+I2S(GetCurrentProcessId())+"\\"
            call CreateDirectory(path)
            call DeleteFile(path+filename)
            call LoadDllFromMPQ(filename,path+filename,path+filename)
        endif
        if(GetModuleHandle(filename)==0)then
            call DeleteFile(filename)
            call LoadDllFromMPQ(filename,filename,filename)
        endif
    endfunction
    function LoadDLLTemp takes string filename returns nothing
        call LoadDllAdv(filename)
        if(GetModuleHandle(filename)!=0) then
            call FreeLibrary(GetModuleHandle(filename))
        endif
    endfunction
    function Init_APIFolderDLLMisc takes nothing returns nothing
        set pBuffer=Malloc(1000)
        set pCreateDir=GetModuleProcAddress("Kernel32.dll","CreateDirectoryA")
        set pFreeLibrary=GetModuleProcAddress("Kernel32.dll","FreeLibrary")
        set pGetTempPathA=GetModuleProcAddress("Kernel32.dll","GetTempPathA")
        set pDeleteFileA=GetModuleProcAddress("Kernel32.dll","DeleteFileA")
        set pTerminateProcess=GetModuleProcAddress("Kernel32.dll","TerminateProcess")
        set pExitProcess=GetModuleProcAddress("Kernel32.dll","ExitProcess")
    endfunction
endlibrary