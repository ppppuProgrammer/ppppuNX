package
{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
 
	/**
	* Pooler of objects to be written to AMF data. Allows for a single
	* writeObject call and therefore reduces the AMF header data size by
	* consolidating it.
	* @author Jackson Dunstan, http://JacksonDunstan.com
	* @license MIT
	*/
	public class AMFObjectPooler
	{
		/** Objects to write */
		private var __objects:Array = [];
 
		/**
		* Add an object to the pool
		* @param obj Object to add
		*/
		public function writeObject(obj:*): void
		{
			__objects.push(obj);
		}
 
		/**
		* Write the pool of objects to an output stream and optionally clear the
		* pool of objects
		* @param output Output stream to write the objects to
		*/
		public function finalize(output:IDataOutput, clear:Boolean=true): void
		{
			output.writeObject(__objects);
			if (clear)
			{
				__objects.length = 0;
			}
		}
 
		/**
		* Read a pool of objects
		* @param input Input stream to read from
		* @return The pool of objects read from the given input stream
		*/
		public static function read(input:IDataInput): Array
		{
			return input.readObject() as Array;
		}
	}
}