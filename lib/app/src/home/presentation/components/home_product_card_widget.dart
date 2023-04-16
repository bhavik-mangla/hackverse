import 'package:hackverse/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../product_model.dart';
import '../../../../../sample2.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../product_detail/presentation/product_detail_page.dart';

class HomeProductCardWidget extends StatelessWidget {
  final Listing image;
  const HomeProductCardWidget({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(image: image),
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
                              image.name,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              image.description,
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
                      const SizedBox(
                        width: 120,
                      ),
                      SizedBox(
                        width: 86,
                        child: AppButton(
                          onPressed: () {},
                          child: Text(
                            "₹" + image.price,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
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
                          const SizedBox(width: 4),
                          Text(
                            '4.5',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: width * 0.05),
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
                      fit: BoxFit.scaleDown,
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
