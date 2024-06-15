

void main(){

  // var h1=Animal.human(); //factory constructor calling
  // print(h1.name);
  //
  // var a1=Animal("dog");
  // a1.eating(); //calling method from extension
  // print(a1.namer);
  // a1.Legs=5;
  // print(a1.legs);


  // List<String?>? names;  //optional list of optional strings
  // names=null;  //names as whole can be null
  // names=[null,null,"bhav"];// names can contain null values as elements
  // //adjust List creation a/c to what you want like if you dont want elements to be null remove ? inside <>.
  //
  // String? name;//="aj";
  // print(name?.length); //the ? provides null safety as length is only called if name is not null
  // name ??= "bhav";//will only assign bhav if name is null
  // print(name);

  show();  //async function
  Pair<int,int>(2,3);  // Generic with int and int as data types
}

Stream<String> shownum(){
  return Stream.periodic(Duration(seconds: 2),(a)=>"Hii");  //will return Hii in a continuous interval of 2 seconds
}

Future<String> showname(){
  return Future.delayed(Duration(seconds: 3),()=>"Hii");  //will return Hii after 3 seconds of calling
}

void show()async{
  String val=await showname();  //await of Future
  print(val);
  // await for (String val in shownum()){  //little different await (unlike Future)
  //   print(val);
  // }
}

class Pair<A,B>{ //Generics :- like templates in C++
  A val1;
  B val2;
  Pair(this.val1,this.val2);
}

class Animal{
  String name;
  int legs=0;
  Animal(this.name);
  factory Animal.human(){  //factory constructor:-used to return instances that are not of the same class
    return Animal("human");

  }
  String get namer => name+"er";  //a getter method
  set Legs(int l) => legs=l;  // a setter method
}

extension eat on Animal{  //to add logic por functionalities in existing class
  eating(){  //generally dont add the return type
    print("Animal is eating...");
  }
}