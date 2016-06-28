package com.takumus.kaitenDisplay
{
	import flash.events.Event;
	
	public class UploaderEvent extends Event
	{
		public static const CONNECT:String = "com.takumus.kaitenDisplay.UploaderEvent.CONNECT";
		public function UploaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}