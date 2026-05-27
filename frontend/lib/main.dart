import 'package:flutter/material.dart';
import 'page/chat_page.dart';
import 'page/trip_page.dart';
import 'page/saved_page.dart';
import 'page/inspiration_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Travel System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  
  // Trạng thái mở rộng của sidebar
  bool _isExpanded = true; 

  final List<Widget> _pages = [
    const ChatPage(),
    const TripPage(),
    const SavedPage(),
    const InspirationPage(),
  ];

  // Hàm xử lý khi người dùng chọn tab điều hướng
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
      // Nếu bấm vào trang Chat -> tự động EXPAND (Mở rộng) Sidebar để hiện danh sách Conversation
      if (index == 0) {
        _isExpanded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildCustomSidebar(),
          VerticalDivider(
            thickness: 1, 
            width: 1, 
            color: Colors.grey.shade200,
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: _isExpanded ? 240 : 80, 
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Column(
        crossAxisAlignment: _isExpanded ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          // 1. Phần Avatar & Tên User
          Row(
            mainAxisAlignment: _isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://ui-avatars.com/api/?name=User&background=0D8ABC&color=fff',
                  ),
                ),
              ),
              if (_isExpanded)
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Traveler',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),

          // 2. Nút Tạo mới (Dấu +)
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: _isExpanded ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: Colors.black54),
                  if (_isExpanded)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'New Plan',
                          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 3. Các nút Menu chính
          HoverableSidebarItem(
            icon: Icons.chat_bubble_outline,
            selectedIcon: Icons.chat_bubble,
            label: 'Chat',
            isSelected: _selectedIndex == 0,
            isExpanded: _isExpanded,
            onTap: () => _onTabSelected(0),
          ),
          
          // ========================================================
          // KHU VỰC SUB-MENU (CONVERSATION) CHỈ HIỆN KHI CHỌN CHAT VÀ ĐANG EXPAND
          // ========================================================
          if (_isExpanded && _selectedIndex == 0) ...[
            const SizedBox(height: 4),
            _buildChatSubMenu(),
            const SizedBox(height: 8),
          ] else ...[
            const SizedBox(height: 16),
          ],

          HoverableSidebarItem(
            icon: Icons.map_outlined,
            selectedIcon: Icons.map,
            label: 'Trips',
            isSelected: _selectedIndex == 1,
            isExpanded: _isExpanded,
            onTap: () => _onTabSelected(1),
          ),
          const SizedBox(height: 16),
          HoverableSidebarItem(
            icon: Icons.bookmark_border,
            selectedIcon: Icons.bookmark,
            label: 'Saved',
            isSelected: _selectedIndex == 2,
            isExpanded: _isExpanded,
            onTap: () => _onTabSelected(2),
          ),
          const SizedBox(height: 16),
          HoverableSidebarItem(
            icon: Icons.grid_view,
            selectedIcon: Icons.grid_view_rounded,
            label: 'Inspiration',
            isSelected: _selectedIndex == 3,
            isExpanded: _isExpanded,
            onTap: () => _onTabSelected(3),
          ),

          const Spacer(),

          // 4. Nút Collapse (Thu gọn/Mở rộng) hiển thị ở mọi trang
          HoverableSidebarItem(
            icon: _isExpanded ? Icons.keyboard_double_arrow_left : Icons.keyboard_double_arrow_right,
            selectedIcon: _isExpanded ? Icons.keyboard_double_arrow_left : Icons.keyboard_double_arrow_right,
            label: 'Collapse',
            isSelected: false,
            isExpanded: _isExpanded,
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          const SizedBox(height: 16),

          // 5. Nút Settings
          HoverableSidebarItem(
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
            label: 'Settings',
            isSelected: false,
            isExpanded: _isExpanded,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // Widget vẽ Sub-menu thụt lề cho phần Chat
  Widget _buildChatSubMenu() {
    return Padding(
      // Thụt lề vào trong so với mép trái
      padding: const EdgeInsets.only(left: 28.0, top: 4.0, bottom: 4.0),
      child: Container(
        // Kẻ một đường viền xám mờ bên trái tạo cảm giác sơ đồ cây (Tree root)
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.grey.shade300, width: 2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HoverableSubItem(
              label: 'Conversation 1',
              isActive: true, // Giả sử dòng đầu tiên đang được chọn
              onTap: () {},
            ),
            const SizedBox(height: 4),
            HoverableSubItem(
              label: 'Conversation 2',
              isActive: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// WIDGET XỬ LÝ HIỆU ỨNG HOVER MENU CHÍNH
// =========================================================
class HoverableSidebarItem extends StatefulWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  const HoverableSidebarItem({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<HoverableSidebarItem> createState() => _HoverableSidebarItemState();
}

class _HoverableSidebarItemState extends State<HoverableSidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected 
                ? Colors.blue.withOpacity(0.1) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: widget.isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: _isHovered || widget.isSelected ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: Icon(
                  _isHovered || widget.isSelected ? widget.selectedIcon : widget.icon,
                  color: widget.isSelected 
                      ? Colors.blue 
                      : (_isHovered ? Colors.black87 : Colors.grey.shade600),
                  size: 24,
                ),
              ),
              if (widget.isExpanded)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: widget.isSelected 
                            ? Colors.blue 
                            : (_isHovered ? Colors.black87 : Colors.grey.shade700),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// WIDGET XỬ LÝ HIỆU ỨNG HOVER CHO SUB-MENU (CONVERSATION 1, 2)
// =========================================================
class HoverableSubItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const HoverableSubItem({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<HoverableSubItem> createState() => _HoverableSubItemState();
}

class _HoverableSubItemState extends State<HoverableSubItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 12.0), // Cách viền xám 12px
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: widget.isActive 
                ? Colors.grey.shade200 
                : (_isHovered ? Colors.grey.shade100 : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
              color: widget.isActive 
                  ? Colors.black87 
                  : (_isHovered ? Colors.black87 : Colors.grey.shade600),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}