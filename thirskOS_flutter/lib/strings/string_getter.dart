///Class for a dictionary of display string and ways to retrieve the string.
class DisplayString{
  Map<String,String> stringMap;
  DisplayString({this.stringMap});
  String getString(String identifier){
    if (stringMap.containsKey(identifier)){
      return stringMap[identifier];
    } else{
      print('Warning: String for "' + identifier + '" is not defined');
      return identifier;
    }
  }
}