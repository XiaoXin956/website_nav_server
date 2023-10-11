
class TypeBean {

  int id;
  String name;
  TypeBean({required this.id, required this.name});

  Map<String,dynamic> toJson()=>{
    "id":id,
    "name":"$name",
  };

}