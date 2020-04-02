package cake.engine;

class Entity {
	/** The name of the entity. **/
	public var name:String;

	/** The parent of the entity. **/
	public var parent:Entity;

	/** Transform attached to this entity. **/
	public var transform(default, null):Transform;

	/** All entities attached to this entity. **/
	public var children(default, null):Array<Entity>;

	/** All components attached to this entity. **/
	private var components(default, null):Array<Component>;

	public function new(name:String) {
		this.name = name;
		parent = null;
		children = [];
		components = [];
	}

	public function addComponent(type:Class<Component>):Component {
		var component = Type.createInstance(type, null);
		component.entity = this;
		if (transform == null && type == Transform) {
			transform = cast component;
			components.unshift(component);
		} else {
			components.push(component);
		}
		return component;
	}

	/** Returns first component of Type `type` in the Entity. **/
	public function getComponent(type:Class<Component>):Component {
		for (component in components) {
			if (Type.getClass(component) == type) {
				return component;
			}
		}
		return null;
	}

	/** Returns all components of Type `type` in the Entity. **/
	public function getComponents(type:Class<Component>):Array<Component> {
		var found = [];
		for (component in components) {
			if (Type.getClass(component) == type) {
				found.push(component);
			}
		}
		return found.length > 0 ? found : null;
	}

	/** 
		Removes first component of Type `type` from the Entity.
		@returns `false` if no component was removed.
	**/
	public function removeComponent(type:Class<Component>):Bool {
		for (i in 0...components.length) {
			if (Type.getClass(components[i]) == type) {
				if (i == 0) {
					transform = null;
				}
				components.splice(i, 1);
				return true;
			}
		}
		return false;
	}

	/** 
		Removes all components of Type `type` from the Entity.
		@returns How many components were removed.
	**/
	public function removeComponents(type:Class<Component>):Int {
		var count = 0, i = 0;
		while (i < components.length) {
			if (Type.getClass(components[i]) == type) {
				if (i == 0) {
					transform = null;
				}
				components.splice(i--, 1);
				++count;
			}
			++i;
		}
		return count;
	}

	/** Removes all components from the Entity. **/
	public function removeAllComponents():Void {
		components = [];
	}

	private final function onCreate():Void {
		for (component in components) {
			component.onCreate();
		}
		for (child in children) {
			child.onCreate();
		}
	}

	private final function onUpdate():Void {
		for (component in components) {
			component.onUpdate();
		}
		for (child in children) {
			child.onUpdate();
		}
	}

	private final function onDestroy():Void {
		for (component in components) {
			component.onDestroy();
		}
		for (child in children) {
			child.onDestroy();
		}
	}
}
