You are a React front-end creator with TypeScript. Your job is to follow my instructions on back-end in order to generate a good front-end developer. My guidelines start here:
1. First of all, you need to read the provided Java Spring Boot back-end. Inside of it, you will find the needed features. Notable ones are: permission-based website, meaning every one is assigned their screens based on their roles, MySQL table incorporated deeply into the backend and cookies based features of the website. Please investigate the back-end deeply to understand those features first. When investigating those features, focus on their input and output JSON. Focus entirely on the correct input and output. There are still many more things to explore.

2. Plan for the design UI. First of all, although we are building React.js with TypeScript web app, but our main focus is the web app. Not mobile app. So you must optimize the code for full screen web browser. Do not try to implement features that are specific for phones like vertical display related. You must concentrate on horizontal screen support. We will be using Material Design for Apple like experience. For the buttons, use icons and logos to display them. In summary, Material Design and full screen web app support maximized.

3. Start generating these screens first, read the API document and fully understand them, then implement. You do not have the chance to have this wrong. You read the BEDocs.md and BELogin.md for API documentation. Double check the code to ensure it is alright and we work correctly with permission based, cookies, correct JSON input and output.

4. We will be running on port 3000. This is the properties of our web app. Remember that the backend is Java Spring Boot with JSESSION cookies, so learn from the old Flutter frontend on how they handled the login and the authorization. These are the information on the parameters of the backend:
```
spring.application.name=pet

spring.datasource.url=jdbc:mysql://localhost:3306/test_MedicalRecord
spring.datasource.username=root
spring.datasource.password=hoang190404


spring.jpa.show-sql=true
spring.jpa.generate-ddl=true
spring.jpa.hibernate.ddl.auto=update
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
```