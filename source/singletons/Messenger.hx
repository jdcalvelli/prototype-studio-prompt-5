package singletons;

import flixel.util.FlxSignal;

class Messenger
{
	public static final Instance = new Messenger();

	public var OnSpace:FlxSignal = new FlxSignal();

	private function new() {}
}
