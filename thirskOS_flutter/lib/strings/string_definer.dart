import 'string_getter.dart';
///The dictionary of string referred to in the app. Helps organize strings
DisplayString stringAsset = DisplayString(stringMap:
{
  'calendar/rememberance':'Rememberance Day',

  'calendar/schoolday/connect':'Connect',
  'calendar/schoolday/ends_in':'ends in',
  'calendar/schoolday/end_of_school':'School is over',
  'calendar/schoolday/focus':'Focus',
  'calendar/schoolday/lunch':'Lunch',
  'calendar/schoolday/period':'Period',


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

  'event/time/future':'The future is now!',
  'event/time/years_ago':'%d years ago',
  'event/time/a_year_ago':'1 year ago',
  'event/time/months_ago':'%d months ago',
  'event/time/a_month_ago':'1 month ago',
  'event/time/weeks_ago':'%d weeks ago',
  'event/time/a_week_ago':'1 week ago',
  'event/time/days_ago':'%d days ago',
  'event/time/a_day_ago':'1 day ago',
  'event/time/hours_ago':'%d hours ago',
  'event/time/a_hour_ago':'1 hour ago',
  'event/time/minutes_ago':'%d minutes ago',
  'event/time/a_minute_ago':'1 minute ago',
  'event/time/seconds_ago':'%d seconds ago',
  'event/time/a_second_ago':'1 second ago',
  'event/time/now':'Just now',

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