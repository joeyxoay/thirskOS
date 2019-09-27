import 'string_getter.dart';
///The dictionary of string referred to in the app. Helps organize strings
DisplayString stringAsset = DisplayString(stringMap:
{
  'credit/app_title' : 'THIRSK OUTER SPACE',
  'credit/version' : 'Closed Alpha: v0.1',
  'credit/2018/header' : 'Credits(2018~2019):',
  'credit/2018/credit' :
    'Creator/Lead App Developer: Christopher Samra\n' +
    'Prototype App Co-Developer: Hasin Zaman\n' +
    'App Co-Developer: Roger Cao\n' +
    'Backend Developer: Dunedin Molnar, Hasin Zaman',
  'credit/2019/header' : 'Credits(2019~2020):',
  'credit/2019/credit' :
    'Creator/Lead App Developer: Roger Cao\n' +
    'Backend Developer: Umut Emre\n' +
    'Random Nobodys:\n-Matt Groeneveldt\n-Ava Daly\n-Joey Koay\n-Tom Allwright\n' + ///To get promoted, actually tell me what you're doing
    'Closed Alpha Testers: No one yet',

  'event/button':'EVENTS',

  'home/button':'HOME',

  'lunch/entry/entree':'Entree',
  'lunch/entry/soup':'Soup',
  'lunch/entry/dessert':'Bake Shop',
  'lunch/entry/no_item':'Looks like there isn\'t anything today. Maybe a bug?',

  'lunch/menu_prompt':'Lunch Menu:',
  'lunch/no_entry':'Check back soon for next week\'s lunch menu!',

  'misc/back':'Back',
  'misc/loading':'Loading...',
  'misc/test':'test string',

  'thrive/button':'THRIVE',
  'thrive/thrive_prompt':'START THRIVING @ Thirsk!',

});
String getString(String identifier){
  return stringAsset.getString(identifier);
}