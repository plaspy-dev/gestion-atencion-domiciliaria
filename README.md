# Gestión de atención domiciliaria

[English](#english) · [Español](#español)

## English

Archived ASP.NET application for coordinating home visits, care teams and service records

> [!WARNING]
> **Status: Archived.** This snapshot preserves an earlier edition. Its build instructions identify the requirements and checks for this cut.

### Overview

Home-care teams can use the application to organise visits, refer to contact and service records, and coordinate the people who provide care.

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

### Requirements

Use Windows with .NET Framework 4.8, IIS Express and PowerShell 7 to build the archived Web Forms edition in the example. Its build script rebuilds the shared library and invokes the ASP.NET compiler. Use a disposable test database and fictional records.

### Getting started

The latest MVC projects target .NET Framework 4.6. Their missing historical shared helpers still prevent a complete build. The verified Web Forms editions build with the instructions below.

The test used the archived edition dated 2012-03-14. Export that commit into a separate local checkout and use a new output folder.

```powershell
git switch --detach 1c845eecac08
$output = Join-Path $env:TEMP ('webforms-demo-' + [guid]::NewGuid().ToString('N'))
pwsh -NoProfile -File demo/Build.ps1 -Output $output
```

### Usage

Use the documented local build with a fictional operator. The available screens include `OrganizationExample15/materna/postparto.aspx` and the other routes above.

Sign in as a fictional care-team operator and open the local site. The verified trial issued a session cookie and logged the operator’s sign-in in disposable MySQL. The trial also provided a local SQL Server with a fictional navigation entry.

### Verification

The archived example was compiled from its own source and used only local services. The coverage is the sign-in and its database activity. Other screens and external service integrations require separate tests.

### Project structure

`OrganizationExample15/` and `OrganizationExample15.mvc.2018-11-21/` contain the MVC editions. `OrganizationExample15.webforms/` contains the Web Forms site. `OrganizationExample16/` contains another archived edition. `movil/` and `movil.no/` contain the mobile pages and an earlier variant. `demo/` holds the fictional example.

### History

This repository combines the archived web editions and keeps their recorded Git dates.The 2026 reconstruction brings the recovered archive snapshots into one timeline. The May and August 2011 cuts remain as source archives with incomplete build inputs.

### Contributing

Keep local settings and fictional test data in a disposable copy. Report the exact edition and steps that reproduce the change.

### Support

Use the repository’s issues to report a reproducible build problem or a missing resource.

### License

The application’s own code is available under the [MIT license](LICENSE). Included third-party files retain their original notices.

---

The local build precompiles the remaining Web Forms pages. The build recipe excludes pages that depend on archived controls that have not survived. The runtime test only checks local sign-in with a fictional account. It does not exercise the excluded pages, clinical forms, or external integrations. The 10 file exclusions in `demo/missing-controls.json` include `paciente/ingreso.aspx`, `paciente/ingreso.aspx.cs`, `paciente/evolucion.aspx`, `paciente/evolucion.aspx.cs`.

## Español

Aplicación ASP.NET archivada para coordinar visitas domiciliarias, equipos de atención y registros del servicio

> [!WARNING]
> **Estado: archivado.** Esta copia conserva una edición anterior. Sus instrucciones de compilación indican los requisitos y las pruebas de este corte.

Aplicación ASP.NET para coordinar visitas domiciliarias, equipos de atención y registros del servicio


### Descripción general

Los equipos de atención domiciliaria pueden organizar visitas, consultar fichas de contacto y de servicio y coordinar al personal que presta la atención.

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

### Requisitos

Usa Windows con .NET Framework 4.8, IIS Express y PowerShell 7 para compilar la edición Web Forms del ejemplo. El script recompila la biblioteca compartida y ejecuta el compilador de ASP.NET. Usa una base desechable y registros ficticios.

### Cómo empezar

Los proyectos MVC más recientes apuntan a .NET Framework 4.6. La ausencia de algunos auxiliares compartidos de la época impide su compilación completa. Las ediciones Web Forms verificadas compilan con las instrucciones de abajo.

La prueba usó la edición archivada del 2012-03-14. Abre ese commit en una copia local aparte y usa una carpeta nueva para la compilación.

```powershell
git switch --detach 1c845eecac08
$output = Join-Path $env:TEMP ('webforms-demo-' + [guid]::NewGuid().ToString('N'))
pwsh -NoProfile -File demo/Build.ps1 -Output $output
```

### Uso

Usa la compilación local documentada con un operador ficticio. Las pantallas disponibles incluyen `OrganizationExample15/materna/postparto.aspx` y las demás rutas de arriba.

Ingresa como un operador ficticio del equipo de atención y abre el sitio local. La prueba verificada emitió una cookie de sesión y registró el ingreso en MySQL desechable. También proporcionó un SQL Server local con una entrada ficticia de navegación.

### Verificación

El ejemplo archivado compiló a partir de su propio código y usó solo servicios locales. La prueba cubre el ingreso y su actividad en la base de datos. Las demás pantallas e integraciones requieren pruebas aparte.

### Estructura del proyecto

`OrganizationExample15/` y `OrganizationExample15.mvc.2018-11-21/` contienen las ediciones MVC. `OrganizationExample15.webforms/` contiene el sitio Web Forms. `OrganizationExample16/` contiene otra edición archivada. `movil/` y `movil.no/` contienen las páginas móviles y una variante anterior. `demo/` guarda el ejemplo ficticio.

### Historia

Este repositorio reúne las ediciones web archivadas y conserva las fechas registradas en Git. El historial principal conserva las demás ediciones archivadas.

### Contribuir

Mantén la configuración local y los datos ficticios en una copia desechable. Indica la edición exacta y los pasos para reproducir el cambio.

### Soporte

Usa los issues del repositorio para reportar un problema de compilación reproducible o un recurso que falte.

### Licencia

El código propio de la aplicación usa la [licencia MIT](LICENSE). Los archivos de terceros conservan sus avisos originales.

## Recovered local build / Compilación local recuperada

The recovered Web Forms site is in `OrganizationExample15.webforms`. Run `pwsh -NoProfile -File demo/Build.ps1 -Output <new-directory>` on Windows with .NET Framework 4.8 and the .NET SDK. The build compiles the compatible shared library from the recovered sources and uses the sample Web.config in the copy.

El sitio Web Forms recuperado se encuentra en `OrganizationExample15.webforms`. Ejecuta `pwsh -NoProfile -File demo/Build.ps1 -Output <carpeta-nueva>` en Windows con .NET Framework 4.8 y el SDK de .NET. La compilación compila la biblioteca propia compatible desde las fuentes recuperadas y usa Web.config de ejemplo en la copia.

The build restores iTextSharp 5.4.4 from the official NuGet package and checks its SHA-256. Set `DOMICILIO_ITEXTSHARP_PACKAGE` to the same package for an offline build.

La compilación restaura iTextSharp 5.4.4 desde el paquete oficial de NuGet y coteja su SHA-256. Indica una copia del mismo paquete en `DOMICILIO_ITEXTSHARP_PACKAGE` para compilar sin Internet.

The 2026 reconstruction restores archived Web Forms inputs and builds the compatible February 2016 copy of the owned shared library. The recipe excludes tracked views with missing patient controls from its disposable build. The fictional MySQL test verified sign-in and the protected home page with the historical grouping mode.

La reconstrucción de 2026 recupera insumos archivados de Web Forms y compila la copia compatible de febrero de 2016 de la biblioteca propia. La receta aparta de la copia desechable las vistas que requieren controles de paciente ausentes. La prueba con MySQL ficticio verificó el ingreso y la portada protegida con el modo histórico de agrupación.

La compilación local precompila las páginas Web Forms disponibles. La receta excluye las páginas que dependen de controles históricos que no se conservaron. La prueba de ejecución cubre solo el ingreso local con una cuenta ficticia. Quedan sin probar las páginas excluidas, los formularios clínicos y las integraciones externas. Las 10 exclusiones de archivos de `demo/missing-controls.json` incluyen `paciente/ingreso.aspx`, `paciente/ingreso.aspx.cs`, `paciente/evolucion.aspx`, `paciente/evolucion.aspx.cs`.

