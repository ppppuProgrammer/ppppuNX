var mcTl = fl.getDocumentDOM().getTimeline();

var l = mcTl.layerCount;
var i = 0;
var currentLayer;
var layerFrameCount;
for(i; i < l; ++i)
{
	currentLayer = mcTl.layers[i];
	layerFrameCount = currentLayer.frameCount;
	mcTl.setSelectedLayers(i);
	
	if(!currentLayer.locked && currentLayer.frameCount > 1)
	{
		mcTl.clearKeyframes(1, layerFrameCount);
	}
}