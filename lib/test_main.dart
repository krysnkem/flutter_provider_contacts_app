class DummyClass {
  final int value;
  static final List<int> values = [];

  const DummyClass(this.value);
}

void main(List<String> args) {
  final dummy1 = DummyClass(1);
  final dummy2 = DummyClass(2);
  DummyClass.values.add(4);

  print('${dummy1.value} ${dummy2.value} ${DummyClass.values}');
}
