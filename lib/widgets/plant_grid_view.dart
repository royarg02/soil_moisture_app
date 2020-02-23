/*
 * plant_grid_view
 * 
 * Displays the available plants in Grid in Overview and Analysis page.
 */

import 'package:flutter/material.dart';

// * External packages import
import 'package:provider/provider.dart';

// * data import
import 'package:soif/data/plant_class.dart';

// * State import
import 'package:soif/states/selected_card_state.dart';

// * utils import
import 'package:soif/utils/sizes.dart';

// * widgets import
import 'package:soif/widgets/plant_card.dart';

class PlantGridView extends StatelessWidget {
  final List<Plant> plantlist;
  final bool isEnabled;
  PlantGridView({@required this.plantlist, this.isEnabled});
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        appWidth(context) * 0.03,
        0.0,
        appWidth(context) * 0.03,
        appWidth(context) * 0.03,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              (appWidth(context) < 600 && isPortrait(context)) ? 3 : 5,
          crossAxisSpacing: appWidth(context) * 0.005,
          mainAxisSpacing: appWidth(context) * 0.005,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, position) {
            return PlantCard(
              plant: plantlist[position],
              isSelected:
                  position == Provider.of<SelectedCardState>(context).selCard,
              onTap: () =>
                  Provider.of<SelectedCardState>(context, listen: false)
                      .chooseCard(position),
              isEnabled: isEnabled ?? true,
            );
          },
          childCount: this.plantlist.length,
        ),
      ),
    );
  }
}
