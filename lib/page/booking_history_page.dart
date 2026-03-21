import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart'; // ĐẢM BẢO ĐƯỜNG DẪN TRANG CHỦ CỦA ÔNG Ở ĐÂY LÀ ĐÚNG

class BookingHistoryPage extends StatefulWidget {
  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  List<Map<String, dynamic>> myTickets = [];
  bool isLoading = true;
  final NumberFormat formatter = NumberFormat("###,###");
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    setState(() => isLoading = true);

    if (currentUser != null) {
      try {
        var snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .collection('tickets')
            .get();

        List<Map<String, dynamic>> fetchedTickets = snapshot.docs.map((doc) => doc.data()).toList();


        fetchedTickets.sort((a, b) {
          int timeA = a['createdAt'] ?? 0;
          int timeB = b['createdAt'] ?? 0;
          return timeA.compareTo(timeB);
        });

        setState(() {
          // Đảo ngược lại để vé mới nhất (vừa đặt xong) luôn nằm trên cùng
          myTickets = fetchedTickets.reversed.toList();
          isLoading = false;
        });
      } catch (e) {
        print("Lỗi tải vé từ Firebase: $e");
        setState(() => isLoading = false);
      }
    } else {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> savedData = prefs.getStringList('my_tickets') ?? [];
      setState(() {
        myTickets = savedData.map((item) => json.decode(item) as Map<String, dynamic>).toList().reversed.toList();
        isLoading = false;
      });
    }
  }

  void _cancelTicket(int index) {
    String targetPnr = myTickets[index]['pnr'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận hủy vé"),
        content: Text("Bạn có chắc chắn muốn hủy chuyến bay mã $targetPnr không?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Không")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (currentUser != null) {
                await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).collection('tickets').doc(targetPnr).delete();
              } else {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                myTickets.removeAt(index);
                List<String> savedData = myTickets.reversed.map((item) => json.encode(item)).toList();
                await prefs.setStringList('my_tickets', savedData);
              }
              _loadTickets();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã hủy vé thành công!"), backgroundColor: Colors.green));
            },
            child: const Text("Có, Hủy vé", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int index) {
    String targetPnr = myTickets[index]['pnr'];
    TextEditingController nameCtrl = TextEditingController(text: myTickets[index]['contactName']);
    TextEditingController phoneCtrl = TextEditingController(text: myTickets[index]['contactPhone']);
    TextEditingController emailCtrl = TextEditingController(text: myTickets[index]['contactEmail']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sửa thông tin liên hệ"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Họ và tên")),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Số điện thoại")),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (currentUser != null) {
                await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).collection('tickets').doc(targetPnr).update({
                  'contactName': nameCtrl.text, 'contactPhone': phoneCtrl.text, 'contactEmail': emailCtrl.text,
                });
              } else {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                myTickets[index]['contactName'] = nameCtrl.text;
                myTickets[index]['contactPhone'] = phoneCtrl.text;
                myTickets[index]['contactEmail'] = emailCtrl.text;
                List<String> savedData = myTickets.reversed.map((item) => json.encode(item)).toList();
                await prefs.setStringList('my_tickets', savedData);
              }
              _loadTickets();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cập nhật thành công!"), backgroundColor: Colors.blue));
            },
            child: const Text("Lưu thay đổi", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // SỬA LỖI ĐEN MÀN HÌNH: Đẩy thẳng về HomePage và xóa các trang cũ
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) =>  HomePage()),
                    (route) => false,
              );
            },
          ),
          centerTitle: true,
          title: const Text("Lịch sử vé", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
          bottom: TabBar(
            labelColor: Colors.blue[700],
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.blue[700],
            tabs: const [
              Tab(child: Text("Lượt đi", style: TextStyle(fontWeight: FontWeight.bold))),
              Tab(child: Text("Khứ hồi", style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            _buildTicketList(isReturnTab: false), // TAB LƯỢT ĐI
            _buildTicketList(isReturnTab: true),  // TAB KHỨ HỒI
          ],
        ),
      ),
    );
  }

  Widget _buildTicketList({required bool isReturnTab}) {
    // Lọc vé khứ hồi cho Tab Khứ hồi
    List<Map<String, dynamic>> displayTickets = isReturnTab
        ? myTickets.where((t) => t['isRoundTrip'] == true).toList()
        : myTickets;

    if (displayTickets.isEmpty) {
      return Center(
          child: Text(
              isReturnTab ? "Chưa có chuyến bay khứ hồi nào." : "Bạn chưa đặt chuyến bay nào.",
              style: const TextStyle(color: Colors.grey, fontSize: 16)
          )
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFilterDropdown("Tất cả địa điểm"),
            _buildFilterDropdown("Tháng này", icon: Icons.calendar_today),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayTickets.length,
          itemBuilder: (context, index) {
            // Tìm index thực tế trong mảng gốc để hàm Xóa/Sửa hoạt động chuẩn
            int realIndex = myTickets.indexOf(displayTickets[index]);
            return _buildTicketCard(realIndex, displayTickets[index], isReturnTab);
          },
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(String text, {IconData icon = Icons.search}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.lightBlue[50], borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: Colors.blue[700], fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.blue[700]),
        ],
      ),
    );
  }

  Widget _buildTicketCard(int realIndex, Map<String, dynamic> ticket, bool isReturnTab) {
    // LOGIC ĐẢO NGƯỢC THÔNG TIN NẾU ĐANG Ở TAB KHỨ HỒI
    String depart = isReturnTab ? (ticket['destination'] ?? "") : (ticket['depart'] ?? "");
    String dest = isReturnTab ? (ticket['depart'] ?? "") : (ticket['destination'] ?? "");
    String date = isReturnTab ? (ticket['dateReturn'] ?? "") : (ticket['date'] ?? "");
    String timeDepart = isReturnTab ? (ticket['timeDepartReturn'] ?? "--:--") : (ticket['timeDepart'] ?? "--:--");
    String timeArrive = isReturnTab ? (ticket['timeArriveReturn'] ?? "--:--") : (ticket['timeArrive'] ?? "--:--");
    String flightNo = isReturnTab ? (ticket['flightNoReturn'] ?? "") : (ticket['flightNo'] ?? "");
    String company = isReturnTab ? (ticket['companyReturn'] ?? "Airlines") : (ticket['company'] ?? "Airlines");

    // Các thông tin chung
    String pnr = ticket['pnr'] ?? "";
    String contactName = ticket['contactName'] ?? "";
    int price = ticket['price'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$depart -> $dest", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                Row(
                  children: [
                    Icon(Icons.airplanemode_active, size: 20, color: Colors.blue[800]),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(flightNo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(company, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildDottedDivider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeLocationCol(timeDepart, date, depart),
                const Icon(Icons.arrow_right_alt, color: Colors.grey),
                _buildTimeLocationCol(timeArrive, date, dest),
              ],
            ),
          ),
          _buildDottedDivider(),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(5)),
                      child: const Text("Xử lý thành công", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Text("PNR: $pnr", style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 4),
                    const Text("Đã xác nhận", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    QrImageView(data: pnr, version: QrVersions.auto, size: 70.0),
                    const SizedBox(height: 8),
                    Text(contactName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const Text("Hành khách", style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          _buildDottedDivider(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (realIndex == 0)
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => _cancelTicket(realIndex),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text("Huỷ vé", style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => _showEditDialog(realIndex),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.blue[700]!),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Text("Sửa thông tin", style: TextStyle(color: Colors.blue[700], fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                else
                  const SizedBox(),
                Text(
                  "${formatter.format(price)} VND",
                  style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLocationCol(String time, String date, String loc) {
    return Column(
      children: [
        Text(time, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
        const SizedBox(height: 4),
        Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(loc, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildDottedDivider() {
    return Row(
      children: List.generate(
        150 ~/ 2,
            (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : Colors.blue[100],
            height: 1,
          ),
        ),
      ),
    );
  }
}