//var overwriteExistingFiles;
//var layers = fl.getDocumentDOM().getTimeline().getSelectedLayers();
var selectedFrames = fl.getDocumentDOM().getTimeline().getSelectedFrames();
//fl.trace(selectedFrames);
//fl.trace(layers);
var i=0;
//var l=layers.length;
var l=selectedFrames.length;
var file = fl.configURI + 'Javascript/MotionXML.jsfl';
var currentMCitem = fl.getDocumentDOM().getTimeline().libraryItem;

var dialogBox = '<dialog buttons="accept, cancel" title="Set a prefix for all exported XMLs">';
dialogBox  += '<vbox>';
dialogBox  += '<hbox>';
dialogBox  += '<label control="prefix" value="Prefix :" />';
dialogBox  += '<textbox id="prefix" value="" />';
dialogBox  += '</hbox>';
dialogBox  += '<hbox>';
dialogBox  += '<label control="saveDir" value="Save Directory :" />';
dialogBox  += '<textbox id="saveDir" value="" />';
dialogBox  += '</hbox>';
dialogBox  += '</vbox>';
dialogBox  += '</dialog>';

var tempOutputUri = fl.configURI + 'Commands/TempDialogXml' + '.xml';
FLfile.write(tempOutputUri, dialogBox);
var panel = fl.getDocumentDOM().xmlPanel(tempOutputUri);
FLfile.remove(tempOutputUri);

if(panel.dismiss == 'accept')
{
	var MMXML_FilePrefix = panel.prefix;
	var fileSaveDirectory = FLfile.platformPathToURI(panel.saveDir);
	
	if(!fileSaveDirectory)
	{
		fileSaveDirectory = document.pathURI;
		fileSaveDirectory = fileSaveDirectory.slice(0, fileSaveDirectory.lastIndexOf('/')+1);
	}
	else
	{
		if(fileSaveDirectory.charAt(fileSaveDirectory.length) != '/')
		{
			fileSaveDirectory += '/';
		}
	}
	for(i;i<l;i+=3)
	{
		//fl.trace(i);
		//var layer = fl.getDocumentDOM().getTimeline().layers[i];
		var layer = selectedFrames[i];
		//fl.trace(layer);
		fl.getDocumentDOM().getTimeline().setSelectedLayers(layer);
		var fileOutputName = MMXML_FilePrefix + '_' + fl.getDocumentDOM().getTimeline().layers[layer].frames[0].elements[0].name;
		//fl.trace(fileOutputName);
		//fl.trace(fileSaveDirectory);
		fl.runScript(file, 'exportMotionXML', fileOutputName, fileSaveDirectory);
	}
}

 