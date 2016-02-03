package 
{
	import aze.motion.eaze;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.Accelerometer;
	import citrus.physics.box2d.Box2D;
	import com.onebyonedesign.mobile.tasks.BaseMobileTasks;
	import flash.desktop.NativeApplication;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author Ahmad Arif
	 */
	public class Game extends StarlingState 
	{		
		private var world:b2World;
		private var data:PhysicsData;
		
		// input controll
		private var accel:Accelerometer;
		private var mic:Microphone;
		private var micActivity:Number;
		private var micCanBlow:Boolean;
		private var micCanBlowTimer:Timer = new Timer(2200, 1);
		private var micCanBlowTimerReady:Boolean = true;
		
		// back press
		private var backPressedCount:uint = 0;
		
		// view
		private var background:Image;
		
		// touch controlls
		private var isSwipe:Boolean = false;
		private var baloonIndex:int = 0;
		private var baloonName:String = "";
		private var baloonSwipe:b2Body;
		
		private var baloonBlow:Image;
		private var baloonColor:String = "blue";
		private var baloonSize:int = 0;
		private const arrSize:Array = [
			new Point(34, 52),
			new Point(69, 105),
			new Point(103, 157),
			new Point(137, 209)
		];
		
		public function Game() 
		{
			// event listener
			Main.onBackPressed.add(onBackPressed);
			
			// create an instance of accelerometer
			accel = new Accelerometer("accel");
			
			// create an instance of microphone
			mic = Microphone.getMicrophone();
			mic.setLoopBack(true);
			mic.setUseEchoSuppression(true);
			mic.setSilenceLevel(100);
			mic.soundTransform = new SoundTransform(0); // mute the sound
			mic.gain = 50; // sensitive
						
			// Create new box2d physics world and its gravity.
			world = new b2World(new b2Vec2(0, 9.8), false);
			
			// create an instance of physics data
			data = new PhysicsData();
			
			// create background;
			background = new Image(Main.assets.getTexture("BG"));
			background.addEventListener(TouchEvent.TOUCH, onBackgroundTouch);
			addChild(background);
			
			// baloon blow
			baloonBlow = new Image(Main.assets.getTexture("blue0"));
			baloonBlow.alignPivot(HAlign.CENTER, VAlign.BOTTOM);
			baloonBlow.x = 240;
			baloonBlow.y = 790;
			baloonBlow.addEventListener(TouchEvent.TOUCH, onBaloonRelease);
			addChild(baloonBlow);
			
			// baloon swipe
			var imgSwipe:Image = new Image(Main.assets.getTexture("swipe-img"));
			imgSwipe.alpha = 0;
			
			baloonSwipe = data.createBody("swipe-img", world, b2Body.b2_staticBody, imgSwipe);
			baloonSwipe.SetPosition(new b2Vec2( -100 / data.ptm_ratio, -100 / data.ptm_ratio));
			addChild(baloonSwipe.GetUserData());
			
			// wall
			createWalls();
			
			micCanBlowTimer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
				trace("TIMER");
			});
			
			micCanBlowTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
				trace("FINISH");
				micCanBlowTimerReady = true;
				micCanBlowTimer.stop();
			});
		}
		
		private function createWalls():void 
		{
			var imgWallLeft:Image = new Image(Main.assets.getTexture("WallVertical"));
			var wallLeft:b2Body = data.createBody("WallVertical", world, b2Body.b2_staticBody, imgWallLeft);
			wallLeft.SetPosition(new b2Vec2(-40 / data.ptm_ratio, 0 / data.ptm_ratio));
			addChild(wallLeft.GetUserData());
			
			var imgWallRight:Image = new Image(Main.assets.getTexture("WallVertical"));
			var wallRight:b2Body = data.createBody("WallVertical", world, b2Body.b2_staticBody, imgWallRight);
			wallRight.SetPosition(new b2Vec2(480 / data.ptm_ratio, 0 / data.ptm_ratio));
			addChild(wallRight.GetUserData());
			
			var imgWallTop:Image = new Image(Main.assets.getTexture("WallHorisontal"));
			var wallTop:b2Body = data.createBody("WallHorisontal", world, b2Body.b2_staticBody, imgWallTop);
			wallTop.SetPosition(new b2Vec2(0 / data.ptm_ratio, -40 / data.ptm_ratio));
			addChild(wallTop.GetUserData());
			
			var imgWallBottom:Image = new Image(Main.assets.getTexture("WallHorisontal"));
			var wallBottom:b2Body = data.createBody("WallHorisontal", world, b2Body.b2_staticBody, imgWallBottom);
			wallBottom.SetPosition(new b2Vec2(0 / data.ptm_ratio, 800 / data.ptm_ratio));
			addChild(wallBottom.GetUserData());
		}
		
		private function createBaloon(x:Number, y:Number):void 
		{
			var imgBaloon:Image = new Image(Main.assets.getTexture(baloonColor + baloonSize));	
			imgBaloon.name = String(baloonIndex++);
			imgBaloon.x = x - imgBaloon.width / 2;
			imgBaloon.y = y - imgBaloon.height / 2;
			
			var baloon:b2Body = data.createBody("baloon" + baloonSize, world, b2Body.b2_dynamicBody, imgBaloon);
			baloon.SetPosition(new b2Vec2((x - imgBaloon.width / 2) / data.ptm_ratio, (y - imgBaloon.height / 2) / data.ptm_ratio));
			baloon.SetLinearVelocity(new b2Vec2(Utils.randomRange( -5, 5), -5));
			baloon.GetUserData().addEventListener(TouchEvent.TOUCH, onBaloonTouch);
			addChild(baloon.GetUserData());
		}
		
		private function onBaloonRelease(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(baloonBlow, TouchPhase.ENDED);
			
			if (touch != null)
			{
				createBaloon(baloonBlow.x, baloonBlow.y - (baloonBlow.height / 2));
				
				baloonSize = 0;
				if (baloonColor == "blue")
					baloonColor = "red";
				else if (baloonColor == "red")
					baloonColor = "yellow";
				else
					baloonColor = "blue";
				
				baloonBlow.removeEventListener(TouchEvent.TOUCH, onBaloonRelease);
				eaze(baloonBlow).to(1, { scaleX:(arrSize[baloonSize].x / baloonBlow.width), scaleY:(arrSize[baloonSize].y / baloonBlow.height) } ).onComplete(function():void{
					baloonBlow.removeFromParent(true);
					baloonBlow = null;
					
					baloonBlow = new Image(Main.assets.getTexture(baloonColor + baloonSize));
					baloonBlow.alignPivot(HAlign.CENTER, VAlign.BOTTOM);
					baloonBlow.x = 240;
					baloonBlow.y = 790;
					baloonBlow.addEventListener(TouchEvent.TOUCH, onBaloonRelease);
					addChild(baloonBlow);
				});
			}
		}
		
		private function onBaloonTouch(e:TouchEvent):void 
		{
			var touchBegan:Touch = e.getTouch(e.target as DisplayObject, TouchPhase.BEGAN);
			var touchMoved:Touch = e.getTouch(e.target as DisplayObject, TouchPhase.MOVED);
			var touchEnded:Touch = e.getTouch(e.target as DisplayObject, TouchPhase.ENDED);
			
			if (touchMoved != null)
			{
				isSwipe = true;
				baloonName = (e.target as DisplayObject).name;
				//trace(baloonName +" clicked");
			}
			
			if (touchEnded == null) return;
			
			isSwipe = false;
			
			for (var b:b2Body = world.GetBodyList(); b; b = b.GetNext()) 
			{
				try
				{
					var sprite:DisplayObject = b.GetUserData() as DisplayObject;
					var target:DisplayObject = e.target as DisplayObject;
					
					if (sprite == target)
					{
						b.GetUserData().removeEventListener(TouchEvent.TOUCH, onBaloonTouch);
						
						_ce.sound.playSound("baloon-pop");
						
						eaze(sprite).to(0.3, { scaleX:1.7, scaleY:1.7, alpha:0 } ).onComplete(function():void{
							removeChild(b.GetUserData());
							world.DestroyBody(b);
						});
						break;
					}
				} 
				catch (err:Error)
				{
					world.DestroyBody(b);
				}
			}
		}
		
		private function onBackgroundTouch(e:TouchEvent):void 
		{
			var touchMoved:Touch = e.getTouch(e.target as DisplayObject, TouchPhase.MOVED);
			var touchEnded:Touch = e.getTouch(e.target as DisplayObject, TouchPhase.ENDED);
			
			if (touchMoved != null)
			{
				//nextBaloonSize();
				var loc:Point = touchMoved.getLocation(e.target as DisplayObject);
				baloonSwipe.SetPosition(new b2Vec2( loc.x / data.ptm_ratio, loc.y / data.ptm_ratio));
			}
			
			if (touchEnded != null)
			{
				baloonSwipe.SetPosition(new b2Vec2( -100 / data.ptm_ratio, -100 / data.ptm_ratio));
			}
		}
		
		private function nextBaloonSize():void 
		{
			_ce.sound.playSound("baloon-blow");
			
			baloonSize++;
			if (baloonSize == 4) 
			{
				baloonSize = 0;
				if (baloonColor == "blue")
					baloonColor = "red";
				else if (baloonColor == "red")
					baloonColor = "yellow";
				else
					baloonColor = "blue";
			}
			
			eaze(baloonBlow).to(2.2, { scaleX:(arrSize[baloonSize].x / baloonBlow.width), scaleY:(arrSize[baloonSize].y / baloonBlow.height) } ).onComplete(function():void{
				baloonBlow.removeEventListener(TouchEvent.TOUCH, onBaloonRelease);
				baloonBlow.removeFromParent(true);
				baloonBlow = null;
				
				baloonBlow = new Image(Main.assets.getTexture(baloonColor + baloonSize));
				baloonBlow.alignPivot(HAlign.CENTER, VAlign.BOTTOM);
				baloonBlow.x = 240;
				baloonBlow.y = 790;
				baloonBlow.addEventListener(TouchEvent.TOUCH, onBaloonRelease);
				addChild(baloonBlow);
			});
		}
		
		private function onBackPressed():void 
		{
			backPressedCount++;
			
			if (backPressedCount == 1)
			{
				if (BaseMobileTasks.isSupported()) 
				{
					BaseMobileTasks.instance.showTextDisplay("Tap again to exit", BaseMobileTasks.TEXT_DISPLAY_SHORT);
				}
			}
			else
			{
				NativeApplication.nativeApplication.exit();
			}
		}
		
		override public function update(timeDelta:Number):void 
		{
			super.update(timeDelta);
			
			if (mic.activityLevel == 0)
			{
				micCanBlow = true;
			}
			else if (mic.activityLevel >= 50)
			{
				micCanBlow = false;
				trace(mic.activityLevel);
				
				if (micCanBlowTimerReady)
				{
					nextBaloonSize();
					micCanBlowTimerReady = false;
					micCanBlowTimer.start();
				}
			}
			
			gravity();
			baloonMove();
		}
		
		private function gravity():void 
		{			
			var gravityY:Number;
			
			if (accel.acceleration.y > 0)
			{
				gravityY = accel.acceleration.y * -20;
			}
			else if (accel.acceleration.y == 0)
			{
				gravityY = -2;
			}
			else
			{
				gravityY = accel.acceleration.y * 20;
			}
		
			world.SetGravity(new b2Vec2(accel.acceleration.x * 10, accel.acceleration.y * -10));
			//world.SetGravity(new b2Vec2(accel.acceleration.x * 20, gravityY));
			world.Step(1 / 30, 10, 10);
			world.ClearForces();
		}
		
		private function baloonMove():void 
		{
			// Code for making starlingImage follows your box2d body.
			for (var b:b2Body = world.GetBodyList(); b; b = b.GetNext()) 
			{
				
				
				// I Include it in a try catch function because for reason I don't really know, a static body automatically created at (0,0). Let's call him mr B -_-
				try
				{
					var sprite:DisplayObject = b.GetUserData() as DisplayObject;
					sprite.x = b.GetPosition().x * data.ptm_ratio;
					sprite.y = b.GetPosition().y * data.ptm_ratio;
					sprite.rotation = b.GetAngle();
				} 
				catch (err:Error)
				{
					// I kill mr B here
					world.DestroyBody(b);
				}
				
				
			} // end of for
		}
		
	}

}