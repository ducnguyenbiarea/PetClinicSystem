Problems with the front-end:


- All Bookings screen:
1. The Bookings screen is currently handling pet = N/A, which means it did not get the right pet that was chosen. And also, the service is managed by the service number, which seems odd. The service table should displays names of the service instead.
2. In the Booking screens, the Pet should not be chosen by inputting Pet ID but choose the Pet that was added in the Pets management screens.
3. The status button of the All Bookings is also trash. Add icon-based status button.

Delete the Quick Actions block of the code. Also delete the lines with similar to this:
" As a doctor, you can manage medical records, view all pets and bookings, and provide medical care."

Change the System Information in the Dashboard to Profile and make the box more colorful.


Owner problem:
The Owner did not see any Medical Records even though they own the pets. The Medical Records screen shows that there is no medical records, but there are actually real medical records in the database.

The same problems go with the screens above. Fix them all.

For Admin, Staff and Doctor, Based on the API provided, read the API docs and try to retrieve the numbers, such as total money of Booking services, etc,... you decide the most important analytics. add more types of Analytics, maybe to a new screen named Analytics. Display the analytics there.

----- Change it

The All Bookings screen still displays Pet as N/A pet. Which is completely wrong. Please fix that.

Please fix the colors of the Profile box for Staff and Admin. Choose a more dim color instead of orange and red. On the white background, they do not fit at all.

And also, the Revenue Analytics is now wrong. Maybe only the Admin should have Analytics screen, not Doctor or Staff. Fix that.

The revenue should be calculated by the total sum of money of the bookings. That is the source of money. Display that in the Revenue, calculated by the Start Date of any bookings. That is for date-based analytics.