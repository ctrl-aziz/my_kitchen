class Foods{
  final String fid;

  Foods.fid({this.fid});

}

class FoodsData{
  final String fid;
  final String infid;
  final String name;
  final String image;
  final String owner;
  final List<String> content;
  final List<String> howToDo;
  final List<String> favorite;
  final List<String> like;
  final List<String> country;


  FoodsData({this.fid, this.infid, this.name, this.image, this.owner, this.content,
    this.howToDo, this.favorite, this.like, this.country});
}