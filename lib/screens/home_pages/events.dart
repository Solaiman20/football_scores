import 'package:football_scores/api/events_api.dart';
import 'package:football_scores/api/leagues_api.dart';
import 'package:football_scores/helpers/constants.dart';
import 'package:football_scores/screens/details/events_details.dart';
import 'package:football_scores/widgets/trensations_widgets.dart';
import 'package:football_scores/widgets/widget_calendar.dart';
import 'package:football_scores/widgets/widgets_events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool _barDrop = true;
  var _selectedDate = DateTime.now();
  int _selectedPost = 1;

  int _selectedLeague = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mSize = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TODO: Bar League
          CardBarMain(
            isDropped: _barDrop,
            name: LeaguesApi.lLeaguesList[_selectedLeague].name,
            logo: LeaguesApi.lLeaguesList[_selectedLeague].logo,
            onTap: () {
              setState(() {
                _barDrop = !_barDrop;
              });
            },
          ),
          //TODO: Bar List Leagues
          AnimatedContainer(
            width: mSize.size.width,
            height: _barDrop ? 50.0 : 0.0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
            color: theme.primaryColorDark,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
              children: [
                ShakeListTransition(
                  duration: Duration(milliseconds: 900),
                  child: CardChipLeague(
                    label: 'All',
                    onTap: () {
                      //TODO: All Leagues
                      setState(() {
                        _barDrop = false;
                      });
                    },
                  ),
                ),
                for (int i = 0; i < LeaguesApi.lLeaguesList.length; i++)
                  ShakeTransition(
                    duration: Duration(milliseconds: (i + 5) * 300),
                    axis: Axis.horizontal,
                    child: CardChipLeague(
                      image: LeaguesApi.lLeaguesList[i].logo,
                      label: LeaguesApi.lLeaguesList[i].name,
                      onTap: () {
                        //TODO: selected League
                        setState(() {
                          _selectedLeague = i;
                          _barDrop = false;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          //TODO: Calendar

          ShakeTransition(
            duration: Duration(milliseconds: 900),
            axis: Axis.vertical,
            child: CardCalendarMain(
              selectedDate: _selectedDate,
              onChangeDate: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),
          ShakeTransition(
            duration: Duration(milliseconds: 1200),
            axis: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text('Day: ${kFormatDateDay(_selectedDate)}',
                  style: theme.textTheme.headline5),
            ),
          ),
          //TODO: List Events
          Flexible(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 0.0),
              children: [
                for (int i = 0; i < EventsApi.eListEvents.length; i++)
                  ShakeListTransition(
                    duration: Duration(milliseconds: (i + 3) * 200),
                    axis: Axis.vertical,
                    child: CardEventItemNew(
                      isSelected: i == _selectedPost,
                      dateMatch: EventsApi.eListEvents[i].dateMatch,
                      timeMatch: EventsApi.eListEvents[i].timeMatch,
                      nameHome: EventsApi.eListEvents[i].nameHome,
                      nameAway: EventsApi.eListEvents[i].nameAway,
                      logoHome: EventsApi.eListEvents[i].logoHome,
                      logoAway: EventsApi.eListEvents[i].logoAway,
                      scoreAway: EventsApi.eListEvents[i].scoreAway,
                      scoreHome: EventsApi.eListEvents[i].scoreHome,
                      onTap: () {
                        Get.to(
                          () => EventDetails(
                            id: i,
                            leagueId: _selectedLeague,
                          ),
                          transition: Transition.downToUp,
                        )!
                            .then((value) {
                          setState(() {
                            _selectedPost = i;
                          });
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
