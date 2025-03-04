import 'package:objectbox/objectbox.dart';

@Entity()
class DeletedItem {
  @Id()
  int id = 0;

  String itemId; // 삭제할 항목의 ID

  DeletedItem({required this.itemId});
}
