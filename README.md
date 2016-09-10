# MageInstall tool

Tool for install/build Magento/Magento package from console.

## Composer installation

```shell
$ composer global require andkirby/mageinstall ^7.0@beta
```

## Features
### Package Building
Build Magento package. It takes your pure Magento copy and selected package and build them together.

### During installation

- base Magento install
- import products
- import system configuration
- add sample data SQL files
- add sample data media files
- clean up var directory and product media files cache before installation

# Building
## Using
Initializing.

`mageshell build init -d symlink -s stable -m /path/to/magento -c http://your-composer-satis.com/`

Building.

`mageshell build -p projectname -g somevendor/packagename:1.0.5 -i 1`

Package directory will be created automatically (if it's not set) by mask `%project_directory%-package`.

More info: `mageshell build --help`.

## Structure
Usually you may have following files structure:
```
  /any/path/to/magento                      - Pure Magento directory
  /yourdocroot
      /project.com-package                  - package files dir (will be created automatically)
      /project.com                          - project HTTP dir
  ~/.mageinstall/build/composer.json        - composer.json distributive file
```
# Install
## Using
### Initialization
If you haven't initialized **MageInstall** it will suggest you to initialize by command `mageshell install`.<br>
Anyway if what to make reinitialization follow the command:
```shell
$ mageshell install init
```
It will create the ~/.mageinstall/params.sh with your custom parameters.

### Install Magento
To run an installation of Magento instance you can make simple command:
```shell
$ mageshell install -p projectname
```
where

* "projectname" is a directory and DB name and DB user.

But it depends on your settings.

Also you may set up as you wish ~/.mageinstall/params.sh file within you local environment.
Just copy of params.sh.dist to ~/.mageinstall/params.sh and update it.

## Docs

- [Configuring parameters](doc/configuring.md)
