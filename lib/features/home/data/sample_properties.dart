import 'package:flutter/material.dart';
import 'package:sn_properties/shared/models/property.dart';

abstract final class SampleProperties {
  static const featured = <Property>[
    Property(
      title: 'The Willow Residence',
      location: 'Whitefield, Bengaluru',
      price: '₹1.85 Cr',
      type: PropertyType.buy,
      category: PropertyCategory.residential,
      bedrooms: 3,
      area: '2,180 sq.ft',
      accentColor: Color(0xFF927A9F),
      isFeatured: true,
    ),
    Property(
      title: 'Skyline Crest',
      location: 'Hitech City, Hyderabad',
      price: '₹78,000/mo',
      type: PropertyType.rent,
      category: PropertyCategory.residential,
      bedrooms: 2,
      area: '1,460 sq.ft',
      accentColor: Color(0xFF7A9D9D),
      isFeatured: true,
    ),
  ];

  static const recentlyAdded = <Property>[
    Property(
      title: 'Palm Grove Enclave',
      location: 'Sarjapur Road, Bengaluru',
      price: '₹92 Lakh',
      type: PropertyType.buy,
      category: PropertyCategory.plots,
      bedrooms: 0,
      area: '1,200 sq.ft',
      accentColor: Color(0xFFB18D62),
    ),
    Property(
      title: 'The Atelier Offices',
      location: 'Andheri East, Mumbai',
      price: '₹2.4 Lakh/mo',
      type: PropertyType.rent,
      category: PropertyCategory.commercial,
      bedrooms: 0,
      area: '2,750 sq.ft',
      accentColor: Color(0xFF7186A3),
    ),
    Property(
      title: 'Green Acres Estate',
      location: 'Devanahalli, Bengaluru',
      price: '₹1.2 Cr',
      type: PropertyType.buy,
      category: PropertyCategory.agricultural,
      bedrooms: 0,
      area: '1.2 acres',
      accentColor: Color(0xFF7E9971),
    ),
  ];
}
