## miaochuan

本地生成百度网盘秒传代码，配合 ~~[秒传链接提取（已失效）](https://greasyfork.org/scripts/424574)~~ ~~[百度网盘秒传转存助手（已失效）](https://greasyfork.org/scripts/468633)~~ 目前暂无脚本使用。

支持 Bash / Zsh 等常见 Shell 环境，Windows 用户可以使用 Git Bash / WSL / Cygwin 等。

## 使用

```sh
$ miaochuan.sh ubuntu-20.04.2-live-server-amd64.iso
aba7e22636c435c5008f5d059ae69a62#9473c90c734bd4406f4f8d452b9fd759#1215168512#ubuntu-20.04.2-live-server-amd64.iso
```

支持通配符：

```sh
$ miaochuan.sh *.iso
e2ddc8268e4c164c32b4ba25be52c9af#4b75117359245f49840b1e5bce360f94#352321536#debian-10.4.0-amd64-netinst.iso
aba7e22636c435c5008f5d059ae69a62#9473c90c734bd4406f4f8d452b9fd759#1215168512#ubuntu-20.04.2-live-server-amd64.iso
```

秒传代码会输出到 stdout，其他信息会重定向到 stderr。

### 更多用法

```sh
$ miaochuan.sh -h
Usage: miaochuan.sh [<options>] <path>...
Print miaochuan code of file(s).

  -k            keep relative path(s)
  -c <dir>      change the directory before printing
  -s            print short miaochuan code
  -h            display this help and exit

Home page: <https://github.com/qianbinbin/miaochuan>
```

假设目录结构如下：

```
foo
├── bar
│   └── ubuntu-20.04.2-live-server-amd64.iso
└── debian-10.4.0-amd64-netinst.iso
```

递归生成 `foo` 目录下所有文件秒传：

```sh
$ miaochuan.sh foo
e2ddc8268e4c164c32b4ba25be52c9af#4b75117359245f49840b1e5bce360f94#352321536#debian-10.4.0-amd64-netinst.iso
aba7e22636c435c5008f5d059ae69a62#9473c90c734bd4406f4f8d452b9fd759#1215168512#ubuntu-20.04.2-live-server-amd64.iso
```

使用 `-k` 保留相对路径：

```sh
$ miaochuan.sh -k foo/debian-10.4.0-amd64-netinst.iso
e2ddc8268e4c164c32b4ba25be52c9af#4b75117359245f49840b1e5bce360f94#352321536#foo/debian-10.4.0-amd64-netinst.iso
```

使用 `-c` 进入 foo 目录，`-k` 保留相对路径，生成 `bar` 目录下所有文件秒传：

```sh
$ miaochuan.sh -c foo -k bar
aba7e22636c435c5008f5d059ae69a62#9473c90c734bd4406f4f8d452b9fd759#1215168512#bar/ubuntu-20.04.2-live-server-amd64.iso
```
