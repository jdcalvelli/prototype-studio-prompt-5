package singletons;

class GameManager
{
	// static instance
	public static final Instance:GameManager = new GameManager();

	// properties on class
	public var testVar:String = "Hello Haxe";

	// private constructor stops class instantiation elsewhere
	private function new() {}
}
