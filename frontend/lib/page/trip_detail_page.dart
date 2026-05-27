import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetailPage extends StatefulWidget {
  final String title;
  
  const TripDetailPage({super.key, this.title = 'Khám Phá Đà Nẵng - Hội An'});

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  late GoogleMapController mapController;
  int _selectedTab = 1; // Mặc định mở Tab Itinerary (Lịch trình) theo thiết kế
  final List<String> _tabs = ['Overview', 'Itinerary', 'Budget', 'Notes'];

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(16.047079, 108.206230),
    zoom: 12.0,
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // ==========================================
          // CỘT BÊN TRÁI: CHI TIẾT LỘ TRÌNH CHI TIẾT
          // ==========================================
          Expanded(
            flex: 6, // Chiếm không gian rộng hơn để hiện lịch trình rõ ràng
            child: Column(
              children: [
                // --- 1. THANH HEADER TRÊN CÙNG ---
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.arrow_back_ios_new, size: 14, color: Colors.grey.shade700),
                              const SizedBox(width: 8),
                              Text(
                                "My Trips",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      _buildHeaderAction(Icons.favorite_border, "Save"),
                      const SizedBox(width: 16),
                      _buildHeaderAction(Icons.share_outlined, "Share"),
                      const SizedBox(width: 16),
                      _buildHeaderAction(Icons.download_outlined, "Export"),
                      const SizedBox(width: 16),
                      Icon(Icons.more_horiz, color: Colors.grey.shade600),
                    ],
                  ),
                ),

                // --- 2. VÙNG NỘI DUNG CUỘN LỊCH TRÌNH ---
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ảnh banner hành trình chính
                        Image.network(
                          'https://images.unsplash.com/photo-1555921015-5532091f6026?q=80&w=1200&auto=format&fit=crop',
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        ),

                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tiêu đề chuyến đi
                              Text(
                                widget.title,
                                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                                  const SizedBox(width: 8),
                                  Text("16 Th 10 - 19 Th 10", style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "✨ AI-optimized route",
                                      style: TextStyle(fontSize: 12, color: Colors.blue.shade700, fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 28),

                              // Các thanh Tab lựa chọn điều hướng con
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                ),
                                child: Row(
                                  children: List.generate(_tabs.length, (index) {
                                    return _buildTabItem(index, _tabs[index]);
                                  }),
                                ),
                              ),
                              const SizedBox(height: 28),

                              // PHÂN TÁCH HIỂN THỊ NỘI DUNG THEO TAB
                              if (_selectedTab == 1) ...[
                                // Khung hiển thị chi tiết mốc thời gian Itinerary
                                _buildDaySection(
                                  dayNumber: "Day 1",
                                  dayTitle: "Khám phá trung tâm & Biển Mỹ Khê",
                                  nodes: [
                                    _buildTimelineNode(
                                      time: "08:30 AM",
                                      title: "Ăn sáng mì Quảng Ếch Bếp Trang",
                                      location: "24 Pasteur, Hải Châu, Đà Nẵng",
                                      description: "Thưởng thức món đặc sản mì Quảng trứ danh khởi đầu ngày mới tràn đầy năng lượng.",
                                      imageUrl: "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?q=80&w=200&auto=format&fit=crop",
                                      category: "Ẩm thực",
                                    ),
                                    _buildTimelineNode(
                                      time: "10:00 AM",
                                      title: "Check-in Nhà Thờ Con Gà (Chính Tòa)",
                                      location: "156 Trần Phú, Hải Châu, Đà Nẵng",
                                      description: "Tham quan công trình kiến trúc Gothic mang sắc hồng đặc trưng cổ kính thời Pháp thuộc.",
                                      imageUrl: "https://images.unsplash.com/photo-1545232979-8bf34eb9757b?q=80&w=200&auto=format&fit=crop",
                                      category: "Điểm tham quan",
                                    ),
                                    _buildTimelineNode(
                                      time: "03:30 PM",
                                      title: "Tắm biển và đón hoàng hôn tại Bãi biển Mỹ Khê",
                                      location: "Võ Nguyên Giáp, Sơn Trà, Đà Nẵng",
                                      description: "Thư giãn tại một trong những bãi biển quyến rũ nhất hành tinh với cát trắng mịn.",
                                      imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=200&auto=format&fit=crop",
                                      category: "Giải trí",
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildDaySection(
                                  dayNumber: "Day 2",
                                  dayTitle: "Chinh phục đỉnh Sơn Trà & Chùa Linh Ứng",
                                  nodes: [
                                    _buildTimelineNode(
                                      time: "09:00 AM",
                                      title: "Viếng thăm Chùa Linh Ứng Bán Đảo Sơn Trà",
                                      location: "Thọ Quang, Sơn Trà, Đà Nẵng",
                                      description: "Chiêm bái tượng Phật Bà Quan Âm cao nhất Việt Nam, ngắm trọn vẹn vịnh biển từ trên cao.",
                                      imageUrl: "https://images.unsplash.com/photo-1528127269322-539801943592?q=80&w=200&auto=format&fit=crop",
                                      category: "Tâm linh",
                                    ),
                                  ],
                                ),
                              ] else ...[
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 40),
                                    child: Text(
                                      "Nội dung của ${_tabs[_selectedTab]} đang được cập nhật.",
                                      style: TextStyle(color: Colors.grey.shade400),
                                    ),
                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Thanh phân cách giữa danh sách và bản đồ
          VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade200),

          // ==========================================
          // CỘT BÊN PHẢI: GOOGLE MAPS CỐ ĐỊNH
          // ==========================================
          Expanded(
            flex: 4, 
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialPosition,
              myLocationEnabled: false, 
              zoomControlsEnabled: true,
            ),
          ),
        ],
      ),
    );
  }

  // --- CÁC WIDGET THÀNH PHẦN CON ---

  Widget _buildHeaderAction(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade700),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        margin: const EdgeInsets.only(right: 32),
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isSelected ? Colors.blueAccent : Colors.transparent, width: 2.5)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.blueAccent : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  // Khung phân chia theo từng Ngày hành trình (Day Container)
  Widget _buildDaySection({required String dayNumber, required String dayTitle, required List<Widget> nodes}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                dayNumber,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                dayTitle,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Chèn tập hợp các node timeline con vào trong ngày
        Padding(
          padding: const EdgeInsets.only(left: 6.0), // Cân chỉnh trục đường nối dọc thẳng hàng
          child: Column(children: nodes),
        ),
      ],
    );
  }

  // Dòng lộ trình mốc điểm (Timeline Node Card) giống bản vẽ thiết kế
  Widget _buildTimelineNode({
    required String time,
    required String title,
    required String location,
    required String description,
    required String imageUrl,
    required String category,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trục thiết kế thanh timeline đứng dọc nối tiếp nhau
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),

          // Hiển thị mốc giờ
          Container(
            width: 75,
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueAccent),
            ),
          ),

          // Thẻ chứa thông tin chi tiết địa điểm bên cạnh mốc thời gian
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nội dung text mô tả
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 13, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location,
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Ảnh thu nhỏ minh họa địa danh check-in
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: 85,
                      height: 85,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 85,
                        height: 85,
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}