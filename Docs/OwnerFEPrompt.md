Explore the back-end and list me the screens that we can implement, list all of them. Please remember that this is a permission based system, with the ones logging in have their own permissions and their set of available screen. Please explore the whole code and generate me a systematic report in the file FEScreens.md. Please analyze deeply in any way possible, from the code to the APIs in the file BEDocs.md and BELogin.md



----- Prompt 2:
I will list you the owner-specific screens. This is when the owner@example.com logs in and goes into the web app, they will see those screens BESIDES THE SHARED SCREENS(EVERYONE WILL SEE THE SHARED SCREENS). We seem to have implemented the screens and fix the bugs, but I still DO NOT SEE the owner-specific screens in the Navbar when logging in as an owner. Please re-read the API documentation provided in BEDocs.md and BELogin.md and re-check the Dart code handling this problem. Find the root cause of why we logged in as owner but still cannot see anything. These are the owner-specific screens(screens besides the shared screens):

## II. Owner-Specific Screens

1.  **My Pets & Medical Records Screen**
    *   **Functionality:**
        *   List pets owned by the logged-in user.
        *   Add new pet, edit existing pet details, delete pet.
        *   View detailed information for a selected pet.
        *   View medical records for a selected pet.
    *   **Relevant APIs:**
        *   Pets: `GET /api/pets/my-pets`, `POST /api/pets`, `GET /api/pets/{id}`, `PUT /api/pets/{id}`, `DELETE /api/pets/{id}`
        *   Medical Records: `GET /api/records/pet/{petId}` (for viewing)
    *   **Accessible by:** Owner.
    *   **Sub-screens/Modals:** Add Pet Form, Edit Pet Form.

2.  **My Bookings Screen**
    *   **Functionality:**
        *   List bookings made by the logged-in user.
        *   Create new booking (selecting service, pet, date).
        *   View booking details.
        *   Cancel an upcoming booking (if permitted by business logic).
    *   **Relevant APIs:** `GET /api/bookings/my-bookings`, `POST /api/bookings`, `GET /api/bookings/{id}`, `PUT /api/bookings/{id}/cancel` (or `PATCH /api/bookings/{id}/status` to set to CANCELLED)
    *   **Accessible by:** Owner.
    *   **Sub-screens/Modals:** Create Booking Form.
*   
----- Prompt 3:

It seems like you fixed nothing in this checklist. Please revise it once again. When I start the front-end, I still see no Services for Owner have been implemented based on the use cases provided below. And also, the Clock has not changed at all. Do not use the Apple Cupertino scrolling clock just like on iPhone or Apple device, use a calendar selection with buttons, not scrollers. We are focusing on web app experience, not iPhone UI!

First of all, fix the owner-specific screens to meet those circumstances:
1. Change the clock form to a calendar and we choose the dates instead of Cupertino scrolling like Apple design. In the Create your First Bookings screen, when we try to create a new booking, it returns the error of "The End Date is not larger or equal to the Start date", something like that and return a Flutter debug error with red screen. Also change the calendar style to choosing calendar instead of scrolling in the Add Pet screen and the Add Pet functionality.

2. Add Services based on the provided document and implement the functionalities and the read the API documents provided to implement those Services. Please note that only these services are available to the owner, other roles cannot access. Please read the API documentation carefully to implement these.
Here are the owner-specific pet services-related use cases, their tables, and descriptions from the document. All of these use cases are used as services:

**1. UC003 “đăng ký khám” (Register for Examination)** [cite: 55]

* **Description:** This use case allows pet owners to register their pets for an examination.
* **Table:**
    * **Mã Use case:** UC003 [cite: 71]
    * **Tên Use case:** Đăng ký khám [cite: 71]
    * **Tác nhân:** Người dùng (User) [cite: 71]
    * **Tiền điều kiện:** Khách đăng nhập thành công với vai trò người dùng (Customer successfully logged in as a user) [cite: 71]
    * **Luồng sự kiện chính (Thành công):**
        * **STT 1:** Chủ nuôi chọn chức năng Lịch khám (Pet owner selects the "Appointment Schedule" function) [cite: 71]
        * **STT 2:** Hệ thống hiển thị giao diện Lịch khám (System displays the "Appointment Schedule" interface) [cite: 71]
        * **STT 3:** Chủ nuôi chọn vào chức năng Đăng ký lịch khám (Pet owner selects the "Register for Appointment" function) [cite: 72]
        * **STT 4:** Hệ Thống hiển thị bảng giao diện Đăng ký lịch khám (System displays the "Register for Appointment" interface table) [cite: 72]
        * **STT 5:** Chủ nuôi nhập các thông tin đăng ký (mô tả phía dưới *) (Pet owner enters registration information (described below *)) [cite: 72]
        * **STT 6:** Chủ nuôi Yêu cầu đăng ký (Pet owner requests registration) [cite: 72]
        * **STT 7:** Hệ thống kiểm tra xem khách đã nhập các trường bắt buộc nhập hay chưa (System checks if the customer has entered all required fields) [cite: 72]
        * **STT 8:** Hệ thống lưu thông tin đăng ký và thông báo đăng ký thành công (System saves registration information and notifies successful registration) [cite: 72]
    * **Luồng sự kiện thay thế:**
        * **STT 8a:** Hệ thống Thông báo lỗi nếu chủ nuôi nhập thiếu thông tin (System notifies error if pet owner enters incomplete information) [cite: 73]
        * **STT 9a:** Hệ thống Thông báo lỗi: nếu lịch khám chủ nuôi đăng ký bị trùng lặp với lịch khám đã có trong hệ thống (System notifies error: if the registered appointment overlaps with an existing appointment in the system) [cite: 74]
    * **Hậu điều kiện:** Không (None) [cite: 74]
    * *** Dữ liệu đầu vào của thông tin cá nhân gồm các trường dữ liệu sau:**
        * **STT 1:** Tên thú cưng (Pet Name) - Có (Required) - Dog (Example) [cite: 75]
        * **STT 2:** Ngày khám (Examination Date) - Có (Required) - 30/7/2023 (Example) [cite: 75]
        * **STT 3:** Thời gian (Time) - Có (Required) - 11:00 (Example) [cite: 76]

**2. UC004 “CRUD thú cưng” (CRUD Pet)** [cite: 76]

* **Description:** This use case allows users (pet owners) to Create, Read, Update, and Delete information about their pets.
* **Table:**
    * **Mã Use case:** UC004 [cite: 76]
    * **Tên Use case:** CRUD thú cưng [cite: 76]
    * **Tác nhân:** Người dùng (User) [cite: 76]
    * **Tiền điều kiện:** Khách đăng nhập thành công với vai trò người dùng (Customer successfully logged in as a user) [cite: 76]
    * **Thêm (C):**
        * **Luồng sự kiện chính:**
            * **STT 1:** Người dùng Chọn chức năng thêm mời thông tin thú cưng (User selects the function to add new pet information) [cite: 76]
            * **STT 2:** Hệ thồng Hiển thị form input bao gồm name, category, age, color, gender (System displays input form including name, category, age, color, gender) [cite: 77]
            * **STT 3:** Người dùng Điền đầy đủ thông tin và nhấn nút thêm mới (User fills in all information and clicks the "Add New" button) [cite: 77]
            * **STT 4:** Hệ thống Kiểm tra tính hợp lệ (System checks validity) [cite: 77]
            * **STT 5:** Hệ thống Hiển thị thông báo thành công (System displays success message) [cite: 77]
        * **Luồng sự kiện thay thế:**
            * **STT 5a1:** Hệ thống Thông báo lỗi nếu người dùng nhập thiếu thông tin (System notifies error if user enters incomplete information) [cite: 77]
            * **STT 6a1:** Hệ thống Thông báo lỗi nếu thú cưng đã có (System notifies error if pet already exists) [cite: 77]
    * **Xem (R):**
        * **Luồng sự kiện chính:**
            * **STT 1:** Người dùng Chọn chức năng hiển thị thông tin thú cưng (User selects the function to display pet information) [cite: 78]
            * **STT 2:** Hệ thống Hiển thị danh sách các thú cưng (System displays a list of pets) [cite: 78]
            * **STT 3:** Người dùng Chọn 1 thú cưng để xem (User selects a pet to view) [cite: 78]
            * **STT 4:** Hệ thống Hiển thị chi tiết thông tin thú cưng (System displays detailed pet information) [cite: 78]
        * **Luồng sự kiện thay thế:**
            * **STT 3a:** Hệ thống Nếu không có thú cưng nào, hệ thống báo lỗi (If no pets exist, the system reports an error) [cite: 78]
    * **Cập nhât (U):**
        * **Luồng sự kiện chính:**
            * **STT 1:** Người dùng Chọn chức năng cập nhật thông tin thú cưng (User selects the function to update pet information) [cite: 78]
            * **STT 2:** Hệ thống hiển thị danh sách thú cưng (System displays a list of pets) [cite: 78]
            * **STT 3:** Người dùng Chọn 1 thú cưng để cập nhật thông tin (User selects a pet to update information) [cite: 79]
            * **STT 4:** Hệ thống Hiển thị form để người dùng cập nhật thông tin thú cưng (System displays a form for the user to update pet information) [cite: 79]
            * **STT 5:** Người dùng Cập nhật thông tin và nhấn nút cập nhật (User updates information and clicks the "Update" button) [cite: 79]
            * **STT 6:** Hệ thống Kiểm tra tính hợp lệ. Cập nhật thông tin (System checks validity. Updates information) [cite: 79]
        * **Luồng sự kiện thay thế:**
            * **STT 3a:** Hệ thống Nếu không có thú cưng, hệ thống hiển thị thông báo (If no pets exist, the system displays a message) [cite: 79]
            * **STT 7a:** Hệ thống Nếu thông tin không hợp lệ, đưa ra thông bóa cho người dùng (If the information is invalid, the system displays a notification to the user) [cite: 79]
    * **Xóa (D):**
        * **Luồng sự kiện chính:**
            * **STT 1:** Người dùng Chọn chức năng xóa thông tin thú cưng (User selects the function to delete pet information) [cite: 79]
            * **STT 2:** Hệ thống Hiển thị danh sách thú cưng (System displays a list of pets) [cite: 79]
            * **STT 3:** Người dùng Chọn 1 thú cưng để xóa (User selects a pet to delete) [cite: 79]
            * **STT 4:** Hệ thống Yêu cầu xác nhận (System requests confirmation) [cite: 80]
            * **STT 5:** Hệ thống Người dùng xác nhận xóa, hệ thống xóa thông tin thú cưng (User confirms deletion, system deletes pet information) [cite: 80]
        * **Luồng sự kiện thay thế:**
            * **STT 3a:** Hệ thống Nếu không có thú cưng nào, hệ thống đưa ra thông báo (If no pets exist, the system displays a message) [cite: 80]
            * **STT 6a:** Hệ thống Nếu người dùng không xác nhận, hệ thống không thực hiện xóa (If the user does not confirm, the system does not perform the deletion) [cite: 80]
    * **Hậu điều kiện:** Không (None) [cite: 80]
    * *** Dữ liệu đầu vào của thông tin cá nhân gồm các trường dữ liệu sau:**
        * **STT 1:** Tên thú cưng (Pet Name) - Có (Required) - Dog (Example) [cite: 81]
        * **STT 2:** Category - Có (Required) - Hoàng Anh (Example) [cite: 81]
        * **STT 3:** Age - Có (Required) - 10 (Example) [cite: 81]
        * **STT 4:** Color - Có (Required) - Red (Example) [cite: 81]

**3. UC005 “đăng ký dịch vụ trông giữ thú cưng” (Register for Pet Boarding Service)** [cite: 81]

* **Description:** This use case allows users (pet owners) to register for pet boarding services.
* **Table:**
    * **Mã Use case:** UC005 [cite: 81]
    * **Tên Use case:** Đăng ký dịch vụ trông giữ thú cưng [cite: 81]
    * **Tác nhân:** Người dùng (User) [cite: 81]
    * **Tiền điều kiện:** Khách đã đăng nhập thành công với vai trò người dùng (Customer has successfully logged in as a user) [cite: 82]
    * **Luồng sự kiện chính (Thành công):**
        * **STT 1:** Người dùng chọn chức năng Dịch vụ trông giữ (User selects the "Pet Boarding Service" function) [cite: 82]
        * **STT 2:** Hệ thống hiển thị giao diện Dịch vụ trông giữ (System displays the "Pet Boarding Service" interface) [cite: 82]
        * **STT 3:** Người dùng chọn vào chức năng Đăng ký dịch vụ (User selects the "Register for Service" function) [cite: 82]
        * **STT 4:** Hệ Thống hiển thị bảng giao diện Đăng ký dịch vụ (System displays the "Register for Service" interface table) [cite: 82]
        * **STT 5:** Người dùng nhập các thông tin đăng ký (mô tả phía dưới *) (User enters registration information (described below *)) [cite: 82]
        * **STT 6:** Người dùng Yêu cầu đăng ký (User requests registration) [cite: 83]
        * **STT 7:** Hệ thống kiểm tra xem khách đã nhập các trường bắt buộc nhập hay chưa (System checks if the customer has entered all required fields) [cite: 83]
        * **STT 8:** Hệ thống lưu thông tin đăng ký và thông báo đăng ký thành công (System saves registration information and notifies successful registration) [cite: 83]
    * **Luồng sự kiện thay thế:**
        * **STT 7a:** Hệ thống Thông báo lỗi nếu người dùng nhập thiếu thông tin (System notifies error if user enters incomplete information) [cite: 84]
    * **Hậu điều kiện:** Không (None) [cite: 84]
    * *** Dữ liệu đầu vào của thông tin cá nhân gồm các trường dữ liệu sau:**
        * **STT 1:** Tên thú cưng (Pet Name) - Có (Required) - dog (Example) [cite: 85]
        * **STT 2:** Ngày (Date) - Có (Required) - 30/7/2023 (Example) [cite: 85]
        * **STT 3:** Thời gian (Time) - Có (Required) - 11:00 (Example) [cite: 85]

**4. UC006 “đăng ký dịch vụ vệ sinh” (Register for Grooming Service)** [cite: 85]

* **Description:** This use case is identical to UC005, allowing users (pet owners) to register for grooming services.
* **Table:** Giống như UC005 (Same as UC005) [cite: 85]

--- Prompt 4:
In the owner's view, these use cases should represent the services that the owner can choose from. Implement this in the Services of the Owner view. Please make sure that these features have links to other features and does not conflict with any one of them. Please read again the API documentation carefully as provided in BEDocs.md and BELogin.md, as well as the POSTMAN curl to understand. Please once again check the JSON input and output format, and take consideration at all costs to implement these features. If a feature is too hard, skip it. Implement only the ones that are doable. These use cases will be part of the Services screen of the owner view, because right now in the owner view, it is "No Services found. No Services available at the moment". This is my list of use cases that I specified:


**1. UC003 “đăng ký khám” (Register for Examination)** [cite: 55]

* **Description:** This use case allows pet owners to register their pets for an examination.
* **Table:**
    * **Mã Use case:** UC003 [cite: 71]
    * **Tên Use case:** Đăng ký khám [cite: 71]
    * **Tác nhân:** Người dùng (User) [cite: 71]
    * **Tiền điều kiện:** Khách đăng nhập thành công với vai trò người dùng (Customer successfully logged in as a user) [cite: 71]
    * **Luồng sự kiện chính (Thành công):**
        * **STT 1:** Chủ nuôi chọn chức năng Lịch khám (Pet owner selects the "Appointment Schedule" function) [cite: 71]
        * **STT 2:** Hệ thống hiển thị giao diện Lịch khám (System displays the "Appointment Schedule" interface) [cite: 71]
        * **STT 3:** Chủ nuôi chọn vào chức năng Đăng ký lịch khám (Pet owner selects the "Register for Appointment" function) [cite: 72]
        * **STT 4:** Hệ Thống hiển thị bảng giao diện Đăng ký lịch khám (System displays the "Register for Appointment" interface table) [cite: 72]
        * **STT 5:** Chủ nuôi nhập các thông tin đăng ký (mô tả phía dưới *) (Pet owner enters registration information (described below *)) [cite: 72]
        * **STT 6:** Chủ nuôi Yêu cầu đăng ký (Pet owner requests registration) [cite: 72]
        * **STT 7:** Hệ thống kiểm tra xem khách đã nhập các trường bắt buộc nhập hay chưa (System checks if the customer has entered all required fields) [cite: 72]
        * **STT 8:** Hệ thống lưu thông tin đăng ký và thông báo đăng ký thành công (System saves registration information and notifies successful registration) [cite: 72]
    * **Luồng sự kiện thay thế:**
        * **STT 8a:** Hệ thống Thông báo lỗi nếu chủ nuôi nhập thiếu thông tin (System notifies error if pet owner enters incomplete information) [cite: 73]
        * **STT 9a:** Hệ thống Thông báo lỗi: nếu lịch khám chủ nuôi đăng ký bị trùng lặp với lịch khám đã có trong hệ thống (System notifies error: if the registered appointment overlaps with an existing appointment in the system) [cite: 74]
    * **Hậu điều kiện:** Không (None) [cite: 74]
    * *** Dữ liệu đầu vào của thông tin cá nhân gồm các trường dữ liệu sau:**
        * **STT 1:** Tên thú cưng (Pet Name) - Có (Required) - Dog (Example) [cite: 75]
        * **STT 2:** Ngày khám (Examination Date) - Có (Required) - 30/7/2023 (Example) [cite: 75]
        * **STT 3:** Thời gian (Time) - Có (Required) - 11:00 (Example) [cite: 76]

**2. UC004 “CRUD thú cưng” (CRUD Pet)** [cite: 76]

* **Description:** This use case allows users (pet owners) to Create, Read, Update, and Delete information about their pets.
* **Table:**
    * **Mã Use case:** UC004 [cite: 76]
    * **Tên Use case:** CRUD thú cưng [cite: 76]
    * **Tác nhân:** Người dùng (User) [cite: 76]
    * **Tiền điều kiện:** Khách đăng nhập thành công với vai trò người dùng (Customer successfully logged in as a user) [cite: 76]
    * **Thêm (C):**
        * **Luồng sự kiện chính:**
            * **STT 1:** Người dùng Chọn chức năng thêm mời thông tin thú cưng (User selects the function to add new pet information) [cite: 76]
            * **STT 2:** Hệ thồng Hiển thị form input bao gồm name, category, age, color, gender (System displays input form including name, category, age, color, gender) [cite: 77]
            * **STT 3:** Người dùng Điền đầy đủ thông tin và nhấn nút thêm mới (User fills in all information and clicks the "Add New" button) [cite: 77]
            * **STT 4:** Hệ thống Kiểm tra tính hợp lệ (System checks validity) [cite: 77]
            * **STT 5:** Hệ thống Hiển thị thông báo thành công (System displays success message) [cite: 77]
        * **Luồng sự kiện thay thế:**
            * **STT 5a1:** Hệ thống Thông báo lỗi nếu người dùng nhập thiếu thông tin (System notifies error if user enters incomplete information) [cite: 77]
            * **STT 6a1:** Hệ thống Thông báo lỗi nếu thú cưng đã có (System notifies error if pet already exists) [cite: 77]
    * **Xem (R):**
        * **Luồng sự kiện chính:**
            * **STT 1:** Người dùng Chọn chức năng hiển thị thông tin thú cưng (User selects the function to display pet information) [cite: 78]
            * **STT 2:** Hệ thống Hiển thị danh sách các thú cưng (System displays a list of pets) [cite: 78]
            * **STT 3:** Người dùng Chọn 1 thú cưng để xem (User selects a pet to view) [cite: 78]
            * **STT 4:** Hệ thống Hiển thị chi tiết thông tin thú cưng (System displays detailed pet information) [cite: 78]
        * **Luồng sự kiện thay thế:**
            * **STT 3a:** Hệ thống Nếu không có thú cưng nào, hệ thống báo lỗi (If no pets exist, the system reports an error) [cite: 78]
    * **Cập nhât (U):**
        * **Luồng sự kiện chính:**
            * **STT 1:** Người dùng Chọn chức năng cập nhật thông tin thú cưng (User selects the function to update pet information) [cite: 78]
            * **STT 2:** Hệ thống hiển thị danh sách thú cưng (System displays a list of pets) [cite: 78]
            * **STT 3:** Người dùng Chọn 1 thú cưng để cập nhật thông tin (User selects a pet to update information) [cite: 79]
            * **STT 4:** Hệ thống Hiển thị form để người dùng cập nhật thông tin thú cưng (System displays a form for the user to update pet information) [cite: 79]
            * **STT 5:** Người dùng Cập nhật thông tin và nhấn nút cập nhật (User updates information and clicks the "Update" button) [cite: 79]
            * **STT 6:** Hệ thống Kiểm tra tính hợp lệ. Cập nhật thông tin (System checks validity. Updates information) [cite: 79]
        * **Luồng sự kiện thay thế:**
            * **STT 3a:** Hệ thống Nếu không có thú cưng, hệ thống hiển thị thông báo (If no pets exist, the system displays a message) [cite: 79]
            * **STT 7a:** Hệ thống Nếu thông tin không hợp lệ, đưa ra thông bóa cho người dùng (If the information is invalid, the system displays a notification to the user) [cite: 79]
    * **Xóa (D):**
        * **Luồng sự kiện chính:**
            * **STT 1:** Người dùng Chọn chức năng xóa thông tin thú cưng (User selects the function to delete pet information) [cite: 79]
            * **STT 2:** Hệ thống Hiển thị danh sách thú cưng (System displays a list of pets) [cite: 79]
            * **STT 3:** Người dùng Chọn 1 thú cưng để xóa (User selects a pet to delete) [cite: 79]
            * **STT 4:** Hệ thống Yêu cầu xác nhận (System requests confirmation) [cite: 80]
            * **STT 5:** Hệ thống Người dùng xác nhận xóa, hệ thống xóa thông tin thú cưng (User confirms deletion, system deletes pet information) [cite: 80]
        * **Luồng sự kiện thay thế:**
            * **STT 3a:** Hệ thống Nếu không có thú cưng nào, hệ thống đưa ra thông báo (If no pets exist, the system displays a message) [cite: 80]
            * **STT 6a:** Hệ thống Nếu người dùng không xác nhận, hệ thống không thực hiện xóa (If the user does not confirm, the system does not perform the deletion) [cite: 80]
    * **Hậu điều kiện:** Không (None) [cite: 80]
    * *** Dữ liệu đầu vào của thông tin cá nhân gồm các trường dữ liệu sau:**
        * **STT 1:** Tên thú cưng (Pet Name) - Có (Required) - Dog (Example) [cite: 81]
        * **STT 2:** Category - Có (Required) - Hoàng Anh (Example) [cite: 81]
        * **STT 3:** Age - Có (Required) - 10 (Example) [cite: 81]
        * **STT 4:** Color - Có (Required) - Red (Example) [cite: 81]

**3. UC005 “đăng ký dịch vụ trông giữ thú cưng” (Register for Pet Boarding Service)** [cite: 81]

* **Description:** This use case allows users (pet owners) to register for pet boarding services.
* **Table:**
    * **Mã Use case:** UC005 [cite: 81]
    * **Tên Use case:** Đăng ký dịch vụ trông giữ thú cưng [cite: 81]
    * **Tác nhân:** Người dùng (User) [cite: 81]
    * **Tiền điều kiện:** Khách đã đăng nhập thành công với vai trò người dùng (Customer has successfully logged in as a user) [cite: 82]
    * **Luồng sự kiện chính (Thành công):**
        * **STT 1:** Người dùng chọn chức năng Dịch vụ trông giữ (User selects the "Pet Boarding Service" function) [cite: 82]
        * **STT 2:** Hệ thống hiển thị giao diện Dịch vụ trông giữ (System displays the "Pet Boarding Service" interface) [cite: 82]
        * **STT 3:** Người dùng chọn vào chức năng Đăng ký dịch vụ (User selects the "Register for Service" function) [cite: 82]
        * **STT 4:** Hệ Thống hiển thị bảng giao diện Đăng ký dịch vụ (System displays the "Register for Service" interface table) [cite: 82]
        * **STT 5:** Người dùng nhập các thông tin đăng ký (mô tả phía dưới *) (User enters registration information (described below *)) [cite: 82]
        * **STT 6:** Người dùng Yêu cầu đăng ký (User requests registration) [cite: 83]
        * **STT 7:** Hệ thống kiểm tra xem khách đã nhập các trường bắt buộc nhập hay chưa (System checks if the customer has entered all required fields) [cite: 83]
        * **STT 8:** Hệ thống lưu thông tin đăng ký và thông báo đăng ký thành công (System saves registration information and notifies successful registration) [cite: 83]
    * **Luồng sự kiện thay thế:**
        * **STT 7a:** Hệ thống Thông báo lỗi nếu người dùng nhập thiếu thông tin (System notifies error if user enters incomplete information) [cite: 84]
    * **Hậu điều kiện:** Không (None) [cite: 84]
    * *** Dữ liệu đầu vào của thông tin cá nhân gồm các trường dữ liệu sau:**
        * **STT 1:** Tên thú cưng (Pet Name) - Có (Required) - dog (Example) [cite: 85]
        * **STT 2:** Ngày (Date) - Có (Required) - 30/7/2023 (Example) [cite: 85]
        * **STT 3:** Thời gian (Time) - Có (Required) - 11:00 (Example) [cite: 85]

**4. UC006 “đăng ký dịch vụ vệ sinh” (Register for Grooming Service)** [cite: 85]

* **Description:** This use case is identical to UC005, allowing users (pet owners) to register for grooming services.
* **Table:** Giống như UC005 (Same as UC005) [cite: 85]

----- Prompt 3:

It seems like you fixed nothing in this checklist. Please revise it once again. When I start the front-end, I still see no Services for Owner have been implemented based on the use cases provided below. And also, the Clock has not changed at all. Do not use the Apple Cupertino scrolling clock just like on iPhone or Apple device, use a calendar selection with buttons, not scrollers. We are focusing on web app experience, not iPhone UI!

First of all, fix the owner-specific screens to meet those circumstances:
1. Change the clock form to a calendar and we choose the dates instead of Cupertino scrolling like Apple design. In the Create your First Bookings screen, when we try to create a new booking, it returns the error of "The End Date is not larger or equal to the Start date", something like that and return a Flutter debug error with red screen. Also change the calendar style to choosing calendar instead of scrolling in the Add Pet screen and the Add Pet functionality.

2. Add Services based on the provided document and implement the functionalities and the read the API documents provided to implement those Services. Please note that only these services are available to the owner, other roles cannot access. Please read the API documentation carefully to implement these.
Here are the owner-specific pet services-related use cases, their tables, and descriptions from the document. All of these use cases are used as services:

**1. UC003 “đăng ký khám” (Register for Examination)** [cite: 55]

* **Description:** This use case allows pet owners to register their pets for an examination.
* **Table:**
    * **Mã Use case:** UC003 [cite: 71]
    * **Tên Use case:** Đăng ký khám [cite: 71]
    * **Tác nhân:** Người dùng (User) [cite: 71]
    * **Tiền điều kiện:** Khách đăng nhập thành công với vai trò người dùng (Customer successfully logged in as a user) [cite: 71]
    * **Luồng sự kiện chính (Thành công):**
        * **STT 1:** Chủ nuôi chọn chức năng Lịch khám (Pet owner selects the "Appointment Schedule" function) [cite: 71]
        * **STT 2:** Hệ thống hiển thị giao diện Lịch khám (System displays the "Appointment Schedule" interface) [cite: 71]
        * **STT 3:** Chủ nuôi chọn vào chức năng Đăng ký lịch khám (Pet owner selects the "Register for Appointment" function) [cite: 72]
        * **STT 4:** Hệ Thống hiển thị bảng giao diện Đăng ký lịch khám (System displays the "Register for Appointment" interface table) [cite: 72]
        * **STT 5:** Chủ nuôi nhập các thông tin đăng ký (mô tả phía dưới *) (Pet owner enters registration information (described below *)) [cite: 72]
        * **STT 6:** Chủ nuôi Yêu cầu đăng ký (Pet owner requests registration) [cite: 72]
        * **STT 7:** Hệ thống kiểm tra xem khách đã nhập các trường bắt buộc nhập hay chưa (System checks if the customer has entered all required fields) [cite: 72]
        * **STT 8:** Hệ thống lưu thông tin đăng ký và thông báo đăng ký thành công (System saves registration information and notifies successful registration) [cite: 72]
    * **Luồng sự kiện thay thế:**
        * **STT 8a:** Hệ thống Thông báo lỗi nếu chủ nuôi nhập thiếu thông tin (System notifies error if pet owner enters incomplete information) [cite: 73]
        * **STT 9a:** Hệ thống Thông báo lỗi: nếu lịch khám chủ nuôi đăng ký bị trùng lặp với lịch khám đã có trong hệ thống (System notifies error: if the registered appointment overlaps with an existing appointment in the system) [cite: 74]
    * **Hậu điều kiện:** Không (None) [cite: 74]
    * *** Dữ liệu đầu vào của thông tin cá nhân gồm các trường dữ liệu sau:**
        * **STT 1:** Tên thú cưng (Pet Name) - Có (Required) - Dog (Example) [cite: 75]
        * **STT 2:** Ngày khám (Examination Date) - Có (Required) - 30/7/2023 (Example) [cite: 75]
        * **STT 3:** Thời gian (Time) - Có (Required) - 11:00 (Example) [cite: 76]

**2. UC004 “CRUD thú cưng” (CRUD Pet)** [cite: 76]

* **Description:** This use case allows users (pet owners) to Create, Read, Update, and Delete information about their pets.
* **Table:**
    * **Mã Use case:** UC004 [cite: 76]
    * **Tên Use case:** CRUD thú cưng [cite: 76]
    * **Tác nhân:** Người dùng (User) [cite: 76]
    * **Tiền điều kiện:** Khách đăng nhập thành công với vai trò người dùng (Customer successfully logged in as a user) [cite: 76]
    * **Thêm (C):**
        * **Luồng sự kiện chính:**
            * **STT 1:** Người dùng Chọn chức năng thêm mời thông tin thú cưng (User selects the function to add new pet information) [cite: 76]
            * **STT 2:** Hệ thồng Hiển thị form input bao gồm name, category, age, color, gender (System displays input form including name, category, age, color, gender) [cite: 77]
            * **STT 3:** Người dùng Điền đầy đủ thông tin và nhấn nút thêm mới (User fills in all information and clicks the "Add New" button) [cite: 77]
            * **STT 4:** Hệ thống Kiểm tra tính hợp lệ (System checks validity) [cite: 77]
            * **STT 5:** Hệ thống Hiển thị thông báo thành công (System displays success message) [cite: 77]
        * **Luồng sự kiện thay thế:**
            * **STT 5a1:** Hệ thống Thông báo lỗi nếu người dùng nhập thiếu thông tin (System notifies error if user enters incomplete information) [cite: 77]
            * **STT 6a1:** Hệ thống Thông báo lỗi nếu thú cưng đã có (System notifies error if pet already exists) [cite: 77]
    * **Xem (R):**
        * **Luồng sự kiện chính:**
            * **STT 1:** Người dùng Chọn chức năng hiển thị thông tin thú cưng (User selects the function to display pet information) [cite: 78]
            * **STT 2:** Hệ thống Hiển thị danh sách các thú cưng (System displays a list of pets) [cite: 78]
            * **STT 3:** Người dùng Chọn 1 thú cưng để xem (User selects a pet to view) [cite: 78]
            * **STT 4:** Hệ thống Hiển thị chi tiết thông tin thú cưng (System displays detailed pet information) [cite: 78]
        * **Luồng sự kiện thay thế:**
            * **STT 3a:** Hệ thống Nếu không có thú cưng nào, hệ thống báo lỗi (If no pets exist, the system reports an error) [cite: 78]
    * **Cập nhât (U):**
        * **Luồng sự kiện chính:**
            * **STT 1:** Người dùng Chọn chức năng cập nhật thông tin thú cưng (User selects the function to update pet information) [cite: 78]
            * **STT 2:** Hệ thống hiển thị danh sách thú cưng (System displays a list of pets) [cite: 78]
            * **STT 3:** Người dùng Chọn 1 thú cưng để cập nhật thông tin (User selects a pet to update information) [cite: 79]
            * **STT 4:** Hệ thống Hiển thị form để người dùng cập nhật thông tin thú cưng (System displays a form for the user to update pet information) [cite: 79]
            * **STT 5:** Người dùng Cập nhật thông tin và nhấn nút cập nhật (User updates information and clicks the "Update" button) [cite: 79]
            * **STT 6:** Hệ thống Kiểm tra tính hợp lệ. Cập nhật thông tin (System checks validity. Updates information) [cite: 79]
        * **Luồng sự kiện thay thế:**
            * **STT 3a:** Hệ thống Nếu không có thú cưng, hệ thống hiển thị thông báo (If no pets exist, the system displays a message) [cite: 79]
            * **STT 7a:** Hệ thống Nếu thông tin không hợp lệ, đưa ra thông bóa cho người dùng (If the information is invalid, the system displays a notification to the user) [cite: 79]
    * **Xóa (D):**
        * **Luồng sự kiện chính:**
            * **STT 1:** Người dùng Chọn chức năng xóa thông tin thú cưng (User selects the function to delete pet information) [cite: 79]
            * **STT 2:** Hệ thống Hiển thị danh sách thú cưng (System displays a list of pets) [cite: 79]
            * **STT 3:** Người dùng Chọn 1 thú cưng để xóa (User selects a pet to delete) [cite: 79]
            * **STT 4:** Hệ thống Yêu cầu xác nhận (System requests confirmation) [cite: 80]
            * **STT 5:** Hệ thống Người dùng xác nhận xóa, hệ thống xóa thông tin thú cưng (User confirms deletion, system deletes pet information) [cite: 80]
        * **Luồng sự kiện thay thế:**
            * **STT 3a:** Hệ thống Nếu không có thú cưng nào, hệ thống đưa ra thông báo (If no pets exist, the system displays a message) [cite: 80]
            * **STT 6a:** Hệ thống Nếu người dùng không xác nhận, hệ thống không thực hiện xóa (If the user does not confirm, the system does not perform the deletion) [cite: 80]
    * **Hậu điều kiện:** Không (None) [cite: 80]
    * *** Dữ liệu đầu vào của thông tin cá nhân gồm các trường dữ liệu sau:**
        * **STT 1:** Tên thú cưng (Pet Name) - Có (Required) - Dog (Example) [cite: 81]
        * **STT 2:** Category - Có (Required) - Hoàng Anh (Example) [cite: 81]
        * **STT 3:** Age - Có (Required) - 10 (Example) [cite: 81]
        * **STT 4:** Color - Có (Required) - Red (Example) [cite: 81]

**3. UC005 “đăng ký dịch vụ trông giữ thú cưng” (Register for Pet Boarding Service)** [cite: 81]

* **Description:** This use case allows users (pet owners) to register for pet boarding services.
* **Table:**
    * **Mã Use case:** UC005 [cite: 81]
    * **Tên Use case:** Đăng ký dịch vụ trông giữ thú cưng [cite: 81]
    * **Tác nhân:** Người dùng (User) [cite: 81]
    * **Tiền điều kiện:** Khách đã đăng nhập thành công với vai trò người dùng (Customer has successfully logged in as a user) [cite: 82]
    * **Luồng sự kiện chính (Thành công):**
        * **STT 1:** Người dùng chọn chức năng Dịch vụ trông giữ (User selects the "Pet Boarding Service" function) [cite: 82]
        * **STT 2:** Hệ thống hiển thị giao diện Dịch vụ trông giữ (System displays the "Pet Boarding Service" interface) [cite: 82]
        * **STT 3:** Người dùng chọn vào chức năng Đăng ký dịch vụ (User selects the "Register for Service" function) [cite: 82]
        * **STT 4:** Hệ Thống hiển thị bảng giao diện Đăng ký dịch vụ (System displays the "Register for Service" interface table) [cite: 82]
        * **STT 5:** Người dùng nhập các thông tin đăng ký (mô tả phía dưới *) (User enters registration information (described below *)) [cite: 82]
        * **STT 6:** Người dùng Yêu cầu đăng ký (User requests registration) [cite: 83]
        * **STT 7:** Hệ thống kiểm tra xem khách đã nhập các trường bắt buộc nhập hay chưa (System checks if the customer has entered all required fields) [cite: 83]
        * **STT 8:** Hệ thống lưu thông tin đăng ký và thông báo đăng ký thành công (System saves registration information and notifies successful registration) [cite: 83]
    * **Luồng sự kiện thay thế:**
        * **STT 7a:** Hệ thống Thông báo lỗi nếu người dùng nhập thiếu thông tin (System notifies error if user enters incomplete information) [cite: 84]
    * **Hậu điều kiện:** Không (None) [cite: 84]
    * *** Dữ liệu đầu vào của thông tin cá nhân gồm các trường dữ liệu sau:**
        * **STT 1:** Tên thú cưng (Pet Name) - Có (Required) - dog (Example) [cite: 85]
        * **STT 2:** Ngày (Date) - Có (Required) - 30/7/2023 (Example) [cite: 85]
        * **STT 3:** Thời gian (Time) - Có (Required) - 11:00 (Example) [cite: 85]

**4. UC006 “đăng ký dịch vụ vệ sinh” (Register for Grooming Service)** [cite: 85]

* **Description:** This use case is identical to UC005, allowing users (pet owners) to register for grooming services.
* **Table:** Giống như UC005 (Same as UC005) [cite: 85]


--- Prompt 5:
Read the project code carefully and focus on fixing the Services. Have a look and also fix these services:
Please note that ALL DATE SELECTION BOX MUST BE IMPLEMENTED IN THE CALENDAR VIEW TO CHOOSE DATE, NOT THE SCROLL BAR OF CUPERTINO DESIGN. FIX THEM ALL FOR START DATE AND END DATE. THE PET SELECTION BOX IN THE SERVICES ARE ALL BROKEN AS WELL.

1. Pet Health Examination: unloadable, causing Flutter red screen error.
2. Vaccination Service: cannot select pet (problem with Cupertino on web app deployment), Service Date cannot be chosen. Because the Select Pet box is currently broken, focus on fixing it.
3. Pet Boarding Service: cannot select pet (problem with Cupertino on web app deployment), Service Date cannot be chosen. Because the Select Pet box is currently broken, focus on fixing it.
4. Pet Daycare: cannot select pet (problem with Cupertino on web app deployment), Service Date cannot be chosen. Because the Select Pet box is currently broken, focus on fixing it.
5. Pet Grooming Service: cannot select pet (problem with Cupertino on web app deployment), Service Date cannot be chosen. Because the Select Pet box is currently broken, focus on fixing it.
6. Dental Cleaning: cannot select pet (problem with Cupertino on web app deployment), Service Date cannot be chosen. Because the Select Pet box is currently broken, focus on fixing it.
7. Emergency Treatment: cannot select pet (problem with Cupertino on web app deployment), Service Date cannot be chosen. Because the Select Pet box is currently broken, focus on fixing it.
8. Surgery Consulation: cannot select pet (problem with Cupertino on web app deployment), Service Date cannot be chosen. Because the Select Pet box is currently broken, focus on fixing it.