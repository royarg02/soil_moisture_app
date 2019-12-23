/*
 * plant_grid_view
 * 
 * Displays the available plants in Grid in Overview and Analysis page.
 */

import 'package:flutter/material.dart';

// * State import
import 'package:soil_moisture_app/states/selected_card_state.dart';

// * ui import
import 'package:soil_moisture_app/ui/plant_card.dart';

// * data import
import 'package:soil_moisture_app/data/plant_class.dart';

// * utils import
import 'package:soil_moisture_app/utils/sizes.dart';

// * External packages import
import 'package:provider/provider.dart';

class PlantGridView extends StatelessWidget {
  final List<Plant> plantlist;
  PlantGridView({@required this.plantlist});
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
            );
          },
          childCount: this.plantlist.length,
        ),
      ),
    );
  }
}
