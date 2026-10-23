import 'package:flutter/material.dart';

class MenuColors {
  static const primary = Color(0xFF247C70);
}

class MenuDrawer extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<String> onMenuSelected;

  const MenuDrawer({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
    required this.onMenuSelected,
  });

  void _selectMenuItem(BuildContext context, String title) {
    Navigator.pop(context);
    onMenuSelected(
      '$title — ئەم بەشە لە قۆناغی داهاتوودا تەواو دەکرێت.',
    );
  }

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: MenuColors.primary),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      onTap: () => _selectMenuItem(context, title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
              decoration: const BoxDecoration(
                color: MenuColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'nawnas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ناوێکی جوان بۆ داهاتوویەکی جوان',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _menuItem(
                    context: context,
                    icon: Icons.child_friendly_rounded,
                    title: 'ڕاپرسی ناوی منداڵ',
                    subtitle: 'دەنگدان بۆ ناوەکان و خوێندنەوەی ئەنجام',
                  ),
                  _menuItem(
                    context: context,
                    icon: Icons.face_retouching_natural_rounded,
                    title: 'گونجاندی خوشک و برا',
                  ),
                  _menuItem(
                    context: context,
                    icon: Icons.bar_chart_rounded,
                    title: 'ناوە باوەکانی ساڵ',
                  ),
                  _menuItem(
                    context: context,
                    icon: Icons.edit_rounded,
                    title: 'پێشنیاری ناوی نوێ',
                  ),
                  _menuItem(
                    context: context,
                    icon: Icons.list_alt_rounded,
                    title: 'پێشنیارەکانم',
                  ),
                  _menuItem(
                    context: context,
                    icon: Icons.support_agent_rounded,
                    title: 'پەیوەندی کردن',
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode_outlined),
                    title: const Text('دۆخی تاریک'),
                    value: isDarkMode,
                    activeColor: MenuColors.primary,
                    onChanged: onDarkModeChanged,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline_rounded,
                      color: MenuColors.primary,
                    ),
                    title: const Text('دەربارە'),
                    onTap: () {
                      Navigator.pop(context);
                      showAboutDialog(
                        context: context,
                        applicationName: 'nawnas',
                        applicationVersion: '1.0.0',
                        children: const [
                          Text(
                            'یارمەتیدەرێک بۆ دۆزینەوەی ناوی گونجاو بۆ منداڵان.',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
