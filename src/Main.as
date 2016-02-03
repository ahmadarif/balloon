package
{
	import aze.motion.eaze;
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.core.starling.ViewportMode;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import org.osflash.signals.Signal;
	import starling.utils.AssetManager;
	
	/**
	 * ...
	 * @author Ahmad Arif
	 */
	public class Main extends StarlingCitrusEngine
	{
		[Embed(source = "../assets/BG.png")]
		private const bg:Class;
		
		public static var assets:AssetManager;
		
		public static var onBackPressed:Signal = new Signal();
		
		override public function initialize():void 
		{
			super.initialize();
			
			_baseWidth  = 480;
			_baseHeight = 800;
			_viewportMode = ViewportMode.LETTERBOX;
			
			var bitmap:Bitmap = new bg();
			bitmap.width = stage.fullScreenWidth;
			bitmap.height = stage.fullScreenHeight;
			bitmap.name = "Loading";
			addChild(bitmap);
			
			setUpStarling(false, 1, new Rectangle(0, 0, 480, 800));
		}
		
		override public function handleStarlingReady():void 
		{
			super.handleStarlingReady();
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onBackPressedEvent);
			
			assets = new AssetManager();
			assets.verbose = false;
			assets.enqueue(File.applicationDirectory.resolvePath("assets"));
			assets.loadQueue(function onProgress(value:Number):void {
				if (value == 1)
				{
					var allSound:Vector.<String> = assets.getSoundNames();
					for (var i:uint = 0; i < allSound.length; i++)
					{
						sound.addSound(allSound[i], { sound:assets.getSound(allSound[i]) } );
						assets.removeSound(allSound[i]);
					}
					
					state = new Game();
					
					var bitmap:Bitmap = getChildByName("Loading") as Bitmap;
					eaze(bitmap).to(2, { alpha:0 } ).onComplete(function():void {
						removeChild(bitmap);
						bitmap = null;
					});
				}
			});
		}
		
		private function onBackPressedEvent(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.BACK)
			{
				e.preventDefault();
				e.stopImmediatePropagation();
				
				onBackPressed.dispatch();
			}
		}
		
	}
	
}