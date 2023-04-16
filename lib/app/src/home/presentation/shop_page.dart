import 'dart:ui';
import 'dart:convert';
import 'package:hackverse/app/src/category/category_list_page.dart';
import 'package:http/http.dart' as http;
import 'package:hackverse/app/config/theme/app_colors.dart';
import 'package:hackverse/app/shared/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../product_model.dart';
import '../../QRPage.dart';
import 'components/home_product_card_widget.dart';
import 'components/runing_drop_widget.dart';
import 'components/shop_product_card_widget.dart';
import 'home_page.dart';

import 'package:permission_handler/permission_handler.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late int _selectedIndex;
  late int _previousIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _previousIndex = 0;
    _controller = AnimationController(
      vsync: this,
      //milliseconds: 800
      duration: const Duration(milliseconds: 500),
    )..forward(from: 2.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> fetchCatalogue() async {
    final response =
        await http.get(Uri.parse('http://10.20.61.164:3000/catalogue'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch catalogue');
    }
  }

  void _onTap(int index) {
    _controller.forward(from: 2.0);
    setState(() {
      _selectedIndex = index;
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _previousIndex = index;
        });
      }
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CategoryListPage()),
      );
    }
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ShopPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: FutureBuilder<String>(
          future: fetchCatalogue(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Map<String, dynamic>> catalogues =
                  List<Map<String, dynamic>>.from(jsonDecode(snapshot.data!));
              List<Shop> allShops = [];

              for (var catalogue in catalogues) {
                {
                  allShops.add(Shop(
                      sid: catalogue['sid'],
                      name: catalogue['name'],
                      phone: catalogue['phone'],
                      address: catalogue['address'],
                      image: catalogue['image'],
                      products: List<Listing>.from(catalogue['products']
                          .map((x) => Listing.fromJson(x)))));
                }
              }
              Future<PermissionStatus> _getCameraPermission() async {
                var status = await Permission.camera.status;
                if (!status.isGranted) {
                  final result = await Permission.camera.request();
                  return result;
                } else {
                  return status;
                }
              }

              allShops.shuffle();
              return Column(
                children: [
                  SizedBox(
                    height: size.height * 0.14,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 32, right: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              PermissionStatus status =
                                  await _getCameraPermission();
                              if (status.isGranted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const QRPage()),
                                );
                              }
                            },
                            child: const FaIcon(Icons.qr_code_scanner,
                                color: AppColors.primaryColor),
                          ),
                          Text(
                            'Zoobi Menu',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const AvatarWidget()
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            color: Color(0xfff8f8f8),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: ListView.separated(
                            itemCount: allShops.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              Shop image = allShops[index];

                              return ShopProductCardWidget(
                                image: image,
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 20,
                                  offset: const Offset(0, -10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 2,
                                        child: RunningDropWidget(
                                          controller: _controller,
                                          selectedIndex: _selectedIndex,
                                          previousIndex: _previousIndex,
                                        ),
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              onTap: () => _onTap(0),
                                              child: const FaIcon(
                                                FontAwesomeIcons.house,
                                                color: AppColors.secondaryColor,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => Navigator.pushNamed(
                                                  context, 'category'),
                                              child: const FaIcon(
                                                FontAwesomeIcons
                                                    .magnifyingGlass,
                                                color: AppColors.secondaryColor,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => _onTap(1),
                                              child: const FaIcon(
                                                FontAwesomeIcons.shop,
                                                color: AppColors.secondaryColor,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => _onTap(2),
                                              child: const FaIcon(
                                                FontAwesomeIcons.cartShopping,
                                                color: AppColors.secondaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
