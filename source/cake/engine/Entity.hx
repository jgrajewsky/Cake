package cake.engine;

@:allow(Main)
final class Entity {
	/** The name of the entity. **/
	public var name:String;

	/** The parent of the entity. **/
	public var parent(default, set):Entity;

	/** All entities attached to this entity. (Read only) **/
	public var children(default, null):ReadOnlyArray<Entity>;

	/** All components attached to this entity. (Read only) **/
	private var components(default, null):ReadOnlyArray<Component>;

	private function new(name:String) {
		this.name = name;
		children = [];
		components = [];
	}

	// #region properties

	private function set_parent(parent:Entity):Entity {
		if (this.parent != null) {
			@:privateAccess this.parent.children.remove(this);
		}
		if (parent != null) {
			@:privateAccess parent.children.push(this);
		}
		this.parent = parent;
		return parent;
	}

	// #endregion
	// #region functions

	/** Attaches a component of Type `type` to the Entity. **/
	public function addComponent(type:Class<Component>):Component {
		var component = Type.createInstance(type, []);
		component.entity = this;
		@:privateAccess components.push(component);
		return component;
	}

	/** Returns first component of Type `type` attached to the Entity. **/
	public function getComponent(type:Class<Component>):Component {
		for (component in components) {
			if (Type.getClass(component) == type) {
				return component;
			}
		}
		return null;
	}

	/** Returns all components of Type `type` attached to the Entity. **/
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
		@return `false` if no component was removed.
	**/
	public function removeComponent(type:Class<Component>):Bool {
		for (i in 0...components.length) {
			if (Type.getClass(components[i]) == type) {
				@:privateAccess components.splice(i, 1);
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
				@:privateAccess components.splice(i--, 1);
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

	// #endregion
	// #region events

	private function onCreate():Void {
		for (component in components) {
			component.onCreate();
		}
		for (child in children) {
			child.onCreate();
		}
	}

	private function onUpdate():Void {
		for (component in components) {
			component.onUpdate();
		}
		for (child in children) {
			child.onUpdate();
		}
	}

	private function onDestroy():Void {
		for (component in components) {
			component.onDestroy();
		}
		for (child in children) {
			child.onDestroy();
		}
	}

	// #endregion
}
