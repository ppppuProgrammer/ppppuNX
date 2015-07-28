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
    constructorBody = ""
    sourceFolderDir = str(folderDir.resolve())
    sourceFolderDir += '/'
    sourceFolderDir = "/.." + sourceFolderDir[sourceFolderDir.rfind("\lib"):len(sourceFolderDir)]
    sourceFolderDir = sourceFolderDir.replace("\\", "/")
    print(sourceFolderDir)
    animationFolderName = sourceFolderDir
    animationFolderName = animationFolderName[animationFolderName.rfind("/", 0, len(animationFolderName)-2): animationFolderName.rfind("/")+1]
    animationFolderName = "." + animationFolderName
    ##print(animationFolderName)
    for filePath in folderDir.iterdir():
        if filePath.is_file():
            if filePath.suffix in ('.tdf'):
               
                tdfASClassFile = filePath.name
                tdfASClassFile = tdfASClassFile[tdfASClassFile.rfind("/")+1:tdfASClassFile.rfind(".")] + ".as"
                xmlObjectName = filePath.name
                classType = filePath.name
                classType = classType[classType.rfind("/")+1:classType.rfind(".")]
                ##print(classType)
                ##print(xmlClassName)
                
                xmlObjectName = xmlObjectName[xmlObjectName.find("_")+1:xmlObjectName.rfind(".")]
                
                with Path(animationFolderName + tdfASClassFile).open('w') as tdfASFile:
                    classDefinition = '''package {0:s}.{1:s}
{{
\timport flash.utils.ByteArray;
\t[Embed(source = \"{2:s}\", mimeType = \"application/octet-stream\")]
\tpublic class {3:s} extends ByteArray
\t{{}}
}}'''.format(package, animationName, sourceFolderDir + filePath.name, classType)
                    tdfASFile.write(classDefinition)
                
                motionXMLDefinitions += '''\t\tpublic var {1:s}:{2:s} = new {2:s}();\n'''.format(sourceFolderDir + filePath.name, xmlObjectName, classType)
                ##constructorBody += 
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
        ##Open layer info file
        layerInfo = ""
        layerInfoFilePath = Path(animationName + " Template layer info.json")
        with layerInfoFilePath.open('r') as layerInfoFile:
            layerInfo = layerInfoFile.read()
        
        
        scriptContents = '''package {0:s}
{{
    import {0:s}.{4:s}.*
    public class {1:s}
    {{
{2:s}
        public const CharacterName:String = \"{3:s}\";
        public const AnimationName:String = \"{4:s}\";
        public const LayerInfo:String = {5:s};
    }}
}}'''.format(package, newClassName, searchWithinFolder(dirIter), character, animationName, layerInfo)
        with asFilePath.open('w') as asFile:
            asFile.write(scriptContents)

userInput = input('Finished. Press enter to exit.')


    
                
        
