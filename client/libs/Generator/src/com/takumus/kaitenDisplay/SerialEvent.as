package com.takumus.kaitenDisplay
{
	import flash.events.Event;
	
	public class SerialEvent extends Event
	{
		public static const COMPLETE:String = "com.takumus.kaitenDisplay.SerialEvent.COMPLETE";
		public static const ERROR:String = "com.takumus.kaitenDisplay.SerialEvent.ERROR";
		internal var _data:Timeline;
		public function SerialEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public function get data():Timeline
		{
			return _data;
		}
	}
}