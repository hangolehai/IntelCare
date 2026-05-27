import 'package:flutter/material.dart';

// --------------------------------------------------------
// MÔ HÌNH DỮ LIỆU CÁC MỤC ĐÃ LƯU (DATA MODEL)
// --------------------------------------------------------
class SavedItem {
  final String imageUrl;
  final String title;
  final String location;
  final String category; // Để phân loại tab: 'Trips', 'Inspiration', 'Chats'
  bool isSaved; // Trạng thái thả tim

  SavedItem({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.category,
    this.isSaved = true,
  });
}

// --------------------------------------------------------
// DỮ LIỆU MẪU (SAMPLE DATA) GIỐNG TRONG ẢNH
// --------------------------------------------------------
final List<SavedItem> sampleSavedItems = [
  SavedItem(
    imageUrl: 'https://images.unsplash.com/photo-1596395819057-e17f0951a808?q=80&w=400&auto=format&fit=crop',
    title: 'Thác Bản Giốc',
    location: 'Cao Bằng, Việt Nam',
    category: 'Inspiration',
  ),
  SavedItem(
    imageUrl: 'https://images.unsplash.com/photo-1582236830560-63f5383a812b?q=80&w=400&auto=format&fit=crop',
    title: 'Hẻm Tu Sản',
    location: 'Hà Giang, Việt Nam',
    category: 'Trips',
  ),
  SavedItem(
    imageUrl: 'https://images.unsplash.com/photo-1555921015-5532091f6026?q=80&w=400&auto=format&fit=crop',
    title: 'Vịnh Hạ Long',
    location: 'Quảng Ninh, Việt Nam',
    category: 'Inspiration',
  ),
  SavedItem(
    imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=400&auto=format&fit=crop',
    title: 'Tháp Eiffel Trip',
    location: 'Paris, France',
    category: 'Trips',
  ),
  SavedItem(
    imageUrl: 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?q=80&w=400&auto=format&fit=crop',
    title: 'Tokyo Street Food',
    location: 'Tokyo, Japan',
    category: 'Inspiration',
  ),
  SavedItem(
    imageUrl: 'https://images.unsplash.com/photo-1600861194942-f884de60f66b?q=80&w=400&auto=format&fit=crop',
    title: 'Đà Nẵng Itinerary',
    location: 'Lịch trình Chat AI',
    category: 'Chats',
  ),
];

// --------------------------------------------------------
// GIAO DIỆN CHÍNH TRANG SAVED ITEMS
// --------------------------------------------------------
class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  // Danh sách các Tab lọc
  final List<String> _tabs = ['All', 'Trips', 'Inspiration', 'Chats'];
  
  // Tab mặc định đang chọn là "All" (Index 0)
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách item dựa trên Tab đang chọn
    List<SavedItem> filteredItems = _selectedIndex == 0
        ? sampleSavedItems
        : sampleSavedItems.where((item) => item.category == _tabs[_selectedIndex]).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER & FILTER TABS ---
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saved Items',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                
                // Hàng chứa các nút Tab (All, Trips, Inspiration...)
                Wrap(
                  spacing: 12, // Khoảng cách ngang giữa các nút
                  runSpacing: 12, // Khoảng cách dọc nếu bị rớt dòng
                  children: List.generate(_tabs.length, (index) {
                    return _buildFilterTab(index, _tabs[index]);
                  }),
                ),
              ],
            ),
          ),

          // --- NỘI DUNG LƯỚI (GRID VIEW) ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        "No items saved in this category yet.",
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      // Sử dụng MaxCrossAxisExtent để Grid tự động chia cột theo kích thước màn hình
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 320, // Kích thước tối đa của 1 thẻ
                        childAspectRatio: 0.85,  // Tỷ lệ khung hình (Rộng / Cao)
                        crossAxisSpacing: 24,    // Khoảng cách ngang giữa các cột
                        mainAxisSpacing: 24,     // Khoảng cách dọc giữa các hàng
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return SavedItemCard(item: filteredItems[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget tạo ra các nút Tab (Filter Pill)
  Widget _buildFilterTab(int index, String title) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------------
// WIDGET THẺ CHI TIẾT (SAVED ITEM CARD)
// --------------------------------------------------------
class SavedItemCard extends StatefulWidget {
  final SavedItem item;

  const SavedItemCard({super.key, required this.item});

  @override
  State<SavedItemCard> createState() => _SavedItemCardState();
}

class _SavedItemCardState extends State<SavedItemCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // Hiệu ứng dịch chuyển nhẹ lên trên khi hover chuột (rất hợp cho Web)
        transform: Matrix4.translationValues(0, _isHovered ? -5 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.04),
              blurRadius: _isHovered ? 15 : 8,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- PHẦN 1: HÌNH ẢNH & ICON TIM ---
            Expanded(
              child: Stack(
                children: [
                  // Hình ảnh Full width
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      widget.item.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(child: Icon(Icons.image, color: Colors.grey)),
                      ),
                    ),
                  ),
                  
                  // Icon Tim (Nút Favorite) ở góc trên bên phải
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.item.isSaved = !widget.item.isSaved; // Toggle tim
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: Icon(
                          widget.item.isSaved ? Icons.favorite : Icons.favorite_border,
                          color: widget.item.isSaved ? Colors.redAccent : Colors.grey.shade400,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- PHẦN 2: THÔNG TIN TEXT ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề (Thác Bản Giốc)
                  Text(
                    widget.item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  
                  // Vị trí / Phân loại (Cao Bằng, Việt Nam)
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.item.location,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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