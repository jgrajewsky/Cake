package cake.engine;

@:allow(Entity)
class Component {
	/** Entity this component is attached to. **/
	public var entity:Entity;

	private final function new() {}

	/** This function is called when the component is created. **/
	public function onCreate():Void {}

	/** This function is called every frame. **/
	public function onUpdate():Void {}

	/** This function is called when the component is destroyed. **/
	public function onDestroy():Void {}
}
