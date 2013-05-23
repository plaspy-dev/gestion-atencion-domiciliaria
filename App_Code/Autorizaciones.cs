using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SDG.Componentes;
using System.Data.SqlClient;

public class Autorizaciones
{
    public class Detalle {
        public string Actividad { get; set; }
        public int Cantidad { get; set; }
        public string Intensidad { get; set; }
        public string NombreCompleto { get {
            string nombre=Actividad;
            if (Intensidad.Length > 0)
                nombre += " [" + Intensidad + "]";
            return nombre;
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
            using(CConectorMS conector = new CConectorMS()) {
                Query query = new Query("phdAutorizacion");
                
                query += "autNumero";
                query += "autFecha";
                query += "autFechaVenc";

                SqlDataReader reader= conector.Query(query.GetSelect("autActivo=1 AND GETDATE()<=ISNULL(autFechaVenc,autFecha+30) AND pacId=" + Query.GetValor(idpaciente) + " ORDER BY autFecha DESC"));
                if(reader!=null) {
                    using (CConectorMS conector2 = new CConectorMS())
                    {
                        Query detalle = new Query("phdDetalleAutorizacion");
                        
                        detalle += "actId";
                        detalle += "autNumSesiones";
                        detalle += "intensidad";

                        while (reader.Read())
                        {
                            Autorizaciones info = new Autorizaciones();
                            info.Autorizacion = reader["autNumero"].ToString();
                            info.fecha = (DateTime)reader["autFecha"];
                            if (reader["autFechaVenc"].ToString() == "")
                                info.vencimiento = info.fecha.AddDays(30);
                            else info.vencimiento = (DateTime)reader["autFechaVenc"];

                            SqlDataReader reader2= conector2.Query(detalle.GetSelect("autNumero=" + Query.GetValor(info.Autorizacion)));
                            if(reader2!=null) {
                                while(reader2.Read()) {

                                    Detalle infodetalle = new Detalle();
                                    infodetalle.Actividad= Procedimientos.GetProcedimiento(reader2["actId"].ToString());
                                    infodetalle.Cantidad = Convert.ToInt32(reader2["autNumSesiones"]);
                                    infodetalle.Intensidad = Procedimientos.GetVarios(reader2["intensidad"].ToString());

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
}
