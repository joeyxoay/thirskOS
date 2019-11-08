import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
//import 'package:path_provider/path_provider.dart';
//import 'package:date_format/date_format.dart';
import 'dart:async';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:thirskOS/general_functions.dart';
import 'package:thirskOS/strings/string_definer.dart';
import 'package:sprintf/sprintf.dart';

///The type of school day that affects whether students and staffs attend or not.
enum SchoolDayType{
  ///Both students and staffs attend school today
  schoolDay,
  ///No school for students, but staff needs to attend
  nonInstructional,
  ///No school for both students and staffs
  noSchool
}
///The type of duration used in [EventDuration]
enum DurationType{
  ///A continuous duration of time. [argument1] specify the start time while [argument2] specify the end time, inclusively.
  fromTo,
  ///A single day. [argument1] specify the day of the event.
  singleDay,
  ///Weekly event. [argument1] provides a List<bool> of size 7, with the i-th specify whether the event apply to this weekday, starting from Monday.
  weekly
}

///A class to store a duration of an event. Select a mode and possibly two arguments.
class EventDuration{
  DurationType type;
  dynamic argument1;
  dynamic argument2;

  ///Initialization of this class requires validation. Depending on the type, a different amount of arguments are required.
  EventDuration(DurationType type, [dynamic argument1, dynamic argument2]){
    switch(type){
      case DurationType.fromTo:
        assert(argument1 is DateTime && argument2 is DateTime && (argument1).isBefore(argument2));
        break;
      case DurationType.singleDay:
        assert(argument1 is DateTime);
        break;
      case DurationType.weekly:
        assert(argument1 is List<bool>);
        break;
      default:
        throw FormatException("Invalid type");
    }
    this.type = type;
    this.argument1 = argument1;
    this.argument2 = argument2;
  }

  bool isUnderDuration(DateTime currentDate){
    currentDate = new DateTime(currentDate.year,currentDate.month,currentDate.day);
    switch(type){
      case DurationType.fromTo:
        return !((argument1 as DateTime).isAfter(currentDate) || (argument1 as DateTime).isBefore(currentDate));
      case DurationType.singleDay:
        return (argument1 as DateTime).isAtSameMomentAs(currentDate);
      case DurationType.weekly:
        return (argument1 as List<bool>)[currentDate.weekday - 1];
      default:
        break;
    }
    return false;
  }
}

class SchoolDayInformation{
  SchoolDayType schoolDayType;
  String title;
  String greeting;
  EventDuration duration;
  SchoolDayInformation({@required this.schoolDayType,@required this.title,this.greeting,@required this.duration});
  bool isUnderDuration(DateTime currentDate){
    return duration.isUnderDuration(currentDate);
  }
}

///A calendar for a typical school year
class SchoolCalendar{
  List<SchoolDayInformation> eventLists;
  SchoolCalendar({this.eventLists});
  SchoolDayInformation getInfo(DateTime currentDate){
    for(var oneEvent in eventLists){
      if(oneEvent.isUnderDuration(currentDate))
        return oneEvent;
    }
    return null;
  }
}
SchoolCalendar schoolCalendar = new SchoolCalendar(
    eventLists: [
      /*
      * Hard-coded events. Too lazy to add events already passed.
      * */
      SchoolDayInformation(
        schoolDayType: SchoolDayType.noSchool,
        title: getString('calendar/rememberance'),
        greeting: getString('calendar/rememberance/greeting'),
        duration: EventDuration(DurationType.fromTo,DateTime(2019,11,9),DateTime(2019,11,11))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.nonInstructional,
          title: getString('calendar/noninstructional'),
          greeting: getString('calendar/noninstructional/greeting'),
          duration: EventDuration(DurationType.singleDay,DateTime(2019,11,22))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.schoolDay,
          title: getString('calendar/last_day'),
          greeting: getString('calendar/last_day/christmas_greeting'),
          duration: EventDuration(DurationType.singleDay,DateTime(2019,12,19))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.nonInstructional,
          title: getString('calendar/noninstructional'),
          greeting: getString('calendar/noninstructional/greeting'),
          duration: EventDuration(DurationType.singleDay,DateTime(2019,12,20))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.noSchool,
          title: getString('calendar/christmas'),
          greeting: getString('calendar/christmas/greeting'),
          duration: EventDuration(DurationType.fromTo,DateTime(2019,12,21),DateTime(2020,1,5))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.schoolDay,
          title: getString('calendar/resume_class'),
          greeting: getString('calendar/resume_class/greeting'),
          duration: EventDuration(DurationType.singleDay,DateTime(2020,1,6))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.nonInstructional,
          title: getString('calendar/noninstructional'),
          greeting: getString('calendar/noninstructional/greeting'),
          duration: EventDuration(DurationType.singleDay,DateTime(2020,1,31))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.noSchool,
          title: getString('calendar/teachers_convention'),
          greeting: getString('calendar/teachers_convention/greeting'),
          duration: EventDuration(DurationType.fromTo,DateTime(2020,2,13),DateTime(2020,2,14))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.noSchool,
          title: getString('calendar/family_day'),
          greeting: getString('calendar/family_day/greeting'),
          duration: EventDuration(DurationType.fromTo,DateTime(2020,2,15),DateTime(2020,2,17))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.schoolDay,
          title: getString('calendar/last_day'),
          greeting: getString('calendar/last_day/spring_greeting'),
          duration: EventDuration(DurationType.singleDay,DateTime(2020,3,19))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.nonInstructional,
          title: getString('calendar/noninstructional'),
          greeting: getString('calendar/noninstructional/greeting'),
          duration: EventDuration(DurationType.singleDay,DateTime(2020,3,20))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.noSchool,
          title: getString('calendar/spring_break'),
          greeting: getString('calendar/spring_break/greeting'),
          duration: EventDuration(DurationType.fromTo,DateTime(2020,3,21),DateTime(2020,3,29))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.schoolDay,
          title: getString('calendar/resume_class'),
          greeting: getString('calendar/resume_class/greeting'),
          duration: EventDuration(DurationType.singleDay,DateTime(2020,3,30))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.schoolDay,
          title: getString('calendar/wtf_weekend'),
          greeting: getString('calendar/wtf_weekend/greeting'),
          duration: EventDuration(DurationType.singleDay,DateTime(2020,4,4))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.noSchool,
          title: getString('calendar/good_friday'),
          greeting: getString('calendar/good_friday/greeting'),
          duration: EventDuration(DurationType.fromTo,DateTime(2020,4,10),DateTime(2020,4,12))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.nonInstructional,
          title: getString('calendar/noninstructional'),
          greeting: getString('calendar/noninstructional/greeting'),
          duration: EventDuration(DurationType.singleDay,DateTime(2020,4,13))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.nonInstructional,
          title: getString('calendar/noninstructional'),
          greeting: getString('calendar/noninstructional/greeting'),
          duration: EventDuration(DurationType.singleDay,DateTime(2020,5,15))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.noSchool,
          title: getString('calendar/victoria_day'),
          greeting: getString('calendar/victoria_day/greeting'),
          duration: EventDuration(DurationType.fromTo,DateTime(2020,5,16),DateTime(2020,5,18))
      ),
      //TODO: Add more events after May 18, 2020.
      /*
      * Happens regularly. Just the weekdays and the weekends.
      * */
      SchoolDayInformation(
        schoolDayType: SchoolDayType.noSchool,
        title: "Weekend",
        greeting: "Enjoy the weekend!",
        duration: EventDuration(DurationType.weekly,[false,false,false,false,false,true,true])
      ),
      SchoolDayInformation(
        schoolDayType: SchoolDayType.schoolDay,
        title: "Regular Class",
        duration: EventDuration(DurationType.weekly,[true,true,true,true,true,false,false])
      )
    ]
);