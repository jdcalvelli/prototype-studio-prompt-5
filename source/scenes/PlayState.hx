package scenes;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import singletons.GameManager;
import singletons.Messenger;

class PlayState extends FlxState
{
	var text = new FlxText(0, 0, 0, GameManager.Instance.testVar, 64);

	override public function create()
	{
		super.create();
		text.screenCenter();
		add(text);

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
		text.text = "signal bussed";
		text.screenCenter();
	}
}
