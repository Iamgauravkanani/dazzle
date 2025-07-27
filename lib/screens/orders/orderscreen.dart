import 'package:dazzle_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer'; // For logging

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Orders', style: GoogleFonts.poppins(fontSize: 20)),
          centerTitle: true,
          backgroundColor: AppTheme.primaryColor,
          elevation: 1,
        ),
        body: const Center(child: Text('Please sign in to view your orders')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders', style: GoogleFonts.poppins(fontSize: 20)),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('received_orders')
                .doc(user.uid)
                .collection('orders')
                .orderBy('createdAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            log('Error fetching orders: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final orderId = order['orderId'] as String? ?? 'Unknown';
              final items = order['items'] as List<dynamic>;
              final totalAmount = order['totalAmount'] as double? ?? 0.0;
              final status = order['status'] as String? ?? 'Unknown';
              final createdAt = (order['createdAt'] as Timestamp?)?.toDate().toString() ?? 'Unknown';

              return Card(
                margin: EdgeInsets.only(bottom: 16.h),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order ID: $orderId', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.h),
                      Text('Date: $createdAt', style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
                      SizedBox(height: 8.h),
                      Text(
                        'Status: $status',
                        style: TextStyle(fontSize: 14.sp, color: status == 'confirmed' ? Colors.green : Colors.orange),
                      ),
                      SizedBox(height: 12.h),
                      Text('Items:', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                      ...items.map((item) {
                        final itemName = item['name'] as String? ?? 'Unknown';
                        final quantity = item['quantity'] as int? ?? 0;
                        final price = item['price'] as double? ?? 0.0;
                        final photo = item['photo'] as String? ?? '';

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: CachedNetworkImage(
                                  imageUrl: photo,
                                  width: 60.w,
                                  height: 60.h,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => Container(color: Colors.grey.shade200),
                                  errorWidget: (context, url, error) => const Icon(Icons.image_not_supported),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      itemName,
                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Quantity: $quantity',
                                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                                    ),
                                    Text(
                                      'Price: ₹${price.toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 12.h),
                      Text(
                        'Total: ₹${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
