using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using SDG.Componentes.Validator;

namespace OrganizationExample15.Models.EntregaTurno
{
    public class Bitacora : ProtectedField
    {
        public string Id { get; set; }
        [Required(ErrorMessage ="Por favor seleccione una fecha")]
        [RegularExpression(@"^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$", ErrorMessage = "Por favor ingrese una fecha valida")]
        public string Fecha { get; set; }
        [Required(ErrorMessage = "Por favor seleccione un tipo")]
        public short? Tipo { get; set; }
        [Required(ErrorMessage = "Por favor ingrese unas observaciones")]
        public string Observaciones { get; set; }
        [RequiredIfNot("NovedadServicio", ErrorMessage="Por favor seleccione una novedad administrativa")]
        public long? NovedadAdministrativa { get; set; }
        [RequiredIfNot("NovedadAdministrativa", ErrorMessage = "Por favor seleccione una novedad de servicio")]
        public long? NovedadServicio { get; set; }
        public MPacienteSimple Paciente { get; set; } = new MPacienteSimple();
        public ulong? Estado { get; set; }
        public string NombreFuncionario { get; set; }
        public bool OmitirEncabezado { get; set; }
    }

    public class BitacoraFilter {
        public string Desde { get; set; }
        public string Hasta { get; set; }
        public uint? NovedadAdministrativa { get; set; } = 0;
        public uint? NovedadServicio { get; set; } = 0;
        public ulong? Estado { get; set; } = 0;
        public uint? Tipo { get; set; } = 0;
        public uint? PDF { get; set; }
        public uint? Print { get; set; }
        public MPacienteSimple Paciente { get; set; } = new MPacienteSimple();
    }
}
