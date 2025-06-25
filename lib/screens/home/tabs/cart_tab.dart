import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazzle_app/controllers/cart_controller.dart';
import 'package:dazzle_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CartTab extends StatelessWidget {
  const CartTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the instance of CartController that was already put in memory.
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      // appBar: AppBar(title: const Text('My Cart'), centerTitle: true, backgroundColor: Colors.white, elevation: 1),
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (cartController.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 80.w, color: Colors.grey.shade400),
                SizedBox(height: 16.h),
                Text('Your cart is empty', style: TextStyle(fontSize: 18.sp, color: Colors.black87)),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Text(
                    'Looks like you haven\'t added anything to your cart yet.',
                    style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                itemCount: cartController.items.length,
                itemBuilder: (context, index) {
                  final item = cartController.items.values.elementAt(index);
                  return _buildCartItem(item, cartController);
                },
              ),
            ),
            _buildCheckoutSection(cartController),
          ],
        );
      }),
    );
  }

  Widget _buildCartItem(CartItem item, CartController controller) {
    final int moq = int.tryParse(item.product.MOQ ?? '') ?? 1;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: item.product.photo,
                width: 100.w,
                height: 100.h,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(color: Colors.grey.shade200),
                errorWidget: (context, url, error) => const Icon(Icons.image_not_supported),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.product.name,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '₹${item.product.price.toStringAsFixed(2)} / piece',
                    style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                  ),
                  SizedBox(height: 8.h),
                  // --- UPDATED: Quantity controls ---
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        onPressed: () => controller.decreaseQuantity(item.product.id),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text('${item.quantity}', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      ),
                      _buildQuantityButton(
                        icon: Icons.add,
                        onPressed: () => controller.increaseQuantity(item.product.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => controller.removeFromCart(item.product.id),
                ),
                SizedBox(height: 30.h),
                Text(
                  '₹${(item.product.price * item.quantity).toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, size: 20.w),
      ),
    );
  }

  Widget _buildCheckoutSection(CartController cartController) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, -3))],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount:', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500)),
              // --- UPDATED: Use totalAmount from controller inside Obx ---
              Obx(
                () => Text(
                  '₹${cartController.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.snackbar('Checkout', 'Proceeding to checkout...', snackPosition: SnackPosition.BOTTOM);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text('Proceed to Checkout', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            ),
          ),
        ],
      ),
    );
  }
}
