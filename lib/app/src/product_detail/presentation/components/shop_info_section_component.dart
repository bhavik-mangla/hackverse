import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../product_model.dart';
import '../../../../config/theme/app_colors.dart';
import '../product_detail_page.dart';
import 'line_product_info_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ShopInfoSectionComponent extends StatelessWidget {
  final Shop image;
  const ShopInfoSectionComponent({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AnimSearchBar(
              width: 400,
              textController: _searchController,
              onSuffixTap: () {},
              onSubmitted: (String) {},
            ),
            const SizedBox(height: 20),
            MasonryGridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0),
              itemCount: image.products.length,
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    ProductTiletrending(
                        image: image.products[index].image,
                        name: image.products[index].name,
                        price: image.products[index].price,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                  image: image.products[index]),
                            ),
                          );
                        }),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProductTiletrending extends StatelessWidget {
  const ProductTiletrending({
    required this.image,
    required this.name,
    required this.price,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final String image;
  final String name;
  final String price;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage(
                placeholder: const AssetImage('assets/cash/img.png'),
                image: NetworkImage(
                    "http://10.20.61.164" + image.substring(21) ?? ''),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/cash/img_1.png',
                      width: width != 0.0 ? width : null,
                      height: height != 0.0 ? height : null);
                },
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
