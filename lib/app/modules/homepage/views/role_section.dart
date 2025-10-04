
import 'package:flutter/material.dart';
import 'package:wisper/app/modules/homepage/widget/role_card.dart';

class RoleSection extends StatelessWidget {
  const RoleSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: 5,
        itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: RoleCard(),
        );
      }),
    );
  }
}