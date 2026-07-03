import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/mock_data.dart';
import '../models/family_member.dart';
import '../models/inventory_item.dart';
import '../services/local_store.dart';
import '../widgets/common/app_buttons.dart';
import '../widgets/common/primary_card.dart';

/// Family screen — household members, what they've claimed, and presence.
class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final List<FamilyMember> _members = List.of(MockData.familyMembers);
  List<InventoryItem> _inventory = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final inventory = await LocalStore.loadInventory();
    if (!mounted) return;
    setState(() => _inventory = inventory ?? List.of(MockData.inventoryItems));
  }

  int _claimedCount(FamilyMember member) {
    final target = member.name == MockData.currentUserName
        ? MockData.currentUserName
        : member.name;
    return _inventory.where((i) => i.claimedBy == target).length;
  }

  void _invite() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Invite link copied to clipboard')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Family', style: AppTheme.heading(22)),
                Text('${_members.length} members', style: AppTheme.body(13)),
              ],
            ),
            const SizedBox(height: 20),
            ..._members.map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _MemberCard(member: m, claimed: _claimedCount(m)),
              ),
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              label: 'Invite Member',
              icon: Icons.person_add_alt_1_rounded,
              onPressed: _invite,
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final FamilyMember member;
  final int claimed;

  const _MemberCard({required this.member, required this.claimed});

  @override
  Widget build(BuildContext context) {
    final online = member.isActive;
    return PrimaryCard(
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.primaryTint,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.person_rounded,
                    color: AppTheme.primary, size: 26),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: online ? AppTheme.accentGreen : AppTheme.textSecondary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.card, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.heading(15),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (member.isAdmin) _roleChip('Admin'),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  online ? 'Online' : 'Offline',
                  style: AppTheme.body(12,
                      color: online
                          ? AppTheme.accentGreen
                          : AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$claimed', style: AppTheme.number(18)),
              Text('claimed', style: AppTheme.body(11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roleChip(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.primaryTint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(role, style: AppTheme.label(10, color: AppTheme.woodText)),
    );
  }
}
