# Base image với OpenJDK 8 trên ARMv8
FROM arm64v8/openjdk:8-jre-slim

# Cài đặt các thư viện cần thiết
RUN apt-get update && \
    apt-get install -y \
        xvfb \
        x11vnc \
        xdotool \
        unzip \
        supervisor \
        fluxbox \
        novnc \
        websockify \
        git \
        wget && \
    apt-get clean

# Tạo thư mục làm việc
WORKDIR /microemulator

# Tải MicroEmulator
RUN wget -O microemulator.zip https://onboardcloud.dl.sourceforge.net/project/microemulator/microemulator/2.0.4/microemulator-2.0.4.zip?viasf=1 && \
    unzip microemulator.zip -d /microemulator && \
    rm microemulator.zip

# Tải và cài đặt noVNC
RUN git clone https://github.com/novnc/noVNC.git /noVNC && \
    ln -s /noVNC/vnc.html /noVNC/index.html

# Tạo thư mục ứng dụng
RUN mkdir -p /microemulator/app

# Tạo thư mục cấu hình Supervisor
RUN mkdir -p /etc/supervisor/conf.d

# Sao chép tệp cấu hình Supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Cổng VNC và noVNC
EXPOSE 5900 6080

# Khởi chạy Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
