import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hackverse/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../product_model.dart';
import '../../../../../sample2.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../product_detail/presentation/product_detail_page.dart';
import '../../../product_detail/presentation/shop_detail_page.dart';

class ShopProductCardWidget extends StatelessWidget {
  final Shop image;
  const ShopProductCardWidget({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    launchWhatsapp() async {
      var whatsapp = image.phone.toString();
      var cc = '+91'.toString();
      var androidUrl =
          "whatsapp://send?phone=$cc$whatsapp&text=Hey, I really liked your store products. I would like to buy some products from your store.";
      var iosUrl =
          "https://wa.me/$cc$whatsapp?text=${Uri.parse('Hey, I really liked your store products. I would like to buy some products from your store.')}";
      try {
        if (kIsWeb) {
          await launch(iosUrl);
        } else if (Platform.isAndroid) {
          await launch(androidUrl);
        } else if (Platform.isIOS) {
          await launch(iosUrl);
        }
      } on Exception {
        Fluttertoast.showToast(msg: "Whatsapp not installed");
      }
    }

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ShopDetailPage(image: image),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 120,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fashion Store',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              image.name,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              image.address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                      topRight: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.06),
                        blurRadius: 8,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * .3,
                      ),
                      SizedBox(
                        width: width * .35,
                        child: AppButton(
                          onPressed: () {
                            launchWhatsapp();
                          },
                          child: Text(
                            image.phone,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.solidStar,
                            color: Colors.yellow[700],
                            size: 16,
                          ),
                          Text(
                            '4.5',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow[700],
                            ),
                          ),
                          SizedBox(width: width * 0.05),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              left: -0,
              child: SizedBox(
                height: 140,
                width: 100,
                child: Hero(
                  tag: image,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/cash/img.png'),
                      image: NetworkImage(
                          "http://10.20.61.164" + image.image.substring(21) ??
                              ''),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/cash/img_1.png',
                            width: width != 0.0 ? width : null,
                            height: height != 0.0 ? height : null);
                      },
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
