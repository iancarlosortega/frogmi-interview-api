# Frogmi Interview Project

## Prerequisites

Before you begin, make sure you have the following installed on your system:

- Ruby
- Rails
- Bundler gem

## Setup Instructions

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/iancarlosortega/frogmi-interview-api.git
    ```
 
2. **Navigate to the Directory:**

   ```bash
   cd frogmi-interview-api
   ```

3. **Install Dependencies:**

   ```bash
    bundle install
    ```

4. **Create the Database:**

    ```bash
    rails db:create
    ```

5. **Run Migrations:**

    ```bash
    rails db:migrate
    ```

6. **Seed the Database:**

    ```bash
    rails seed:usgs_earthquakes
    ```

7. **Start the Server:**

    ```bash
    rails server
    ```

8. **Open your browser and navigate to `http://localhost:3000` to view the application.**
