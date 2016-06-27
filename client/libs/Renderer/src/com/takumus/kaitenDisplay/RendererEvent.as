package com.takumus.kaitenDisplay
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class RendererEvent extends Event
	{
		public static const COMPLETE:String = "com.takumus.kaitenDisplay.RendererEvent.COMPLETE";
		public static const ERROR:String = "com.takumus.kaitenDisplay.RendererEvent.ERROR";
		internal var _data:BitmapData;
		public function RendererEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public function get data():BitmapData
		{
			return _data;
		}
	}
}