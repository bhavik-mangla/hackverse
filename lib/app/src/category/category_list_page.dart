import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../category.dart';
import '../../config/theme/app_colors.dart';
import 'components/staggered_category_card.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<Category> categories = [
    Category(
      Color(0xffFCE183),
      Color(0xffF68D7F),
      'Gadgets',
      'assets/images/gadgets.png',
    ),
    Category(
      Color(0xffF749A2),
      Color(0xffFF7375),
      'Clothes',
      'assets/images/gadgets.png',
    ),
    Category(
      Color(0xff00E9DA),
      Color(0xff5189EA),
      'Fashion',
      'assets/images/gadgets.png',
    ),
    Category(
      Color(0xffAF2D68),
      Color(0xff632376),
      'Home',
      'assets/images/gadgets.png',
    ),
    Category(
      Color(0xff36E892),
      Color(0xff33B2B9),
      'Beauty',
      'assets/images/gadgets.png',
    ),
    Category(
      Color(0xffF123C4),
      Color(0xff668CEA),
      'Appliances',
      'assets/images/gadgets.png',
    ),
  ];

  List<Category> searchResults = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchResults = categories;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.secondaryColor,
      child: Container(
        margin: const EdgeInsets.only(top: kToolbarHeight),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment(-1, 0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Category List',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: AppColors.primaryColor.withOpacity(0.25),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xff333333),
                    )),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    List<Category> tempList = [];
                    categories.forEach((category) {
                      if (category.category.toLowerCase().contains(value)) {
                        tempList.add(category);
                      }
                    });
                    setState(() {
                      searchResults.clear();
                      searchResults.addAll(tempList);
                    });
                    return;
                  } else {
                    setState(() {
                      searchResults.clear();
                      searchResults.addAll(categories);
                    });
                  }
                },
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (_, index) => Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: StaggeredCardCard(
                    begin: searchResults[index].begin,
                    end: searchResults[index].end,
                    categoryName: searchResults[index].category,
                    assetPath: searchResults[index].image,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
