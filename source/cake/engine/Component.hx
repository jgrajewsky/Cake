package cake.engine;

@:allow(Entity)
class Component {
	/** Entity this component is attached to. **/
	public var entity:Entity;

	public function new() {}

	/** Attaches the Component to the specified Entity. **/
	public function attach(to:Entity):Void {
		to.attachComponent(this);
	}

	/** Detaches the Component from the Entity it's attached to. **/
	public function detach():Void {
		entity.detachInstance(this);
	}
}
