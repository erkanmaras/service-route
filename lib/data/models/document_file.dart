import 'package:service_route/data/data.dart';
import 'package:path/path.dart' as path;
import 'package:service_route/infrastructure/infrastructure.dart';

class DocumentFile {
  DocumentFile(this.documentCategory, this.filePath) : fileName = path.basename(filePath) {
    _prettyFileName = documentCategory.id + Clock().now().millisecondsSinceEpoch.toString();
  }

  final DocumentCategory documentCategory;
  final String filePath;
  final String fileName;

  String _prettyFileName;
  String get prettyFileName {
    return _prettyFileName;
  }
}
