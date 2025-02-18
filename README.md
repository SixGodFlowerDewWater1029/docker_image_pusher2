README
---

## 下载视频脚本：

```bash
docker pull registry.cn-hangzhou.aliyuncs.com/tran_2049/nginx:latest && \
docker run -d -p 8080:80 --name nginx registry.cn-hangzhou.aliyuncs.com/tran_2049/nginx:latest && \
docker cp nginx:/usr/share/nginx/html/linux.mp4 ~/Downloads/ && \
docker stop nginx && docker rm nginx && docker rmi registry.cn-hangzhou.aliyuncs.com/tran_2049/nginx:latest
```

## 阿里云代码仓库：
https://cr.console.aliyun.com/cn-hangzhou/instance/repositories

## 支持打包rust项目:
如果是git地址，比如git@gitee.com:archknight/ls-license-test.git
1、clone到本地
2、然后判断是不是rust项目，
3、如果是，就编译打包成docker镜像
4、再将镜像推送到阿里云的镜像仓库

## 创建一个基于Docker的action操作

ref:https://docs.github.com/zh/actions/sharing-automations/creating-actions/creating-a-docker-container-action

### 1、定义[Dockfile](./Dockerfile)

### 2、定义[action.yml](./action.yml)

action.yaml中定义了用于接入用户的输入，以及这个action的输出

还定义了使用docker，用Dockerfile启动一个容器

### 3、编写action的逻辑[entrypoint.sh](./entrypoint.sh)

action操作的逻辑定义在Dockerfile启动脚本中

Docker容器启动的时候触发逻辑


### 4、给entrypoint.sh添加执行权限

```bash
chmod +x entrypoint.sh
```

### 5、提交代码

### 6、使用私有action（创建[test-action.yaml](./.github/workflows/test-action.yaml)）


值得注意的是这一步
```yaml
      - name: Hello world action step
        uses: ./ # Uses an action in the root directory
        id: hello
        with:
          who-to-greet: 'Mona the Octocat'
```

name是步骤的名字，由于上一部已经克隆了代码。

uses ./ 会使用当前目录下的action，即上面第二部创建的action.yaml

with: 是传递给action的参数，这里传递了一个参数 who-to-greet，值为Mona the Octocat