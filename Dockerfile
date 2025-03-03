FROM bitnami/minideb:latest

# 添加镜像信息
LABEL maintainer="Maintainer <maintainer@example.com>"
LABEL description="A secure SSH server with PostgreSQL and JDK 17 support"
LABEL version="1.0"

# 设置构建参数
ARG ROOT_PASSWORD=password

# 复制所需文件
COPY arthas-4.0.4.deb /tmp/
COPY lsmod_install.tar.gz postgresql-16.1.tar.gz /opt/

# 安装依赖包并配置系统
RUN set -ex \
    && install_packages openssh-server unzip telnet openjdk-17-jdk \
    && mkdir -p /var/run/sshd \
    && ssh-keygen -A \
    && echo "root:${ROOT_PASSWORD}" | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    # 安装并配置Arthas
    && dpkg -i /tmp/arthas-4.0.4.deb \
    && rm -f /tmp/arthas-4.0.4.deb \
    # 解压并安装lsmod和PostgreSQL
    && cd /opt \
    && tar xzf lsmod_install.tar.gz \
    && tar xzf postgresql-16.1.tar.gz \
    && rm -f lsmod_install.tar.gz postgresql-16.1.tar.gz \
    # 清理安装缓存
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 设置环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=${JAVA_HOME}/bin:${PATH}
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/lib64:/opt/pgsql/lib

# 创建启动脚本
RUN echo '#!/bin/bash
set -e

# 确保SSH服务正常运行
if [ ! -d "/var/run/sshd" ]; then
    mkdir -p /var/run/sshd
    chmod 0755 /var/run/sshd
fi

# 启动SSH服务
exec /usr/sbin/sshd -D' > /start.sh \
    && chmod +x /start.sh

# 暴露SSH端口
EXPOSE 22

# 使用启动脚本作为入口点
CMD ["/start.sh"]