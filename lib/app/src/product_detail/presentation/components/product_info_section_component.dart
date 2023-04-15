import 'package:flutter/material.dart';

import 'line_product_info_widget.dart';

class ProductInfoSectionComponent extends StatelessWidget {
  const ProductInfoSectionComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 52),
      child: Column(
        children: const [
          LineProductInfoWidget(
            title: 'Shop Name',
            description: 'Shop Address',
          ),
          SizedBox(height: 14),
        ],
      ),
    );
  }
}
