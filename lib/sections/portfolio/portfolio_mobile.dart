import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:folio/configs/configs.dart';
import 'package:folio/constants.dart';
import 'package:folio/utils/project_utils.dart';
import 'package:folio/utils/utils.dart';
import 'package:folio/widget/custom_text_heading.dart';
import 'package:folio/widget/project_card.dart';

class PortfolioMobileTab extends StatelessWidget {
  const PortfolioMobileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomSectionHeading(
          text: "\nPortfolio",
        ),
        const CustomSectionSubHeading(
          text: "Apps I have designed, built and shipped :)\n\n",
        ),
        CarouselSlider.builder(
          itemCount: ProjectUtils.projects.length,
          itemBuilder: (BuildContext context, int itemIndex, int i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: ProjectCard(
              project: ProjectUtils.projects[itemIndex],
            ),
          ),
          options: CarouselOptions(
            height: AppDimensions.normalize(140),
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enableInfiniteScroll: false,
          ),
        ),
        Space.y!,
        SizedBox(
          height: AppDimensions.normalize(14),
          width: AppDimensions.normalize(50),
          child: OutlinedButton(
            onPressed: () => openURL(StaticUtils.gitHub),
            child: Text(
              'See More',
              style: AppText.l1b,
            ),
          ),
        )
      ],
    );
  }
}
