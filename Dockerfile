FROM eclipse-temurin:17.0.13_11-jdk

# 复制所需文件
COPY arthas-4.0.4.deb /tmp/
COPY lsmod_install.tar.gz postgresql-16.1.tar.gz /opt/

# 安装必要软件并配置系统
RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        busybox \
        dmidecode \
        dnsutils \
        fonts-dejavu \
        iputils-ping \
        iproute2 \
        netcat-openbsd \
        openssh-client \
        openssh-server \
        rsync \
        tcpdump \
        tzdata \
        zip \
        unzip \
        tar \
        telnet \
    # 安装Arthas
    && dpkg -i /tmp/arthas-4.0.4.deb \
    && rm -f /tmp/arthas-4.0.4.deb \
    # 解压并安装lsmod和PostgreSQL
    && cd /opt \
    && tar xzf lsmod_install.tar.gz \
    && tar xzf postgresql-16.1.tar.gz \
    && rm -f lsmod_install.tar.gz postgresql-16.1.tar.gz \
    && cd /opt/lsmod_install && ./install.sh \
    # 清理安装缓存
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    # 创建符号链接
    && ln -s /usr/bin/busybox /usr/bin/vi \
    && ln -s /usr/bin/busybox /usr/bin/less \
    && ln -s /usr/bin/busybox /usr/bin/ifconfig \
    # 设置时区
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    # 配置SSH
    && mkdir /var/run/sshd \
    && echo 'root:!#D4WGdmVorxgJ' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib64:/opt/pgsql/lib' >> /root/.bashrc \
    && echo 'export PATH=$PATH:/opt/java/openjdk/bin' >> /root/.bashrc

# 设置环境变量
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib64:/opt/pgsql/lib
ENV PATH=$PATH:/opt/java/openjdk/bin

# 创建启动脚本
RUN echo '#!/bin/bash\n\
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH\n\
export PATH=$PATH:/opt/java/openjdk/bin\n\
alias tailf="tail -f"\n\
exec /usr/sbin/sshd -D' > /start.sh \
    && chmod +x /start.sh

# 暴露 SSH 端口
EXPOSE 22

# 启动服务
CMD ["/start.sh"]