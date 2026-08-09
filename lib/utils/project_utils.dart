import 'package:flutter/material.dart';

/// Where a project card sends you when tapped.
enum ProjectLinkKind { playStore, github, none }

class Project {
  final String title;

  /// One-line hook shown under the title.
  final String tagline;

  /// Longer blurb shown in the body of the card.
  final String description;

  /// Square launcher icon. Null for projects with no published listing,
  /// in which case [iconData] is drawn instead.
  final String? icon;
  final IconData? iconData;

  final List<String> tech;
  final String? link;
  final ProjectLinkKind linkKind;

  /// Brand colour used for the icon halo and hover glow.
  final Color accent;

  const Project({
    required this.title,
    required this.tagline,
    required this.description,
    required this.tech,
    required this.accent,
    this.icon,
    this.iconData,
    this.link,
    this.linkKind = ProjectLinkKind.none,
  });

  String get linkLabel {
    switch (linkKind) {
      case ProjectLinkKind.playStore:
        return 'Play Store';
      case ProjectLinkKind.github:
        return 'Source';
      case ProjectLinkKind.none:
        return '';
    }
  }

  IconData get linkIcon {
    switch (linkKind) {
      case ProjectLinkKind.playStore:
        return Icons.shop_rounded;
      case ProjectLinkKind.github:
        return Icons.code_rounded;
      case ProjectLinkKind.none:
        return Icons.lock_outline_rounded;
    }
  }
}

class ProjectUtils {
  static const String _appIcons = 'assets/projects/apps';

  static const List<Project> projects = [
    Project(
      title: 'Airbest',
      tagline: 'Air & goods cargo booking',
      description:
          'Cargo app for Airbest customers, wired directly into the company\'s internal '
          'cargo management software. Handles booking, real-time shipment tracking and '
          'coupons, keeping app and back office in sync.',
      icon: '$_appIcons/airbest.png',
      tech: ['Flutter', 'GetX', 'Node.js', 'REST API'],
      link: 'https://play.google.com/store/apps/details?id=com.airbest.app',
      linkKind: ProjectLinkKind.playStore,
      accent: Color(0xff2E86DE),
    ),
    Project(
      title: 'RentDoor',
      tagline: 'Rental property management SaaS',
      description:
          'Separate owner and tenant apps covering rent collection, complaints, '
          'announcements, billing, KYC, agreements and move-in/out reports. Razorpay '
          'Routes splits each payment between the owner and the platform.',
      icon: '$_appIcons/rentdoor.png',
      tech: ['Flutter', 'GetX', 'Node.js', 'Razorpay'],
      link: 'https://play.google.com/store/apps/details?id=com.rentdoor.owner',
      linkKind: ProjectLinkKind.playStore,
      accent: Color(0xff4A69BD),
    ),
    Project(
      title: 'Zenvy',
      tagline: 'Doctor consultation platform',
      description:
          'Two-role system for patients and doctors with online consultation booking and '
          'clinic-side slot management, live video calls over ZegoCloud, Socket.IO chat '
          'and secure Razorpay payments.',
      icon: '$_appIcons/zenvy.png',
      tech: ['Flutter', 'GetX', 'ZegoCloud', 'Socket.IO', 'Razorpay'],
      link: 'https://play.google.com/store/apps/details?id=com.zenvy.app',
      linkKind: ProjectLinkKind.playStore,
      accent: Color(0xff00B894),
    ),
    Project(
      title: 'Smileji',
      tagline: 'Guided habits & video tutor',
      description:
          'Subscription app built around video-based daily tasks, with progress tracked '
          'through charts and history graphs. Razorpay for billing and GetX for reactive '
          'state throughout.',
      icon: '$_appIcons/smileji.png',
      tech: ['Flutter', 'GetX', 'Razorpay'],
      link: 'https://play.google.com/store/apps/details?id=com.app.smileji',
      linkKind: ProjectLinkKind.playStore,
      accent: Color(0xffE17055),
    ),
    Project(
      title: 'Shwe Nan Taw',
      tagline: 'Jewellery e-commerce',
      description:
          'Online jewellery store with product listings, cart, orders and secure '
          'checkout. Every standard commerce module built on a clean architecture with '
          'Provider driving state.',
      icon: '$_appIcons/shwenantaw.png',
      tech: ['Flutter', 'Provider', 'REST API'],
      link: 'https://play.google.com/store/apps/details?id=com.shwenantaw.app',
      linkKind: ProjectLinkKind.playStore,
      accent: Color(0xffD4A017),
    ),
    Project(
      title: 'Flyden Holidays',
      tagline: 'Holiday, hotel & flight booking',
      description:
          'Travel booking app integrating the TrippJack and TBO APIs for live hotel and '
          'flight availability, with dynamic booking workflows and visa assistance '
          'handled through GetX.',
      icon: '$_appIcons/flyden.png',
      tech: ['Flutter', 'GetX', 'REST API'],
      link: 'https://play.google.com/store/apps/details?id=com.app.flydn',
      linkKind: ProjectLinkKind.playStore,
      accent: Color(0xff0984E3),
    ),
    Project(
      title: 'Kathoram',
      tagline: 'Verified staff, secure calls',
      description:
          'Marketplace that connects users with verified staff and keeps both sides '
          'private by routing conversations through secure in-app voice calls.',
      icon: '$_appIcons/kathoram.png',
      tech: ['Flutter', 'REST API'],
      link:
          'https://play.google.com/store/apps/details?id=com.kathoram.user_app',
      linkKind: ProjectLinkKind.playStore,
      accent: Color(0xff6C5CE7),
    ),
    Project(
      title: 'Genex',
      tagline: 'Employee management',
      description:
          'Internal workforce app covering task assignment, attendance, clock-in/out, '
          'live location tracking and expense claims, backed by REST services.',
      iconData: Icons.badge_rounded,
      tech: ['Flutter', 'GetX', 'Node.js'],
      accent: Color(0xff00A8A8),
    ),
    Project(
      title: 'MEDICO',
      tagline: 'Doctor appointment booking',
      description:
          'Appointment platform with user registration, doctor profiles, slot scheduling '
          'and SMS notifications, running on Firebase with BLoC for real-time '
          'responsiveness.',
      icon: 'assets/projects/image-removebg-preview.png',
      tech: ['Flutter', 'Firebase', 'BLoC'],
      link: 'https://github.com/muhammed-shadil/doctor-booking-app',
      linkKind: ProjectLinkKind.github,
      accent: Color(0xff2BAE8C),
    ),
  ];
}
