package scenes;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class GameOverState extends FlxState
{
	override public function create()
	{
		super.create();

		var text:FlxText = new FlxText(32, 64, 0, "plz no law\na prototype by jd calvelli", 32);
		add(text);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.R)
		{
			FlxG.switchState(new scenes.PlayState());
		}
	}
}
