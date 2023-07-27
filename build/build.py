import os
import sys
import shutil
from os import path

from settings import settings

modes = {}
modes["jass"]=False
modes["map"]=False
modes["pjass"]=False

args = [arg for arg in sys.argv]
args.pop(0)


for arg in args:
    match arg:
        case "--jass":
            modes["jass"]=True
        case "-j":
            modes["jass"]=True
        case "--map":
            modes["map"]=True
        case "-m":
            modes["map"]=True
        case "-p":
            modes["pjass"]=True
        case "-a":
            modes["map"]=True
            modes["jass"]=True

print(f"current path: {map}")

def windowsPath(path,to=True):
    result:any
    if(to):
        result = os.popen(f"winepath -w {path}").read()
    else:
        result =  os.popen(f"winepath -u {path}").read()
    return result.replace("\n","")

def formatPath(folder,file):
    if(not path.isabs(file)):
        file = file if path.isabs(file) else "{}{}{}".format(folder,path.sep,file)
    return path.abspath(file)

def getMapFolder():
    return settings["in_folder"]

def getScriptFolder():
    in_path = settings["in_folder"]
    if(path.isabs(settings["script_folder"])):
        in_path = settings["script_folder"]
    else:
        in_path = path.abspath(in_path+settings["script_folder"])

    return in_path


def getScripts():
    in_path = getScriptFolder()
    mappath = getMapFolder()


    commonj = formatPath(mappath,settings["common"])
    blizzardj = formatPath(mappath,settings["blizzard"])
    war3map_in = formatPath(in_path,settings["script_main"])
    war3map_out=formatPath(mappath,settings["war3map"])
    return commonj,blizzardj,war3map_in,war3map_out

def pjass():
    in_path = getMapFolder()
    

    

    temp_path_backup = formatPath(in_path,"backups")
    temp_path_logs = formatPath(in_path,"logs")

    if(path.exists(temp_path_backup)):
        shutil.rmtree(temp_path_backup)
    if(path.exists(temp_path_logs)):
        shutil.rmtree(temp_path_logs)

    command:any

    commonj,blizzardj,war3map,out_path = getScripts()

    match settings["system"]:
        case "windows":
            NotImplemented
        case "linux":
            command = f'''wine {settings["jasshelper"]} --scriptonly --nooptimize '{windowsPath(commonj)}' '{windowsPath(blizzardj)}' '{windowsPath(war3map)}' '{windowsPath(out_path)}' 2>/dev/null'''
    print(command)
    os.system(command)

def getInPath():
    return settings["in_folder"]

def w3x():
    in_path = getInPath()
    command:any
    match settings["system"]:
        case "windows":
            NotImplemented
        case "linux":
            command = f'''{f"cd {in_path};"if in_path!="./" else ""} wine {settings["w3xlni"]} slk '{windowsPath(path.abspath("./"))}' 2>/dev/null'''
    print(command)
    os.system(command)

    
    
    
def moveFromStandartPath():
    in_path = getInPath()
    compiled_map = path.normpath(path.abspath(in_path)+".w3x")
    output = path.abspath(settings["out_file"])
    print(compiled_map,output)

    if(compiled_map!=output):
        if(path.exists(output)):
            os.remove(output)
        shutil.move(compiled_map,output)

def checkOutScript():
    command:any

    commonj,blizzardj,war3map,war3map_out = getScripts()

    match settings["system"]:
        case "windows":
            NotImplemented
        case "linux":
            command = f'''wine {settings["pjass"]} '{windowsPath(commonj)}' '{windowsPath(blizzardj)}' '{windowsPath(war3map_out)}' 2</dev/null '''

    os.system(command)

if(modes["jass"]):
    pjass()
    
if(modes["pjass"]):
    checkOutScript()
if(modes["map"]):
    w3x()
    moveFromStandartPath()