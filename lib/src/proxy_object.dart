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

  String $_esc(anything) {
    // http://wonko.com/post/html-escaping
    return anything.toString()
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;')
      .replaceAll('`', '&#96;')
      .replaceAll('!', '&#33;')
      .replaceAll('@', '&#64;')
      .replaceAll(r'$', '&#36;')
      .replaceAll('%', '&#37;')
      .replaceAll('(', '&#40;')
      .replaceAll(')', '&#41;')
      .replaceAll('=', '&#61;')
      .replaceAll('+', '&#43;')
      .replaceAll('{', '&#123;')
      .replaceAll('}', '&#125;')
      .replaceAll('[', '&#91;')
      .replaceAll(']', '&#93;');
  }
}
