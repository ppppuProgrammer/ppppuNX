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
    sourceFolderDir = str(folderDir.resolve())
    sourceFolderDir += '/'
    sourceFolderDir = "/.." + sourceFolderDir[sourceFolderDir.rfind("\lib"):len(sourceFolderDir)]
    sourceFolderDir = sourceFolderDir.replace("\\", "/")
    print(sourceFolderDir)
    for filePath in folderDir.iterdir():
        if filePath.is_file():
            if filePath.suffix in ('.xml'):
                xmlClassName = filePath.name
                ##print(xmlClassName)
                
                xmlClassName = xmlClassName[xmlClassName.rfind("_")+1:xmlClassName.rfind(".")]
                motionXMLDefinitions += '''\t\t[Embed(source = \"{0:s}\", mimeType = \"application/octet-stream\")]
\t\tpublic static const {1:s}:Class;\n'''.format(sourceFolderDir + filePath.name, xmlClassName)
    ##print(motionXMLDefinitions)
    return motionXMLDefinitions

##Get current directory of script and deduce the package for the as file
currDir = Path('.')
package = str(currDir.resolve())
package = package.split("\\lib\\")[1]
package = package.replace("\\", ".")
##print(package)
##Get name of character the motionXML is used for
character = package
firstDot = character.find(".")
character = character[firstDot+1:len(character)]
##print(character)

for dirIter in currDir.iterdir():
    if dirIter.is_dir():
        animationName = str(dirIter.resolve())
        animationName = animationName[animationName.rfind("\\")+1:len(animationName)]
        ##print(animationName)
        baseFileName = character + animationName
        ##print(baseFileName)
        ##Final class name
        newClassName = baseFileName + "Motions"
        ##Create file name
        fileName = newClassName + ".as"
        ##Create path that the file will be created in
        asFilePath = Path(fileName)

        scriptContents = '''package {0:s}
{{
    public class {1:s}
    {{
{2:s}
        public static const CharacterName:String = \"{3:s}\";
        public static const AnimationName:String = \"{4:s}\";
    }}
}}'''.format(package, newClassName, searchWithinFolder(dirIter), character, animationName)
        with asFilePath.open('w') as asFile:
            asFile.write(scriptContents)

userInput = input('Finished. Press enter to exit.')


    
                
        
