class DisplayString{
  Map<String,String> stringMap;
  DisplayString({this.stringMap});
  String getString(String identifier){
    if (stringMap.containsKey(identifier)){
      return stringMap[identifier];
    } else{
      return identifier;
    }
  }
}