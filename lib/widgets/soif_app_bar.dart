import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soif/states/theme_state.dart';
import 'package:soif/utils/sizes.dart';

class SoifAppBar extends StatelessWidget {
  final double elevation;
  final bool forceElevated;
  final double titleSpacing;
  final double expandedHeight;
  final Widget backgroundWidget;
  final Widget title;
  final EdgeInsetsGeometry backgroundWidgetPadding;
  final PreferredSizeWidget bottom;
  SoifAppBar(
      {@required this.backgroundWidget,
      this.elevation,
      this.forceElevated,
      this.title,
      this.bottom,
      this.titleSpacing,
      this.expandedHeight,
      this.backgroundWidgetPadding});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: this.elevation ?? 4.0,
      titleSpacing: this.titleSpacing ?? NavigationToolbar.kMiddleSpacing,
      primary: true,
      forceElevated: this.forceElevated ?? false,
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
      expandedHeight: this.expandedHeight ?? appHeight(context) * 0.45,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          alignment: Alignment.topCenter,
          padding: this.backgroundWidgetPadding ?? EdgeInsets.zero,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: this.backgroundWidget,
        ),
      ),
      bottom: this.bottom,
    );
  }
}
