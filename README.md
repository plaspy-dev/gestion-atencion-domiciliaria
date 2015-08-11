# Home-care management / Gestión de atención domiciliaria

[English](#english) · [Español](#español)

## English

Archived ASP.NET application for coordinating home visits, care teams and service records

> [!WARNING]
> **Status: Archived.** This snapshot preserves an earlier edition. Its build instructions identify the requirements and checks for this cut.

### Overview

This cut records the home-care application as archived on 2015-08-11.

The application keeps the records used to arrange visits and coordinate the people providing care.


### Features in the retained source

- Review the list of therapeutic progress notes. `OrganizationExample15/terapeutico/evoluciones.aspx`.
- List cases that are waiting to be scheduled. `OrganizationExample15/programacion/sinprogramar.aspx`.
- Open the batch admission screen to process patient admissions. `OrganizationExample15/admisiones/amasivas.aspx`.
- List discharges from the wound-care clinic. `OrganizationExample15/clinicaheridas/egresos.aspx`.
- Record the wound assessment in the clinical record. `OrganizationExample15/clinicaheridas/valoracion.aspx`.
- Consult and maintain wound progression notes. `OrganizationExample15/clinicaheridas/evolucion.aspx`.
- Open the patient record and its care information. `OrganizationExample15/paciente/paciente.aspx`.
- Open the staff record for the care team. `OrganizationExample15/rh/funcionario.aspx`.
- View and maintain access groups. `OrganizationExample15/administrador/grupos.aspx`.
- Manage the operator accounts used to sign in. `OrganizationExample15/administrador/usuario.aspx`.

### Build and local use

On Windows, build the recovered Web Forms copy with `pwsh -NoProfile -File demo/Build.ps1 -Output <new-temp-folder>`. Use IIS Express and a separate MySQL instance for fictional data.

The retained site entry is `OrganizationExample15/Default.aspx`. Use fictional accounts and a disposable database on loopback.

### Archive notes

The archive inventory counted 1 additions, 11 edits and 1 removals.

### Framework versions

The archived descriptors declare these .NET Framework versions.

- .NET Framework 4.5 in `OrganizationExample15.sln`

### Usage

Use the documented local build with a fictional operator. The available screens include `OrganizationExample15/terapeutico/evoluciones.aspx` and the other routes above.

The retained entry page is `OrganizationExample15/Default.aspx`. Connect the matching local edition to an isolated database with a fictional operator before attempting a protected view.

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

Este corte conserva la versión de atención domiciliaria archivada el 2015-08-11.

La aplicación reúne los registros para organizar las visitas y coordinar al personal que presta la atención.


### Funciones en el código conservado

- Consulta el listado de notas de evolución terapéutica. `OrganizationExample15/terapeutico/evoluciones.aspx`.
- Consulta los casos pendientes de programación. `OrganizationExample15/programacion/sinprogramar.aspx`.
- Abre la pantalla de admisiones masivas para procesar ingresos de pacientes. `OrganizationExample15/admisiones/amasivas.aspx`.
- Consulta los egresos de la clínica de heridas. `OrganizationExample15/clinicaheridas/egresos.aspx`.
- Registra la valoración de heridas en la ficha clínica. `OrganizationExample15/clinicaheridas/valoracion.aspx`.
- Consulta y actualiza las notas de evolución de heridas. `OrganizationExample15/clinicaheridas/evolucion.aspx`.
- Abre la ficha del paciente y su información de atención. `OrganizationExample15/paciente/paciente.aspx`.
- Abre la ficha del personal del equipo de atención. `OrganizationExample15/rh/funcionario.aspx`.
- Consulta y administra los grupos de acceso. `OrganizationExample15/administrador/grupos.aspx`.
- Administra las cuentas de operador para ingresar. `OrganizationExample15/administrador/usuario.aspx`.

### Compilación y uso local

Los insumos conservados incluyen `OrganizationExample15.sln`. Abre la solución o el proyecto en un entorno de desarrollo de Visual Studio y .NET Framework compatible con el corte. Recupera las referencias compartidas, los paquetes y la configuración de ASP.NET de esta edición antes de usar MSBuild.

La entrada conservada del sitio es `OrganizationExample15/Default.aspx`. Usa cuentas ficticias y una base desechable en la interfaz local.

### Notas del respaldo

El inventario del respaldo registró 1 adiciones, 11 cambios y 1 retiros.

### Versiones de .NET Framework

Los descriptores archivados declaran estas versiones de .NET Framework.

- .NET Framework 4.5 en `OrganizationExample15.sln`

### Uso

Usa la compilación local documentada con un operador ficticio. Las pantallas disponibles incluyen `OrganizationExample15/terapeutico/evoluciones.aspx` y las demás rutas de arriba.

La portada conservada es `OrganizationExample15/Default.aspx`. Conecta la edición local a una base aislada con un operador ficticio antes de abrir una vista protegida.

### Licencia

El código propio usa la [licencia MIT](LICENSE).

### Contribuir

Si propones cambios de documentación o compilación, identifica la edición archivada e incluye los pasos para repetir el resultado.

### Soporte

Si tienes dudas sobre la compilación o la demostración, abre una incidencia con el commit, la versión de la herramienta y el comando. Retira los datos privados de los registros adjuntos.

### Historia

Consulta el historial de commits para comparar esta copia y sus notas de reconstrucción con las ediciones posteriores.

## Recovered local build / Compilación local recuperada

The recovered Web Forms site is in `OrganizationExample15`. Run `pwsh -NoProfile -File demo/Build.ps1 -Output <new-directory>` on Windows with .NET Framework 4.8 and the .NET SDK. The build recompiles the original shared library with its own activation optional and uses the sample Web.config in the copy.

El sitio Web Forms recuperado se encuentra en `OrganizationExample15`. Ejecuta `pwsh -NoProfile -File demo/Build.ps1 -Output <carpeta-nueva>` en Windows con .NET Framework 4.8 y el SDK de .NET. La compilación reconstruye la biblioteca propia con la activación opcional y usa Web.config de ejemplo en la copia.

The build restores iTextSharp 5.4.4 from the official NuGet package and checks its SHA-256. Set `DOMICILIO_ITEXTSHARP_PACKAGE` to the same package for an offline build.

La compilación restaura iTextSharp 5.4.4 desde el paquete oficial de NuGet y coteja su SHA-256. Indica una copia del mismo paquete en `DOMICILIO_ITEXTSHARP_PACKAGE` para compilar sin Internet.

Restore the Boolean insert overload in the shared Query class. The patient form keeps its original replacement behavior.

Recupera la sobrecarga booleana de inserción en la clase Query compartida. El formulario de pacientes conserva su comportamiento de reemplazo.
