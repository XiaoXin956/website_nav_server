
class TypeBean {

  int? id;
  String? name;
  int? parentId;
  List<TypeBean?>? childBean;

  TypeBean({ this.id,  this.name, this.parentId,this.childBean});

   Map<String,dynamic> toJson()=>{
    "id":id,
    "name":name,
    "parentId":parentId,
    "childBean":childBean?.map((e){
      var json = e?.toJson();
      // return e?.toJson();
      // return {"id":"${id}","name":e["name"],"parentId":e['parentId']};
      return e?.toJson();
    }).toList(),
  };

}