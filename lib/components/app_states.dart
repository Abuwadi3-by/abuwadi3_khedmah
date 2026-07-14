import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/text%20form.dart';

class AppStates {
  // Empty state ----------------------------------
  static Widget buildEmptyState(
    String message, {
    IconData icon = Icons.inbox_outlined,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 72, color: Colors.grey[300]),
          Gap(16),
          TextForm(
            text: message,
            size: 20,
            weight: FontWeight.w500,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  //  Error state --------------------------
  static Widget buildErrorState(
    String message, {
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 72, color: Colors.red[200]),
          Gap(16),
          TextForm(text: message, size: 20, color: Colors.grey[400]),
          Gap(20),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1976D2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text("إعادة المحاولة"),
          ),
        ],
      ),
    );
  }

  // Loading state -------------------------------------
  static Widget buildLoadingState() {
    return Center(child: CircularProgressIndicator(color: Color(0xFF1976D2)));
  }
}
