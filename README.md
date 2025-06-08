Dưới đây là nội dung README ngắn gọn, dễ hiểu bằng tiếng Việt, hướng dẫn cách chạy cả backend và frontend cho repo này:

---

# PetClinicSystem

## Hướng dẫn chạy Backend

1. **Yêu cầu:**  
   - Đã cài đặt Java 17+  
   - Đã cài đặt Maven

2. **Chạy Backend:**
   ```sh
   cd BE/pet
   ./mvnw spring-boot:run
   ```
   Hoặc trên Windows:
   ```sh
   cd BE\pet
   mvnw.cmd spring-boot:run
   ```

3. **API sẽ chạy tại:**  
   http://localhost:8080

---

## Hướng dẫn chạy Frontend

### Flutter App (FE)

1. **Yêu cầu:**  
   - Đã cài đặt Flutter SDK  
   - Đã cài đặt Android Studio hoặc VS Code (có plugin Flutter)

2. **Cài đặt dependencies:**
   ```sh
   cd fe
   flutter pub get
   ```

3. **Chạy ứng dụng:**
   ```sh
   flutter run
   ```
   (Chọn thiết bị mô phỏng hoặc thiết bị thật để chạy app)

---

### Web Frontend (ReactJS)

1. **Yêu cầu:**  
   - Đã cài đặt Node.js và npm

2. **Cài đặt dependencies:**
   ```sh
   cd js_fe
   npm install
   ```

3. **Chạy ứng dụng:**
   ```sh
   npm run dev
   ```
   Ứng dụng sẽ chạy tại: http://localhost:3000

---

## Liên hệ

Nếu gặp vấn đề, vui lòng liên hệ nhóm phát triển để được hỗ trợ.

---