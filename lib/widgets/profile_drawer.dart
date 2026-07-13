import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/bank_provider.dart';
import 'svg_icons.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BankProvider>();

    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E), // Dark matching the theme
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: const NetworkImage(
                      'https://i.pravatar.cc/150?img=11',
                    ), // Mock avatar
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tayyab Sohail',
                    style: TextStyle(fontFamily: 'Arimo', 
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  Text(
                    'Profile Settings',
                    style: TextStyle(fontFamily: 'Arimo', 
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingCard(
                    SvgIcons.eStatement,
                    'E-Statement',
                    Colors.blue,
                  ),
                  _buildSettingCard(
                    SvgIcons.wallet,
                    'Credit Card',
                    Colors.blue,
                  ), // Reused wallet for cc icon in drawer
                  _buildSettingCard(SvgIcons.settings, 'Settings', Colors.blue),

                  const SizedBox(height: 24),
                  Text(
                    'Notification',
                    style: TextStyle(fontFamily: 'Arimo', 
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF252525),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.string(
                          SvgIcons.notification,
                          width: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.blue,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'App Notification',
                            style: TextStyle(fontFamily: 'Arimo', 
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        CupertinoSwitch(
                          value: provider.appNotificationEnabled,
                          activeTrackColor: const Color(0xFF0D7BFF),
                          onChanged: (val) => context
                              .read<BankProvider>()
                              .toggleAppNotification(val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'More',
                    style: TextStyle(fontFamily: 'Arimo', 
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingCard(SvgIcons.language, 'Language', Colors.blue),
                  _buildSettingCard(SvgIcons.country, 'Country', Colors.blue),

                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        // Logout logic or visual cue
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD6D6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Logout',
                              style: TextStyle(fontFamily: 'Arimo', 
                                color: const Color(0xFF900000),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SvgPicture.string(
                              SvgIcons.logout,
                              width: 20,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF900000),
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(String svgIcon, String title, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          SvgPicture.string(
            svgIcon,
            width: 24,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontSize: 16),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }
}
