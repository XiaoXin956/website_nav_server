
class TypeBean {

  int? id;
  String? name;

  TypeBean({ this.id,  this.name});

   Map<String,dynamic> toJson()=>{
    "id":id,
    "name":name,
  };

}