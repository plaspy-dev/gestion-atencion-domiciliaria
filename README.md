# Home-care management / Gestión de atención domiciliaria

[English](#english) · [Español](#español)

## English

Archived ASP.NET application for coordinating home visits, care teams and service records

> [!WARNING]
> **Status: Archived.** This snapshot preserves an earlier edition. Its build instructions identify the requirements and checks for this cut.

### Overview

This cut records the home-care application as archived on 2012-07-14.

The application keeps the records used to arrange visits and coordinate the people providing care.


### Features in the retained source

- Open the staff record for the care team. `rh/funcionario.aspx`.
- Manage the operator accounts used to sign in. `administrador/usuario.aspx`.
- Open the batch admission screen to process patient admissions. `admisiones/amasivas.aspx`.
- Retrieve images linked to the clinical files in this edition. `archivo/foto.ashx`.
- Open the patient record and its care information. `paciente/paciente.aspx`.
- View and maintain access groups. `administrador/grupos.aspx`.
- List cases that are waiting to be scheduled. `programacion/sinprogramar.aspx`.
- Start from the census to review cases recorded in the site. `censo/Default.aspx`.

### Build and local use

This edition lacks an archived solution or project file. A standalone build requires the application entry point, its shared references and its ASP.NET configuration for this edition.

The retained site entry is `censo/Default.aspx`. Use fictional accounts and a disposable database on loopback.

### Archive notes

The archive inventory counted 1 additions, 21 edits and 1 removals.

### Framework versions

The archive does not record the original framework version. The local build recipe uses the ASP.NET Web Forms compiler for .NET Framework 4.x on Windows and the packages declared in this cut.

### Usage

Use the documented local build with a fictional operator. The available screens include `rh/funcionario.aspx` and the other routes above.

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

Este corte conserva la versión de atención domiciliaria archivada el 2012-07-14.

La aplicación reúne los registros para organizar las visitas y coordinar al personal que presta la atención.


### Funciones en el código conservado

- Abre la ficha del personal del equipo de atención. `rh/funcionario.aspx`.
- Administra las cuentas de operador para ingresar. `administrador/usuario.aspx`.
- Abre la pantalla de admisiones masivas para procesar ingresos de pacientes. `admisiones/amasivas.aspx`.
- Consulta las imágenes vinculadas a los archivos clínicos de esta edición. `archivo/foto.ashx`.
- Abre la ficha del paciente y su información de atención. `paciente/paciente.aspx`.
- Consulta y administra los grupos de acceso. `administrador/grupos.aspx`.
- Consulta los casos pendientes de programación. `programacion/sinprogramar.aspx`.
- Empieza en el censo para consultar los casos registrados en el sitio. `censo/Default.aspx`.

### Compilación y uso local

Esta edición carece de un archivo de solución o proyecto. Una compilación independiente requiere el punto de entrada, sus referencias compartidas y la configuración ASP.NET de este corte.

La entrada conservada del sitio es `censo/Default.aspx`. Usa cuentas ficticias y una base desechable en la interfaz local.

### Notas del respaldo

El inventario del respaldo registró 1 adiciones, 21 cambios y 1 retiros.

### Versiones de .NET Framework

El respaldo no registra la versión original del framework. La receta local usa el compilador de ASP.NET Web Forms para .NET Framework 4.x en Windows y los paquetes declarados en este corte.

### Uso

Usa la compilación local documentada con un operador ficticio. Las pantallas disponibles incluyen `rh/funcionario.aspx` y las demás rutas de arriba.

La portada conservada es `administrador/Default.aspx`. Conecta la edición local a una base aislada con un operador ficticio antes de abrir una vista protegida.

### Licencia

El código propio usa la [licencia MIT](LICENSE).

### Contribuir

Si propones cambios de documentación o compilación, identifica la edición archivada e incluye los pasos para repetir el resultado.

### Soporte

Si tienes dudas sobre la compilación o la demostración, abre una incidencia con el commit, la versión de la herramienta y el comando. Retira los datos privados de los registros adjuntos.

### Historia

Consulta el historial de commits para comparar esta copia y sus notas de reconstrucción con las ediciones posteriores.

## Recovered local build / Compilación local recuperada

The recovered Web Forms site is in `.`. Run `pwsh -NoProfile -File demo/Build.ps1 -Output <new-directory>` on Windows with .NET Framework 4.8 and the .NET SDK. The build recompiles the original shared library with its own activation optional and uses the sample Web.config in the copy.

El sitio Web Forms recuperado se encuentra en `.`. Ejecuta `pwsh -NoProfile -File demo/Build.ps1 -Output <carpeta-nueva>` en Windows con .NET Framework 4.8 y el SDK de .NET. La compilación reconstruye la biblioteca propia con la activación opcional y usa Web.config de ejemplo en la copia.

The build restores iTextSharp 5.2.0 from the official NuGet package and checks its SHA-256. Set `DOMICILIO_ITEXTSHARP_PACKAGE` to the same package for an offline build.

La compilación restaura iTextSharp 5.2.0 desde el paquete oficial de NuGet y coteja su SHA-256. Indica una copia del mismo paquete en `DOMICILIO_ITEXTSHARP_PACKAGE` para compilar sin Internet.

Set `DOMICILIO_SESSION_KEY_3` in the IIS process before signing in or using the recovered modules. Use independently generated fictional values for a disposable test.

Define `DOMICILIO_SESSION_KEY_3` en el proceso de IIS antes de ingresar o usar los módulos recuperados. Genera valores ficticios independientes para una prueba desechable.
