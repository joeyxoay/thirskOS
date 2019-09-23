import 'string_getter.dart';
//The dictionary of string referred to in the app. Helps organize strings
DisplayString stringAsset = DisplayString(stringMap:
{
  "credit/app_title" : "THIRSK OUTER SPACE",
  "credit/version" : "Closed Alpha: v0.1",
  "credit/2018/header" : "Credits(2018~2019):",
  "credit/2018/credit" :
    "Creator/Lead App Developer: Christopher Samra\n" +
    "Prototype App Co-Developer: Hasin Zaman\n" +
    "App Co-Developer: Roger Cao\n" +
    "Backend Developer: Dunedin Molnar, Hasin Zaman"
  ,

  "lunch/check_back_soon":"Check back soon for next week's lunch menu!",
  "lunch/menu_prompt":"Lunch Menu:",

  "misc/back":"Back",
  "misc/test":"test string",
});
String getString(String identifier){
  return stringAsset.getString(identifier);
}