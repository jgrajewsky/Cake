package cake.engine;

@:allow(Main, cake.engine)
final class Entity {
	/** The name of the entity. **/
	public var name:String;

	/** The parent of the entity. **/
	public var parent(default, set):Entity;

	/** All entities attached to this entity. (Read only) **/
	public var children(default, null):ReadOnlyArray<Entity>;

	/** All Components attached to this entity. (Read only) **/
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

	/** Attaches given `component` to the Entity. **/
	public inline function attachComponent(component:Component):Void {
		@:privateAccess components.push(component);
	}

	/** Attaches given `components` to the Entity. **/
	public function attachComponents(components:Array<Component>):Void {
		var start = this.components.length;
		var add = components.length;
		components.resize(this.components.length + add);
		var i = 0;
		while (i < add) {
			@:privateAccess this.components[start + i] = components[i];
			++i;
		}
	}

	/** Returns first Component of Type `type` attached to the Entity. **/
	@:generic
	public function getComponent<T:Component>(type:Class<T>):T {
		for (component in components) {
			if (Std.is(component, type)) {
				return cast component;
			}
		}
		return null;
	}

	/** Returns all Components of Type `type` attached to the Entity. **/
	@:generic
	public function getComponents<T:Component>(type:Class<T>):Array<T> {
		var found:Array<T> = new Array<T>();
		for (component in components) {
			if (Std.is(component, type)) {
				found.push(cast component);
			}
		}
		return found.length > 0 ? found : null;
	}

	/** 
		Detaches first Component of Type `type` from the Entity.
		@return The detached Component otherwise `null`.
	**/
	@:generic
	public function detachComponent<T:Component>(type:Class<T>):T {
		for (i in 0...components.length) {
			if (Std.is(components[i], type)) {
				var component = components[i];
				@:privateAccess components.splice(i, 1);
				return cast component;
			}
		}
		return null;
	}

	private inline function detachInstance(component:Component):Void {
		for (i in 0...components.length) {
			if (components[i] == component) {
				@:privateAccess components.splice(i, 1);
				break;
			}
		}
	}

	/** 
		Detaches all Components of Type `type` from the Entity.
		@returns How many Components were detached.
	**/
	public function detachComponents(type:Class<Component>):Int {
		var count = 0, i = 0;
		while (i < components.length) {
			if (Std.is(components[i], type)) {
				@:privateAccess components.splice(i--, 1);
				++count;
			}
			++i;
		}
		return count;
	}

	/** Removes all components from the Entity. **/
	public inline function detachAllComponents():Void {
		components = [];
	}

	// #endregion
	// #region events

	private function onUpdate():Void {
		// for (behaviour in behaviours) {
		// 	behaviour.onUpdate();
		// }
		for (child in children) {
			child.onUpdate();
		}
	}

	private function onDestroy():Void {
		// for (behaviour in behaviours) {
		// 	behaviour.onDetach();
		// }
		for (child in children) {
			child.onDestroy();
		}
	}

	// #endregion
}
