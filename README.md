# Hệ Thống Quản Lý Phòng Khám Thú Cưng

Dự án này là một hệ thống quản lý phòng khám thú cưng full-stack với backend Java Spring Boot và frontend React.js (TypeScript). Hướng dẫn này sẽ giúp bạn cài đặt và chạy ứng dụng trên **Windows**.

---
## Mục Lục
- [Yêu Cầu Chuẩn Bị](#yêu-cầu-chuẩn-bị)
- [Cài Đặt Backend (Java Spring Boot)](#cài-đặt-backend-java-spring-boot)
  - [1. Cài Đặt JDK 21](#1-cài-đặt-jdk-21)
  - [2. Cài Đặt Maven](#2-cài-đặt-maven)
  - [3. Cài Đặt MySQL](#3-cài-đặt-mysql)
  - [4. Cấu Hình Cơ Sở Dữ Liệu MySQL](#4-cấu-hình-cơ-sở-dữ-liệu-mysql)
  - [5. Chạy Backend](#5-chạy-backend)
- [Cài Đặt Frontend (React.js + TypeScript)](#cài-đặt-frontend-reactjs--typescript)
  - [1. Cài Đặt Node.js & npm](#1-cài-đặt-nodejs--npm)
  - [2. Cài Đặt Thư Viện](#2-cài-đặt-thư-viện)
  - [3. Chạy Frontend](#3-chạy-frontend)
- [Cấu Trúc Dự Án](#cấu-trúc-dự-án)
- [Khắc Phục Sự Cố](#khắc-phục-sự-cố)

---

## Yêu Cầu Chuẩn Bị

- **JDK 21** ([Tải về](https://adoptium.net/en-GB/temurin/releases/?version=21))
- **Maven** ([Tải về](https://maven.apache.org/download.cgi))
- **MySQL Community Server** ([Tải về](https://dev.mysql.com/downloads/mysql/))
- **Node.js (bao gồm npm)** ([Tải về](https://nodejs.org/en/download/))

---

## Cài Đặt Backend (Java Spring Boot)

### 1. Cài Đặt JDK 21
- Tải và cài đặt JDK 21 từ [Adoptium Temurin](https://adoptium.net/en-GB/temurin/releases/?version=21).
- Sau khi cài đặt, thiết lập biến môi trường `JAVA_HOME`:
  1. Mở **System Properties** > **Advanced** > **Environment Variables**.
  2. Ở mục **System variables**, nhấn **New**.
  3. Tên biến: `JAVA_HOME`
  4. Giá trị biến: Đường dẫn đến thư mục cài đặt JDK 21 (ví dụ: `C:\Program Files\Eclipse Adoptium\jdk-21.x.x`).
  5. Thêm `%JAVA_HOME%\bin` vào biến `Path`.
- Kiểm tra cài đặt:
  ```powershell
  java -version
  ```

### 2. Cài Đặt Maven
- Tải Maven từ [đây](https://maven.apache.org/download.cgi) và giải nén.
- Thêm thư mục `bin` của Maven vào biến môi trường `Path`.
- Kiểm tra cài đặt:
  ```powershell
  mvn -version
  ```

### 3. Cài Đặt MySQL
- Tải và cài đặt MySQL Community Server từ [đây](https://dev.mysql.com/downloads/mysql/).
- Trong quá trình cài đặt, đặt mật khẩu root và ghi nhớ.

### 4. Cấu Hình Cơ Sở Dữ Liệu MySQL
- Mở MySQL Command Line Client hoặc MySQL Workbench.
- Tạo database:
  ```sql
  CREATE DATABASE test_medicalrecord;
  ```
- Backend sẽ tự động tạo và khởi tạo các bảng cần thiết trong database này.

- **Cập nhật `application.properties` nếu cần:**
  - File: `BE/pet/src/main/resources/application.properties`
  - Ví dụ cấu hình:
    ```properties
    spring.datasource.url=jdbc:mysql://localhost:3306/test_medicalrecord
    spring.datasource.username=TÊN_TÀI_KHOẢN_MYSQL_CỦA_BẠN
    spring.datasource.password=MẬT_KHẨU_MYSQL_CỦA_BẠN
    spring.jpa.hibernate.ddl-auto=update
    spring.jpa.show-sql=true
    ```

### 5. Chạy Backend
- Mở terminal và chuyển đến thư mục backend:
  ```powershell
  cd BE\pet
  ```
- Chạy ứng dụng bằng Maven Wrapper:
  ```powershell
  .\mvnw spring-boot:run
  ```
- Backend sẽ chạy tại [http://localhost:8080](http://localhost:8080) theo mặc định.

---

## Cài Đặt Frontend (React.js + TypeScript)

### 1. Cài Đặt Node.js & npm
- Tải và cài đặt Node.js (bao gồm npm) từ [đây](https://nodejs.org/en/download/).
- Kiểm tra cài đặt:
  ```powershell
  node -v
  npm -v
  ```

### 2. Cài Đặt Thư Viện
- Mở terminal và chuyển đến thư mục frontend:
  ```powershell
  cd js_fe
  ```
- Cài đặt các thư viện:
  ```powershell
  npm install
  ```

### 3. Chạy Frontend
- Khởi động server phát triển:
  ```powershell
  npm run dev
  ```
- Frontend sẽ chạy tại [http://localhost:5173](http://localhost:5173) theo mặc định.

---

## Cấu Trúc Dự Án

## Chức Năng Hệ Thống

- Quản lý hồ sơ thú cưng: thêm/sửa/xóa, theo dõi lịch sử khám.
- Đặt lịch khám: khách hàng tự đặt, quản lý và nhắc lịch.
- Quản lý thuốc và đơn thuốc: kê đơn, theo dõi.
- Thống kê & báo cáo:doanh thu, đặt lịch hẹn sắp tới.




```
BE/           # Backend (Java Spring Boot)
  pet/
    src/
      main/
        java/com/demo/pet/...
      resources/application.properties
    ...
js_fe/        # Frontend (React.js + TypeScript)
  src/
    components/
    pages/
    ...
```

---

## Khắc Phục Sự Cố

- **Trùng Cổng:**
  - Backend mặc định: `8080`
  - Frontend mặc định: `5173`
  - Có thể thay đổi cổng trong file cấu hình nếu cần.
- **Lỗi Kết Nối Database:**
  - Đảm bảo MySQL đang chạy và thông tin trong `application.properties` chính xác.
- **Lỗi Thư Viện Frontend:**
  - Xóa thư mục `node_modules` và chạy lại `npm install`.
- **Lỗi Java/Maven:**
  - Đảm bảo đã thiết lập đúng biến môi trường `JAVA_HOME` và `MAVEN_HOME`.

---

## Liên Kết Hữu Ích
- [Tải JDK 21](https://adoptium.net/en-GB/temurin/releases/?version=21)
- [Tải Maven](https://maven.apache.org/download.cgi)
- [Tải MySQL](https://dev.mysql.com/downloads/mysql/)
- [Tải Node.js](https://nodejs.org/en/download/)

---

Nếu bạn gặp vấn đề, vui lòng xem phần khắc phục sự cố hoặc liên hệ người quản lý dự án.
