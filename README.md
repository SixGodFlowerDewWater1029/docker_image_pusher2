
```bash
docker pull registry.cn-hangzhou.aliyuncs.com/tran_2049/nginx:latest && \
docker run -d -p 8080:80 --name nginx registry.cn-hangzhou.aliyuncs.com/tran_2049/nginx:latest && \
docker cp nginx:/usr/share/nginx/html/linux.mp4 ~/Downloads/
docker stop nginx && docker rm nginx
```

https://cr.console.aliyun.com/cn-hangzhou/instance/repositories