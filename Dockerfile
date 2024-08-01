# Sử dụng hình ảnh cơ sở Python
FROM python:3.11

# Cài đặt Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Thêm Poetry vào PATH
ENV PATH="/root/.local/bin:${PATH}"

# Cài đặt các phụ thuộc hệ thống cần thiết cho Playwright
RUN apt-get update && apt-get install -y \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    libnss3 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libnspr4 \
    libpangocairo-1.0-0 \
    libpango-1.0-0 \
    libgtk-3-0 \
    libgbm1 \
    libasound2 \
    libxshmfence1 \
    libxkbcommon0 \
    libwayland-client0 \
    libwayland-server0 \
    fonts-liberation \
    libappindicator3-1 \
    && rm -rf /var/lib/apt/lists/*

# Thiết lập thư mục làm việc
WORKDIR /app

# Sao chép và cài đặt các phụ thuộc
COPY pyproject.toml poetry.lock* /app/
RUN poetry install --no-root

# Sao chép mã nguồn ứng dụng vào container
COPY . /app/

# Cài đặt Playwright trong môi trường Poetry
RUN poetry run pip install playwright

# Cài đặt Playwright
RUN poetry run playwright install

# Mở cổng 8000
EXPOSE 8000

# Lệnh để chạy ứng dụng
CMD ["poetry", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
