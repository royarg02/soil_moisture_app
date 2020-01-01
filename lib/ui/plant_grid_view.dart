/*
 * plant_grid_view
 * 
 * Displays the available plants in Grid in Overview and Analysis page.
 */

import 'package:flutter/material.dart';

// * State import
import 'package:soif/states/selected_card_state.dart';

// * ui import
import 'package:soif/ui/plant_card.dart';

// * data import
import 'package:soif/data/plant_class.dart';

// * utils import
import 'package:soif/utils/sizes.dart';

// * External packages import
import 'package:provider/provider.dart';

class PlantGridView extends StatelessWidget {
  final List<Plant> plantlist;
  final bool isEnabled;
  PlantGridView({@required this.plantlist, this.isEnabled});
  @override
  Widget build(BuildContext context) {
    SelectedCardState selectedCardObj = Provider.of<SelectedCardState>(context);
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
              isSelected: position == selectedCardObj.selCard,
              onTap: () => selectedCardObj.chooseCard(position),
              isEnabled: isEnabled ?? true,
            );
          },
          childCount: this.plantlist.length,
        ),
      ),
    );
  }
}
