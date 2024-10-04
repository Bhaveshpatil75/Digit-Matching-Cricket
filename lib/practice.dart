
import 'dart:io';

// void main(){
//   int row=4;
//   for (int i=1;i<=row;i++){
//     int inc=row;
//     int num=i;
//     for (int j=1;j<=i;j++){
//       stdout.write(num);
//       stdout.write(" ");
//       num=num+inc;
//       inc--;
//     }
//     print("");
//   }
// }

void main(){
  int num=1,temp;
  int prev=0;
  int row=4;
  for (int i=1;i<=row;i++){
    for (int j=1;j<=i;j++){
      stdout.write(num);
      stdout.write(" ");
      temp=num;
      num+=prev;
      prev=temp;
    }
    print("");
  }

}