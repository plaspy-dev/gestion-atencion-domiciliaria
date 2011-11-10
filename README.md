# Home-care management / Gestión de atención domiciliaria

[English](#english) · [Español](#español)

## English

Archived ASP.NET application for coordinating home visits, care teams and service records

> [!WARNING]
> **Status: Archived.** This snapshot preserves an earlier edition. Its build instructions identify the requirements and checks for this cut.

### Overview

This cut records the home-care application as archived on 2011-11-10.

The application keeps the records used to arrange visits and coordinate the people providing care.


### Features in the retained source

- Open the staff record for the care team. `rh/funcionario.aspx`.
- Open the patient record and its care information. `paciente/paciente.aspx`.
- View and maintain access groups. `administrador/grupos.aspx`.
- Manage the operator accounts used to sign in. `administrador/usuario.aspx`.

### Build and local use

On Windows with PowerShell 7 and .NET Framework 4.8, run the archived Web Forms precompile recipe.

```powershell
$output = Join-Path $env:TEMP ('webforms-demo-' + [guid]::NewGuid().ToString('N'))
pwsh -NoProfile -File demo/Build.ps1 -Output $output
```

The retained site entry is `Default.aspx`. Use fictional accounts and a disposable database on loopback.

### Archive notes

The archive inventory counted 6 additions, 13 edits and 5 removals.

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

Este corte conserva la versión de atención domiciliaria archivada el 2011-11-10.

La aplicación reúne los registros para organizar las visitas y coordinar al personal que presta la atención.


### Funciones en el código conservado

- Abre la ficha del personal del equipo de atención. `rh/funcionario.aspx`.
- Abre la ficha del paciente y su información de atención. `paciente/paciente.aspx`.
- Consulta y administra los grupos de acceso. `administrador/grupos.aspx`.
- Administra las cuentas de operador para ingresar. `administrador/usuario.aspx`.

### Compilación y uso local

En Windows con PowerShell 7 y .NET Framework 4.8, ejecuta la receta de precompilación Web Forms del corte.

```powershell
$output = Join-Path $env:TEMP ('webforms-demo-' + [guid]::NewGuid().ToString('N'))
pwsh -NoProfile -File demo/Build.ps1 -Output $output
```

La entrada conservada del sitio es `Default.aspx`. Usa cuentas ficticias y una base desechable en la interfaz local.

### Notas del respaldo

El inventario del respaldo registró 6 adiciones, 13 cambios y 5 retiros.

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
