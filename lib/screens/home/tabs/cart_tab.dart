import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../controllers/cart_controller.dart';
import '../../../controllers/order_controller.dart';
import '../../../models/product_model.dart';
import '../../../utils/theme.dart';

class CartTab extends StatelessWidget {
  const CartTab({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    final OrderController orderController = Get.put(OrderController());

    return Obx(() {
      if (cartController.items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 64.w,
                color: AppTheme.borderGray,
              ),
              SizedBox(height: 16.h),
              Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Add items to your cart to proceed with checkout',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: cartController.items.length,
              itemBuilder: (context, index) {
                final item = cartController.items.values.elementAt(index);
                return _buildCartItem(item, cartController);
              },
            ),
          ),
          _buildCheckoutSection(cartController, orderController),
        ],
      );
    });
  }

  Widget _buildCartItem(CartItem item, CartController controller) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: item.product.imageUrls.first,
                width: 100.w,
                height: 100.w,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppTheme.borderGray,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppTheme.borderGray,
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '₹${item.product.pricePerPiece.toStringAsFixed(2)} per piece',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (item.quantity > 1) {
                            controller.updateQuantity(
                              item.product.id,
                              item.quantity - 1,
                            );
                          }
                        },
                      ),
                      Text(
                        '${item.quantity}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          controller.updateQuantity(
                            item.product.id,
                            item.quantity + 1,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: AppTheme.dangerColor,
                  onPressed: () {
                    controller.removeFromCart(item.product.id);
                    Get.snackbar(
                      'Success',
                      'Product removed from cart',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
                Text(
                  '₹${(item.product.pricePerPiece * item.quantity).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(CartController cartController, OrderController orderController) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '₹${cartController.total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement checkout process
                Get.snackbar(
                  'Coming Soon',
                  'Checkout functionality will be available soon!',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: const Text('Proceed to Checkout'),
            ),
          ),
        ],
      ),
    );
  }
} 