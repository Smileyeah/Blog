## 使用OpenSSL生成新的证书并导出

### 生成证书命令

```
openssl req -newkey rsa:2048 -nodes -keyout xxx.xxxxxx.key -x509 -days 365 -out xxx.xxxxxx.cer
```

生成的过程中，一般会让你输入一些信息。如：  
```
Country Name (2 letter code) [AU]:CN
State or Province Name (full name) [Some-State]:GuangDong
Locality Name (eg, city) []:ShenZhen
Organization Name (eg, company) [Internet Widgits Pty Ltd]:explame
Organizational Unit Name (eg, section) []:explame
Common Name (e.g. server FQDN or YOUR name) []:explame
Email Address []:explame@explame.com
```
生成完毕后，文件夹下会出现两个文件`xxx.xxxxxx.key`和`xxx.xxxxxx.cer`。至此证书就生成成功了

### 导出证书命令

导出为pfx格式的证书。
```
openssl pkcs12 -export -in cas.clientservice.cer -inkey cas.clientservice.key -out cas.clientservice.pfx
```
