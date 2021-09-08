// scene location object info

typedef ObjectInfo = {
  var id: String;
  var names: Array<String>;
  @:optional var state: Int; // generic object state counter (default 0)
  @:optional var simpleActions: Map<String, String>;
  @:optional var locationNote: String;
  @:optional var note: String;
  @:optional var actions: Array<ObjectActionInfo>;
  @:optional var isEnabled: Bool;
}
