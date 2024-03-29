

class KnowledgeBean {
  int? id;
  String? label;
  String? text;
  String? url;
  int? typeId;
  String? describe;
  String? imgUrl;

  KnowledgeBean({this.id, this.label, this.text, this.url, this.typeId, this.describe, this.imgUrl});

  KnowledgeBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    text = json['text'];
    url = json['url'];
    typeId = json['type_id'];
    describe = json['describe'];
    imgUrl = json['img_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['text'] = this.text;
    data['url'] = this.url;
    data['type_id'] = this.typeId;
    data['describe'] = this.describe;
    data['img_url'] = this.imgUrl;
    return data;
  }
}
