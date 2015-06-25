#!python3

##TODO add animation variant variable
##ex Peach.Cowgirl.Var2 <- a second variation of the cowgirl animation

from pathlib import Path



def classNameCheck(className):
    nameIsOk = True
    for i in range(len(className)):
        if className[i].isspace():
            nameIsOk = False
            break
    return nameIsOk

def searchWithinFolder(folderDir):
    motionXMLDefinitions = ""
    for filePath in folderDir.iterdir():
##        print(filePath.name)
        if filePath.is_file():
            if filePath.suffix in ('.xml'):
                xmlClassName = filePath.name
                xmlClassName = xmlClassName[xmlClassName.rfind("_")+1:xmlClassName.rfind(".")]
                ##print(xmlClassName)
                ##xmlClassName = xmlClassName.replace(".xml", "")
               ## xmlClassName = xmlClassName.replace("_", "")
                ##xmlClassName = xmlClassName.replace(" ", "")
                ##xmlClassName = xmlClassName.lstrip()
                motionXMLDefinitions += '''\t\t[Embed(source = \"{0:s}\", mimeType = \"application/octet-stream\")]
\t\tpublic static const {1:s}:Class;\n'''.format(filePath.name, xmlClassName)
    ##print(motionXMLDefinitions)
    return motionXMLDefinitions
                
                

##enterPrompt = "Enter the name of the character these motion XMLs are for: "
##while True:
##    character = str(input(enterPrompt))
##    if classNameCheck(character) == True:
##        break
##    else:
##        print("Name can not contain spaces.\n")
##
##enterPrompt = "Enter the name of the animation these motion XMLs are for: "
##while True:
##    animation = str(input(enterPrompt))
##    if classNameCheck(animation) == True and animation != character:
##        break
##    else:
##        print("Animation name can not contain spaces and has to be different from the character's name.\n")

##Get current directory of script and deduce the package for the as file
currDir = Path('.')
package = str(currDir.resolve())
package = package.split("\\lib\\")[1]
package = package.replace("\\", ".")
print(package)
##Get name of character the motionXML is used for
character = package
firstDot = character.find(".")
character = character[firstDot+1:character.find(".", firstDot+1)]
print(character)

animation = package
animation = animation[animation.rfind(".")+1:]
print(animation)

baseFileName = character + animation
print(baseFileName)
newClassName = baseFileName + "Motions"

fileName = newClassName + ".as"
asFilePath = Path(fileName)
##print(fileName)


##print(package)

scriptContents = '''package {0:s}
{{
    public class {1:s}
    {{
{2:s}
        public static const CharacterName:String = \"{3:s}\";
        public static const AnimationName:String = \"{4:s}\";
    }}
}}'''.format(package, newClassName, searchWithinFolder(currDir), character, animation)
##print(scriptContents)
##scriptContents
with asFilePath.open('x') as asFile:
    asFile.write(scriptContents)          


userInput = input('Finished. Press enter to exit.')


    
                
        
