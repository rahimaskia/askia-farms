import 'package:flutter/material.dart';

class StickyTabbedSliverAppBar extends StatelessWidget {
  const StickyTabbedSliverAppBar(
      {Key? key,
      required this.tabLength,
      this.leading,
      this.title,
      this.actions,
      required this.flexibleSpaceBackground,
      required this.tabs,
      required this.tabBarViews})
      : super(key: key);
  final int tabLength;
  final IconButton? leading;
  final Widget? title;
  final Widget flexibleSpaceBackground;
  final List<Tab> tabs;
  final List<Widget> tabBarViews;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabLength,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  leading: leading,
                  title: title,
                  actions: actions,
                  expandedHeight: 250,
                  flexibleSpace:
                      FlexibleSpaceBar(background: flexibleSpaceBackground),
                  floating: true,
                  pinned: true,
                  snap: true,
                  bottom: TabBar(
                    tabs: tabs,
                    isScrollable: true,
                  ),
                ),
              ];
            },
            body: Container(
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: TabBarView(
                children: tabBarViews,
              ),
            ),
          ),
        ));
  }
}
