# Task Service

## Setup and Execution Instructions for Task Service

### Prerequisites

- Ensure you have Docker and Docker Compose installed on your machine.

### Cloning the Repository

1. Clone the main project repository:

   ```bash
   git clone https://github.com/Raphaelbsi/task_service.git
   cd task_service
   ```

2. Clone the submodules for the microservices:
   ```bash
   git clone https://github.com/Raphaelbsi/auth_service.git
   git clone https://github.com/Raphaelbsi/notification_service.git
   git clone https://github.com/Raphaelbsi/scraping_service.git
   ```

### Building and Running the Services

3. Build and run the Docker containers:
   ```bash
   docker-compose up --build
   ```

### Database Setup

4. Run the migrations and seed the database for each service:

   - For the `main_app`:

     ```bash
     docker-compose exec main_app bundle exec rails db:create db:migrate
     ```

   - For the `auth_service`:

     ```bash
     docker-compose exec auth_service bundle exec rails db:create db:migrate db:seed
     ```

   - For the `notification_service`:

     ```bash
     docker-compose exec notification_service bundle exec rails db:create db:migrate
     ```

   - For the `scraping_service`:
     ```bash
     docker-compose exec scraping_service bundle exec rails db:create db:migrate
     ```

### Postman Collection

5. Use the provided Postman collection (located in the root of the project) to test the API endpoints. You can import the `task_service.postman_collection.json` file into Postman.

### Example Requests Using Curl

- **Login**

  ```bash
  curl --location 'http://localhost:3001/login'   --header 'Content-Type: application/json'   --data-raw '{"email": "test@example.com", "password": "password"}'
  ```

- **Create a Task**

  ```bash
  curl --location 'http://localhost:3000/tasks'   --header 'Content-Type: application/json'   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.mEJWMrdc0KptbXLg1xVjzrKo37J8uLS2-55t7ZHfgK8'   --data '{
    "task": {
            "title": "Cruze",
            "status": "pending",
            "url": "https://www.webmotors.com.br/comprar/bmw/118i/15-12v-gasolina-m-sport-steptronic/4-portas/2023/52659137?pos=c52659137g:&np=1&ct=1840177"
          }
  }'
  ```

- **View Created Task**

  ```bash
  curl --location 'http://localhost:3000/tasks'   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.mEJWMrdc0KptbXLg1xVjzrKo37J8uLS2-55t7ZHfgK8'
  ```

- **View Collected Data**

  ```bash
  curl --location 'http://localhost:3003/scraping_results'   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.mEJWMrdc0KptbXLg1xVjzrKo37J8uLS2-55t7ZHfgK8'
  ```

- **View Notifications**
  ```bash
  curl --location 'http://localhost:3002/notifications'
  ```

### Notes

- Ensure the `DATABASE_HOST`, `DATABASE_USER`, `DATABASE_PASSWORD`, and `DATABASE_NAME` environment variables are correctly set in each service's `Dockerfile` or `docker-compose.yml`.
- The Postman collection requires a valid JWT token for authentication. Replace `SEU_TOKEN` in the headers with a valid token.

With these steps, you should have all the services up and running, ready for testing and development.
