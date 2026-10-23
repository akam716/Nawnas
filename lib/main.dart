import 'package:flutter/material.dart';

import 'menu.dart';

void main() {
  runApp(const NawnasApp());
}

class AppColors {
  static const primary = Color(0xFF247C70);
  static const primaryDark = Color(0xFF185D55);
  static const background = Color(0xFFF8F5EF);
  static const surface = Colors.white;
  static const accent = Color(0xFFE88D9A);
  static const text = Color(0xFF263B38);
  static const secondaryText = Color(0xFF788783);
  static const softGreen = Color(0xFFE8F2EE);
}

class NawnasApp extends StatefulWidget {
  const NawnasApp({super.key});

  @override
  State<NawnasApp> createState() => _NawnasAppState();
}

class _NawnasAppState extends State<NawnasApp> {
  bool _isDarkMode = false;

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nawnas',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121A18),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
      ),
      home: HomePage(
        isDarkMode: _isDarkMode,
        onDarkModeChanged: _toggleDarkMode,
      ),
    );
  }
}

class BabyName {
  final String name;
  final String meaning;
  final String category;

  const BabyName({
    required this.name,
    required this.meaning,
    required this.category,
  });
}

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  String _searchText = '';
  String? _selectedLetter;

  final Set<String> _favoriteNames = {};
  final Map<String, List<String>> _commentsByName = {};

  final List<String> _letters = const [
    'ئ', 'ا', 'ب', 'پ', 'ت', 'ج', 'چ', 'ح', 'خ', 'د', 'ر', 'ڕ',
    'ز', 'ژ', 'س', 'ش', 'ع', 'غ', 'ف', 'ڤ', 'ق', 'ک', 'گ', 'ل',
    'ڵ', 'م', 'ن', 'ھ', 'ە', 'و', 'ۆ', 'ی', 'ێ',
  ];

  final List<List<BabyName>> _namesByCategory = const [
    [
      BabyName(name: 'هانا', meaning: 'خۆشی و بەختەوەری', category: 'کچ'),
      BabyName(name: 'ژین', meaning: 'ژیان و زیندوویی', category: 'کچ'),
      BabyName(name: 'روژین', meaning: 'ڕووناکی و خۆر', category: 'کچ'),
      BabyName(name: 'ئارین', meaning: 'پاک و ڕوون', category: 'کچ'),
      BabyName(name: 'باران', meaning: 'بارینی باران', category: 'کچ'),
    ],
    [
      BabyName(
        name: 'ئاراس',
        meaning: 'ناوی ڕووبارێکی ناسراو',
        category: 'کوڕ',
      ),
      BabyName(name: 'هێمن', meaning: 'ئارام و بێدەنگ', category: 'کوڕ'),
      BabyName(name: 'کاروان', meaning: 'گەشتیار و کاروان', category: 'کوڕ'),
      BabyName(name: 'ئاوات', meaning: 'هیوا و ئارەزوو', category: 'کوڕ'),
      BabyName(name: 'بەهروز', meaning: 'خاوەنی بەختی باش', category: 'کوڕ'),
    ],
    [
      BabyName(name: 'ڕۆژ', meaning: 'ڕووناکی و خۆر', category: 'هاوبەش'),
      BabyName(name: 'ئومێد', meaning: 'هیوا و چاوەڕوانی', category: 'هاوبەش'),
      BabyName(name: 'باران', meaning: 'بارینی باران', category: 'هاوبەش'),
      BabyName(name: 'ئاوات', meaning: 'هیوا و ئارەزوو', category: 'هاوبەش'),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging && mounted) {
      setState(() {
        _selectedLetter = null;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<BabyName> _getVisibleNames(int categoryIndex) {
    var names = _namesByCategory[categoryIndex];

    if (_selectedLetter != null) {
      names = names
          .where((item) => item.name.startsWith(_selectedLetter!))
          .toList();
    }

    if (_searchText.trim().isNotEmpty) {
      final query = _searchText.trim();
      names = names
          .where(
            (item) =>
                item.name.contains(query) || item.meaning.contains(query),
          )
          .toList();
    }

    return names;
  }

  void _toggleFavorite(String name) {
    setState(() {
      if (_favoriteNames.contains(name)) {
        _favoriteNames.remove(name);
      } else {
        _favoriteNames.add(name);
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _shareName(BabyName item) {
    _showMessage('ناو: ${item.name} — واتا: ${item.meaning}');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: MenuDrawer(
          isDarkMode: widget.isDarkMode,
          onDarkModeChanged: widget.onDarkModeChanged,
          onMenuSelected: _showMessage,
        ),
        appBar: _buildAppBar(),
        body: TabBarView(
          controller: _tabController,
          children: List.generate(3, _buildCategoryPage),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      titleSpacing: 0,
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'بگەڕێ بەدوای ناوێک...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() => _searchText = value);
              },
            )
          : const Text(
              'nawnas',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 23,
              ),
            ),
      actions: [
        IconButton(
          tooltip: 'ناوە دڵخوازەکان',
          onPressed: _showFavorites,
          icon: const Icon(Icons.favorite_rounded),
        ),
        IconButton(
          tooltip: _isSearching ? 'داخستن' : 'گەڕان',
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              _searchText = '';
              _searchController.clear();
            });
          },
          icon: Icon(_isSearching ? Icons.close : Icons.search_rounded),
        ),
        const SizedBox(width: 6),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(62),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.primaryDark.withOpacity(0.45),
            borderRadius: BorderRadius.circular(18),
          ),
          child: TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            labelColor: AppColors.primaryDark,
            unselectedLabelColor: Colors.white,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'کچ'),
              Tab(text: 'کوڕ'),
              Tab(text: 'هاوبەش'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPage(int categoryIndex) {
    final names = _getVisibleNames(categoryIndex);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 12, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedLetter == null
                            ? 'ناوەکان'
                            : 'ناوەکانی پیتی $_selectedLetter',
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_selectedLetter != null)
                      TextButton(
                        onPressed: () {
                          setState(() => _selectedLetter = null);
                        },
                        child: const Text('هەموو'),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: names.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
                        itemCount: names.length,
                        itemBuilder: (context, index) {
                          return _buildNameCard(names[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
        _buildAlphabetSelector(),
      ],
    );
  }

  Widget _buildAlphabetSelector() {
    return Container(
      width: 42,
      margin: const EdgeInsets.fromLTRB(0, 12, 8, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 6),
        itemCount: _letters.length,
        itemBuilder: (context, index) {
          final letter = _letters[index];
          final isSelected = _selectedLetter == letter;

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              setState(() {
                _selectedLetter = isSelected ? null : letter;
              });
            },
            child: Container(
              height: 30,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                letter,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primaryDark,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameCard(BabyName item) {
    final isFavorite = _favoriteNames.contains(item.name);
    final commentCount = _commentsByName[item.name]?.length ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.softGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'واتا: ${item.meaning}',
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 22),
            Row(
              children: [
                _actionButton(
                  icon: isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  label: 'لایک',
                  color:
                      isFavorite ? AppColors.accent : AppColors.secondaryText,
                  onTap: () => _toggleFavorite(item.name),
                ),
                const SizedBox(width: 18),
                _actionButton(
                  icon: Icons.mode_comment_outlined,
                  label: commentCount == 0 ? 'کۆمێنت' : '$commentCount کۆمێنت',
                  color: AppColors.secondaryText,
                  onTap: () => _showComments(item),
                ),
                const Spacer(),
                _actionButton(
                  icon: Icons.share_outlined,
                  label: 'هاوبەشکردن',
                  color: AppColors.primary,
                  onTap: () => _shareName(item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 42,
              color: AppColors.secondaryText,
            ),
            SizedBox(height: 10),
            Text(
              'هیچ ناوێک بەو پیتە نەدۆزرایەوە',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComments(BabyName item) {
    final commentController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final comments = _commentsByName[item.name] ?? [];

            return Padding(
              padding: EdgeInsets.fromLTRB(
                18,
                18,
                18,
                18 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'کۆمێنت بۆ ${item.name}',
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'هێشتا کۆمێنتێک نییە.',
                        style: TextStyle(color: AppColors.secondaryText),
                      ),
                    )
                  else
                    ...comments.map(
                      (comment) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.softGreen,
                          child: Icon(
                            Icons.person_outline,
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text(comment),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'کۆمێنتەکەت بنووسە...',
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: () {
                          final text = commentController.text.trim();
                          if (text.isEmpty) return;

                          setState(() {
                            _commentsByName
                                .putIfAbsent(item.name, () => [])
                                .add(text);
                          });

                          setSheetState(() {});
                          commentController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(Icons.send_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(commentController.dispose);
  }

  void _showFavorites() {
    final favorites = _namesByCategory
        .expand((category) => category)
        .where((item) => _favoriteNames.contains(item.name))
        .toList();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ناوە دڵخوازەکان',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                if (favorites.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('هێشتا هیچ ناوێکت لایک نەکردووە'),
                  )
                else
                  ...favorites.map(_buildNameCard),
              ],
            ),
          ),
        );
      },
    );
  }
}
