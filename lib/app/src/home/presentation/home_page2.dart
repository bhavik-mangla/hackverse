import 'dart:convert';
import 'dart:ui';

import 'package:hackverse/app/src/home/presentation/shop_page.dart';
import 'package:hackverse/sample2.dart';
import 'package:http/http.dart' as http;
import 'package:hackverse/app/config/theme/app_colors.dart';
import 'package:hackverse/app/shared/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';

import '../../../../product_model.dart';
import 'components/home_product_card_widget.dart';
import 'components/runing_drop_widget.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> with TickerProviderStateMixin {
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
    )..forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> fetchCatalogue() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/catalogue'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch catalogue');
    }
  }

  void _onTap(int index) {
    _controller.forward(from: 0.0);
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
    if (index == 1) {
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
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.14,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 32, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const FaIcon(FontAwesomeIcons.barsStaggered),
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
                    itemCount: productz.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      Listing image = productz[index]['listing'];

                      return HomeProductCardWidget(
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
                                        FontAwesomeIcons.magnifyingGlass,
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
      ),
    );
  }
}
