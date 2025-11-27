// lib/data/models/collection_request.dart
import 'package:flutter/foundation.dart';

@immutable
class CollectionRequest {
  
  final int page;
  final int pageSize;


  final String sortBy;      
  final bool isAscending;


  final String? filterTerm; // General search term (e.g., title or description)
  final String? category;   // Specific filter (e.g., 'Electronics', 'Clothing')
  final double? minPrice;   // Price range filter start
  final double? maxPrice;   // Price range filter end

  // Full Constructor
  const CollectionRequest({
    this.page = 0,
    this.pageSize = 10,
    this.sortBy = 'name', // Default sort field
    this.isAscending = true, // Default sort direction
    this.filterTerm,
    this.category,
    this.minPrice,
    this.maxPrice,
  });

  CollectionRequest copyWith({
    int? page,
    int? pageSize,
    String? sortBy,
    bool? isAscending,
    String? filterTerm,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) {
    return CollectionRequest(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      sortBy: sortBy ?? this.sortBy,
      isAscending: isAscending ?? this.isAscending,
      // Use null to clear the filter if the user provides null, 
      // otherwise use the existing value.
      filterTerm: filterTerm ?? this.filterTerm, 
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}