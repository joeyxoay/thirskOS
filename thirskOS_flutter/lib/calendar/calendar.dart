import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thirskOS/strings/string_definer.dart';
import 'package:thirskOS/general_functions.dart';
import 'package:table_calendar/table_calendar.dart';
//import 'package:sprintf/sprintf.dart';

///The type of school day that affects whether students and staffs attend or not.
enum SchoolDayType{
  ///Both students and staffs attend school today
  schoolDay,
  ///No school for students, but staff needs to attend
  nonInstructional,
  ///No school for both students and staffs
  noSchool,
  ///For Thirsk days
  thirskDay,
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
///The name for each day of the week, starting from monday as 1 and sunday as 7
List<String> weekName = ["","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];

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

  ///Get a list of Dates that falls under the duration. For weekly events,
  List<DateTime> getListOfDates({DateTime startTime, DateTime endTime}){
    switch(type){
      case DurationType.singleDay:
        return [argument1 as DateTime];
      case DurationType.fromTo:
        List<DateTime> dates = new List();
        for(var i = argument1 as DateTime; !(argument2 as DateTime).isBefore(i); i = i.add(Duration(days: 1))){
          dates.add(i);
          print(i);
        }
        return dates;
      case DurationType.weekly:
        assert(startTime != null && endTime != null);
        continue defaultCase;
      defaultCase:
      default:
        break;
    }
    return [];
  }
  @override
  String toString() {
    // TODO: implement toString
    switch(type){
      case DurationType.singleDay:
        return "On " + argument1.toString();
      case DurationType.fromTo:
        return "From " + argument1.toString() + " To " + argument2.toString();
      case DurationType.weekly:
        String returnString = "";
        List tempList = (argument1 as List<bool>);
        for(var i = 0; i < tempList.length; i++){
          if(tempList[i]){
            if(returnString != ""){
              returnString += ",";
            }
            returnString += weekName[i + 1];
          }
        }
        return returnString == "" ? "Weekly(Unidentified)" : "Every " + returnString;
      default:
        return "Warning: Unidentified Duration Type";
    }
  }
}

///The information for school day for a period of time, such as whether it is a regular day, non-instructional, or a national holiday
class SchoolDayInformation{
  SchoolDayType schoolDayType;
  ///Name of this class such as "Victoria Day" or "Christmas Break"
  String title;
  ///The greeting that should be displayed for this event
  String greeting;
  ///The duration for this event.
  EventDuration duration;
  ///Is the this event ignored when displaying in a calendar
  bool ignoreInCalendar;

  SchoolDayInformation({@required this.schoolDayType,@required this.title,this.greeting,@required this.duration,this.ignoreInCalendar = false});
  bool isUnderDuration(DateTime currentDate){
    return duration.isUnderDuration(currentDate);
  }
  @override
  String toString() {
    // TODO: implement toString
    return title + " (" + duration.toString() + ")";
  }
}

///A calendar for a typical school year
class SchoolCalendar{
  ///The list of events for a school year
  List<SchoolDayInformation> eventLists;
  ///A map that maps the event ID found on [TableCalendar] and the referenced [SchoolDayInformation]
  //Map<String,SchoolDayInformation> _identifierEventMap;
  ///A private variable that tracks what id should be assigned to [_identifierEventMap]
  //int _identifierCount = 0;

  ///Get the private variable [_identifierEventMap]
  //Map get getIdentifierMap => _identifierEventMap;

  SchoolCalendar({this.eventLists}){
    //_identifierEventMap = new Map<String,SchoolDayInformation>();
  }
  ///Get what information does [currentDate] have. Select from the first-most event that falls under the duration.
  SchoolDayInformation getInfo(DateTime currentDate){
    for(var oneEvent in eventLists){
      if(oneEvent.isUnderDuration(currentDate))
        return oneEvent;
    }
    return null;
  }
  ///Get the holiday calendar used in [TableCalendar]. Note that the event id, rather than the actual event reference is passed. Might change later
  Map<DateTime,List> getHolidayCalendar(){
    Map<DateTime,List> returnVal = new Map<DateTime,List>();
    for(var oneEvent in eventLists){
      if(!oneEvent.ignoreInCalendar){
        for(var i in oneEvent.duration.getListOfDates()){
          if(!returnVal.containsKey(i)){
            returnVal[i] = [oneEvent];//["eventid_"+_identifierCount.toString()];
            //_identifierEventMap["eventid_"+_identifierCount.toString()] = oneEvent;
            //_identifierCount++;
          }
        }
      }
    }
    return returnVal;
  }

}
///The default calendar for the school. Is currently hard-coded but in the future we might do it server based.
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
      SchoolDayInformation(
          schoolDayType: SchoolDayType.schoolDay,
          title: getString('calendar/last_day'),
          greeting: getString('calendar/last_day/summer_greeting'),
          duration: EventDuration(DurationType.singleDay,DateTime(2020,6,29))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.nonInstructional,
          title: getString('calendar/noninstructional'),
          greeting: getString('calendar/noninstructional/greeting'),
          duration: EventDuration(DurationType.singleDay,DateTime(2020,6,30))
      ),
      SchoolDayInformation(
          schoolDayType: SchoolDayType.noSchool,
          title: getString('calendar/summer_break'),
          greeting: getString('calendar/summer_break/greeting'),
          //TODO:Update the end date for summer break as soon as next year's calendar is released.
          duration: EventDuration(DurationType.fromTo,DateTime(2020,7,1),DateTime(2020,8,30))
      ),

      /*
      * Happens regularly. Just the weekdays and the weekends.
      * */
      SchoolDayInformation(
        schoolDayType: SchoolDayType.noSchool,
        title: "Weekend",
        greeting: "Enjoy the weekend!",
        duration: EventDuration(DurationType.weekly,[false,false,false,false,false,true,true]),
        ignoreInCalendar: true,
      ),
      SchoolDayInformation(
        schoolDayType: SchoolDayType.schoolDay,
        title: "Regular Class",
        duration: EventDuration(DurationType.weekly,[true,true,true,true,true,false,false]),
        ignoreInCalendar: true,
      )
    ]
);
///A widget that displays information such as the date of today or which period it is now
class DateDisplay extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _DateDisplayState();
}
class _DateDisplayState extends State<DateDisplay>{

  @override
  Widget build(BuildContext context) {
    var currentDate = DateTime.now();
    var todaysInfo = schoolCalendar.getInfo(currentDate);
    var currentPeriod = "No Class";
    int timeOfDayToInt(int hour,int minute) => hour * 60 + minute;
    int datetimeToInt(DateTime time) => timeOfDayToInt(time.hour, time.minute);
    if(todaysInfo.schoolDayType == SchoolDayType.schoolDay){
      var periods = [[0,2,1,4,3],[0,1,2,3,4]];
      bool finished = false;
      void setCurrentPeriod(int hour, int minute, String text){
        if(!finished && datetimeToInt(currentDate) < timeOfDayToInt(hour,minute)) {
          currentPeriod = text + " " +
              (timeOfDayToInt(hour, minute) - datetimeToInt(currentDate))
                  .toString() + " minute(s).";
          finished = true;
        }
      }
      if(currentDate.weekday == 5){
        setCurrentPeriod(8,30,getString('calendar/schoolday/beginning_of_school'));
        setCurrentPeriod(9,30,getString('calendar/schoolday/period') + " " + periods[currentDate.weekday % 2][1].toString() + " " + getString('calendar/schoolday/ends_in'));
        setCurrentPeriod(10,15,getString('calendar/schoolday/connect') + " " + getString('calendar/schoolday/ends_in'));
        setCurrentPeriod(11,15,getString('calendar/schoolday/period') + " " + periods[currentDate.weekday % 2][2].toString() + " " + getString('calendar/schoolday/ends_in'));
        setCurrentPeriod(11,35,getString('calendar/schoolday/lunch') + " " + getString('calendar/schoolday/ends_in'));
        setCurrentPeriod(12,35,getString('calendar/schoolday/period') + " " + periods[currentDate.weekday % 2][3].toString() + " " + getString('calendar/schoolday/ends_in'));
        setCurrentPeriod(13,35,getString('calendar/schoolday/period') + " " + periods[currentDate.weekday % 2][4].toString() + " " + getString('calendar/schoolday/ends_in'));
      } else {
        setCurrentPeriod(8,30,getString('calendar/schoolday/beginning_of_school'));
        setCurrentPeriod(9,45,getString('calendar/schoolday/period') + " " + periods[currentDate.weekday % 2][1].toString() + " " + getString('calendar/schoolday/ends_in'));
        setCurrentPeriod(10,35,getString('calendar/schoolday/focus') + " " + getString('calendar/schoolday/ends_in'));
        setCurrentPeriod(11,50,getString('calendar/schoolday/period') + " " + periods[currentDate.weekday % 2][2].toString() + " " + getString('calendar/schoolday/ends_in'));
        setCurrentPeriod(12,30,getString('calendar/schoolday/lunch') + " " + getString('calendar/schoolday/ends_in'));
        setCurrentPeriod(13,45,getString('calendar/schoolday/period') + " " + periods[currentDate.weekday % 2][3].toString() + " " + getString('calendar/schoolday/ends_in'));
        setCurrentPeriod(15,0,getString('calendar/schoolday/period') + " " + periods[currentDate.weekday % 2][4].toString() + " " + getString('calendar/schoolday/ends_in'));
      }
      if(!finished)
        currentPeriod = getString('calendar/schoolday/end_of_school');
    }
    var schoolText = todaysInfo.greeting != null ? Text(todaysInfo.greeting) : null;
    return Column(
      children: <Widget>[
        Text(
          new DateFormat("| EEEE | MMM d | yyyy |").format(currentDate,),
          //TODO: Add a button here somewhere that leads to a calendar screen.
          style: new TextStyle(
              fontSize: 16,
              color: Colors.white,
              letterSpacing: 4,
              fontFamily: 'LEMONMILKLIGHT'
          ),
          textAlign: TextAlign.center,
        ),
        RawMaterialButton(
          child: Text(getString('calendar/view_detail'), style: TextStyle(color: Colors.white, fontSize: 18,),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(5),
          fillColor: Colors.black12,
          splashColor: Colors.white,

          onPressed: () {
            goToPage(context, DetailedCalendar());
          },
        ),
        Text(todaysInfo.title),
        schoolText,
        Text(currentPeriod),
      ]
      //Remove the null values from the list in this column for safety
        ..removeWhere((widget) => widget == null),
    );
  }
}

class DetailedCalendar extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _DetailedCalendar();
}

class _DetailedCalendar extends State<DetailedCalendar>{

  //DateTime _currentDate;
  CalendarController _calendarController;
  Map<DateTime,List> _holidays;
  //Map<String, SchoolDayInformation> _eventIdentifier;

  @override
  void initState() {
    super.initState();
    //_currentDate = DateTime.now();
    _calendarController = new CalendarController();
    _holidays = schoolCalendar.getHolidayCalendar();
    //_eventIdentifier = schoolCalendar.getIdentifierMap;
    print(_holidays);
  }

  @override
  void dispose() {
    //_animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }
  void _onDaySelected(DateTime date, List events){
    print('Selected ' + date.toString() + ': ');
    print(events);
    for(var i in events){
      print(i.runtimeType);
      print('Event: ' + i.toString());//_eventIdentifier[i].title);
    }
  }

  List<Widget> _getEventMarker(BuildContext context, DateTime date, List events, List holidays){
    Widget schoolDayMarker;
    Widget otherEventMarker;
    for(var i in events){
      if(i is SchoolDayInformation){
        Color dotColor;
        switch(i.schoolDayType){
          case SchoolDayType.nonInstructional:
            dotColor = Colors.lightBlueAccent;
            break;
          case SchoolDayType.noSchool:
            dotColor = Colors.red[300];
            break;
          case SchoolDayType.schoolDay:
            dotColor = Colors.grey;
            break;
          case SchoolDayType.thirskDay:
            dotColor = Colors.green[400];
            break;
          default:

        }
        if(dotColor != null) {
          schoolDayMarker = Container(
            width: 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 0.3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
            ),
          );
        }

      } else {
//        otherEventMarker = Container(
//          width: 8.0,
//          height: 8.0,
//          margin: const EdgeInsets.symmetric(horizontal: 0.3),
//          decoration: BoxDecoration(
//            shape: BoxShape.circle,
//            color: Colors.blueAccent[100],
//          ),
//          child: Icon(
//            Icons.add,
//          ),
//        );
      }
    }
    //print(schoolDayMarker);
    return [schoolDayMarker];
//    return [schoolDayMarker, otherEventMarker]
//      ..removeWhere((obj) => obj = null);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
        color: Colors.grey[800],
        child: Column(
          children: <Widget>[
            new Container(
              height: 30.0,

            ),

            new RawMaterialButton(
              child: Text(getString('misc/back'), style: TextStyle(color: Colors.white, fontSize: 18,),),
              shape: StadiumBorder(),
              highlightColor: Color(0x0083ff),
              padding: EdgeInsets.all(5),
              fillColor: Colors.black12,
              splashColor: Colors.white,

              onPressed: () {
                Navigator.pop(context);
              },
            ),

            new Container(
              height: 20.0,

            ),

            TableCalendar(
              calendarController: _calendarController,
              events: _holidays,
              onDaySelected: _onDaySelected,
              builders: CalendarBuilders(
                markersBuilder: _getEventMarker

              ),
            ),

          ],
        )
    );
  }
}