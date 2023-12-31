import 'package:football_scores/api/events_api.dart';
import 'package:football_scores/api/leagues_api.dart';

import 'package:football_scores/screens/details/events/chats.dart';
import 'package:football_scores/screens/details/events/commentary.dart';
import 'package:football_scores/screens/details/events/lineup.dart';
import 'package:football_scores/screens/details/events/stats.dart';
import 'package:football_scores/widgets/widgets_events.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventDetails extends StatefulWidget {
  final id;
  final int leagueId;

  EventDetails({
    required this.id,
    required this.leagueId,
  });

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  ScrollController _controller = ScrollController();
  PageController _pageController = PageController();

  int _indexTabEvent = 0;

  List<Widget> _listPagesEvents = [];

  _animateToPage(int page) {
    _pageController.animateToPage(page,
        duration: Duration(milliseconds: 300), curve: Curves.easeOutSine);
  }

  @override
  void initState() {
    _listPagesEvents = [
      ChatsPage(),
      MatchStatsPage(),
      LineUpPage(
        homeName: EventsApi.eListEvents[widget.id].nameHome,
        awayName: EventsApi.eListEvents[widget.id].nameAway,
      ),
      Commentary(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 250,
              title: CardBarEvent(
                name: LeaguesApi.lLeaguesList[widget.leagueId].name,
                logo: LeaguesApi.lLeaguesList[widget.leagueId].logo,
              ),
              pinned: true,
              backgroundColor: theme.primaryColorDark,
              automaticallyImplyLeading: false,
              flexibleSpace: BarEventDetails(
                id: widget.id,
              ),
              bottom: PreferredSize(
                preferredSize: Size(mSize.size.width, 40.0),
                child: CardTabsEvents(children: [
                  TabTileEvent(
                    isSelected: _indexTabEvent == 0,
                    label: "Chats",
                    icon: FontAwesomeIcons.solidComments,
                    onTap: () {
                      setState(() {
                        _animateToPage(0);
                        _indexTabEvent = 0;
                      });
                    },
                  ),
                  TabTileEvent(
                    isSelected: _indexTabEvent == 1,
                    label: "atch Stats",
                    icon: FontAwesomeIcons.chartPie,
                    onTap: () {
                      setState(() {
                        _animateToPage(1);
                        _indexTabEvent = 1;
                      });
                    },
                  ),
                  TabTileEvent(
                    isSelected: _indexTabEvent == 2,
                    label: "Lineup",
                    icon: FontAwesomeIcons.users,
                    onTap: () {
                      setState(() {
                        _animateToPage(2);
                        _indexTabEvent = 2;
                      });
                    },
                  ),
                  TabTileEvent(
                    isSelected: _indexTabEvent == 3,
                    label: "Commentary",
                    icon: FontAwesomeIcons.alignJustify,
                    onTap: () {
                      setState(() {
                        _animateToPage(3);
                        _indexTabEvent = 3;
                      });
                    },
                  ),
                ]),
              ),
            ),

            // SliverList(
            //     delegate: SliverChildListDelegate([
            //   Column(
            //     children: [
            //
            //     ],
            //   )
            // ])),
          ];
        },
        body: PageView(
          onPageChanged: (val) {
            setState(() {
              _indexTabEvent = val;
            });
          },
          controller: _pageController,
          children: _listPagesEvents,
        ),
      ),
    );
  }
}

class CardTabsEvents extends StatelessWidget {
  final children;

  CardTabsEvents({@required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.primaryColorDark.withOpacity(0.0),
            theme.primaryColorDark,
            theme.primaryColorDark,
          ],
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
