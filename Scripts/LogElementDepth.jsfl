/* This is how it should be formed
'{
	"Initial": 
	{
		"legL":0, 
		"legR":1
	}
	"20":
	{
		"legL":1
	}
}'
*/

var mcTl = fl.getDocumentDOM().getTimeline();
//fl.trace(mcTl.name + " layer info");
var l = mcTl.layerCount;
var i = 0;
var currentLayer;
var currentElementName;
var currentElement;
var textToWrite = "\'{\"F0\":{";
var fileSaveURI = flash.documents[0].pathURI;
var fileSaveURI = fileSaveURI.slice(0, fileSaveURI.lastIndexOf("/")+1) + mcTl.name + " layer info.json";
//fl.outputPanel.clear();
var layerDepth = 0;
for(i; i < l; ++i)
{
	currentLayer = mcTl.layers[i];
	//fl.trace(currentLayer.name);
	//fl.trace(currentLayer.layerType);
	if(currentLayer.frameCount > 0 && currentLayer.layerType != "guide" && currentLayer.layerType != "folder")
	{
		textToWrite += "\"" + currentLayer.name + "\":" + layerDepth.toString();
		if(i+1 < l){textToWrite += ","}
		++layerDepth;
		/*currentElement = currentLayer.frames[0].elements[0];
		if(currentElement)
		{
			if(currentElement.elementType == "instance")
			{
				currentElementName = currentElement.name;
				//fl.trace(currentElementName);
				if(currentElementName != "" && currentElementName != null)
				{
					currentLayer.name = currentElementName;
				}
			}
		}*/
	}
}
textToWrite += "}}\'";
FLfile.write(fileSaveURI, textToWrite);