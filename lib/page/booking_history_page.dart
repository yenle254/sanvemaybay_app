import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class BookingHistoryPage extends StatefulWidget {
  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  List<Map<String, dynamic>> myTickets = [];
  bool isLoading = true;
  final NumberFormat formatter = NumberFormat("###,###");

  @override
  void initState() {
    super.initState();
    _loadOfflineTickets();
  }

  // Đọc dữ liệu từ bộ nhớ máy
  Future<void> _loadOfflineTickets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedData = prefs.getStringList('my_tickets') ?? [];

    setState(() {
      // Decode dữ liệu và ĐẢO NGƯỢC mảng để vé mới mua lên đầu tiên (index = 0)
      myTickets = savedData.map((item) => json.decode(item) as Map<String, dynamic>).toList().reversed.toList();
      isLoading = false;
    });
  }

  // Cập nhật lại bộ nhớ sau khi Sửa hoặc Hủy
  Future<void> _updateOfflineData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Đảo ngược mảng lại về như cũ (cũ trước, mới sau) để lưu vào máy
    List<String> savedData = myTickets.reversed.map((item) => json.encode(item)).toList();
    await prefs.setStringList('my_tickets', savedData);
    setState(() {}); // Cập nhật lại giao diện
  }

  // Hàm Hủy vé
  void _cancelTicket(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Xác nhận hủy vé"),
        content: Text("Bạn có chắc chắn muốn hủy chuyến bay mã ${myTickets[index]['pnr']} không?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Không", style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              myTickets.removeAt(index);
              _updateOfflineData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã hủy vé thành công!"), backgroundColor: Colors.green));
            },
            child: Text("Có, Hủy vé", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Hàm Sửa thông tin liên hệ
  void _editTicket(int index) {
    TextEditingController nameCtrl = TextEditingController(text: myTickets[index]['contactName']);
    TextEditingController phoneCtrl = TextEditingController(text: myTickets[index]['contactPhone']);
    TextEditingController emailCtrl = TextEditingController(text: myTickets[index]['contactEmail']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sửa thông tin liên hệ"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: "Họ và tên")),
              TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: "Số điện thoại")),
              TextField(controller: emailCtrl, decoration: InputDecoration(labelText: "Email")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Hủy")),
          TextButton(
            onPressed: () {
              myTickets[index]['contactName'] = nameCtrl.text;
              myTickets[index]['contactPhone'] = phoneCtrl.text;
              myTickets[index]['contactEmail'] = emailCtrl.text;
              _updateOfflineData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cập nhật thành công!"), backgroundColor: Colors.blue));
            },
            child: Text("Lưu thay đổi", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vé của tôi", style: TextStyle(fontFamily: "Roboto Medium")),
        backgroundColor: Colors.blue[800],
      ),
      backgroundColor: Colors.grey[200],
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : myTickets.isEmpty
          ? Center(child: Text("Bạn chưa có chuyến bay nào.", style: TextStyle(color: Colors.grey, fontSize: 16)))
          : ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: myTickets.length,
        itemBuilder: (context, index) {
          var ticket = myTickets[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mã đặt chỗ: ${ticket['pnr']}",
                        style: TextStyle(color: Colors.red[700], fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: index == 0 ? Colors.green : Colors.grey, borderRadius: BorderRadius.circular(4)),
                        child: Text(index == 0 ? "Mới nhất" : "Đã hoàn thành", style: TextStyle(color: Colors.white, fontSize: 12)),
                      )
                    ],
                  ),
                  Divider(height: 24, thickness: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${ticket['depart']} ➔ ${ticket['destination']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text("Ngày đi: ${ticket['date']}", style: TextStyle(color: Colors.grey[700])),
                            Text("Chuyến bay: ${ticket['flightNo']} (${ticket['company']})", style: TextStyle(color: Colors.grey[700])),
                            SizedBox(height: 4),
                            Text("Hành khách: ${ticket['contactName']}", style: TextStyle(color: Colors.grey[700], fontStyle: FontStyle.italic)),
                            Text("SĐT: ${ticket['contactPhone']}", style: TextStyle(color: Colors.grey[700], fontStyle: FontStyle.italic)),
                            SizedBox(height: 8),
                            Text("Tổng tiền: ${formatter.format(ticket['price'])} VNĐ", style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                      QrImageView(data: ticket['pnr'], version: QrVersions.auto, size: 90.0),
                    ],
                  ),
                  // Chỉ hiển thị nút Sửa/Hủy cho vé mới nhất (index == 0)
                  if (index == 0) ...[
                    Divider(height: 24, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          onPressed: () => _editTicket(index),
                          icon: Icon(Icons.edit, color: Colors.blue),
                          label: Text("Sửa thông tin", style: TextStyle(color: Colors.blue)),
                        ),
                        TextButton.icon(
                          onPressed: () => _cancelTicket(index),
                          icon: Icon(Icons.cancel, color: Colors.red),
                          label: Text("Hủy vé", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    )
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}