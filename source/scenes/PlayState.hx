package scenes;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import singletons.GameManager;
import singletons.Messenger;

class PlayState extends FlxState
{
	// state
	// its decoupled from objects bc of the way i did this
	// i dont like that, i'll do it better next time
	var isGameboyOut:Bool = true;
	var isCatchPhase:Bool = false;

	// global timers
	var momPotentialTimer:FlxTimer = new FlxTimer();

	// sprites dict
	var spriteDict:Map<String, FlxSprite> = [
		"background" => new FlxSprite().loadGraphic(AssetPaths.Background__PNG),
		"room" => new FlxSprite().loadGraphic(AssetPaths.Room__PNG),
		"desk" => new FlxSprite().loadGraphic(AssetPaths.Desk__PNG),
		"stuff-on-desks" => new FlxSprite().loadGraphic(AssetPaths.Stuff_On_Desk__PNG),
		"whiteboard" => new FlxSprite().loadGraphic(AssetPaths.Whiteboard__PNG),
		"gameboy" => new FlxSprite().loadGraphic(AssetPaths.gameboy_spritesheet__png, true, 640, 360),
		"door" => new FlxSprite().loadGraphic(AssetPaths.door_spritesheet__png, true, 640, 360),
	];

	override public function create()
	{
		super.create();

		// gameboy animation
		spriteDict["gameboy"].animation.add("default", [0, 1], 12);
		spriteDict["gameboy"].animation.play("default");
		// setting door frame
		spriteDict["door"].animation.frameIndex = 0;

		// add sprites
		for (sprite in spriteDict)
		{
			sprite.screenCenter();
			add(sprite);
		}

		// timer start
		momPotentialTimer.start(3, onMomPotentialTimerComplete, 0);

		// global signals subscription
		// this was overkill but it would have made sense if i coded this right
		Messenger.Instance.OnSpace.add(this.onSpaceSignal);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (isGameboyOut && isCatchPhase)
		{
			FlxG.camera.shake(0.1, 0.5, () ->
			{
				FlxG.switchState(new scenes.GameOverState());
			});
		}

		// input check
		if (FlxG.keys.justPressed.SPACE)
		{
			Messenger.Instance.OnSpace.dispatch();
		}
	}

	private function onSpaceSignal()
	{
		// haxe ternary operator
		var tweenLocation:Int = spriteDict["gameboy"].y == 0 ? 128 : 0;

		FlxTween.tween(spriteDict["gameboy"], {
			y: tweenLocation,
		}, 0.75, {
			type: FlxTweenType.ONESHOT,
			ease: FlxEase.sineInOut,
			onStart: changeGameboyState,
		});
	}

	// callbacks
	// tween passes itself through first, if you want additional args you have to
	// lambda in the callback and then pass the func through the lambda
	private function changeGameboyState(tween:FlxTween)
	{
		isGameboyOut = !isGameboyOut;
		trace(isGameboyOut);
	}

	private function onMomPotentialTimerComplete(timer:FlxTimer)
	{
		trace("mom potential fired");
		momPotentialTimer.active = false;
		spriteDict["door"].animation.frameIndex = 1;
		var subtimer:FlxTimer = new FlxTimer();
		subtimer.start(1, (?_) ->
		{
			// random check to see if we go into catch phase
			// if not go back to the initial timer
			if (new FlxRandom().bool(30))
			{
				isCatchPhase = true;
				momPotentialTimer.active = false;
				spriteDict["door"].animation.frameIndex = 2;
				var subtimer:FlxTimer = new FlxTimer();
				subtimer.start(1, (?_) ->
				{
					isCatchPhase = false;
					momPotentialTimer.active = true;
					spriteDict["door"].animation.frameIndex = 0;
				}, 1);
			}
			else
			{
				momPotentialTimer.active = true;
				spriteDict["door"].animation.frameIndex = 0;
			}
		}, 1);
	}
}
