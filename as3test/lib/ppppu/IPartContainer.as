package ppppu 
{
	
	/**
	 * Interface for body part containers. The purpose of this interface is to allow the containers to have their 
	 * children record their initial transform matrix in an animation and to have the capability to restore it (typically for the first frame)
	 * @author 
	 */
	public interface IPartContainer 
	{
		function SaveInitialTransforms();
		function ResetInitialTransforms();
	}
	
}