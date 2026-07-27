# rogue.sh

[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/) [![CodeFactor](https://www.codefactor.io/repository/github/1337spectra/rogue/badge)](https://www.codefactor.io/repository/github/1337spectra/rogue)

Rogue es un script de bash diseñado para simplificar los flujos de trabajo de pruebas de penetración para profesionales de la seguridad. Automatiza el proceso de escaneo con Nmap, configura Metasploit, ejecuta exploits, recolecta credenciales con John the Ripper, genera informes profesionales y realiza la limpieza. El script estandariza estos procesos para reducir el trabajo manual y permitir que los analistas se concentren en el análisis. Con solo una dirección IP como entrada, el script pretende optimizar los procesos, permitiendo al mismo tiempo que los usuarios experimentados personalicen los escaneos o omitan los comportamientos predeterminados según sea necesario.


## Dependencias

- Kali Linux.
- Bash shell.
- Privilegios de root para el usuario que ejecuta el script.
- PostgreSQL y paquetes del cliente PostgreSQL.
- Utilidad `fdupes` para encontrar y eliminar archivos duplicados.
- `msfdb` para inicializar la base de datos de Metasploit.
- Herramienta de exploración de red `Nmap`.
- `git` para clonar el repositorio nmap-parse-output.
- `wget` para descargar el plugin de Metasploit `db_autopwn.rb`.
- Metasploit Framework.
- Herramienta de craqueo de contraseñas John the Ripper.

## Características

- Automatiza un flujo de trabajo de pentesting de extremo a extremo a través de múltiples funciones.
- Escanea el objetivo con Nmap para identificar servicios y vulnerabilidades.
- Importa los resultados del escaneo en Metasploit para la explotación.
- Ejecuta exploits y craqueo de credenciales para obtener acceso inicial.
- Extrae archivos, contraseñas y otra inteligencia del SO.
- Identifica y establece sesiones con privilegios elevados.
- Genera informes a partir de los datos de escaneo y post-explotación.
- El diseño modular permite la personalización de los pasos.
- Utiliza herramientas principales de pentesting como Nmap, Metasploit y John.
- Empaqueta los resultados para su análisis mientras limpia los artefactos.

## Instalación

Abre una terminal y clona el proyecto.

```bash
  git clone https://github.com/1337spectra/rogue.git
```

Navega al directorio donde se clonó el script.

```bash
  cd rogue
```

Haz que el script sea ejecutable.

```bash
  chmod +x rogue.sh
```

## Uso

1. Ejecuta el script como root:

```bash
  sudo ./rogue.sh
```

2. Ingresa la dirección IP del objetivo cuando se te solicite.

```bash
  [!] Enter Target IP Address: 127.0.0.1
```

**Nota**: Por favor, asegúrate de que el script se ejecute con privilegios de root, ya que algunos comandos requieren acceso administrativo.

## Estructura de Archivos

El script crea los siguientes directorios:

1. `reports`: Contiene el resultado del escaneo Nmap en XML y el informe HTML generado.
2. `modules`: Contiene los archivos `auto.rc`, `post.rc` y `creds.rc` utilizados en Metasploit Framework.
3. `creds`: Contiene las credenciales craqueadas y el archivo de credenciales combinadas.
4. `files`: Contiene los archivos extraídos del sistema objetivo.

```
	Pentest
	├── reports
	│   ├── Nmap XML scan result
	│   └── Generated HTML report
	├── modules
	│   ├── auto.rc
	│   ├── post.rc
	│   └── creds.rc
	├── creds
	│   ├── Cracked credentials
	│   └── Combined credentials
	└── files
	    └── Extracted files from target
```

### Salida

Al final de la ejecución del script, se muestra la siguiente salida:

```bash
[!] Pentest done. All reports, files, and credentials can be found in 'Pentest'.
```

El directorio `Pentest` se creará en el mismo directorio que el script y contendrá todos los informes, archivos y credenciales generados.

## Documentación

Esta documentación proporciona una visión general de cada función en el script de pruebas de penetración, detallando qué está diseñada para hacer y cómo logra esos objetivos. Las funciones trabajan juntas para llevar a cabo sistemáticamente el proceso general de prueba de principio a fin.

![](https://mermaid.ink/img/pako:eNqNVFtv2jAU_itHlipeKCIBBs3DpnKHlq6CTpPm9MFNDFglTuQ4LRTx33diA01Zi-aHKD637_O5bUkQh5x45OJiK6TQHmxLeskjXvJKIVPPpd3u4sKX81X8GiyZ0vDQ9SXgSbOnhWLJEq6BzjRqHq2cy9CXJyZtoJ0lD55hGscafqVc7Y3z03boKDVCo_7xCJeX36Ht0t5aaBBzuEOfXHMGoAN0hOQFW4k3Dj35IlQsIy51Aafj0BnXWQJdoXigYyV4arE6btF7xtWLCFD3NVwXaFekyYptoM2kROZMhtBZcaZgFijOZQG369APGgPZdU8inEHr5Y9LMkw9UwuuYXRfiN5zaE9qZHCq_CxSH-g0k3AXsQTZsCLLPsZZ8yDTvKA2VPsunbEXDlOeZit9Li0D2Gd4wjXDx8VYv9-xek4TFvAC1sAp5nsy60OXafbEUm4RBy7tKM6Qyqn3Z6hDoAW8aQf6YsXBBBBx8YlD5xCWZTquqMCiDY9oSZzqd3HtIMayhWku_5rDyCa2tzYkUngVelnIQoHEyKG3MQs_Uhi5x-Rfo_wYZ6-tWZcP9EZ1eo_3g6l5K8w0Tw5ODet0JG-l3-iESbYw-QlxPrAG5yo6Bjrg2J0madjiP9WCybxoU57E6tgM-Rk776bDh8nt3gTmKo5MS1kGY9dMg8QueeARWjC1MRXb8x7X6CmIHa7_4nsDOA3hvwbXdqfYabcDaL492-G262zZbZ4sF_O98SUpk4iriIkQF-U2D-kTsyR94uFvvid94ssd2uV1nW1kQDytMl4mWRJiRrqCIcGIeHPkj9KEyT9xHB2M8Eq8LVkTz6nXKq2rerNZb9acRrNWd8tkQ7xLp1p3K45ba9WqbqtZbVw1d2XyZkK4lbrjokOr6riNutt0G2XCQ4ELbmI3u1nwu7959dlw?type=png)

### initialize()

La función initialize() configura el entorno y las herramientas necesarias para la evaluación. Primero verifica que el script se esté ejecutando con privilegios de root. Luego realiza actualizaciones del sistema, instala paquetes requeridos como PostgreSQL e inicia los servicios relevantes. Se crean directorios críticos para informes, módulos, credenciales y archivos. La función clona un repositorio de GitHub que contiene un analizador de Nmap y descarga herramientas adicionales de repositorios en línea. Finalmente, establece los permisos de archivos y las variables de ruta para completar la etapa de inicialización.

**Pseudocódigo**:

```
Check if root, update packages
Install required packages like PostgreSQL
Start PostgreSQL service
Initialize MSF db
Create directories for reports, modules, creds, files
Clone Nmap parsing repo, download plugins
Set directory permissions
```

### banner()

**Pseudocódigo**:

```
Print colorful banner text with project info
```

### nmapScan()

Un escaneo de Nmap es esencial para el descubrimiento y la identificación de vulnerabilidades. La función nmapScan() ejecuta un escaneo exhaustivo del sistema objetivo utilizando varias banderas de Nmap, ejecuta scripts de descubrimiento adicionales y envía los resultados a un informe XML. Este informe centralizado, guardado en el directorio de informes, proporciona información valiosa sobre el objetivo para el resto del proceso de prueba.

**Pseudocódigo**:

```
Print scan starting message
Run Nmap on target with specified flags
Save XML results
Print scan complete message
```

### msfSetup()

Esta función prepara el framework Metasploit para acciones de explotación y post-explotación. Importa los datos XML de Nmap en la base de datos de Metasploit, actualiza la lista de hosts, configura opciones como la IP del host local y, finalmente, sale de msfconsole. Estos pasos preparatorios integran el reconocimiento del objetivo en Metasploit para permitir su uso automatizado en las funciones posteriores.

**Pseudocódigo**:

```
Print setup starting message
Import Nmap XML, reload hosts in MSF
Set LHOST, save config
Print setup done message
```

### createAuto()

Basándose en los resultados de nmapScan() y msfSetup(), la función createAuto() genera un script de automatización. Este script aprovecha el plugin `db_autopwn` de Metasploit para descubrir y explotar objetivos automáticamente. Al obtener el acceso, identifica sesiones, incluidas aquellas con privilegios elevados. También se encadenan acciones de post-explotación como la recolección de credenciales. El resultado final es un módulo que lleva a cabo metódicamente la fase de explotación con una interacción mínima.

**Pseudocódigo**:

```
Create auto.rc file in modules dir
Write commands to file:
- Import hosts, load plugin
- Run db_autopwn
- Run vsftpd exploit
- Get all sessions
- Filter for root sessions
- Run post.rc on root sessions
- Gather additional data
- Export results, clean up
- Exit MSF
```

### createPost()

Obtener información adicional de los hosts comprometidos es crítico. La función createPost() define un módulo de post-explotación de Metasploit para extraer inteligencia valiosa como hashes de contraseñas, configuraciones de red, historiales de usuario y más. Al finalizar, el objetivo queda totalmente perfilado basándose en lo que fue accesible únicamente a través de técnicas de post-explotación.

**Pseudocódigo**:

```
Create post.rc file in modules dir
Write commands to gather:
- Hashes, files, configs
- Container/VM data
- Credentials
- Exit MSF
```

### createCreds()

Con las credenciales extraídas, el paso final suele ser el craqueo de hashes para revertir las contraseñas. Esta función utiliza John the Ripper para la recuperación de contraseñas contra los archivos de hash. Las credenciales craqueadas se añaden luego a la base de datos de Metasploit, completando el ciclo completo de pruebas de penetración desde el descubrimiento de vulnerabilidades hasta el compromiso de credenciales.

**Pseudocódigo**:

```
Combine passwd, shadow files
Crack hashes with John
Add cracked creds to MSF db
Clean up files
```

### autopwn()

La función autopwn() inicia el proceso de explotación ejecutando el módulo de automatización `auto.rc` generado previamente. Esto impulsa la fase de explotación hasta su finalización de acuerdo con los pasos definidos en createAuto(), sin requerir intervención manual una vez iniciado.

**Pseudocódigo**:

```
Print running message
Run MSF with auto.rc
```

### report()

Para finalizar, la función report() utiliza la herramienta nmap-parse-output para transformar los datos detallados de Nmap XML en un informe HTML formateado. Esto condensa los resultados y hallazgos más relevantes en un entregable consumible para las partes interesadas.

**Pseudocódigo**:

```
Print parsing message
Generate HTML report from Nmap XML
Print report done message
```

### cleanup()

Ningún esfuerzo de prueba está completo sin la limpieza de artefactos. La función cleanup() elimina archivos duplicados, borra carpetas y archivos vacíos, procesa la salida de texto para los informes, elimina códigos de terminal y asegura que el entorno se restaure a su estado inicial; todos ellos pasos importantes de contención y Anti-Forense.

**Pseudocódigo**:

```
Print cleanup message
Remove duplicate files
Process text files
Generate extracted_files report
Strip terminal codes
Print cleanup done message
```

### mainf()

Todas las funciones anteriores son orquestadas centralmente por mainf(). Solicita el objetivo, llama a las funciones en secuencia y finalmente empaqueta los resultados para su entrega. Así, un proceso de prueba bien diseñado se define de principio a fin a través de esta función controladora y las funciones de componentes modulares debajo de ella.

**Pseudocódigo**:

```
Call all functions in sequence
Package results
Exit with finished message
```

## Limitaciones

- Rogue requiere habilidades básicas de pruebas de penetración para su uso y habilidades avanzadas para su personalización.
- No está diseñado para reemplazar las pruebas manuales, sino para estandarizar tareas rutinarias.
- La herramienta está destinada únicamente a uso educativo y no debe utilizarse para la explotación no autorizada de sistemas.
- La compatibilidad se limita a máquinas virtuales Metasploitable 2 y puede no funcionar con otras versiones o configuraciones.
- Rogue.sh está diseñado específicamente para Kali Linux y puede no funcionar correctamente en otros sistemas operativos.
- El plugin `db_autpwn` utilizado en el script está obsoleto en versiones más recientes de Metasploit.
- El script carece de una verificación o validación de errores exhaustiva.
- Las rutas hardcodeadas a las carpetas y archivos principales pueden causar problemas si se altera la estructura de directorios o si el script se ejecuta en una máquina diferente.
- El script asume que el usuario se está ejecutando bajo el nombre de usuario 'kali'.
- Rogue.sh genera una cantidad significativa de ruido de red durante su operación, lo que podría ser detectado por herramientas de monitoreo de red.

## Capturas de Pantalla

![Screenshot 1](https://rawcdn.githack.com/1337spectra/rogue/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/1.jpg)

![Screenshot 2](https://rawcdn.githack.com/1337spectra/rogue/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/2.jpg)

![Screenshot 3](https://rawcdn.githack.com/1337spectra/rogue/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/3.jpg)

![Screenshot 4](https://rawcdn.githack.com/1337spectra/rogue/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/4.jpg)

![Screenshot 5](https://rawcdn.githack.com/1337spectra/rogue/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/5.jpg)

## Autores

- Gabrielle Decker: [LinkedIn](https://www.linkedin.com/in/gabrielle-decker) [GitHub](https://1337spectra.github.io/) [CodePen](https://codepen.io/gndecker)


## Licencia

[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)

Este proyecto está licenciado bajo la GPL v3; consulta el archivo [LICENSE.txt](https://github.com/1337spectra/rogue/blob/main/LICENSE.md) para más detalles.

## Agradecimientos

* [db_autopwn.rb](https://github.com/hahwul/metasploit-autopwn)
* [Nmap](https://github.com/nmap/nmap)
* [Metasploit](https://github.com/rapid7/metasploit-framework)
