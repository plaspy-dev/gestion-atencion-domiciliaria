# Gestión de atención domiciliaria / Home care management

[English](#english) · [Español](#español)

## English

Archived ASP.NET application for coordinating home visits, care teams and service records

> [!WARNING]
> **Status: Archived.** This snapshot preserves an earlier edition. Use the requirements and checks in its guide.

### Overview

This cut records the home-care application as documented on 2026-11-18.

### Features

- Record postpartum care and follow-up in the maternal care module. `OrganizationExample15/materna/postparto.aspx`.
- Consult the maternal care report. `OrganizationExample15/materna/informe.aspx`.
- Open the batch admission screen to process patient admissions. `OrganizationExample15/admisiones/amasivas.aspx`.
- Review visit scheduling from the census. `OrganizationExample15/censo/censo_programacion.aspx`.
- Review the list of therapeutic progress notes. `OrganizationExample15/terapeutico/evoluciones.aspx`.
- List discharges from the wound-care clinic. `OrganizationExample15/clinicaheridas/egresos.aspx`.
- Record the wound assessment in the clinical record. `OrganizationExample15/clinicaheridas/valoracion.aspx`.
- Consult and maintain wound progression notes. `OrganizationExample15/clinicaheridas/evolucion.aspx`.
- Open the patient record and its care information. `OrganizationExample15/paciente/paciente.aspx`.
- Open the staff record for the care team. `OrganizationExample15/rh/funcionario.aspx`.

### What you can do

- Review intake, progress, and nursing records.
- Keep patient, staff, and service information in working forms.
- Includes web screens and separate branches for mobile and historical versions.

### Example

Use a fictional person and practice visit to walk through intake and locate the follow-up record. See the synthetic example in `demo/`.

### Getting started

The site uses historical ASP.NET. Review its pages and code in a Windows environment compatible with .NET Framework. To run locally, identify the connections the application uses and prepare an empty database with test data. Original connections, resources, and services are managed separately.

Entry points in the source. [`movil.sln`](movil.sln), [`OrganizationExample16.sln`](OrganizationExample16.sln).

History dates come from Git or available backup evidence. Reconstructed dates from files with no time zone use 12:00 UTC as a reference.

### Contributing

For documentation or build changes, describe the archived edition and include the steps to reproduce your result.

### Support

For build or demo questions, open an issue with the commit, tool version and command. Remove private data from attached logs.

### Usage

Use the documented local build with a fictional operator. The available screens include `OrganizationExample15/materna/postparto.aspx` and the other routes above.

The retained entry page is `OrganizationExample15.mvc.2018-11-21/censo/Default.aspx`. Connect the matching local edition to an isolated database with a fictional operator before attempting a protected view.

### History

Use the commit history to compare this snapshot and the recovery notes with later editions.

### License

[MIT License](LICENSE).

---

The local build precompiles the remaining Web Forms pages. The build recipe excludes pages that depend on archived controls that have not survived. The runtime test only checks local sign-in with a fictional account. It does not exercise the excluded pages, clinical forms, or external integrations. The 10 file exclusions in `demo/missing-controls.json` include `paciente/ingreso.aspx`, `paciente/ingreso.aspx.cs`, `paciente/evolucion.aspx`, `paciente/evolucion.aspx.cs`.

## Español

Aplicación ASP.NET archivada para coordinar visitas domiciliarias, equipos de atención y registros del servicio

> [!WARNING]
> **Estado: archivado.** Este corte conserva una edición anterior. Consulta los requisitos y las pruebas de su guía.

### Descripción general

Este corte conserva la versión de atención domiciliaria documentado el 2026-11-18.

### Funciones

- Registra la atención posparto y su seguimiento en el módulo materno. `OrganizationExample15/materna/postparto.aspx`.
- Consulta el informe de atención materna. `OrganizationExample15/materna/informe.aspx`.
- Abre la pantalla de admisiones masivas para procesar ingresos de pacientes. `OrganizationExample15/admisiones/amasivas.aspx`.
- Consulta la programación de visitas desde el censo. `OrganizationExample15/censo/censo_programacion.aspx`.
- Consulta el listado de notas de evolución terapéutica. `OrganizationExample15/terapeutico/evoluciones.aspx`.
- Consulta los egresos de la clínica de heridas. `OrganizationExample15/clinicaheridas/egresos.aspx`.
- Registra la valoración de heridas en la ficha clínica. `OrganizationExample15/clinicaheridas/valoracion.aspx`.
- Consulta y actualiza las notas de evolución de heridas. `OrganizationExample15/clinicaheridas/evolucion.aspx`.
- Abre la ficha del paciente y su información de atención. `OrganizationExample15/paciente/paciente.aspx`.
- Abre la ficha del personal del equipo de atención. `OrganizationExample15/rh/funcionario.aspx`.

### Qué puedes hacer

- Consulta fichas de ingreso, evolución y registros de enfermería.
- Centraliza información de pacientes, personal y servicios en formularios de trabajo.
- Incluye vistas web y variantes móviles e históricas en ramas separadas.

### Ejemplo

Usa una persona ficticia y una visita de prueba para recorrer el ingreso y consultar dónde se registra el seguimiento. Usa el ejemplo sintético de `demo/`.

### Cómo empezar

El sitio usa ASP.NET de su época. Revisa las páginas y su código en un entorno Windows compatible con .NET Framework. Para una ejecución local, identifica las conexiones que usa la aplicación y prepara una base vacía con datos de prueba. Las conexiones, recursos y servicios originales se gestionan por separado.

Puntos de entrada en el código. [`movil.sln`](movil.sln), [`OrganizationExample16.sln`](OrganizationExample16.sln).

Las fechas del historial se apoyan en Git o en la evidencia disponible de los respaldos. Las fechas reconstruidas a partir de archivos sin zona horaria usan las 12:00 UTC como referencia.

### Contribuir

Si propones cambios de documentación o compilación, identifica la edición archivada e incluye los pasos para repetir el resultado.

### Soporte

Si tienes dudas sobre la compilación o la demostración, abre una incidencia con el commit, la versión de la herramienta y el comando. Retira los datos privados de los registros adjuntos.

### Uso

Usa la compilación local documentada con un operador ficticio. Las pantallas disponibles incluyen `OrganizationExample15/materna/postparto.aspx` y las demás rutas de arriba.

La portada conservada es `OrganizationExample15.mvc.2018-11-21/censo/Default.aspx`. Conecta la edición local a una base aislada con un operador ficticio antes de abrir una vista protegida.

### Historia

Consulta el historial de commits para comparar esta copia y sus notas de reconstrucción con las ediciones posteriores.

### Licencia

[Licencia MIT](LICENSE).

## Session setup / Configuración de sesión

Set `DOMICILIO_SESSION_KEY`, `DOMICILIO_SESSION_KEY_2`, `DOMICILIO_SESSION_KEY_4` in the ASP.NET process environment before signing in. Generate independent values for your deployment. Use synthetic values in local tests.

Define `DOMICILIO_SESSION_KEY`, `DOMICILIO_SESSION_KEY_2`, `DOMICILIO_SESSION_KEY_4` en el entorno del proceso ASP.NET antes de iniciar sesión. Genera valores propios para tu instalación. Usa valores ficticios en las pruebas locales.

## Recovered local build / Compilación local recuperada

The recovered Web Forms site is in `OrganizationExample15.webforms`. Run `pwsh -NoProfile -File demo/Build.ps1 -Output <new-directory>` on Windows with .NET Framework 4.8 and the .NET SDK. The build compiles the compatible shared library from the recovered sources and uses the sample Web.config in the copy.

El sitio Web Forms recuperado se encuentra en `OrganizationExample15.webforms`. Ejecuta `pwsh -NoProfile -File demo/Build.ps1 -Output <carpeta-nueva>` en Windows con .NET Framework 4.8 y el SDK de .NET. La compilación compila la biblioteca propia compatible desde las fuentes recuperadas y usa Web.config de ejemplo en la copia.

The build restores iTextSharp 5.4.4 from the official NuGet package and checks its SHA-256. Set `DOMICILIO_ITEXTSHARP_PACKAGE` to the same package for an offline build.

La compilación restaura iTextSharp 5.4.4 desde el paquete oficial de NuGet y coteja su SHA-256. Indica una copia del mismo paquete en `DOMICILIO_ITEXTSHARP_PACKAGE` para compilar sin Internet.

The 2026 reconstruction restores archived Web Forms inputs and builds the compatible February 2016 copy of the owned shared library. The recipe excludes tracked views with missing patient controls from its disposable build. The fictional MySQL test verified sign-in and the protected home page with the historical grouping mode.

La reconstrucción de 2026 recupera insumos archivados de Web Forms y compila la copia compatible de febrero de 2016 de la biblioteca propia. La receta aparta de la copia desechable las vistas que requieren controles de paciente ausentes. La prueba con MySQL ficticio verificó el ingreso y la portada protegida con el modo histórico de agrupación.

La compilación local precompila las páginas Web Forms disponibles. La receta excluye las páginas que dependen de controles históricos que no se conservaron. La prueba de ejecución cubre solo el ingreso local con una cuenta ficticia. Quedan sin probar las páginas excluidas, los formularios clínicos y las integraciones externas. Las 10 exclusiones de archivos de `demo/missing-controls.json` incluyen `paciente/ingreso.aspx`, `paciente/ingreso.aspx.cs`, `paciente/evolucion.aspx`, `paciente/evolucion.aspx.cs`.

