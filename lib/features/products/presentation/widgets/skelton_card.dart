import 'package:flutter/material.dart';
import 'package:tech_nest/core/constants/assets.dart';

class SkeltonCard extends StatelessWidget {
  const SkeltonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(12),
                child: Image.asset(Assets.brokenImage, fit: BoxFit.fill),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("Product Name"), Text("price")],
                ),
                Icon(Icons.abc),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
