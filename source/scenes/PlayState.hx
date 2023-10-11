package scenes;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import singletons.GameManager;
import singletons.Messenger;

class PlayState extends FlxState
{
	// static sprites dict
	var spriteDict:Map<String, FlxSprite> = [
		"background" => new FlxSprite().loadGraphic(AssetPaths.Background__PNG),
		"room" => new FlxSprite().loadGraphic(AssetPaths.Room__PNG),
		"desk" => new FlxSprite().loadGraphic(AssetPaths.Desk__PNG),
		"stuff-on-desks" => new FlxSprite().loadGraphic(AssetPaths.Stuff_On_Desk__PNG),
		"whiteboard" => new FlxSprite().loadGraphic(AssetPaths.Whiteboard__PNG),
	];

	override public function create()
	{
		super.create();

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

		if (FlxG.keys.justPressed.SPACE)
		{
			Messenger.Instance.OnSpace.dispatch();
		}
	}

	private function onSpaceSignal()
	{
		trace("signal bussed");
	}
}
