# Home-care management / Gestión de atención domiciliaria

[English](#english) · [Español](#español)

## English

Archived ASP.NET application for coordinating home visits, care teams and service records

> [!WARNING]
> **Status: Archived.** This snapshot preserves an earlier edition. Its build instructions identify the requirements and checks for this cut.

### Overview

This cut records the home-care application as archived on 2012-07-04.

The application keeps the records used to arrange visits and coordinate the people providing care.


### Features in the retained source

- Open the batch admission screen to process patient admissions. `admisiones/amasivas.aspx`.
- Retrieve images linked to the clinical files in this edition. `archivo/foto.ashx`.
- Open the patient record and its care information. `paciente/paciente.aspx`.
- Open the staff record for the care team. `rh/funcionario.aspx`.
- View and maintain access groups. `administrador/grupos.aspx`.
- Manage the operator accounts used to sign in. `administrador/usuario.aspx`.
- List cases that are waiting to be scheduled. `programacion/sinprogramar.aspx`.
- Start from the census to review cases recorded in the site. `censo/Default.aspx`.

### Build and local use

On Windows, install PowerShell 7, the .NET SDK, .NET Framework 4.8, IIS Express, Python 3, Git and Docker. The recovered Web Forms site for 2012-07-04 uses its source project and `demo/Build.ps1`. The script builds the shared library and precompiles the site into a new directory.

```powershell
pwsh -NoProfile -File demo/Build.ps1 -Output <new-directory>
```

For a fictional sign-in, install Playwright for Python with its Chromium browser and run `python demo/run-local-webforms.py`. Set `DOMICILIO_CHROMIUM` to a local Chromium executable if you use an existing installation. Load the MySQL 5.7 and SQL Server Developer images pinned by the script before running it. The script creates two disposable local database servers, starts IIS Express on loopback, checks the fictional sign-in and removes its containers afterward.

The July 2012 demo starts IIS Express with Debug enabled in its disposable copy. The archived code redirects the home page in Release. In Debug, the trial reaches the protected page and MySQL records the fictional sign-in. The demo creates empty task tables in its SQL Server container so the home page can load its task panel. The scheduling and reporting pages still require a separate test.

The build restores iTextSharp 5.2.0 from the official NuGet package and checks its SHA-256. Set `DOMICILIO_ITEXTSHARP_PACKAGE` to the same package for an offline build.

Set `DOMICILIO_SESSION_KEY_3` in the IIS process before signing in or using the recovered modules. Use independently generated fictional values for a disposable test.

The 2026 reconstruction restores the Web Forms project and its shared library. It recovers the management scheduling page’s search and row display handlers from the matching 4 July archive.

### Archive notes

The archive inventory counted 1 additions, 2 edits and 0 removals.

### Framework versions

The original Web Site does not declare a framework in a project file. The verified recovery uses .NET Framework 4.8.

### Usage

Use the documented local build with a fictional operator. The available screens include `admisiones/amasivas.aspx` and the other routes above.

The retained entry page is `administrador/Default.aspx`. Connect the matching local edition to an isolated database with a fictional operator before attempting a protected view.

### License

The application’s own code uses the [MIT license](LICENSE).

### Contributing

For documentation or build changes, describe the archived edition and include the steps to reproduce your result.

### Support

For build or demo questions, open an issue with the commit, tool version and command. Remove private data from attached logs.

### History

Use the commit history to compare this snapshot and the recovery notes with later editions.

---

## Español

Aplicación ASP.NET archivada para coordinar visitas domiciliarias, equipos de atención y registros del servicio

> [!WARNING]
> **Estado: archivado.** Esta copia conserva una edición anterior. Sus instrucciones de compilación indican los requisitos y las pruebas de este corte.

### Descripción general

Este corte conserva la versión de atención domiciliaria archivada el 2012-07-04.

La aplicación reúne los registros para organizar las visitas y coordinar al personal que presta la atención.


### Funciones en el código conservado

- Abre la pantalla de admisiones masivas para procesar ingresos de pacientes. `admisiones/amasivas.aspx`.
- Consulta las imágenes vinculadas a los archivos clínicos de esta edición. `archivo/foto.ashx`.
- Abre la ficha del paciente y su información de atención. `paciente/paciente.aspx`.
- Abre la ficha del personal del equipo de atención. `rh/funcionario.aspx`.
- Consulta y administra los grupos de acceso. `administrador/grupos.aspx`.
- Administra las cuentas de operador para ingresar. `administrador/usuario.aspx`.
- Consulta los casos pendientes de programación. `programacion/sinprogramar.aspx`.
- Empieza en el censo para consultar los casos registrados en el sitio. `censo/Default.aspx`.

### Compilación y uso local

En Windows instala PowerShell 7, el SDK de .NET, .NET Framework 4.8, IIS Express, Python 3, Git y Docker. El sitio Web Forms recuperado del 2012-07-04 usa su proyecto fuente y `demo/Build.ps1`. El script compila la biblioteca propia y precompila el sitio en una carpeta nueva.

```powershell
pwsh -NoProfile -File demo/Build.ps1 -Output <carpeta-nueva>
```

Para probar el ingreso ficticio, instala Playwright para Python con su navegador Chromium y ejecuta `python demo/run-local-webforms.py`. Indica `DOMICILIO_CHROMIUM` si usas un ejecutable de Chromium ya instalado. Carga antes las imágenes MySQL 5.7 y SQL Server Developer fijadas por el script. El script crea dos servidores desechables, arranca IIS Express en la interfaz local, comprueba el ingreso ficticio y retira los contenedores al terminar.

La demo de julio de 2012 arranca IIS Express con Debug habilitado en su copia desechable. El código archivado redirige la portada en Release. En Debug, la prueba abre la página protegida y MySQL registra el ingreso ficticio. La demo crea tablas de tareas vacías en su contenedor SQL Server para que la portada pueda cargar ese panel. Queda por probar el recorrido de las pantallas de programación e informes.

La compilación restaura iTextSharp 5.2.0 desde el paquete oficial de NuGet y coteja su SHA-256. Indica una copia del mismo paquete en `DOMICILIO_ITEXTSHARP_PACKAGE` para compilar sin Internet.

Define `DOMICILIO_SESSION_KEY_3` en el proceso de IIS antes de ingresar o usar los módulos recuperados. Genera valores ficticios independientes para una prueba desechable.

La reconstrucción de 2026 restaura el sitio Web Forms y su biblioteca propia. Recupera los eventos de búsqueda y presentación de resultados de la programación de gerencia del respaldo del 4 de julio.

### Notas del respaldo

El inventario del respaldo registró 1 adiciones, 2 cambios y 0 retiros.

### Versiones de .NET Framework

El sitio original no declara el framework en un archivo de proyecto. La recuperación verificada usa .NET Framework 4.8.

### Uso

Usa la compilación local documentada con un operador ficticio. Las pantallas disponibles incluyen `admisiones/amasivas.aspx` y las demás rutas de arriba.

La portada conservada es `administrador/Default.aspx`. Conecta la edición local a una base aislada con un operador ficticio antes de abrir una vista protegida.

### Licencia

El código propio usa la [licencia MIT](LICENSE).

### Contribuir

Si propones cambios de documentación o compilación, identifica la edición archivada e incluye los pasos para repetir el resultado.

### Soporte

Si tienes dudas sobre la compilación o la demostración, abre una incidencia con el commit, la versión de la herramienta y el comando. Retira los datos privados de los registros adjuntos.

### Historia

Consulta el historial de commits para comparar esta copia y sus notas de reconstrucción con las ediciones posteriores.
