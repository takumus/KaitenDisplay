package com.takumus.kaitenDisplay
{
	import flash.events.Event;
	
	public class GeneratorEvent extends Event
	{
		public static const COMPLETE:String = "com.takumus.kaitenDisplay.GeneratorEvent.COMPLETE";
		public static const ERROR:String = "com.takumus.kaitenDisplay.GeneratorEvent.ERROR";
		internal var _data:Frame;
		public function GeneratorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public function get data():Frame
		{
			return _data;
		}
	}
}