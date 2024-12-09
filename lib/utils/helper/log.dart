import 'package:flutter/foundation.dart';

void logPrint(dynamic message){
  if(kDebugMode){
    print(message);
  }
}