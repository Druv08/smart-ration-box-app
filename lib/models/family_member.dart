/// Represents a family member who uses the app
class FamilyMember {
  final String id;
  final String name;
  final String role; // Admin, Member, Guest
  final String email;
  final String? profileImage;
  final DateTime joinedDate;
  final bool isActive;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    this.profileImage,
    required this.joinedDate,
    this.isActive = true,
  });

  bool get isAdmin => role.toLowerCase() == 'admin';
}
