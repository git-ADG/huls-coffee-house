import 'package:flutter/material.dart';
import 'package:huls_coffee_house/config/config.dart';
import 'package:huls_coffee_house/pages/cart_ui/utils/colors.dart';
import 'package:huls_coffee_house/pages/cart_ui/utils/styles.dart';

class CartTotalCost extends StatelessWidget {
  const CartTotalCost({
    super.key,
    required this.totalFunc,
  });

  final Function totalFunc;

  @override
  Widget build(BuildContext context) {
    double totalCost = totalFunc();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Orange "Total" label
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'Total',
                    style: AppStyles.total,
                  ),
                ),
                // "Rs" label with amount
                Text(
                  'Rs $totalCost', // Display total cost here
                  style: AppStyles.totalcost,
                ),
              ],
            ),
          ),
        ),
        // SizedBox(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FloatingActionButton.extended(
            onPressed: () {
              // Action on pressing the checkout button
            },
            backgroundColor: orange,
            label: const Text(
              'CHECKOUT',
              style: AppStyles.checkouttext,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
