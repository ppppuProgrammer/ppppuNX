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
var thisFrameDepthLayout;
var frameString = "F" + (mcTl.currentFrame+1);
var textToWrite = "\'{";
thisFrameDepthLayout = "\"" + frameString + "\":{";
var fileSaveURI = flash.documents[0].pathURI;
var fileSaveURI = fileSaveURI.slice(0, fileSaveURI.lastIndexOf("/")+1) + mcTl.name + " layer info.json";
fl.outputPanel.clear();
var layerDepth = 0;
//back to front version (matches Flash's depth management behavior)
//depth of 0 is the back 
for(i=l-1; i >= 0; --i)
{
	currentLayer = mcTl.layers[i];
	//fl.trace(currentLayer.name);
	//fl.trace(currentLayer.layerType);
	if(currentLayer.frameCount > 0 && currentLayer.layerType != "guide" && currentLayer.layerType != "folder" && currentLayer.visible == true && currentLayer.outline == false)
	{
		if(layerDepth > 0)
		{
			thisFrameDepthLayout += ",";
		}
		thisFrameDepthLayout += "\"" + currentLayer.name + "\":" + layerDepth.toString();
		++layerDepth;
	}
}

// front to back version
//depth of 0 is the front
/*for(i; i < l; ++i)
{
	currentLayer = mcTl.layers[i];
	//fl.trace(currentLayer.name);
	//fl.trace(currentLayer.layerType);
	if(currentLayer.frameCount > 0 && currentLayer.layerType != "guide" && currentLayer.layerType != "folder" && currentLayer.visible == true && currentLayer.outline == false)
	{
		if(layerDepth > 0)
		{
			thisFrameDepthLayout += ",";
		}
		thisFrameDepthLayout += "\"" + currentLayer.name + "\":" + layerDepth.toString();
		++layerDepth;
	}
}*/
thisFrameDepthLayout += "}";
textToWrite += thisFrameDepthLayout;
textToWrite += "}\'";
if(frameString == "F1")
{
	FLfile.write(fileSaveURI, textToWrite);
	fl.trace("Successfully saved");
}
else
{
	fl.trace("Place the following text into " + mcTl.name + " layer info.json before the last instance of \"}\" (if it doesn't exist, please run this script again with the first frame selected on the timeline) :");
	fl.trace("," + thisFrameDepthLayout);
}