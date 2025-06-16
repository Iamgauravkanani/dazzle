import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/theme.dart';

class OffersTab extends StatelessWidget {
  const OffersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildOfferCard(
          title: 'Welcome Offer',
          description: 'Get 10% off on your first order',
          code: 'WELCOME10',
          validUntil: DateTime.now().add(const Duration(days: 30)),
          backgroundColor: AppTheme.primaryColor,
        ),
        SizedBox(height: 16.h),
        _buildOfferCard(
          title: 'Bulk Purchase',
          description: 'Buy 5 or more items and get 15% off',
          code: 'BULK15',
          validUntil: DateTime.now().add(const Duration(days: 15)),
          backgroundColor: AppTheme.accentColor,
        ),
        SizedBox(height: 16.h),
        _buildOfferCard(
          title: 'Seasonal Sale',
          description: 'Get 20% off on all summer collection',
          code: 'SUMMER20',
          validUntil: DateTime.now().add(const Duration(days: 7)),
          backgroundColor: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildOfferCard({
    required String title,
    required String description,
    required String code,
    required DateTime validUntil,
    required Color backgroundColor,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor,
              backgroundColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.secondaryColor.withOpacity(0.9),
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Use code: ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Valid until ${_formatDate(validUntil)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.secondaryColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 