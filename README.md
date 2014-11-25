# Home-care management / Gestión de atención domiciliaria

[English](#english) · [Español](#español)

## English

Archived ASP.NET application for coordinating home visits, care teams and service records

> [!WARNING]
> **Status: Archived.** This snapshot preserves an earlier edition. Its build instructions identify the requirements and checks for this cut.

### Overview

This cut records the home-care application as archived on 2014-11-25.

The application keeps the records used to arrange visits and coordinate the people providing care.


### Features in the retained source

- Open the batch admission screen to process patient admissions. `OrganizationExample15 .net-3.5/admisiones/amasivas.aspx`.
- Record the wound assessment in the clinical record. `OrganizationExample15 .net-3.5/clinicaheridas/valoracion.aspx`.
- Consult and maintain wound progression notes. `OrganizationExample15 .net-3.5/clinicaheridas/evolucion.aspx`.
- Open the patient record and its care information. `OrganizationExample15 .net-3.5/paciente/paciente.aspx`.
- Open the staff record for the care team. `OrganizationExample15 .net-3.5/rh/funcionario.aspx`.
- View and maintain access groups. `OrganizationExample15 .net-3.5/administrador/grupos.aspx`.
- Manage the operator accounts used to sign in. `OrganizationExample15 .net-3.5/administrador/usuario.aspx`.
- List cases that are waiting to be scheduled. `OrganizationExample15 .net-3.5/programacion/sinprogramar.aspx`.
- Open purchase orders for pharmacy supplies. `OrganizationExample15 .net-3.5/farmacia/ordendecompra.aspx`.
- Consult the pharmacy reports for this edition. `OrganizationExample15 .net-3.5/farmacia/informes.aspx`.

### Build and local use

On Windows, build the recovered Web Forms copy with `pwsh -NoProfile -File demo/Build.ps1 -Output <new-temp-folder>`. Use IIS Express and a separate MySQL instance for fictional data.

The retained site entry is `OrganizationExample15 .net-3.5/Default.aspx`. Use fictional accounts and a disposable database on loopback.

### Framework versions

The archive does not record the original framework version. The local build recipe uses the ASP.NET Web Forms compiler for .NET Framework 4.x on Windows and the packages declared in this cut.

### Usage

Use the documented local build with a fictional operator. The available screens include `OrganizationExample15 .net-3.5/admisiones/amasivas.aspx` and the other routes above.

The retained entry page is `OrganizationExample15 .net-3.5/Default.aspx`. Connect the matching local edition to an isolated database with a fictional operator before attempting a protected view.

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

Este corte conserva la versión de atención domiciliaria archivada el 2014-11-25.

La aplicación reúne los registros para organizar las visitas y coordinar al personal que presta la atención.


### Funciones en el código conservado

- Abre la pantalla de admisiones masivas para procesar ingresos de pacientes. `OrganizationExample15 .net-3.5/admisiones/amasivas.aspx`.
- Registra la valoración de heridas en la ficha clínica. `OrganizationExample15 .net-3.5/clinicaheridas/valoracion.aspx`.
- Consulta y actualiza las notas de evolución de heridas. `OrganizationExample15 .net-3.5/clinicaheridas/evolucion.aspx`.
- Abre la ficha del paciente y su información de atención. `OrganizationExample15 .net-3.5/paciente/paciente.aspx`.
- Abre la ficha del personal del equipo de atención. `OrganizationExample15 .net-3.5/rh/funcionario.aspx`.
- Consulta y administra los grupos de acceso. `OrganizationExample15 .net-3.5/administrador/grupos.aspx`.
- Administra las cuentas de operador para ingresar. `OrganizationExample15 .net-3.5/administrador/usuario.aspx`.
- Consulta los casos pendientes de programación. `OrganizationExample15 .net-3.5/programacion/sinprogramar.aspx`.
- Abre las órdenes de compra de insumos de farmacia. `OrganizationExample15 .net-3.5/farmacia/ordendecompra.aspx`.
- Consulta los informes de farmacia de esta edición. `OrganizationExample15 .net-3.5/farmacia/informes.aspx`.

### Compilación y uso local

Los insumos conservados incluyen `lib.net-3.5/componentes.sln`. Abre la solución o el proyecto en un entorno de desarrollo de Visual Studio y .NET Framework compatible con el corte. Recupera las referencias compartidas, los paquetes y la configuración de ASP.NET de esta edición antes de usar MSBuild.

La entrada conservada del sitio es `OrganizationExample15 .net-3.5/Default.aspx`. Usa cuentas ficticias y una base desechable en la interfaz local.

### Versiones de .NET Framework

El respaldo no registra la versión original del framework. La receta local usa el compilador de ASP.NET Web Forms para .NET Framework 4.x en Windows y los paquetes declarados en este corte.

### Uso

Usa la compilación local documentada con un operador ficticio. Las pantallas disponibles incluyen `OrganizationExample15 .net-3.5/admisiones/amasivas.aspx` y las demás rutas de arriba.

La portada conservada es `OrganizationExample15 .net-3.5/Default.aspx`. Conecta la edición local a una base aislada con un operador ficticio antes de abrir una vista protegida.

### Licencia

El código propio usa la [licencia MIT](LICENSE).

### Contribuir

Si propones cambios de documentación o compilación, identifica la edición archivada e incluye los pasos para repetir el resultado.

### Soporte

Si tienes dudas sobre la compilación o la demostración, abre una incidencia con el commit, la versión de la herramienta y el comando. Retira los datos privados de los registros adjuntos.

### Historia

Consulta el historial de commits para comparar esta copia y sus notas de reconstrucción con las ediciones posteriores.

## Recovered local build / Compilación local recuperada

The recovered Web Forms site is in `OrganizationExample15 .net-3.5`. Run `pwsh -NoProfile -File demo/Build.ps1 -Output <new-directory>` on Windows with .NET Framework 4.8 and the .NET SDK. The build recompiles the original shared library with its own activation optional and uses the sample Web.config in the copy.

El sitio Web Forms recuperado se encuentra en `OrganizationExample15 .net-3.5`. Ejecuta `pwsh -NoProfile -File demo/Build.ps1 -Output <carpeta-nueva>` en Windows con .NET Framework 4.8 y el SDK de .NET. La compilación reconstruye la biblioteca propia con la activación opcional y usa Web.config de ejemplo en la copia.

The build restores iTextSharp 5.4.4 from the official NuGet package and checks its SHA-256. Set `DOMICILIO_ITEXTSHARP_PACKAGE` to the same package for an offline build.

La compilación restaura iTextSharp 5.4.4 desde el paquete oficial de NuGet y coteja su SHA-256. Indica una copia del mismo paquete en `DOMICILIO_ITEXTSHARP_PACKAGE` para compilar sin Internet.

Set `DOMICILIO_SESSION_KEY_4` in the IIS process before signing in or using the recovered modules. Use independently generated fictional values for a disposable test.

Define `DOMICILIO_SESSION_KEY_4` en el proceso de IIS antes de ingresar o usar los módulos recuperados. Genera valores ficticios independientes para una prueba desechable.
