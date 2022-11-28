module scope_cleanup;

/// RAII object that does nothing but calling, when destructed, the function passed at construction.
struct ScopeCleanup
{
	@disable this();
	@disable this(this);

	this(void delegate() cleanup) { this.cleanup = cleanup; }
	
	~this() { cleanup(); }

	private void delegate() cleanup;
}

/// Enables assigning e.g. extern(C) functions to D delgate variables
/// and discards any return value.
auto wrapAsVoidDelegate(alias f)() { return delegate void() { f(); }; }
