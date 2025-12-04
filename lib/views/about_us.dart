import 'package:flutter/material.dart';
import 'package:union_shop/views/widgets/common_widgets.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // About Us Content
            SizedBox(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Text(
                      'About Us',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 48),
                    Column(
                      children: [
                        Text(
                          'This is the About Us page.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          'We are committed to providing the best products and services to our customers.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          'Our mission is to create a seamless shopping experience for everyone.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            FooterWidget(),
          ],
        ),
      ),
    );
  }
}
