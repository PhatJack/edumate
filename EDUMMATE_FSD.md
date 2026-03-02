# **TÀI LIỆU ĐẶC TẢ CHỨC NĂNG (FSD)**

**Tên sản phẩm:** Edumate \- Trợ lý Sư phạm dành cho Phụ huynh

**Phiên bản:** 1.0.0

**Ngày cập nhật:** 27/02/2026

## **1\. TỔNG QUAN SẢN PHẨM**

**Edumate** là một ứng dụng ứng dụng trí tuệ nhân tạo (AI) đóng vai trò như một "chuyên gia sư phạm" đồng hành cùng phụ huynh.

Khác với các ứng dụng giải bài tập thông thường (quét ảnh ra đáp án), Edumate giúp phân tích đề bài, bám sát phương pháp giảng dạy của giáo viên trên lớp và cung cấp cho phụ huynh các câu hỏi gợi mở, kịch bản giao tiếp để hướng dẫn con tự tư duy tìm ra đáp án.

## **2\. ĐỐI TƯỢNG NGƯỜI DÙNG**

* **Phụ huynh học sinh (Cấp 1, 2):** Những người có nhu cầu dạy con học tại nhà nhưng gặp khó khăn về phương pháp sư phạm hoặc không nắm rõ chương trình học hiện hành.

## **3\. KIẾN TRÚC GIAO DIỆN (UI/UX)**

Ứng dụng được thiết kế theo dạng **3 cột (3-Column Layout)** trên Desktop và **Lớp phủ (Overlay)** trên Mobile, bao gồm:

1. **Left Sidebar (Quản lý):** Danh sách tài liệu và Hồ sơ cá nhân.  
2. **Main Chat Area (Tương tác):** Khung chat AI, thanh chọn bài tập và khung nhập liệu.  
3. **Right Sidebar (Không gian làm việc):** Chi tiết đề bài, Phương pháp tham khảo và Tạo bài tương tự.

**Phong cách thiết kế:** Chuyên nghiệp, tối giản, không sử dụng biểu tượng cảm xúc (emoji), sử dụng tông màu Indigo (Chàm) và Slate (Xám xanh) làm chủ đạo.

## **4\. ĐẶC TẢ CHỨC NĂNG CHI TIẾT**

### **4.1. Quản lý Hồ sơ học sinh (User Profile)**

* **Mô tả:** Cá nhân hóa trải nghiệm AI dựa trên đặc điểm của từng học sinh.  
* **Trường dữ liệu:**  
  * Tên phụ huynh, Email (Tài khoản liên kết).  
  * Tên học sinh, Lớp học.  
  * Đặc điểm học tập (Textarea): Ghi chú về điểm mạnh, điểm yếu, sở thích học tập (VD: "Tiếp thu hình học chậm, thích ví dụ thực tế").  
* **Hành vi:** Cập nhật thông tin qua Modal. Dữ liệu này được nhúng vào Context (ngữ cảnh) của AI để điều chỉnh giọng điệu và cách lấy ví dụ.

### **4.2. Quản lý Tài liệu (Document Management)**

* **Thêm mới tài liệu:** Pop-up cho phép nhập tài liệu từ 5 nguồn:  
  1. Tải File PDF (Tài liệu dài).  
  2. Chụp bài tập (Camera).  
  3. Tải ảnh lên.  
  4. Google Drive.  
  5. Nhập văn bản trực tiếp.  
* **Danh sách tài liệu:** \* Mỗi tài liệu tạo ra một phiên hội thoại (session) độc lập.  
  * Hiển thị icon theo định dạng (PDF, Image, Text).  
  * Chức năng phụ: Xem lại nội dung tài liệu gốc (Eye icon) và Xóa tài liệu (Trash icon).

### **4.3. Phân tích & Trích xuất Bài tập (Exercise Extraction)**

* **Đối với tài liệu ngắn (Ảnh, Text):** Hệ thống tự động phân tích và trả về danh sách các bài tập ngay lập tức.  
* **Đối với tài liệu dài (PDF):** \* Hệ thống khóa khung chat.  
  * Yêu cầu người dùng nhập "Số trang" ở thanh công cụ.  
  * Sau khi quét trang, chỉ trả về danh sách bài tập thuộc trang đó.  
* **Trọng tâm bài học (Focus Mode):**  
  * Người dùng **bắt buộc** phải chọn 1 bài tập cụ thể từ Menu Dropdown trước khi có thể chat với AI.  
  * Khung nhập chat bị disable (làm mờ) nếu chưa chọn bài tập.

### **4.4. Tương tác AI (Chatbot Interface)**

* **Giao diện:** Phân biệt rõ ràng tin nhắn của Phụ huynh (Bên phải, nền Indigo) và AI (Bên trái, nền Trắng, hỗ trợ Markdown).  
* **Tương tác thông minh:** Khi AI quét xong tài liệu, tin nhắn chào mừng sẽ đính kèm các nút bấm (Chips) là tên các bài tập để phụ huynh bấm chọn nhanh.  
* **Luồng xử lý sư phạm:** AI không trả lời trực tiếp đáp án mà đưa ra câu hỏi gợi mở (VD: "Ba mẹ hãy hỏi con: Đề bài đã cho biết những dữ kiện nào?").

### **4.5. Không gian làm việc (Right Sidebar)**

Thanh công cụ bên phải mở ra khi một bài tập được chọn (Focus), bao gồm 3 tính năng cốt lõi:

* **Tính năng 4.5.1: Chi tiết & Hiệu chỉnh đề bài (OCR Edit)**  
  * Hiển thị nguyên văn đề bài được trích xuất.  
  * Cho phép chế độ "Chỉnh sửa" (Edit Mode) để phụ huynh tự sửa text nếu hệ thống nhận diện sai do ảnh mờ, sau đó "Lưu lại" cập nhật vào hệ thống.  
* **Tính năng 4.5.2: Bài giải tham khảo (Teacher's Solution)**  
  * Mục đích: Giúp AI bám sát phương pháp giảng dạy tại trường học.  
  * Phụ huynh có thể nhập tóm tắt cách giải bằng văn bản, hoặc đính kèm ảnh (Chụp, Tải lên, Drive).  
  * Có nút "Lưu lại" để xác nhận cấu hình phương pháp này cho AI.  
* **Tính năng 4.5.3: Tạo bài tập mở rộng (Generate Similar)**  
  * Mục đích: Tạo bài tập rèn luyện thêm sau khi bé đã hiểu bài.  
  * Có khung nhập yêu cầu tùy chỉnh (VD: "Đổi thành bài toán về siêu thị", "Số liệu nhỏ hơn 10").  
  * Sau khi tạo, bài tập mới sẽ được thêm trực tiếp vào "Danh sách bài tập" của tài liệu hiện tại và tự động chuyển Focus sang bài mới này.

### **4.6. Hướng dẫn sử dụng tự động (Interactive Tour Guide)**

Hệ thống tích hợp thư viện Tour Guide (driver.js) với các cơ chế đặc biệt:

* **Auto-start:** Tự động chạy lần đầu tiên người dùng mở app (lưu cờ edumate\_tour\_completed trong LocalStorage).  
* **Tài liệu ảo (Mock Document):** Sinh ra một tài liệu ảo (có cờ isTourDoc) chỉ để phục vụ Tour. Tránh ảnh hưởng/làm hỏng dữ liệu thật của người dùng. Tài liệu này bị xóa ngay khi kết thúc Tour.  
* **Đồng bộ DOM Động:** Chuyển bước Tour không dùng setTimeout cứng, mà liên tục kiểm tra (requestAnimationFrame) kết hợp đo lường Viewport để đảm bảo Sidebar trượt ra hoàn tất và phần tử hiển thị 100% trước khi khoanh sáng.

## **5\. LUỒNG NGHIỆP VỤ CHÍNH (USER FLOW)**

**Luồng 1: Sử dụng tài liệu PDF (Đa trang)**

1. Nhấn \[+\] Thêm tài liệu \-\> Chọn File PDF.  
2. AI thông báo đây là file dài, yêu cầu chọn trang.  
3. Phụ huynh nhập số trang \-\> Nhấn "Quét".  
4. AI trả về danh sách bài tập của trang đó.  
5. Phụ huynh chọn 1 bài tập \-\> Khung chat mở khóa \+ Thanh bên phải mở ra hiển thị đề bài.  
6. Phụ huynh chat với AI để nhận gợi ý giảng bài.

**Luồng 2: Áp dụng phương pháp của giáo viên**

1. Đã chọn bài tập (Đang Focus).  
2. Mở thanh bên phải \-\> Cuộn đến "Bài giải tham khảo".  
3. Nhập tóm tắt cách cô giáo chữa bài hoặc chụp ảnh vở của con.  
4. Nhấn "Lưu lại".  
5. Chat với AI: "Hướng dẫn tôi dạy bài này". AI sẽ trả về các bước dựa trên phương pháp vừa cung cấp.

## **6\. YÊU CẦU PHI CHỨC NĂNG (NON-FUNCTIONAL REQUIREMENTS)**

* **Responsive:** Hoạt động hoàn hảo trên Mobile, Tablet, Desktop. Trên Mobile, thanh công cụ trái/phải phải là dạng Lớp phủ (Overlay) trượt vào (Slide in) để tiết kiệm không gian.  
* **Performance:** Sử dụng useMemo cho việc lọc tài liệu/bài tập đang Active để tránh re-render không cần thiết.  
* **Tự động cuộn:** Khung chat phải tự động cuộn xuống tin nhắn mới nhất mỗi khi Phụ huynh gửi tin hoặc AI phản hồi.