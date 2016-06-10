package
{
	import flash.display.Sprite;
	import flash.display.Stage;

	public class Canvas
	{
		public function Canvas()
		{
		}
		private static var _sprite:Sprite;
		public static function get sprite():Sprite
		{
			return _sprite;
		}
		public static function init(stage:Stage):void
		{
			_sprite = new Sprite();
			stage.addChild(_sprite);
		}
	}
}