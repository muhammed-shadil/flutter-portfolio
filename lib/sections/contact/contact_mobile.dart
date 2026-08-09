import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:folio/configs/app_dimensions.dart';
import 'package:folio/utils/contact_utils.dart';
import 'package:folio/widget/contact_card.dart';
import 'package:folio/widget/custom_text_heading.dart';

class ContactMobileTab extends StatelessWidget {
  const ContactMobileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomSectionHeading(
          text: "\nGet in Touch",
        ),
        const CustomSectionSubHeading(
          text: "Let's build something together :)\n\n",
        ),
        CarouselSlider.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int itemIndex, int i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ContactCard(
              icon: ContactUtils.contactIcon[i],
              title: ContactUtils.titles[i],
              detail: ContactUtils.details[i],
              link: ContactUtils.link[i],
            ),
          ),
          options: CarouselOptions(
            height: AppDimensions.normalize(90),
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enableInfiniteScroll: false,
          ),
        ),
      ],
    );
  }
}
