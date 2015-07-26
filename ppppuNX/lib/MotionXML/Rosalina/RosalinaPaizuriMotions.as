package MotionXML.Rosalina
{
    public class RosalinaPaizuriMotions
    {
		[Embed(source = "/../lib/MotionXML/Rosalina/Paizuri/Rosalina_HairBack.xml", mimeType = "application/octet-stream")]
		public static const HairBack:Class;
		[Embed(source = "/../lib/MotionXML/Rosalina/Paizuri/Rosalina_HairFront.xml", mimeType = "application/octet-stream")]
		public static const HairFront:Class;

        public static const CharacterName:String = "Rosalina";
        public static const AnimationName:String = "Paizuri";
        public static const LayerInfo:String = "";
    }
}