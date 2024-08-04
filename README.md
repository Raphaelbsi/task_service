
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

5. Use the provided Postman collection to test the API endpoints. You can import the collection into Postman using the link below:

   [Import Postman Collection](https://winter-eclipse-754259.postman.co/workspace/FolhaCCL~273bf4d1-5f5d-432c-9b6b-7c75ef8429a5/collection/13522477-d412fdf2-18f1-4dce-b629-bfdafec9ad75?action=share&source=collection_link&creator=13522477)

   The collection includes endpoints for:

   - Creating, updating, and deleting tasks.
   - Authenticating users.
   - Sending notifications.
   - Scraping data.

### Notes

- Ensure the `DATABASE_HOST`, `DATABASE_USER`, `DATABASE_PASSWORD`, and `DATABASE_NAME` environment variables are correctly set in each service's `Dockerfile` or `docker-compose.yml`.
- The Postman collection requires a valid JWT token for authentication. Replace `SEU_TOKEN` in the headers with a valid token.

With these steps, you should have all the services up and running, ready for testing and development.
