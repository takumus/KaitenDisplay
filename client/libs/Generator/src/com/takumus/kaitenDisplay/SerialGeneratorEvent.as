package com.takumus.kaitenDisplay
{
	import flash.events.Event;
	
	public class SerialGeneratorEvent extends Event
	{
		public static const COMPLETE:String = "com.takumus.kaitenDisplay.SerialGeneratorEvent.COMPLETE";
		public static const ERROR:String = "com.takumus.kaitenDisplay.SerialGeneratorEvent.ERROR";
		internal var _data:Timeline;
		public function SerialGeneratorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public function get data():Timeline
		{
			return _data;
		}
	}
}