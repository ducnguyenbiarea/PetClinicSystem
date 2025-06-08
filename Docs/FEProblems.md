Admin Screens problems:
1. All Bookings contain nothing. Please implement the All Bookings by connecting to the API related to booking in the Java Spring Boot backend.
2. Medical Records problem, cannot access the Medical Records screen and the Medical Records print nothing out. Please add this screen.
3. The taskbar is freezing everytime I press All Bookings and Medical Records. It is like these screens did not get completed in implementation. Sometimes the screen is completely freezing, sometimes these buttons are pressable.
4. We still cannot manage the users. Please add the user management to the admin page. 

Please refer to the API Documentation to implement these screens for admin and connect them to the right API of the backend. Please keep the Cupertino design and make the buttons pressible on web version of Flutter, without messing it up to scroll bars and change all calendar to pressible calendar instead of Apple's normal date selection design.


---- Problem 2:
The biggest problem is:
Navigating and pressing buttons but they are not responsive at all, they are just like pressing at dummy buttons. To navigate, we were forced to use the go back and go forward button of the browser to switch between pages. This is not cool at all.


We added Medical Records but the medical records did not get displayed on the medical records page at all. 

We did not get any booking display on our page and we cannot change the booking at all


-- Problem 3:
Remove the backend conneced successfully box and in the login screen, remove the test accounts buttons. This is Flutter frontend's problem only.



These errors may be caused by the highly security backend with JESSIONID cookies. Please read the backend and the API docs carefully before changing the frontend code. Please read them very carefully to tackle the problems. 
Staff screen problems:

2. The All Bookings screen of the Staff frontend shows no bookings, even though there are bookings available. Connect it to the Bookings part of the Spring Boot backend. Please, that is not a dummy screen. It should connect to real booking screens. Although there are 3 current bookings, it displays none. And even when we add bookings in this screen, it does not display a thing. 

Doctor screen problems:
1. The All Bookings screen of the Doctor frontend shows no bookings, even though there are bookings available. Connect it to the Bookings part of the Spring Boot backend. Please, that is not a dummy screen. It should connect to real booking screens. Although there are 3 current bookings, it displays none. And even when we add bookings in this screen, it does not display a thing. Please connect the screen correctly to the APIs related to the bookings. Look at the owner, they can clearly see which they book. But in the doctor and staff's case, they cannot see a thing.
2. The Medical Records display none. Go back to the frontend code of the owner's pages. you can see there are codes that assigned a medical record to the pet. It is related to the staff and the doctor, and you can see they are working in the owner's pages, while they are not working on the staff, admin and the doctor's pages, which is weird. Please carefully examine the code base to fix all of these nasty problems.



- In the Dashboard, the number are false. For example, it displays that there are 24 bookings. But I see no bookings available in the All Bookings tab. Also, it shows 5 pending bookings in the Dashboard but no actual pending bookings. It shows 18 medical records but is that correct? I am not sure. Sometimes, the buttons of the Navbar cannot be pressed. When hovering around them, my mouse remains a cursor without the chance to press them. They freeze. This is especially when switching to another tab and come back. Please fix the root of the Flutter frontend to get rid of this problem.




2. The All Bookings screen of the Staff frontend shows no bookings, even though there are bookings available. Connect it to the Bookings part of the Spring Boot backend. Please, that is not a dummy screen. It should connect to real booking screens.
3. The Medical Records screen does not display anything. Please display this screen by linking it to the API base of the backend, display all of existing medical records of the patients. 

Doctor screen problems:
1. Doctor should be able to see All Bookings as well. Add the Doctor's screens to All Bookings. And please fix that the All Bookings screen display nothing.
2. The Medical Records of the Doctor still displays nothing even though we can add Medical Records and it was displayed on the owner's Pet Management screens.



