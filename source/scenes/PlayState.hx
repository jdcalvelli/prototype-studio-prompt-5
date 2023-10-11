package scenes;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import singletons.GameManager;
import singletons.Messenger;

class PlayState extends FlxState
{
	// state
	// its decoupled from objects bc of the way i did this
	// i dont like that, i'll do it better next time
	var isGameboyOut:Bool = true;

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

		// global signals subscription
		Messenger.Instance.OnSpace.add(this.onSpaceSignal);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

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
			onComplete: changeGameboyState,
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
}
