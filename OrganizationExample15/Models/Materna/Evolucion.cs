using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.ModelBinding;
using OrganizationExample15.Models.Administrador;
using Newtonsoft.Json;
using SDG.Componentes.Validator;

namespace OrganizationExample15.Models.Materna
{
    public class Evolucion : ProtectedField
    {
        public class ParameterControlLaboratorio : ParameterBase
        {
            [RegularExpression(@"^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$", ErrorMessage = "Por favor ingrese una fecha valida")]
            public string PTFecha { get; set; }
            public string PTResultado { get; set; }
            [RegularExpression(@"^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$", ErrorMessage = "Por favor ingrese una fecha valida")]
            public string STFecha { get; set; }
            public string STResultado { get; set; }
            [RegularExpression(@"^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$", ErrorMessage = "Por favor ingrese una fecha valida")]
            public string TTFecha { get; set; }
            public string TTResultado { get; set; }
        }

        public class ParameterControlEcografico : ParameterBase
        {
            public string Trimestre1 { get; set; }
            public string Trimestre2 { get; set; }
            public string Trimestre3 { get; set; }
        }

        [JsonIgnore]
        [BindNever]
        public string Id
        {
            get
            {
                return ProtectedFields["id"];
            }
            set
            {
                ProtectedFields["id"] = value;
            }
        }
        [JsonIgnore]
        public MPacienteSimple Paciente { get; set; } = new MPacienteSimple();

        [Required(ErrorMessage = "Por favor ingrese una fecha")]
        [RegularExpression(@"^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)))) (0[0-9]|1\d|2[0-3]):([0-5]\d)$", ErrorMessage = "Por favor ingrese una fecha valida")]
        public string Fecha { get; set; }
        [JsonIgnore]
        public MFuncionarioSimple Funcionario { get; set; } = new MFuncionarioSimple();
        public MDiagnostico DiagnosticoPrevio { get; set; } = new MDiagnostico();
        public MDiagnostico DiagnosticoActual { get; set; } = new MDiagnostico();

        [RegularExpression(@"^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$", ErrorMessage = "Por favor ingrese una fecha valida")]
        public string FechaUltimaMestruacion { get; set; }

        [RegularExpression(@"^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$", ErrorMessage = "Por favor ingrese una fecha valida")]
        public string FechaProbableParto { get; set; }

        public string CriterioPriorizacionOtro { get; set; }
        public string CriterioPriorizacionObservaciones { get; set; }
        public uint? EdadGestacional { get; set; }

        public string MomentoOcurrenciaEvento { get; set; }

        public string AsistenciaControlPrenatal { get; set; }
        public uint? NumeroControlesPrenatales { get; set; }
        public string ClasificacionRiesgo { get; set; }
        public string Hallazgos { get; set; }
        public string AsesoriaMetodoAnticonceptivo { get; set; }
        public string AccedioMetodoAnticonceptivo { get; set; }
        public string CualMetodoAnticonceptivo { get; set; }
        public string Observaciones { get; set; }

        public List<ParameterValueRequired> CriterioPriorizacion { get; set; }
        public List<ParameterValueRequired> FactoresRiesgoPsicoSocial { get; set; }
        public List<ParameterValueRequired> FactoresRiesgoPsicoSocial2 { get; set; }
        public List<ParameterValueRequired> FactoresRiesgoPsicoSocial3 { get; set; }
        public List<ParameterValueRequired> PreguntasEmbarazoActual { get; set; }
        // public List<ParameterValueRequired> MomentoOcurrenciaDelEvento { get; set; }
        public List<ParameterValueRequired> FormulaObstetrica { get; set; }
        public List<ParameterValueRequired> Antecedentes { get; set; }
        public List<ParameterControlLaboratorio> ControlLaboratorio { get; set; }
        public List<ParameterControlEcografico> ControlesEcograficos { get; set; }
        public List<ParameterValueRequired> SignosVitales { get; set; }
        public List<ParameterValueRequired> AlteracionesExamenFisico { get; set; }
        public List<ParameterValueRequired> PlanManejo { get; set; }

        public Evolucion() : this(false)
        {
        }

        public Evolucion(bool init) {
            if (init)
            {
                PlanManejo = MVarios.GetList(MVarios.Tipo.MaternoEvolucionPlanManejo).Select(x => new ParameterValueRequired() { Id = x.Id }).ToList();
                AlteracionesExamenFisico = MVarios.GetList(MVarios.Tipo.MaternoEvolucionAlteracionesExamenFisico).Select(x => new ParameterValueRequired() { Id = x.Id }).ToList();
                SignosVitales = MVarios.GetList(MVarios.Tipo.MaternoEvolucionSignosVitales).Select(x => new ParameterValueRequired() { Id = x.Id }).ToList();
                ControlesEcograficos = MVarios.GetList(MVarios.Tipo.MaternoEvolucionControlesEcograficos).Select(x => new ParameterControlEcografico() { Id = x.Id }).ToList();
                ControlLaboratorio = MVarios.GetList(MVarios.Tipo.MaternoEvolucionControlLaboratorios).Select(x => new ParameterControlLaboratorio() { Id = x.Id }).ToList();
                Antecedentes = MVarios.GetList(MVarios.Tipo.MaternoEvolucionAntecendentes).Select(x => new ParameterValueRequired() { Id = x.Id }).ToList();
                FormulaObstetrica = MVarios.GetList(MVarios.Tipo.MaternoEvolucionFormulaObstetrica).Select(x => new ParameterValueRequired() { Id = x.Id }).ToList();
                // MomentoOcurrenciaDelEvento = MVarios.GetList(MVarios.Tipo.MaternoEvolucionMomentoOcurrenciaEvento).Select(x => new ParameterValueRequired() { Id = x.Id }).ToList();
                PreguntasEmbarazoActual = MVarios.GetList(MVarios.Tipo.MaternoEvolucionPreguntasEmbarazoActual).Select(x => new ParameterValueRequired() { Id = x.Id }).ToList();
                FactoresRiesgoPsicoSocial3 = MVarios.GetList(MVarios.Tipo.MaternoEvolucionFactoresRiesgoPsicoSocial3).Select(x => new ParameterValueRequired() { Id = x.Id }).ToList();
                FactoresRiesgoPsicoSocial2 = MVarios.GetList(MVarios.Tipo.MaternoEvolucionFactoresRiesgoPsicoSocial2).Select(x => new ParameterValueRequired() { Id = x.Id }).ToList();
                FactoresRiesgoPsicoSocial = MVarios.GetList(MVarios.Tipo.MaternoEvolucionFactoresRiesgoPsicoSocial).Select(x => new ParameterValueRequired() { Id = x.Id }).ToList();
                CriterioPriorizacion = MVarios.GetList(MVarios.Tipo.MaternoEvolucionCriterioPriorizacion).Select(x => new ParameterValueRequired() { Id = x.Id }).ToList();
            } else {
                PlanManejo = new List<ParameterValueRequired>();
                AlteracionesExamenFisico = new List<ParameterValueRequired>();
                SignosVitales = new List<ParameterValueRequired>();
                ControlesEcograficos = new List<ParameterControlEcografico>();
                ControlLaboratorio = new List<ParameterControlLaboratorio>();
                Antecedentes = new List<ParameterValueRequired>();
                FormulaObstetrica = new List<ParameterValueRequired>();
                // MomentoOcurrenciaDelEvento = new List<ParameterValueRequired>();
                PreguntasEmbarazoActual = new List<ParameterValueRequired>();
                FactoresRiesgoPsicoSocial3 = new List<ParameterValueRequired>();
                FactoresRiesgoPsicoSocial2 = new List<ParameterValueRequired>();
                FactoresRiesgoPsicoSocial = new List<ParameterValueRequired>();
                CriterioPriorizacion = new List<ParameterValueRequired>();
            }
        }
    }
}