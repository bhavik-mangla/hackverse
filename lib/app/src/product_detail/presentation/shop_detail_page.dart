import 'dart:math' as math;

import 'package:hackverse/app/config/theme/app_colors.dart';
import 'package:hackverse/app/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../product_model.dart';
import '../../../shared/utils/image_util.dart';
import '../../../shared/widgets/app_button.dart';
import 'components/circle_product_widget.dart';
import 'components/product_counter_widget.dart';
import 'components/product_info_section_component.dart';
import 'components/product_tile_section_component.dart';
import 'components/shop_info_section_component.dart';

class ShopDetailPage extends StatefulWidget {
  final Shop image;
  const ShopDetailPage({
    super.key,
    required this.image,
  });

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState(image);
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  final Shop image;

  _ShopDetailPageState(this.image);

  final DraggableScrollableController _scrollableController =
      DraggableScrollableController();
  final ValueNotifier<double> _circleRadius = ValueNotifier<double>(180);
  final ValueNotifier<double> _imageHeight = ValueNotifier<double>(250);
  final double _minSize = 0.44;
  final double _maxSize = 0.76;

  final ValueNotifier<bool> _buttonLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scrollableController.addListener(_updateCircleRadius);
  }

  @override
  void dispose() {
    _scrollableController.removeListener(_updateCircleRadius);
    super.dispose();
  }

  void _updateCircleRadius() {
    double size = _scrollableController.size.clamp(_minSize, _maxSize);
    double normalizedSize = (size - _minSize) / (_maxSize - _minSize);
    _circleRadius.value = 180 - (normalizedSize * 100);
    _imageHeight.value = 250 - (normalizedSize * 100);
  }

  @override
  Widget build(BuildContext context) {
    print("http://10.20.61.164" + image.image.substring(21));
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBarWidget(
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(42),
                  bottomRight: Radius.circular(42),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    child: SizedBox(
                      height: size.height * .5,
                      width: size.width,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 30,
                            left: 0,
                            right: 0,
                            child: ValueListenableBuilder(
                              valueListenable: _imageHeight,
                              builder: (context, value, _) {
                                return Container(
                                  height: value * 1.5,
                                  child: Hero(
                                    tag: image,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: FadeInImage(
                                        placeholder: const AssetImage(
                                            'assets/cash/img.png'),
                                        image: NetworkImage(
                                            "http://10.20.61.164" +
                                                    image.image.substring(21) ??
                                                ''),
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                              'assets/cash/img_1.png',
                                              width:
                                                  width != 0.0 ? width : null,
                                              height: height != 0.0
                                                  ? height
                                                  : null);
                                        },
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildDiscoverDrawer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _sliverList(int size, int sliverChildCount) {
    List<Widget> widgetList = [];
    widgetList.add(
      SliverPersistentHeader(
        pinned: true,
        delegate: _SliverAppBarDelegate(
          maxHeight: 120,
          minHeight: 120,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(42),
                topRight: Radius.circular(42),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    image.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  Text(
                    image.address,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryColor.withOpacity(.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    widgetList.add(
      SliverFixedExtentList(
        itemExtent: 350,
        delegate: SliverChildBuilderDelegate(
          childCount: sliverChildCount,
          (context, index) {
            return ShopInfoSectionComponent(
              image: image,
            );
          },
        ),
      ),
    );
    return widgetList;
  }

  Widget _buildDiscoverDrawer() {
    return DraggableScrollableSheet(
      maxChildSize: 0.76,
      minChildSize: 0.44,
      initialChildSize: 0.44,
      snap: true,
      controller: _scrollableController,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(42),
              topRight: Radius.circular(42),
              bottomLeft: Radius.circular(42),
              bottomRight: Radius.circular(42),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: _sliverList(10, 1),
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
