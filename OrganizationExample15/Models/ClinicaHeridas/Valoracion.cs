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
    public class Herida {

        public string Id { get; set; }
        [Required(ErrorMessage ="Por favor seleccione una localización")]
        public uint? Localizacion { get; set; }
        [Required(ErrorMessage = "Por favor seleccione una localización")]
        public uint? Localizacion2 { get; set; }
        [Required(ErrorMessage = "Por favor seleccione una localización")]
        public uint? Localizacion3 { get; set; }
        [Required(ErrorMessage = "Por favor ingrese una ubicación especifica")]
        public string UbicacionEspecifica { get; set; }
        [Required(ErrorMessage = "Por favor seleccione la ubicación en los miembros inferiores")]
        public uint? MiembrosInferiores { get; set; }
        [Required(ErrorMessage = "Por favor seleccione la ubicación en los pies")]
        public uint? Pies { get; set; }
        [Required(ErrorMessage = "Por favor seleccione una etiología")]
        public uint? Etiologia { get; set; }
        public string OtroEtiologia { get; set; }
        [Required(ErrorMessage = "Por favor seleccione una clasificación")]
        public uint? Clasificacion { get; set; }
        [Required(ErrorMessage = "Por favor ingrese unos factores de riesgo")]
        public string FactoresRiesgo { get; set; }
        [Required(ErrorMessage = "Por favor ingrese una longitud")]
        public string Longitud { get; set; }
        [Required(ErrorMessage = "Por favor ingrese una anchura")]
        public string Anchura { get; set; }
        [Required(ErrorMessage = "Por favor ingrese profundidad")]
        public string Profundidad { get; set; }
        public bool Tunelizacion { get; set; }
        [RequiredIf("Tunelizacion", ErrorMessage = "Por favor ingrese una tunelización")]
        public string TunelizacionParametro { get; set; }
        [Required(ErrorMessage = "Por favor ingrese una cavidad")]
        public string Cavidad { get; set; }
        public bool Bolsillo { get; set; }
        [RequiredIf("Bolsillo", ErrorMessage = "Por favor ingrese una profundidad")]
        public string BolsilloProfundidad { get; set; }
        [RequiredIf("Bolsillo", ErrorMessage = "Por favor ingrese una ubicación")]
        public uint? BolsilloUbicacion { get; set; }
        [Required(ErrorMessage = "Por favor seleccione un tejido necrotico")]
        public uint? TejidoNecrotico { get; set; }
        // public string Tejido { get; set; }
        [Required(ErrorMessage = "Por favor ingrese un porcentaje de compacto")]
        public string TejidoCompacto { get; set; }
        [Required(ErrorMessage = "Por favor ingrese un porcentaje de fibrina")]
        public string TejidoFibrina { get; set; }
        [Required(ErrorMessage = "Por favor ingrese un porcentaje de epitelización")]
        public string TejidoEpitelizacion { get; set; }
        [Required(ErrorMessage = "Por favor ingrese un porcentaje de esfacelo")]
        public string TejidoEsfacelo { get; set; }
        [Required(ErrorMessage = "Por favor ingrese un porcentaje de granulación")]
        public string TejidoGranulacion { get; set; }
        [Required(ErrorMessage = "Por favor ingrese un porcentaje de hipergranulación")]
        public string TejidoHiperGranulacion { get; set; }
        [Required(ErrorMessage = "Por favor ingrese un porcentaje de limpio pero no granulado")]
        public string TejidoLimpioNoGranulado { get; set; }
        [Required(ErrorMessage = "Por favor ingrese un porcentaje de necrosis profunda")]
        public string TejidoNecrosis { get; set; }
        [Required(ErrorMessage = "Por favor seleccione una exposición")]
        public string TejidoExposicion { get; set; }

        public string TiempoEvolucionUlcera { get; set; }
        public uint? TejidoProfundoSospechoso { get; set; }
        public uint? LugarOrigen { get; set; }
        public string HogarGeriatrico { get; set; }

        [Required(ErrorMessage = "Por favor seleccione un exudado")]
        public uint? Exudado { get; set; }
        [Required(ErrorMessage = "Por favor seleccione un tipo exudado")]
        public uint? ExudadoTipo { get; set; }
        [Required(ErrorMessage = "Por favor seleccione una piel circundante")]
        public uint? ExudadoPiel { get; set; }
        [Required(ErrorMessage = "Por favor seleccione los bordes de la herida")]
        public uint? ExudadoBordes { get; set; }
        [Required(ErrorMessage = "Por favor seleccione un olor")]
        public uint? ExudadoOlor { get; set; }
        [Required(ErrorMessage = "Por favor seleccione unos signos o sintomas")]
        public uint? ExudadoSignos { get; set; }
        public string ExudadoDescripcion { get; set; }
        public bool ExudadoComplicaciones { get; set; }
        [RequiredIf("ExudadoComplicaciones", ErrorMessage = "Por favor ingrese unas complicaciones")]
        public string ExudadodComplicacionesParametro { get; set; }
        [Required(ErrorMessage = "Por favor seleccione una clasificación")]
        public uint? ExudadoClasificacion { get; set; }
        public Galeria Galeria { get; set; }

        public uint? CambioHerida { get; set; }
        public string SignoInfeccion { get; set; }
        public bool Evolucion { get; set; }

        public bool Eliminado { get; set; }
        public bool ShowOK { get; set; }
    }

    public class Valoracion : ProtectedField
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
        [RegularExpression(@"^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$", ErrorMessage = "Por favor ingrese una fecha valida")]
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
        // Fistulas
        public bool Fistulas { get; set; }
        [RequiredIf("Fistulas", ErrorMessage = "Por favor ingrese un localización")]
        public string LocalizacionFistula { get; set; }
        [RequiredIf("Fistulas", ErrorMessage = "Por favor ingrese una cantidad afluente")]
        public string CantidadAfluente { get; set; }
        public bool SignosDeInfeccion { get; set; }

        // Ostomias
        public bool Ostomias { get; set; }
        [RequiredIf("Ostomias", ErrorMessage = "Por favor seleccione un tipo de ostomía")]
        public string TipoOstomia { get; set; }
        [RequiredIf("Ostomias", ErrorMessage = "Por favor ingrese una ubicación")]
        public string UbicacionEstoma { get; set; }
        [RequiredIf("Ostomias", ErrorMessage = "Por favor seleccione un color del estoma")]
        public uint? ColorEstoma { get; set; }
        [RequiredIf("Ostomias", ErrorMessage = "Por favor seleccione un estado a nivel de la piel")]
        public uint? EstomaNivelPiel { get; set; }
        [RequiredIf("Ostomias", ErrorMessage = "Por favor seleccione unas complicaciones")]
        public uint? EstomaComplicaciones { get; set; }
        [RequiredIf("Ostomias", ErrorMessage = "Por favor seleccione un estado de piel")]
        public uint? EstadoPiel { get; set; }

        // Dispositivos medicos insertados
        public bool DispositivosMedicosInsertados { get; set; }
        [RequiredIf("DispositivosMedicosInsertados", ErrorMessage = "Por favor seleccione un tipo de dispositivo")]
        public uint? TipoDispositivo { get; set; }
        public bool Funcional { get; set; }
        // [RequiredIf("DispositivosMedicosInsertados", "Funcional", ErrorMessage = "Por favor seleccione si el dispositivo es funcional")]
        public uint? FuncionalParametro { get; set; }
        public string FuncionalDescripcion { get; set; }

        [Required(ErrorMessage ="Por favor seleccione una escala de dolor")]
        public uint? EscalaDolor { get; set; }

        [Required(ErrorMessage = "Por favor ingrese una periodicidad")]
        public string Periodicidad { get; set; }
        [Required(ErrorMessage = "Por favor ingrese un plan de manejo")]
        public string Manejo { get; set; }

        public bool ConsentimientoInformado { get; set; }

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

        protected List<CheckTextParam> _Antecendentes { get; set; }
        public List<CheckTextParam> Antecendentes {
            get {
                if (_Antecendentes == null) {
                    _Antecendentes = new List<CheckTextParam>();
                    _Antecendentes = MVarios.GetList(MVarios.Tipo.HojaDeIngresoAntecendentes).Select(x=>new CheckTextParam() { Id=Convert.ToUInt32(x.Id), Required=true }).ToList();
                }
                return _Antecendentes;
            }
            set {
                _Antecendentes = value;
            }
        }

        protected List<CheckTextParam> _Riesgos { get; set; }
        public List<CheckTextParam> Riesgos
        {
            get
            {
                if (_Riesgos == null)
                {
                    _Riesgos = new List<CheckTextParam>();
                    _Riesgos = MVarios.GetList(MVarios.Tipo.HojaDeIngresoFactoresRiesgo).Select(x => new CheckTextParam() { Id = Convert.ToUInt32(x.Id), Required = true }).ToList();
                }
                return _Riesgos;
            }
            set
            {
                _Riesgos = value;
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

        public bool ValidateHeridasCount() {

            return Heridas?.Where(x=>x.Eliminado!=true).ToList().Count > 0;
        }

        public Galeria Galeria { get; set; } = new Galeria();
    }
}