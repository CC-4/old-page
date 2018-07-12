---
layout: post
title: "Instalación de material"
comments: true
date:   2018-07-11 08:00:00 -0600
category: proyectos
numero: 0
descripcion: >
 Instrucciones para la instalación del material necesario para las asignaciones del proyecto
---

# Instalación de material CC4

Para poder realizar las fases del proyecto del compilador se requiere que utilicen una distribucion de linux por lo que se les proporcionarán dos opciones: descargar una máquina virtual con el contenido necesario, o si usted prefiere y tiene instalado alguna distribucion de linux, puede descargar solo el material en su computadora y no usar la máquina virtual.

El material que incluye es el código base que les servirá para poder comenzar las fases del proyecto, una versión de `spim` compatible con los programas de mips que genera cool, un compilador de `coolc` con el cual pueden comenzar a probar escribir programas en COOL.

Luego de tener instalado el material deben crear una carpeta donde guardarán su código y que contendrá cada una de las fases del proyecto. Esta carpeta se puede llamar como ustedes quieran, la carpeta debe contener las siguientes carpetas: 

* PA1
* PA2
* PA3
* PA4
* PA5

Cada una de estas carpetas corresponderá a una fase del proyecto. **Utilizaremos scripts automatizados para calificar por lo que si usted no respeta este convenio de nombres de carpetas, puede tener problemas con su nota.**

Después de haber realizado lo anterior, como se les mencionó en clase, el uso de GIT será **obligatorio**. Por lo tanto, dentro de la carpeta inicial (la cual nombraron como ustedes deseaban), deben iniciar un repositorio de GIT. 


```shell
git init
```

## Opcion 1: Descargar máquina virtual
La máquina virtual la pueden descargar desde cualquiera de los siguientes enlaces (ocupa 3.73Gb):

* [Google Drive](https://drive.google.com/file/d/0B5xlmAbvK4yAbFlRbUFBQnR3akk/view?usp=sharing)
* [MEGA](https://mega.nz/#!uQVWxLBa!5ILhjmsxK6dWBBNDEEyCHjccbbsA2dKmP-qwNOpcnSU)

Es una máquina virtual de Ubuntu 16.04 LTS para VMWare Workstation 12, después de descargar el archivo CC4.zip debe descomprimirlo y abrir el archivo `.ovf` con el cual le deberá salir una ventana para agregar la máquina virtual a su VMWare.

**Nota:** el password de la maquina virtual es `cool`

## Opcion 2: Instalar el material necesario en una computadora con linux
Deben ejecutar las siguientes lineas en la terminal: 

```shell
wget https://cc-4.github.io/proyectos/install_cc4.sh
chmod +x install_cc4.sh
. ./install_cc4.sh
```
esto descargará Java 8 (Oracle), Jlex, CUP, git y el código necesario para el proyecto.
**NOTA:** Si tienen problemas para usar spim y les sale un error que no se encuentra el archivo prueben ejecutar esta linea:
```shell
sudo apt-get install lib32z1 lib32ncurses5
```
