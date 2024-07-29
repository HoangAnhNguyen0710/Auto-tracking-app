# Sử dụng image chính thức của Python và Playwright
FROM mcr.microsoft.com/playwright/python:v1.31.1-focal

# Đặt thư mục làm việc trong container
WORKDIR /app

# Sao chép file requirements.txt vào thư mục làm việc
COPY requirements.txt /app/

# Cài đặt các gói Python
RUN pip install --no-cache-dir -r requirements.txt

# Cài đặt các phụ thuộc cần thiết cho Playwright
RUN apt-get update && apt-get install -y libatk1.0-0 libatk-bridge2.0-0 libdrm2 libatspi2.0-0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 libxkbcommon0 libasound2

# Sao chép mã nguồn ứng dụng vào thư mục làm việc
COPY . /app

# Cài đặt các trình duyệt cần thiết cho Playwright
RUN playwright install

# Mở cổng 8000 để ứng dụng FastAPI có thể truy cập
EXPOSE 8000

# Chạy lệnh để khởi động ứng dụng FastAPI
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
