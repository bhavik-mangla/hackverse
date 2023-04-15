import 'package:flutter/material.dart';

import 'tile_product_info_widget.dart';

class ProductTileSectionComponent extends StatelessWidget {
  const ProductTileSectionComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        TileProductInfoWidget(
          title: 'Brand Name',
          description: 'Brand Address',
          color: Color(0xff7378ff),
        ),
        TileProductInfoWidget(
          title: 'CAN',
          description: '130 OZ',
          color: Color(0xffff9b9b),
        ),
        TileProductInfoWidget(
          title: 'COLOR',
          description: 'HAZY GOLD',
          color: Color(0xffffe55e),
        ),
      ],
    );
  }
}
