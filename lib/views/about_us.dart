import 'package:flutter/material.dart';
import 'package:union_shop/views/widgets/appbar.dart';
import 'package:union_shop/views/widgets/drawer.dart';


class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      home: const AboutUsScreen(),
      // By default, the app starts at the '/' route, which is the HomeScreen
      initialRoute: '/about_us',
    );
  }
}
  class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // About Us Content
            const SizedBox(
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
                          'Here you can provide information about your company, mission, values, and team.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          'Feel free to customize this section to best represent your brand and connect with your audience.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[50],
              padding: const EdgeInsets.all(24),
              child: const Text(
                'Contact Email: info@example.com / Phone: 123-456-7890 \n'
                '© 2024 Union Shop. All rights reserved. \n'
                'Privacy Policy | Terms of Service',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
