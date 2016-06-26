package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	public class Canvas
	{
		public function Canvas()
		{
		}
		private static const _sprite:Sprite = new Sprite();
		private static const _background:Shape = new Shape();
		public static function get sprite():Sprite
		{
			return _sprite;
		}
		public static function init(stage:Stage, color:uint):void
		{
			stage.addChild(_background);
			stage.addChild(_sprite);
			stage.addEventListener(Event.RESIZE, function(e:Event):void
			{
				_background.graphics.clear();
				_background.graphics.beginFill(color);
				_background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			});
		}
	}
}