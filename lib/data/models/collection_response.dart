import 'package:flutter/foundation.dart';
import 'products.dart';

@immutable
class CollectionResponse {
  // --- DATA ---
  final List<Product> products; // The list of products for the CURRENT page

  // --- PAGINATION METADATA ---
  final int
      totalCount; // Total number of items after filtering (e.g., 55 items)
  final int
      totalPages; // Total number of pages (e.g., 6 pages for 55 items at 10 per page)
  final int
      currentPage; // The 0-indexed page number that was successfully returned
  final int pageSize; // The number of items requested per page

  // --- STATUS METADATA (Optional but helpful for UI) ---
  final bool isEmpty; // Convenience property: true if products is empty
  final bool hasNextPage; // Convenience property: true if page < totalPages - 1
  final bool hasPreviousPage; // Convenience property: true if page > 0

  // Full Constructor
  CollectionResponse({
    required this.products,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  })  :
        // Initialize convenience properties based on required inputs
        isEmpty = products.isEmpty,
        hasNextPage = currentPage < totalPages - 1,
        hasPreviousPage = currentPage > 0;

  // Factory method to simplify creation and handle the calculation of totalPages
  factory CollectionResponse.fromData({
    required List<Product> pageData,
    required int totalFilteredCount,
    required int requestedPage,
    required int requestedPageSize,
  }) {
    // Calculate total pages safely (e.g., handles 0 total items)
    final totalPages = totalFilteredCount > 0
        ? (totalFilteredCount / requestedPageSize).ceil()
        : 1;

    return CollectionResponse(
      products: pageData,
      totalCount: totalFilteredCount,
      totalPages: totalPages,
      currentPage: requestedPage,
      pageSize: requestedPageSize,
    );
  }
}
