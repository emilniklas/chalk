@proxy
class ProxyObject {
  final Map<Symbol, dynamic> _map;

  ProxyObject(this._map);

  noSuchMethod(Invocation invocation) {
    if (!invocation.isGetter) {
      return super.noSuchMethod(invocation);
    }

    return _map[invocation.memberName];
  }
}
