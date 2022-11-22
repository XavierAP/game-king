module scope_cleanup;

/// RAII object that does nothing but calling, when destructed, the function passed at construction.
struct ScopeCleanup
{
	@disable this();
	this(void function() cleanup) { this.cleanup = cleanup; }
	~this() { cleanup(); }

	private void function() cleanup;
}

/// Enables assigning e.g. extern(C) functions to D function pointer variables.
auto wrapAsFunction(alias f)() { return function void() { f(); }; }
