# Ứng dụng Nhà hàng (Restaurant App)

Một ứng dụng giao đồ ăn hoàn chỉnh (full-stack) được xây dựng bằng Flutter, Node.js và MongoDB.

## Thành viên nhóm
- **Trần Văn Tài**
- **Trần Tấn Phúc**

## Video Demo
Bạn có thể xem video mô tả ứng dụng tại đây: [Link Video Demo Dự Án](https://drive.google.com/file/d/1oGIlXly-sIW-OcBQu2Xp8GSU6eYIN2Tm/view?usp=drive_link)

## Tính năng chính
- **Xác thực (Auth)**: Đăng nhập và Đăng ký tài khoản.
- **Thực đơn (Menu)**: Duyệt món ăn theo văn hóa/danh mục (Trung Hoa, Mexico, Ấn Độ, v.v.).
- **Giỏ hàng (Cart)**: Thêm/xóa món ăn và điều chỉnh số lượng.
- **Thanh toán (Checkout)**: Màn hình mô phỏng thanh toán thành công.

## Cấu trúc dự án
- `api/`: Server Node.js Express.
- `flutter_app/`: Ứng dụng di động Flutter.
- `assets/images/`: Các tệp hình ảnh sử dụng trong ứng dụng.

## Công nghệ sử dụng
- **Frontend**: Flutter, Provider (Quản lý trạng thái), Google Fonts.
- **Backend**: Node.js, Express, Mongoose.
- **Database**: MongoDB Atlas.
- **Auth**: JWT & Bcryptjs.

## Kiến trúc Backend & Kết nối

### 1. Kết nối Cơ sở dữ liệu (MongoDB)
Ứng dụng sử dụng **MongoDB** làm cơ sở dữ liệu chính. Việc kết nối được quản lý thông qua thư viện `mongoose`:
- **Biến môi trường**: Các thông tin nhạy cảm như URI MongoDB và Cổng (Port) được lưu trữ trong tệp `.env` để bảo mật.
- **Logic kết nối**: Một tệp cấu hình `db.js` riêng biệt xử lý việc kết nối bất đồng bộ đến MongoDB Atlas. Server chỉ khởi động sau khi kết nối DB thành công.
- **Thiết kế Schema**: Các Model cho `User`, `Category`, và `Food` được định nghĩa với kiểu dữ liệu chặt chẽ và có mối quan hệ với nhau (ví dụ: mỗi món ăn tham chiếu đến một ID danh mục).

### 2. Xây dựng Server Node.js
Backend được xây dựng theo kiến trúc RESTful API sử dụng **Express.js**:
- **Middleware**: Sử dụng `express.json()` để phân tích dữ liệu yêu cầu và `cors` để cho phép kết nối với ứng dụng Flutter.
- **Xác thực**: Triển khai **JWT (JSON Web Tokens)**. Khi người dùng đăng nhập, server sẽ ký một token để ứng dụng di động lưu trữ và xác thực các yêu cầu tiếp theo.
- **Định tuyến (Routing)**: Sử dụng các route mô-đun hóa để tách biệt các chức năng:
    - `/api/auth`: Xử lý logic đăng ký và đăng nhập.
    - `/api/categories`: Lấy danh sách danh mục món ăn.
    - `/api/foods`: Xử lý việc truy xuất và lọc các món ăn.
- **Dữ liệu mẫu (Seeding)**: Bao gồm một script `seed.js` để tự động đổ dữ liệu ban đầu cho món ăn và danh mục vào database (sử dụng link ảnh mạng).

## Hướng dẫn bắt đầu
1. Di chuyển vào thư mục `api` và chạy lệnh `npm install`.
2. Cấu hình tệp `.env` của bạn với `MONGO_URI` và `JWT_SECRET`.
3. Khởi động server bằng lệnh `npm start` hoặc `node server.js`.
4. Chạy ứng dụng Flutter bằng lệnh `flutter run`.