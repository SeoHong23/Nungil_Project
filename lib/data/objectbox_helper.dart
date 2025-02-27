import 'package:nungil/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

class ObjectBox {
  static late final Store store;

  // 싱글턴 인스턴스
  static final ObjectBox _instance = ObjectBox._internal();

  factory ObjectBox() => _instance;

  ObjectBox._internal();

  // 초기화 메서드
  Future<void> init() async {
    store = await openStore();
  }

  // 전역에서 box 접근
  Box<T> getBox<T>() => store.box<T>();

}
