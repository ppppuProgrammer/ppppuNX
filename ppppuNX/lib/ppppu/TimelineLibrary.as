package ppppu 
{
	import com.greensock.TimelineMax;
	import flash.utils.Dictionary;
	/**
	 * Holds all the various timelines that can be used in the program. 
	 * @author ...
	 */
	public class TimelineLibrary 
	{
		//"Enum" of additional timeline types
		public const TYPE_EXPRESSION:int = 0; //Used to fine tune the mouth graphic displayed and it's placement.
		public const TYPE_EYE:int = 1; //Used to fine tune the eye graphics displayed and their placement.
		
		/*Contains the default timelines for an animation. Is a vector (animation ids are used for indices) 
		containing a vector<TimelineMax>.
		Concise version: vector[animID] > vector[timelines]*/
		private var baseTimelinesCollection:Vector.<Vector.<TimelineMax>> = new Vector.<Vector.<TimelineMax>>();
		
		/*Contains additional timelines that will replace base timelines in an animation. Primarily used for body part rearraignment.
		 * Is a vector (animation id) of vectors (character) of dictionaries (animation set which is a group of timelines meant for a 
		 * certain purpose) which will use a string as a key(set name) and a vector<TimelineMax> as the value. 
		 * Concise version: vector[anim] > vector[char] > dict[set] > vector[timelines]*/
		private var replacementTimelinesCollection:Vector.<Vector.<Dictionary>> = new Vector.<Vector.<Dictionary>>();
		
		/*Contains supplementary timelines to add onto the base timelines in an animation.
		 *Is a vector (animation ids) of vectors (character ids) of vectors (timeline type) of vector<timelineMax>.
		 *Concise version: vector[anim] > vector[char] > vector[type] > vector[timelines]*/
		private var supplementTimelinesCollection:Vector.<Vector.<Vector.<Vector.<TimelineMax>>>>;
		
		public function TimelineLibrary() 
		{
			
		}
		
		/*Adding timeline(s) to library functions*/
		
		
		public function AddBaseTimelinesToLibrary(animationID:int, timelines:Vector.<TimelineMax> ):void
		{
			baseTimelinesCollection[animationID] = timelines;
		}
		
		public function AddReplacementTimelinesToLibrary(animationID:int, characterID:int, setName:String, timelines:Vector.<TimelineMax> ):void
		{
			var timelineSetDictionary:Dictionary = replacementTimelinesCollection[animationID][characterID];
			if (timelineSetDictionary == null)
			{
				timelineSetDictionary = new Dictionary();
				replacementTimelinesCollection[animationID][characterID] = timelineSetDictionary;
			}
			timelineSetDictionary[setName] = timelines;
		}
		
		public function AddSupplementTimelineToLibrary(animationID:int, characterID:int, type:int, timelineName:String, timeline:TimelineMax):void
		{
			var typeVector:Vector.<TimelineMax> = supplementTimelinesCollection[animationID][characterID][type];
			
			var timelineWithSameNameFound:Boolean = false;
			//Check that a timeline of the given name isn't already in the vector. If it is, then write over it.
			for (var i:int = 0, l:int = typeVector.length; i < l; ++i )
			{
				if (typeVector[i].data == timelineName)
				{
					//Replace the old timeline of the given name with the new one
					typeVector[i] = timeline;
					timelineWithSameNameFound = true;
					break;//Exit the for loop
				}
			}
			if (timelineWithSameNameFound == false)
			{
				//Have the timeline's data contain the given name for it.
				timeline.data = timelineName;
				typeVector[typeVector.length] = timeline;
			}
		}
		
		/*Get timeline(s) from library functions*/
		
		
		public function GetBaseTimelinesFromLibrary(animationID:int):Vector.<TimelineMax>
		{
			var baseTimelines:Vector.<TimelineMax> = null;
			if (animationID < baseTimelinesCollection.length)
			{
				baseTimelines = baseTimelinesCollection[animationID];
			}
			return baseTimelines;
		}
		
		public function GetReplacementTimelinesToLibrary(animationID:int, characterID:int, setName:String ):Vector.<TimelineMax>
		{
			var dictionary:Dictionary = replacementTimelinesCollection[animationID][characterID] as Dictionary;
			var timelines:Vector.<TimelineMax> = dictionary[setName] as Vector.<TimelineMax>;
			return timelines;
		}
		
		public function GetSupplementTimelineLibrary(animationID:int, characterID:int, type:int, timelineName:String):TimelineMax
		{
			var typeVector:Vector.<TimelineMax> = supplementTimelinesCollection[animationID][characterID][type];
			
			var timeline:TimelineMax = null;
			for (var i:int = 0, l:int = typeVector.length; i < l; ++i )
			{
				if (typeVector[i].data == timelineName)
				{
					timeline = typeVector[i];
					break;
				}
			}
			return timeline;
		}
		
		public function GetSupplementTimelineFromLibrary(animationID:int, characterID:int, type:int, timelineName:String):TimelineMax
		{
			var typeVector:Vector.<TimelineMax> = supplementTimelinesCollection[animationID][characterID][type];
			
			var timeline:TimelineMax = null;
			for (var i:int = 0, l:int = typeVector.length; i < l; ++i )
			{
				if (typeVector[i].data == timelineName)
				{
					timeline = typeVector[i];
					break;
				}
			}
			return timeline;
		}
		
		/*Timeline existance checking*/
		
		public function DoesBaseTimelinesForAnimationExist(animationID:int):Boolean
		{
			var exists:Boolean = false;
			//Enlarge the vector so the index for animationID exists, if it doesn't already.
			while (baseTimelinesCollection.length <= animationID)
			{
				baseTimelinesCollection[baseTimelinesCollection.length] = null;
			}
			if (baseTimelinesCollection.length > 0 && baseTimelinesCollection[animationID] != null)
			{
				exists = true;
			}
			
			return exists;
		}
		
		public function DoesCharacterSetExists(animationID:int, characterID:int, setName:String):Boolean
		{
			var exists:Boolean = false;
			while (replacementTimelinesCollection.length <= animationID)
			{
				replacementTimelinesCollection[replacementTimelinesCollection.length] = null;
			}
			while (replacementTimelinesCollection[animationID].length <= characterID)
			{
				replacementTimelinesCollection[animationID][replacementTimelinesCollection[animationID].length] = new Dictionary();
			}
			var dictionary:Dictionary = replacementTimelinesCollection[animationID][characterID] as Dictionary;
			if (dictionary[setName] != null)
			{
				exists = true;
			}
			
			return exists;
		}
	}

}