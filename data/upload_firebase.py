import firebase_admin
from firebase_admin import credentials, firestore
import json
import os

# --- CẤU HÌNH ĐƯỜNG DẪN ---
# Bạn có thể giữ nguyên đường dẫn tuyệt đối này nếu file vẫn nằm ở Downloads
KEY_PATH = r"G:\uni\Mobile\sanvemaybay_app_fixed\sanvemaybay_app_fixed\data\serviceAccountKey.json"
DATA_FILE = "CLEANED_DATA.json"

print("🔄 Đang thiết lập kết nối Firebase...")

# 1. Kết nối với Firebase
try:
    cred = credentials.Certificate(KEY_PATH)
    # Kiểm tra xem app đã khởi tạo chưa để tránh lỗi nếu chạy script nhiều lần
    if not firebase_admin._apps:
        firebase_admin.initialize_app(cred)
    db = firestore.client()
    print("✅ Kết nối Firebase thành công!")
except FileNotFoundError:
    print(f"❌ Lỗi: Không tìm thấy file chìa khóa tại: {KEY_PATH}")
    exit()
except Exception as e:
    print(f"❌ Lỗi kết nối Firebase: {e}")
    exit()

# 2. Đọc file dữ liệu đã clean
try:
    with open(DATA_FILE, "r", encoding="utf-8") as f:
        flights_data = json.load(f)
    print(f"📂 Đọc thành công {len(flights_data)} chuyến bay từ file {DATA_FILE}.")
except FileNotFoundError:
    print(f"❌ Lỗi: Không tìm thấy file dữ liệu '{DATA_FILE}'. Hãy chắc chắn nó nằm cùng thư mục với script.")
    exit()

# 3. Đẩy lên collection 'flights' trên Firestore
print(f"🚀 Bắt đầu tải dữ liệu lên đám mây...")
collection_ref = db.collection('flights')
success_count = 0

for i, flight in enumerate(flights_data):
    try:
        # Lệnh .add() giúp Firebase tự tạo một ID ngẫu nhiên, không lo bị trùng lặp
        collection_ref.add(flight)
        success_count += 1
        
        # In ra tiến độ cho dễ theo dõi (mỗi 10 chuyến báo 1 lần)
        if (i + 1) % 10 == 0 or (i + 1) == len(flights_data):
            print(f"⏳ Đang xử lý: {i + 1}/{len(flights_data)} chuyến bay...")
    except Exception as e:
        print(f"⚠️ Lỗi khi đẩy chuyến bay thứ {i+1}: {e}")

print(f"🎉 HOÀN THÀNH! Đã tải thành công {success_count} chuyến bay lên Firestore.")