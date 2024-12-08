
```bash
docker pull registry.cn-hangzhou.aliyuncs.com/tran_2049/nginx:latest && \
docker run -d -p 8080:80 --name nginx registry.cn-hangzhou.aliyuncs.com/tran_2049/nginx:latest && \
docker cp nginx:/usr/share/nginx/html/linux.mp4 ~/Downloads/
docker stop nginx && docker rm nginx
```

https://cr.console.aliyun.com/cn-hangzhou/instance/repositories

支持打包rust项目:
如果是git地址，比如git@gitee.com:archknight/ls-license-test.git
1、clone到本地
2、然后判断是不是rust项目，
3、如果是，就编译打包成docker镜像
4、再将镜像推送到阿里云的镜像仓库
