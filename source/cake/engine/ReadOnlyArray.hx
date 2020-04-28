package cake.engine;

@:forward(length, concat, copy, filter, indexOf, iterator, join, lastIndexOf, map, slice, toString)
abstract ReadOnlyArray<T>(Array<T>) from Array<T> {
	@:arrayAccess inline function get(i:Int):T {
		return this[i];
	}

	private inline function push(x:T):Int {
		return this.push(x);
	}

	private inline function remove(x:T):Bool {
		return this.remove(x);
    }
    
    private inline function splice(pos:Int, len:Int):Array<T> {
        return this.splice(pos, len);
    }
}
