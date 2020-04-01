package cake.engine;

class Component {
	public var entity:Entity;

	public function new() {}

	public function onCreate():Void {}

	public function onUpdate():Void {}

	public function onDestroy():Void {}
}
