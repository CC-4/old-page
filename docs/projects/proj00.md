# Instalación del Material

Para poder realizar las fases del proyecto del compilador se requiere que utilicen una distribucion de Linux por lo que se les proporcionarán dos opciones:

1. Descargar una máquina virtual con el contenido necesario (*opción recomendada*).
2. Instalar una distribución de Linux y descargar e instalar el material en su computadora.

El material que se incluye es el código base que les serivirá para poder comenzar las fases del proyecto y una versión de **SPIM** compatible con los programas de MIPS que genera COOL, un compilador de COOL llamado **coolc** con el cual pueden comenzar a escribir programas en COOL y compilarlos.

Luego de tener instalado el material deben de crear una carpeta en donde guardarán su código y que contendrá cada una de las fases del proyecto. Esta carpeta se puede llamar como ustedes quieram la carpeta debe contener las siguientes carpetas:

* [x] **PA1** (_Análisis Léxico_)
* [x] **PA2** (_Análisis Sintáctico_)
* [x] **PA3** (_Análisis Semántico_)
* [x] **PA4** (_Generación de Código_)

Cada una de estas carpetas corresponderá a una fase del proyecto. **Utilizaremos scripts automatizados para calificar por lo que si usted no respeta este convenio de nombres de carpetas, puede tener problemas con su nota**.

Después de haber realizado lo anterior, como se les mencionó en clase, el uso de GIT será **obligatorio**. Por lo tanto, dentro de la carpeta inicial (la cual nombraron como ustedes deseaban), deben iniciar un repositorio de GIT.

```sh
git init
```

## Opción 1: Máquina Virtual

La máquina virtual la pueden descargar desde cualquiera de los siguientes enlaces (ocupa 3.73Gb):

* [Google Drive](https://drive.google.com/file/d/0B5xlmAbvK4yAbFlRbUFBQnR3akk/view?usp=sharing)
* [Mega](https://mega.nz/#!uQVWxLBa!5ILhjmsxK6dWBBNDEEyCHjccbbsA2dKmP-qwNOpcnSU)

Es una máquina virtual de **Ubuntu 16.04 LTS** para VMWare Workstation 12, después de descargar el archivo CC4.zip debe descomprimirlo y abrir el archivo .ovf con el cual le deberá salir una ventana para agregar la máquina virtual a su VMWare.

!!! note "Nota"
    La contraseña de la máquina virtual es **cool**.


## Opción 2: Instalar el Material

Para esta opción se asume que tienen ya una máquina con una distribución de Linux instalada, entonces en una terminal (pueden abrir una haciendo <kbd>CTRL</kbd><kbd>+</kbd><kbd>T</kbd>) tiene que escribir hacer lo siguiente:

```sh
wget https://cc-4.github.io/assets/install_cc4.sh
chmod +x install_cc4.sh
. ./install_cc4.sh
```

esto descargará Java 8 (Oracle), Jlex, CUP, git y el código necesario para el proyecto.

!!! note "Nota"
    Si tienen problemas para usar spim y les sale un error que no se encuentra el archivo prueben ejecutar esta linea:

    ```sh
    sudo apt install lib32z1 lib32ncurses5
    ```
