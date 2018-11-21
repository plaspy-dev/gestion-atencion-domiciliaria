using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Dynamic;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using SDG.Componentes.Validator;

namespace OrganizationExample15.Models.terapeutico
{
    public class Cuentas : ProtectedField
    {
        public class Servicio {

            [Required(ErrorMessage ="Por favor seleccione un paciente")]
            public string PacienteId { get; set; }
            [Required(ErrorMessage ="Por favor seleccione un servicio")]
            public string ServicioId { get; set; }
            [Required(ErrorMessage ="Por favor ingrese una cantidad")]
            [MethodValidator("ValidateCantidad", ErrorMessage ="Por favor ingrese una cantidad valida")]
            public uint? Cantidad { get; set; }
            public decimal? Valor { get; set; }

            public bool ValidateCantidad() { return true; }

            public string PacienteIdLabel {
                get {
                    return  Paciente.GetPaciente(PacienteId).DocumentoYNombres;
                }
            }

            public string ServicioIdLabel {
                get {
                    return Procedimientos.GetProcedimiento(ServicioId);
                }
            }
        }


        [Required(ErrorMessage = "Por favor ingrese la fecha de Desde")]
        [RegularExpression(@"^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$", ErrorMessage = "Por favor ingrese una fecha valida")]
        public string Inicio { get; set; }
        [Required(ErrorMessage = "Por favor ingrese la fecha de Hasta")]
        [RegularExpression(@"^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$", ErrorMessage = "Por favor ingrese una fecha valida")]
        public string Fin { get; set; }
        public MFuncionarioSimple Funcionario { get; set; }
        public Galeria Galeria { get; set; }
        public uint? Estado { get; set; }

        public List<Servicio> Servicios = new List<Servicio>();
        [MethodValidator("ValidateServiciosCount", ErrorMessage = "Por favor ingrese por lo menos 1 servicio")]
        [MethodValidator1("ValidateServicios", ErrorMessage = "Por favor ingrese unos servicios validos")]
        public string _Servicios {
            get {
                return JsonConvert.SerializeObject(Servicios, HomeCareVersion.JsonSerializerSettingsCamelCase);
            }
            set {
                try {
                    Servicios = JsonConvert.DeserializeObject<List<Servicio>>(value);
                } catch { }
            }
        }

        // Dummy class
        public Servicio _Servicio { get; set; }

        public Cuentas() {
            Funcionario = new MFuncionarioSimple();
            Galeria = new Galeria();
        }

        public bool ValidateServiciosCount() {

            return Servicios?.Count > 0;
        }

        public bool ValidateServicios() {

            List<Servicio> lista = ((dynamic)GetPacientesServicio()).l;
            for (int i = 0; i < Servicios?.Count; i++) {
                Servicio info= Servicios[i];
                Servicio programado= lista.Find(x => x.PacienteId == info.PacienteId && x.ServicioId == info.ServicioId);
                if (info==null || info.Cantidad > programado.Cantidad) {
                    return false;
                }
                programado.Cantidad -= info.Cantidad;
            }
            return true;
        }

        public object GetPacientesServicio() {

            using (CConector conector = new CConector())
            {
                List<Servicio> lista = new List<Servicio>();
                Dictionary<string, string> services= new Dictionary<string, string>();
                Dictionary<string, string> pacientes = new Dictionary<string, string>();

                Query query = new Query("programacion");

                query += "programacion.pacId";
                query += "programacion.actId";
                query["paciente"]= "CONCAT(paciente.pacDocumento,'-',paciente.pacNombres)";
                query["an"]= "CONCAT(medicamentos.codigo, '-',medicamentos.nombre)";
                query["p"] = "medicamentos.precio";
                query["c"] = "COUNT(*)";

                MySqlDataReader reader = conector.Query(query.GetSelect("DATE(programacion.prgFechaProg) BETWEEN {0} AND {1} AND programacion.perId={2} " +
                    " GROUP BY programacion.pacId,programacion.actId,paciente.pacNombres,an"
                    , "LEFT JOIN medicamentos ON (medicamentos.id=programacion.actId) LEFT JOIN paciente ON (paciente.pacId=programacion.pacId)"
                    , Query.GetValor(Query.GetMySQLDateFormat(ProtectedFields["ds"]))
                    , Query.GetValor(Query.GetMySQLDateFormat(Fin))
                    , Query.GetValor(ProtectedFields["fid"])
                    ));

                if (reader != null)
                {
                    while (reader.Read())
                    {
                        Servicio info = new Servicio();
                        info.PacienteId = reader["pacId"].ToString();
                        info.ServicioId = reader["actId"].ToString();
                        info.Cantidad = (uint ?)(reader["c"] as long?);
                        info.Valor = reader["p"] as decimal?;

                        services[reader["actId"].ToString()] = reader["an"].ToString();
                        pacientes[reader["pacId"].ToString()] = reader["paciente"].ToString();
                        lista.Add(info);
                    }
                }

                return new { l= lista, p= pacientes, s= services };
            }
        }
    }
}