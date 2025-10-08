import 'package:flutter/material.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/modules/homepage/widget/post_card.dart';

class BoostScreen extends StatefulWidget {
  const BoostScreen({super.key});

  @override
  State<BoostScreen> createState() => _BoostScreenState();
}

class _BoostScreenState extends State<BoostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            heightBox40,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
                Text(
                  'Advertisement',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 32,
                  width: 66,
                  child: CustomElevatedButton(
                    title: 'Next',
                    textSize: 12,
                    borderRadius: 50,
                    onPress: () {},
                  ), 
                ),
              ],
            ),
            heightBox12,
            PostCard(trailing: Container()),
            heightBox20,
            CustomTextField(
              hintText: 'Select your package',
              items: [
                DropdownMenuItem(
                  value: '3 Days 10 USD',
                  child: Text('3 Days 10 USD'),
                ),
                DropdownMenuItem(
                  value: '7 Days 50 USD',
                  child: Text('7 Days 50 USD'),
                ),
                DropdownMenuItem(
                  value: '10 Days 100 USD',
                  child: Text('10 Days 100 USD'),
                ),
                DropdownMenuItem(
                  value: '15 Days 200 USD',
                  child: Text('15 Days 200 USD'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
