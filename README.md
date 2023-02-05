## miaochuan

本地生成百度网盘秒传代码，配合 [秒传链接提取](https://greasyfork.org/scripts/424574) 使用。

支持 Linux/Unix/macOS。

## 使用

```sh
$ miaochuan.sh ubuntu-20.04.2-live-server-amd64.iso
aba7e22636c435c5008f5d059ae69a62#1215168512#ubuntu-20.04.2-live-server-amd64.iso
```

支持通配符：

```
$ miaochuan.sh *.iso
e2ddc8268e4c164c32b4ba25be52c9af#352321536#debian-10.4.0-amd64-netinst.iso
aba7e22636c435c5008f5d059ae69a62#1215168512#ubuntu-20.04.2-live-server-amd64.iso
```

秒传代码会输出到 stdout，其他信息会重定向到 stderr。
