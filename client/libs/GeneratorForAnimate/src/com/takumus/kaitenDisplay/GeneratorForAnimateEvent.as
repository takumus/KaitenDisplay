package com.takumus.kaitenDisplay
{
	import flash.events.Event;
	
	public class GeneratorForAnimateEvent extends Event
	{
		public static const COMPLETE:String = "com.takumus.kaitenDisplay.GeneratorForAnimateEvent.COMPLETE";
		public static const ERROR:String = "com.takumus.kaitenDisplay.GeneratorForAnimateEvent.ERROR";
		internal var _data:Timeline;
		public function GeneratorForAnimateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public function get data():Timeline
		{
			return _data;
		}
	}
}