import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'; // Import thư viện lịch
import 'trip_detail_page.dart';

// --------------------------------------------------------
// MÔ HÌNH DỮ LIỆU CHUYẾN ĐI (DATA MODEL)
// --------------------------------------------------------
class Trip {
  final String imageUrl;
  final String title;
  final String dateRange;
  final String price;
  final String status;

  Trip({
    required this.imageUrl,
    required this.title,
    required this.dateRange,
    required this.price,
    required this.status,
  });
}

// --------------------------------------------------------
// DỮ LIỆU MẪU (SAMPLE DATA)
// --------------------------------------------------------
final List<Trip> sampleTrips = [
  Trip(
    imageUrl: 'https://images.unsplash.com/photo-1596395819057-e17f0951a808?q=80&w=300&auto=format&fit=crop',
    title: 'Mù Cang Chải 4 ngày 3 đêm',
    dateRange: '16 Th 10 - 19 Th 10',
    price: '2.500.000 VNĐ',
    status: 'SẮP KHỞI HÀNH', 
  ),
  Trip(
    imageUrl: 'https://images.unsplash.com/photo-1582236830560-63f5383a812b?q=80&w=300&auto=format&fit=crop',
    title: 'Hà Giang 5 ngày 4 đêm',
    dateRange: '23 Th 10 - 26 Th 10',
    price: '3.200.000 VNĐ',
    status: 'ĐÃ KẾT THÚC', 
  ),
  Trip(
    imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=300&auto=format&fit=crop',
    title: 'Khám Phá Paris 7 ngày 6 đêm',
    dateRange: '05 Th 11 - 12 Th 11',
    price: '45.000.000 VNĐ',
    status: 'SẮP KHỞI HÀNH',
  ),
];

// --------------------------------------------------------
// GIAO DIỆN CHÍNH TRANG MY TRIPS
// --------------------------------------------------------
class TripPage extends StatelessWidget {
  const TripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Trips',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false, 
                  builder: (context) => const TripCreationDialog(),
                );
              },
              icon: const Icon(Icons.add, size: 18, color: Colors.white),
              label: const Text('Create Trip', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: ListView.builder(
          itemCount: sampleTrips.length,
          itemBuilder: (context, index) {
            return TripItemCard(trip: sampleTrips[index]);
          },
        ),
      ),
    );
  }
}

// --------------------------------------------------------
// WIDGET POPUP - CREATION DIALOG (CÁC BƯỚC TẠO CHUYẾN ĐI)
// --------------------------------------------------------
class TripCreationDialog extends StatefulWidget {
  const TripCreationDialog({super.key});

  @override
  State<TripCreationDialog> createState() => _TripCreationDialogState();
}

class _TripCreationDialogState extends State<TripCreationDialog> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4; 

  String _destination = '';
  String _dates = ''; // Lưu chuỗi hiển thị ngày (VD: Oct 15 - Oct 20)
  String _companions = 'Solo';
  String _budget = 'Medium';
  
  String _selectedCurrency = 'VND'; 
  final List<String> _currencies = ['VND', 'USD', 'THB', 'IDR', 'MYR']; 
  final TextEditingController _customBudgetController = TextEditingController();

  final Map<String, String> _currencySymbols = {
    'VND': '₫',
    'USD': '\$',
    'THB': '฿',
    'IDR': 'Rp',
    'MYR': 'RM',
  };

  // Hàm chuyển đổi từ DateTime sang chuỗi tháng tiếng Anh
  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chuyến đi đến $_destination đã được tạo thành công!')),
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 500, 
        height: 650, // Nới rộng thêm một chút để lịch hiển thị thoải mái
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            // --- HEADER POPUP ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentPage > 0
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        onPressed: _prevPage,
                      )
                    : const SizedBox(width: 40), 
                
                Text(
                  "Step ${_currentPage + 1} of $_totalPages",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                
                IconButton(
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: () => Navigator.of(context).pop(), 
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- NỘI DUNG CHÍNH (PAGE VIEW TRƯỢT NGANG) ---
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), 
                children: [
                  _buildStepWhere(),
                  _buildStepWhen(),
                  _buildStepWho(),
                  _buildStepOverview(), 
                ],
              ),
            ),

            // --- NÚT TIẾP TỤC (NEXT / FINISH) ---
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                // Ràng buộc điều kiện Next
                onPressed: (_destination.isEmpty && _currentPage == 0) || (_dates.isEmpty && _currentPage == 1) 
                    ? null 
                    : _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  _currentPage == _totalPages - 1 ? 'Build Itinerary' : 'Next',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- BƯỚC 1: WHERE? ---
  Widget _buildStepWhere() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Where to?", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text("Where do you want to go?", style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 32),
        TextField(
          autofocus: true, 
          onChanged: (val) => setState(() => _destination = val),
          decoration: InputDecoration(
            hintText: "e.g. Da Nang, Paris, Tokyo...",
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 24),
        const Text("Popular Destinations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildPopularChip("Đà Nẵng"),
            _buildPopularChip("Hà Nội"),
            _buildPopularChip("Hồ Chí Minh"),
            _buildPopularChip("Sapa"),
          ],
        )
      ],
    );
  }

  Widget _buildPopularChip(String name) {
    return ActionChip(
      label: Text(name),
      onPressed: () => setState(() => _destination = name),
      backgroundColor: _destination == name ? Colors.blue.shade50 : Colors.grey.shade100,
      side: BorderSide(color: _destination == name ? Colors.blueAccent : Colors.transparent),
    );
  }

  // --- BƯỚC 2: WHEN? (INLINE CALENDAR) ---
  Widget _buildStepWhen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("When?", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text("Select your travel dates", style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 16),
        
        // Khung chứa Lịch Inline
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.range, // Chế độ quét dải ngày
                minDate: DateTime.now(), // Không cho chọn ngày quá khứ
                startRangeSelectionColor: Colors.blueAccent,
                endRangeSelectionColor: Colors.blueAccent,
                rangeSelectionColor: Colors.blueAccent.withOpacity(0.1),
                todayHighlightColor: Colors.blueAccent,
                monthViewSettings: const DateRangePickerMonthViewSettings(
                  firstDayOfWeek: 1, // Thứ 2 là đầu tuần
                ),
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  // Lắng nghe sự kiện người dùng quét chọn ngày
                  if (args.value is PickerDateRange) {
                    DateTime? startDate = args.value.startDate;
                    DateTime? endDate = args.value.endDate ?? startDate; // Nếu mới chấm 1 ngày thì start = end

                    setState(() {
                      if (startDate != null && endDate != null) {
                        _dates = '${_formatDate(startDate)} - ${_formatDate(endDate)}';
                      }
                    });
                  }
                },
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        // Dòng hiển thị tổng hợp ngày đã chọn
        Center(
          child: Text(
            _dates.isEmpty ? "Please select a date range" : "Selected Dates: $_dates",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _dates.isEmpty ? Colors.redAccent : Colors.blueAccent,
            ),
          ),
        ),
      ],
    );
  }

  // --- BƯỚC 3: WHO & BUDGET? ---
  Widget _buildStepWho() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Who's going?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSelectBox("Solo", Icons.person, _companions, (v) => setState(() => _companions = v)),
              _buildSelectBox("Couple", Icons.favorite, _companions, (v) => setState(() => _companions = v)),
              _buildSelectBox("Family", Icons.family_restroom, _companions, (v) => setState(() => _companions = v)),
              _buildSelectBox("Friends", Icons.groups, _companions, (v) => setState(() => _companions = v)),
            ],
          ),
          const SizedBox(height: 32),
          
          const Text("Budget", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSelectBox("Budget", Icons.attach_money, _budget, (v) {
                setState(() {
                  _budget = v;
                  _customBudgetController.clear();
                });
              }),
              _buildSelectBox("Medium", Icons.money, _budget, (v) {
                setState(() {
                  _budget = v;
                  _customBudgetController.clear();
                });
              }),
              _buildSelectBox("Luxury", Icons.diamond, _budget, (v) {
                setState(() {
                  _budget = v;
                  _customBudgetController.clear();
                });
              }),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("OR", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _customBudgetController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    NumericTextFormatter(),                 
                  ],
                  decoration: InputDecoration(
                    labelText: "Custom amount",
                    prefixText: '${_currencySymbols[_selectedCurrency]} ', 
                    prefixStyle: const TextStyle(
                      color: Colors.blueAccent, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (val) {
                    setState(() {
                      if (val.isNotEmpty) _budget = ''; 
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCurrency,
                    items: _currencies.map((curr) => DropdownMenuItem(value: curr, child: Text(curr))).toList(),
                    onChanged: (val) => setState(() => _selectedCurrency = val!),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectBox(String label, IconData icon, String groupValue, Function(String) onChanged) {
    bool isSelected = label == groupValue;
    return GestureDetector(
      onTap: () => onChanged(label),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
          border: Border.all(color: isSelected ? Colors.blueAccent : Colors.grey.shade200, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.blueAccent : Colors.grey.shade600),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.blueAccent : Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }

  // --- BƯỚC 4: OVERVIEW ---
  Widget _buildStepOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ready to explore?", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text("Review your preferences before we generate the trip.", style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: Column(
            children: [
              _buildSummaryRow(Icons.location_on, "Destination", _destination.isEmpty ? "Not set" : _destination),
              const Divider(height: 32),
              _buildSummaryRow(Icons.calendar_month, "Dates", _dates.isEmpty ? "Not set" : _dates),
              const Divider(height: 32),
              _buildSummaryRow(Icons.group, "Companions", _companions),
              const Divider(height: 32),
              _buildSummaryRow(
                Icons.account_balance_wallet, 
                "Budget", 
                _customBudgetController.text.isNotEmpty 
                    ? "${_currencySymbols[_selectedCurrency]} ${_customBudgetController.text}" 
                    : (_budget.isNotEmpty ? _budget : "Not set")
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600),
        const SizedBox(width: 16),
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// --------------------------------------------------------
// WIDGET CHI TIẾT THẺ CHUYẾN ĐI (TRIP ITEM CARD)
// --------------------------------------------------------
class TripItemCard extends StatelessWidget {
  final Trip trip;

  const TripItemCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                trip.imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_month_outlined, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(trip.dateRange, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.monetization_on_outlined, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(trip.price, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusTag(trip.status),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TripDetailPage(title: trip.title),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Chi tiết', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
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

  Widget _buildStatusTag(String status) {
    Color backgroundColor = status == 'SẮP KHỞI HÀNH' ? const Color(0xFFFFF3E0) : Colors.grey.shade100;
    Color textColor = status == 'SẮP KHỞI HÀNH' ? const Color(0xFFE65100) : Colors.grey.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10)),
      child: Text(
        status,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor, letterSpacing: 0.5),
      ),
    );
  }
}

// =========================================================
// WIDGET ĐỊNH DẠNG SỐ TIỀN (THÊM DẤU CHẤM HÀNG NGHÌN)
// =========================================================
class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) return newValue.copyWith(text: '');

    final chars = digitsOnly.split('').reversed.toList();
    String formatted = '';
    for (int i = 0; i < chars.length; i++) {
      if (i > 0 && i % 3 == 0) {
        formatted = '.$formatted'; 
      }
      formatted = '${chars[i]}$formatted';
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}