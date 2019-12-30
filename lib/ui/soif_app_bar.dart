import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soif/states/theme_state.dart';
import 'package:soif/utils/sizes.dart';

class SoifAppBar extends StatelessWidget {
  final double titleSpacing;
  final double expandedHeight;
  final Widget backgroundWidget;
  final Widget title;
  final PreferredSizeWidget bottom;
  SoifAppBar(
      {@required this.backgroundWidget,
      this.title,
      this.bottom,
      this.titleSpacing,
      this.expandedHeight});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      titleSpacing: this.titleSpacing ?? NavigationToolbar.kMiddleSpacing,
      primary: true,
      forceElevated: false,
      pinned: true,
      floating: true,
      snap: true,
      title: this.title ??
          Image.asset(
            (Provider.of<ThemeState>(context).isDarkTheme)
                ? './assets/images/Soif_sk_dark.png'
                : './assets/images/Soif_sk.png',
            height: appWidth(context) * 0.08,
          ),
      expandedHeight: this.expandedHeight ?? appHeight(context) * 0.40,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          alignment: Alignment.topCenter,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: this.backgroundWidget,
        ),
      ),
      bottom: this.bottom,
    );
  }
}
