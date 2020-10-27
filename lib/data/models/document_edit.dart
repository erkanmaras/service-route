import 'package:aff/infrastructure.dart';

class DocumentEdit {
  DocumentEdit({
    this.filesToAdd,
    // this.filesToRemove,
  });

  factory DocumentEdit.fromJson(Map<String, dynamic> json) => DocumentEdit(
        filesToAdd: List<FilesToAdd>.from(
            (json['filesToAdd'] as Iterable<Map<String, dynamic>>).map<FilesToAdd>((x) => FilesToAdd.fromJson(x))),
        // filesToRemove: List<int>.from((json['filesToRemove'] as Iterable<int>).map<int>((x) => x)),
      );

  List<FilesToAdd> filesToAdd;
  List<int> filesToRemove;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'filesToAdd': List<dynamic>.from(filesToAdd.map<dynamic>((x) => x.toJson())),
        // 'filesToRemove': List<dynamic>.from(filesToRemove.map<dynamic>((x) => x)),
      };
}

class FilesToAdd {
  FilesToAdd({
    this.category,
    this.path,
    this.name,
  });
  factory FilesToAdd.fromJson(Map<String, dynamic> json) => FilesToAdd(
        category: json.getValue<String>('category'),
        path: json.getValue<String>('path'),
        name: json.getValue<String>('name'),
      );

  String category;
  String path;
  String name;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'category': category,
        'path': path,
        'name': name,
      };
}
