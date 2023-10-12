
class TypeBean {

  int? id;
  String? name;
  int? parentId;
  List<TypeBean?>? childBean;

  TypeBean({ this.id,  this.name, this.parentId,this.childBean});

  Map<String,dynamic> toJson()=>{
    "id":id,
    "name":"$name",
    "parentId":"$parentId",
    "childBean":"${childBean?.map((e) => e?.toJson()).toList()}",
  };

}