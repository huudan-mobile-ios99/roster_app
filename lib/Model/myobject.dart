class MyObject {
  final String foo;
  final int bar;

  MyObject._({required this.foo, required this.bar});

  factory MyObject.fromJson(Map<String, dynamic> data) {
    return MyObject._(
      foo: data['foo'] as String,
      bar: data['bar'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foo': foo,
      'bar': bar,
    };
  }
}