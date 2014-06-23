using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SDG.Componentes;
using System.Data.SqlClient;
using MySql.Data.MySqlClient;

public class Autorizaciones
{
    public class Detalle {
        public string Actividad { get; set; }
        public int Cantidad { get; set; }
        public string NombreCorto {
            get
            {
                return NombreCompleto.Replace("ATENCION [VISITA] DOMICILIARIA", "AT...RIA")
                    .Replace("ATENCION", "AT..N")
                    .Replace("DOMICILIARIA", "DO..A")
                    .Replace("VISITA", "VI..A");
            }
        }
        public string NombreCompleto { get {
            return Actividad;
        } }
        public Detalle() {}
    }

    public string Autorizacion { get; set; }
    public DateTime fecha { get; set; }
    public DateTime vencimiento { get; set; }
    public List<Detalle> detalles { get; set; }
    public Autorizaciones()
    {
        detalles = new List<Detalle>();
    }

    public static List<Autorizaciones>GetAutorizaciones(string idpaciente) {
        if (string.IsNullOrEmpty(idpaciente))
            return null;
        List<Autorizaciones> autorizaciones = (List<Autorizaciones>)HttpRuntime.Cache["au" + idpaciente];
        if(autorizaciones==null) {

            autorizaciones = new List<Autorizaciones>();
            using(CConector conector = new CConector()) {
                Query query = new Query("autorizacion");
                
                query += "autNumero";
                query += "autFecha";
                query += "autFechaVenc";

                MySqlDataReader reader = conector.Query(query.GetSelect("autActivo=1 AND SYSDATE()<=IFNULL(autFechaVenc,autFecha+30) AND pacId=" + Query.GetValor(idpaciente) + " ORDER BY autFecha DESC"));
                if(reader!=null) {
                    using (CConector conector2 = new CConector())
                    {
                        Query detalle = new Query("autorizacion_detalle");
                        
                        detalle += "actId";
                        detalle += "autNumSesiones";

                        while (reader.Read())
                        {
                            Autorizaciones info = new Autorizaciones();
                            info.Autorizacion = reader["autNumero"].ToString();
                            info.fecha = (DateTime)reader["autFecha"];
                            if (reader["autFechaVenc"].ToString() == "")
                                info.vencimiento = info.fecha.AddDays(30);
                            else info.vencimiento = (DateTime)reader["autFechaVenc"];

                            MySqlDataReader reader2= conector2.Query(detalle.GetSelect("autNumero=" + Query.GetValor(info.Autorizacion)));
                            if(reader2!=null) {
                                while(reader2.Read()) {

                                    Detalle infodetalle = new Detalle();
                                    infodetalle.Actividad= Procedimientos.GetProcedimiento(reader2["actId"].ToString());
                                    infodetalle.Cantidad = Convert.ToInt32(reader2["autNumSesiones"]);

                                    info.detalles.Add(infodetalle);
                                }
                            }

                            autorizaciones.Add(info);
                        }
                    }
                }
            }
            HttpRuntime.Cache.Insert("au" + idpaciente, autorizaciones);
        }
        return autorizaciones;
    }

    public static void RemoveAutorizaciones(string idpaciente) {
        HttpRuntime.Cache.Remove("au" + idpaciente);
    }

    public static bool UpdateSesiones(CConector conector, string autorizacion) {
        string query= string.Format("UPDATE autorizacion_detalle SET sesiones_programadas=(SELECT SUM(programacion.prgNumSesion)"
                            + " FROM programacion"
                            + " WHERE"
                            + " programacion.autNumero=autorizacion_detalle.autNumero AND programacion.actId=autorizacion_detalle.actId "
                            //+ " AND programacion.prgActivo=1 "
                            + ") WHERE autNumero={0}", Query.GetValor(autorizacion));
        if (conector.QueryMod(query) == -1)
            return false;
        return true;
    }
}
