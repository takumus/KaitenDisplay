package com.takumus.kaitenDisplay
{
	import flash.events.Event;
	
	public class MultiEvent extends Event
	{
		public static const COMPLETE:String = "com.takumus.kaitenDisplay.MultiEvent.COMPLETE";
		public static const ERROR:String = "com.takumus.kaitenDisplay.MultiEvent.ERROR";
		internal var _data:String;
		public function MultiEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public function get data():String
		{
			return _data;
		}
	}
}