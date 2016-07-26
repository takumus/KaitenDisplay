package
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class SocketManagerEvent extends Event
	{
		public static const COMPLETE:String = "sme.complete";
		public static const PROGRESS:String = "sme.progress";
		public var data:ByteArray;
		public var bytesTotal:int;
		public var bytesLoaded:int;
		public var client:Client;
		public function SocketManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}