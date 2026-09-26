import 'package:flutter/material.dart';
import 'package:sn_properties/shared/models/property.dart';

abstract final class SampleProperties {
  static const featured = <Property>[
    Property(
      id: 'the-willow-residence',
      title: 'The Willow Residence',
      location: 'Whitefield, Bengaluru',
      price: '₹1.85 Cr',
      type: PropertyType.buy,
      category: PropertyCategory.residential,
      bedrooms: 3,
      area: '2,180 sq.ft',
      accentColor: Color(0xFF927A9F),
      description: 'A sunlit family home with a private balcony.',
      imageUrls: [
        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1200&q=80',
      ],
      isFeatured: true,
    ),
    Property(
      id: 'skyline-crest',
      title: 'Skyline Crest',
      location: 'Hitech City, Hyderabad',
      price: '₹78,000/mo',
      type: PropertyType.rent,
      category: PropertyCategory.residential,
      bedrooms: 2,
      area: '1,460 sq.ft',
      accentColor: Color(0xFF7A9D9D),
      description: 'A modern apartment close to Hyderabad business hubs.',
      imageUrls: [
        'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=1200&q=80',
      ],
      isFeatured: true,
    ),
  ];

  static const recentlyAdded = <Property>[
    Property(
      id: 'palm-grove-enclave',
      title: 'Palm Grove Enclave',
      location: 'Sarjapur Road, Bengaluru',
      price: '₹92 Lakh',
      type: PropertyType.buy,
      category: PropertyCategory.plots,
      bedrooms: 0,
      area: '1,200 sq.ft',
      accentColor: Color(0xFFB18D62),
      description: 'A quiet garden plot with convenient road access.',
      imageUrls: [
        'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1200&q=80',
      ],
    ),
    Property(
      id: 'the-atelier-offices',
      title: 'The Atelier Offices',
      location: 'Andheri East, Mumbai',
      price: '₹2.4 Lakh/mo',
      type: PropertyType.rent,
      category: PropertyCategory.commercial,
      bedrooms: 0,
      area: '2,750 sq.ft',
      accentColor: Color(0xFF7186A3),
      description: 'Flexible office space in a well-connected business district.',
      imageUrls: [
        'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=1200&q=80',
      ],
    ),
    Property(
      id: 'green-acres-estate',
      title: 'Green Acres Estate',
      location: 'Devanahalli, Bengaluru',
      price: '₹1.2 Cr',
      type: PropertyType.buy,
      category: PropertyCategory.agricultural,
      bedrooms: 0,
      area: '1.2 acres',
      accentColor: Color(0xFF7E9971),
      description: 'Open agricultural land surrounded by green fields.',
      imageUrls: [
        'https://images.unsplash.com/photo-1510798831971-661eb04b3739?auto=format&fit=crop&w=1200&q=80',
      ],
    ),
  ];

  static const all = <Property>[...featured, ...recentlyAdded];
}
