using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.ModelBinding;
using System.Web.Mvc;
using OrganizationExample15.Models.Administrador;
using Newtonsoft.Json;
using SDG.Componentes.Validator;

namespace OrganizationExample15.Models.ClinicaHeridas
{
    public class Evolucion : ProtectedField
    {
        [BindNever]
        public string Id {
            get {
                return ProtectedFields["id"];
            }
            set
            {
                ProtectedFields["id"] = value;
            }
        }
        public MPacienteSimple Paciente { get; set; } = new MPacienteSimple();
        [Required(ErrorMessage ="Por favor ingrese una fecha")]
        [RegularExpression(@"^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)))) (0[0-9]|1\d|2[0-3]):([0-5]\d)$", ErrorMessage = "Por favor ingrese una fecha valida")]
        public string Fecha { get; set; }
        public MFuncionarioSimple Funcionario { get; set; } = new MFuncionarioSimple();
        [Required(ErrorMessage = "Por favor ignrese una tensión arterial")]
        public string TA { get; set; }
        [Required(ErrorMessage = "Por favor ingrese una frecuencia cardiaca")]
        public string FC { get; set; }
        [Required(ErrorMessage = "Por favor ingrese una frecuencia respiratoria")]
        public string FR { get; set; }
        [Required(ErrorMessage = "Por favor ingrese una temperatura")]
        public string T { get; set; }
        [Required(ErrorMessage = "Por favor seleccione unos pulsos distales")]
        public string PulsosDistales { get; set; }
        public string ObservacionesPulso { get; set; }
        public string Otros { get; set; }

        // Informativo
        public string IdValoracion { get; set; }
        public string ValoracionIncial { get; set; }
        public int? DiasValoracion { get; set; }
        public string IdUltimaEvolucion { get; set; }
        public string UltimaEvolucion { get; set; }
        public int? DiasUltimaEvolucion { get; set; }
        
        [Required(ErrorMessage = "Por favor ingrese un plan de manejo")]
        public string Manejo { get; set; }

        // public bool ConsentimientoInformado { get; set; }

        public List<Herida> Heridas { get; set; } = new List<Herida>();
        [MethodValidator("ValidateHeridasCount", ErrorMessage = "Por favor ingrese por lo menos 1 herida")]
        public string _Heridas {
            get {
                return JsonConvert.SerializeObject(Heridas, HomeCareVersion.JsonSerializerSettingsCamelCase);
            }
            set {
                try
                {
                    Heridas = JsonConvert.DeserializeObject<List<Herida>>(value);
                }
                catch { }
            }
        }

        protected List<CheckTextParam> _ComponenteEducativo { get; set; }
        public List<CheckTextParam> ComponenteEducativo
        {
            get
            {
                if (_ComponenteEducativo == null)
                {
                    _ComponenteEducativo = new List<CheckTextParam>();
                    _ComponenteEducativo = MVarios.GetList(MVarios.Tipo.ValoracionHeridasComponenteEducativo).Select(x => new CheckTextParam() { Id = Convert.ToUInt32(x.Id) }).ToList();
                }
                return _ComponenteEducativo;
            }
            set
            {
                _ComponenteEducativo = value;
            }
        }

        protected List<CheckTextParam> _SeguridadPaciente { get; set; }
        public List<CheckTextParam> SeguridadPaciente
        {
            get
            {
                if (_SeguridadPaciente == null)
                {
                    _SeguridadPaciente = new List<CheckTextParam>();
                    _SeguridadPaciente = MVarios.GetList(MVarios.Tipo.ValoracionHeridasSeguridadPaciente).Select(x => new CheckTextParam() { Id = Convert.ToUInt32(x.Id) }).ToList();
                }
                return _SeguridadPaciente;
            }
            set
            {
                _SeguridadPaciente = value;
            }
        }

        public bool ValidateHeridasCount() {

            return Heridas?.Where(x=>x.Eliminado!=true).ToList().Count > 0;
        }

        public Galeria Galeria { get; set; } = new Galeria();
    }
}