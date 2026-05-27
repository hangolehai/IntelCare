import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Controller cho Google Map
  late GoogleMapController mapController;
  
  // Tọa độ mặc định (Hà Nội)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(21.028511, 105.804817),
    zoom: 13.0,
  );

  // Danh sách các chuyến đi (dữ liệu mẫu)
  final List<String> trips = ["Da Nang Trip #1", "Sapa Adventure #2"];

  // Hàm được gọi khi Map tải xong
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
          // PHẦN BÊN TRÁI: GIAO DIỆN CHAT AI
          // ==========================================
          Expanded(
            flex: 2, // Chiếm 2/3 màn hình
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  const Text(
                    "365 Travel Agent",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Lời chào và gợi ý
                  const Text(
                    "How can I help you today?",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildSuggestionCard(Icons.directions_rounded, "Suggest some itineraries"),
                      const SizedBox(width: 16),
                      _buildSuggestionCard(Icons.hotel_rounded, "Help me find hotel options"),
                      const SizedBox(width: 16),
                      _buildSuggestionCard(Icons.restaurant_rounded, "Recommend food and drinks"),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Khu vực hiển thị tin nhắn (Lịch sử Chat)
                  Expanded(
                    child: ListView(
                      children: const [
                        // Chỗ này sau này bạn sẽ map() dữ liệu chat thật vào
                        Center(
                          child: Text(
                            "Conversation will appear here...",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Khu vực thanh Chat và Các chuyến đi
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Trips:",
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      // Danh sách tag chuyến đi
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: trips.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            return _buildTripTag(trips[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Thanh Chat Input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.attach_file, color: Colors.grey),
                              onPressed: () {}, // Xử lý đính kèm file
                            ),
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Type something...",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              decoration: const BoxDecoration(
                                color: Colors.blueAccent,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                                onPressed: () {}, // Xử lý gửi tin nhắn
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ==========================================
          // PHẦN BÊN PHẢI: GOOGLE MAP (FLUTTER WEB)
          // ==========================================
          Expanded(
            flex: 1, // Chiếm 1/3 màn hình
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialPosition,
              
              // QUAN TRỌNG: Phải để false để tránh lỗi Null trên môi trường Web
              myLocationEnabled: false, 
              
              zoomControlsEnabled: true,
              markers: {
                const Marker(
                  markerId: MarkerId('hanoi_center'),
                  position: LatLng(21.028511, 105.804817),
                  infoWindow: InfoWindow(title: 'Hanoi', snippet: 'Capital of Vietnam'),
                )
              },
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  // CÁC WIDGET PHỤ TRỢ (NÚT GỢI Ý & TAG CHUYẾN ĐI)
  // --------------------------------------------------------

  // Card Gợi ý (Suggestions)
  Widget _buildSuggestionCard(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tag Chuyến đi (Trip Tag)
  Widget _buildTripTag(String tripName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tripName,
            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black54),
        ],
      ),
    );
  }
}