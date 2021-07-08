# Docker Image for XRDP, by [FEROX](https://ferox.yt)

![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/frxyt/xrdp.svg)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/frxyt/xrdp.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/frxyt/xrdp.svg)
![GitHub issues](https://img.shields.io/github/issues/frxyt/docker-xrdp.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/frxyt/docker-xrdp.svg)

This image packages XRDP and VNC.

* Docker Hub: https://hub.docker.com/r/frxyt/xrdp
* GitHub: https://github.com/frxyt/docker-xrdp

## Docker Hub Image

**`frxyt/xrdp`**

### Supported tags

* **`frxyt/xrdp:cinnamon`**: with [Cinnamon](http://developer.linuxmint.com/projects/cinnamon-projects.html)
* ~~**`frxyt/xrdp:gnome`**: with [GNOME](https://www.gnome.org/)~~
* ~~**`frxyt/xrdp:kde`**: with [KDE](https://kde.org/)~~
* **`frxyt/xrdp:latest`**: *without any desktop, only XRDP with VNC*
* **`frxyt/xrdp:lxde`**: with [LXDE](https://lxde.org/)
* **`frxyt/xrdp:mate`**: with [MATE](https://mate-desktop.org/)
* **`frxyt/xrdp:xfce`**: with [Xfce](https://www.xfce.org/)

## Usage

### Try it

1. Run an image with a pre-installed desktop:
   * Cinnamon: `docker run --rm -p 33890:3389 frxyt/xrdp:cinnamon`
   * ~~GNOME: `docker run --rm -p 33890:3389 frxyt/xrdp:gnome`~~
   * ~~KDE: `docker run --rm -p 33890:3389 frxyt/xrdp:kde`~~
   * LXDE: `docker run --rm -p 33890:3389 frxyt/xrdp:lxde`
   * MATE: `docker run --rm -p 33890:3389 frxyt/xrdp:mate`
   * Xfce: `docker run --rm -p 33890:3389 frxyt/xrdp:xfce`
1. Start a RDP client:
   * Windows: press `Win+R`, run `mstsc`, connect to: `localhost:33890`
1. Enter default credentials: user `debian`, password `ChangeMe`
1. Enjoy !

### Configurable environment variables

These environment variables can be overriden to change the default behavior of the image and adapt it to your needs:

| Name                     | Default value                                       | Example                                          | Description
| :------------------------| :-------------------------------------------------- | :----------------------------------------------- | :----------
| `FRX_APTGET_DISTUPGRADE` | ` ` *(Empty)*                                       | `1`                                              | Update installed packages
| `FRX_APTGET_INSTALL`     | ` ` *(Empty)*                                       | `midori terminator`                              | Packages to install with `apt-get`
| `FRX_CMD_INIT`           | ` ` *(Empty)*                                       | `echo 'Hello World !'`                           | Command to run before anything else
| `FRX_CMD_START`          | ` ` *(Empty)*                                       | `echo 'Hello World !'`                           | Command to run before starting services
| `FRX_LOG_PREFIX_MAXLEN`  | `6`                                                 | `10`                                             | Maximum length of prefix displayed in logs
| `FRX_XRDP_CERT_SUBJ`     | `/C=FX/ST=None/L=None/O=None/OU=None/CN=localhost`  | `/C=FR/ST=67/L=SXB/O=FRXYT/OU=IT/CN=xrdp.frx.yt` | XRDP certificate subject
| `FRX_XRDP_USER_NAME`     | `debian`                                            | `john.doe`                                       | Default user name
| `FRX_XRDP_USER_PASSWORD` | `ChangeMe`                                          | `myNOTsecretPassword`                            | Default user password
| `FRX_XRDP_USER_SUDO`     | `1`                                                 | `0`                                              | Add default user to `sudoers` if set to `1`
| `FRX_XRDP_USER_GID`      | `1000`                                              | `33`                                             | Default user ID (UID)
| `FRX_XRDP_USER_UID`      | `1000`                                              | `33`                                             | Default user group ID (GID)
| `FRX_XRDP_USER_COPY_SA`  | `0`                                                 | `1`                                              | Copy default icons to desktop if set to `1`
| `TZ`                     | `Etc/UTC`                                           | `Europe/Paris`                                   | Default time zone

### Example

#### Basic example

To run this image, you can use this sample `docker-compose.yml` file:

```yaml
php:
  image: frxyt/xrdp:xfce
  environment:
    - FRX_XRDP_USER_NAME=john.doe
    - FRX_XRDP_USER_PASSWORD=MyPassword
  ports:
    - "22000:22"
    - "3389:3389"
  volumes:
    - ./home:/home:rw
```

#### Full PHP development environment with Apache, MySQL, DBeaver and VS Code

1. Create this `docker-compose.yml` file:
   ```yaml
   version: '3.7'

   services: 
     xrdp:
       image: frxyt/xrdp:xfce
       environment:
         - |
           FRX_CMD_INIT=curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/packages.microsoft.gpg
           echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/   vscode.list
           curl -sSL https://dbeaver.io/debs/dbeaver.gpg.key | apt-key add -
           echo "deb https://dbeaver.io/debs/dbeaver-ce /" > /etc/apt/sources.list.d/dbeaver.list
         - |
           FRX_APTGET_INSTALL=apache2 libapache2-mod-php
           code
           dbeaver-ce
           default-mysql-server php-mysql php-pdo
           firefox-esr
           php php-bcmath php-cli php-common php-curl php-gd php-json php-mbstring php-pear php-xdebug php-xml php-zip
         - |
           FRX_CMD_START=
           rm -f /var/run/apache2/apache2.pid
           echo "UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root'; FLUSH PRIVILEGES;" > /etc/mysql/init.sql
           echo -e "[program:apache2]\ncommand=/usr/sbin/apache2ctl -DFOREGROUND" > /etc/supervisor/conf.d/apache2.conf
           echo -e "[program:mysqld]\ncommand=/usr/bin/mysqld_safe --init-file=/etc/mysql/init.sql" > /etc/supervisor/conf.d/mysqld.conf
       ports:
         - "22000:22"
         - "33890:3389"
   ```
1. Run `docker-compose up`

### Execute custom scripts upon startup

You can copy your executable scripts in `/frx/entrypoint.d/` and they'll be executed in alphabetical order right before `supervisor` is started.

### Start custom process in background

You can use `supervisor` to start them and place all the services you need as `.conf` files in `/etc/supervisor/conf.d/`.

## Build

```sh
docker build -f Dockerfile -t frxyt/xrdp:latest .
```

## License

This project and images are published under the [MIT License](LICENSE).

```
MIT License

Copyright (c) 2019 FEROX YT EIRL, www.ferox.yt <devops@ferox.yt>
Copyright (c) 2019 Jérémy WALTHER <jeremy.walther@golflima.net>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```