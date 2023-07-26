import os
import sys
import shutil

from settings import settings

jass = False
map = False

args = [arg for arg in sys.argv]
args.pop(0)


for arg in args:
    match arg:
        case "--jass":
            jass = True
        case "-j":
            jass = True
        case "--map":
            map = True
        case "-m":
            map = True
        case "-a":
            map = True
            jass = True

print(f"current path: {map}")

def pjass():
    in_path = settings["in_folder"]
    if(os.path.isabs(settings["script_folder"])):
        in_path = settings["script_folder"]
    else:
        in_path = os.path.normpath(in_path+settings["script_folder"])

    
    out_path = settings["in_folder"]+"/scripts"

    temp_path_backup = in_path+"/backups"
    temp_path_logs = in_path+"/logs"

    shutil.rmtree(temp_path_backup)
    shutil.rmtree(temp_path_logs)

    command:any
    match settings["system"]:
        case "windows":
            NotImplemented
        case "linux":
            command = f'''{f"cd {in_path};" if in_path!="./" else ""} wine {settings["jasshelper"]} --scriptonly --nooptimize {settings["common"]} {settings["blizzard"]} {settings["war3map"]} {out_path}'''
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
            command = f'''{f"cd {in_path};"if in_path!="./" else ""} wine {settings["w3xlni"]} slk {os.path.abspath("./")}'''
    print(command)
    os.system(command)

    
    
    
def moveFromStandartPath():
    in_path = getInPath()
    compiled_map = os.path.normpath(os.path.abspath(in_path)+".w3x")
    output = os.path.abspath(settings["out_file"])
    print(compiled_map,output)

    if(compiled_map!=output):
        shutil.move(compiled_map,output)

if(jass):
    pjass()
if(map):
    w3x()
    moveFromStandartPath()