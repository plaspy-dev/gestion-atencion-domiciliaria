<%@ WebHandler Language="C#" Class="migrar" %>

using System;
using System.IO;
using System.Web;
using System.Configuration;
using System.Globalization;
using System.Data.SqlClient;
using MySql.Data.MySqlClient;
using SDG.Componentes;

public class migrar : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        
        context.Response.ContentType = "text/html";
        context.Response.Buffer = false;
        context.Response.Write("<html><body>");

        /*if (!Copiar(context, "alerta", "genTareas")) return;
        if (!Copiar(context, "usuario_alerta", "GenUsuarioTarea")) return;
        if (!Copiar(context, "paciente", "phdPaciente")) return;
        if (!Copiar(context, "asegurador", "admEntidad")) return;
        if (!Copiar(context, "paciente_tipo_pago", "phdPagoDirecto")) return;
        if (!Copiar(context, "cie10", "phdCIE10")) return;
        if (!Copiar(context, "paciente_egreso", "phdEgresos")) return;
        if (!Copiar(context, "causa_egreso", "phdCausaEgreso")) return;
        if (!Copiar(context, "paciente_auditoria_servicios", "phdAuditServicios")) return;
        if (!Copiar(context, "paciente_reingreso", "phdReingresos")) return;
        if (!Copiar(context, "causa_reingreso", "phdCausaReingreso")) return;
        if (!Copiar(context, "tipo_documento", "phdTipoDocumento")) return;
        if (!Copiar(context, "autorizacion", "phdAutorizacion")) return;
        if (!Copiar(context, "autorizacion_detalle", "phdDetalleAutorizacion")) return;
        if (!Copiar(context, "paciente_archivo", "arcArchivoGestion")) return;
        if (!Copiar(context, "programacion", "programacion")) return;
        if (!Copiar(context, "programacion_novedad", "phdNovedad")) return;
        if (!Copiar(context, "queja_reclamo", "serQuejasReclamos")) return;
        if (!Copiar(context, "queja_reclamo_seguimiento", "serSeguimiento")) return;
        if (!Copiar(context, "queja_reclamo_funcionario", "serQuejaRecPersonal")) return;
        if (!Copiar(context, "bitacora_turno", "turBitacora")) return;
        if (!Copiar(context, "recurso_humano", "admPersonalHS")) return;
        if (!Copiar(context, "profesion", "admProfesion")) return;
        if (!Copiar(context, "cargo", "admCargo")) return;
        if (!Copiar(context, "area", "admArea")) return;
        if (!Copiar(context, "nivel_complejidad", "admNivelComplejidad")) return;
        if (!Copiar(context, "paciente_estado", "phdEstado")) return;
        if (!Copiar(context, "tipo_evento", "phdTipoEvento")) return;
        if (!Copiar(context, "causa_novedad", "phdCausaNovedad")) return;
        if (!Copiar(context, "estado_civil", "admEstadoCivil")) return;
        if (!Copiar(context, "funcionario_estados", "admEstadoEstancia")) return;
        if (!Copiar(context, "tipo_contrato", "admTipoContrato")) return;
        if (!Copiar(context, "disponibilidad", "admDisponibilidad")) return;
        if (!Copiar(context, "banco", "admBanco")) return;
        if (!Copiar(context, "funcionario_documentos", "admDocumentos")) return;
        if (!Copiar(context, "recurso_humano_documento", "admDocsPersonalHS")) return;
        if (!Copiar(context, "recurso_humano_formacion", "admPersonalInfoProf")) return;
        if (!Copiar(context, "funcionario_formacion", "admInfoProfesional")) return;
        if (!Copiar(context, "vehiculo", "vehVehiculo")) return;
        if (!Copiar(context, "vehiculo_recorrido", "vehRecorrido")) return;
        if (!Copiar(context, "pago_autorizacion", "pago_autorizacion")) return;
        if (!Copiar(context, "prestamo_archivo", "prestamo_archivo")) return;
        if (!Copiar(context, "localidad", "admLocalidad")) return;
        if (!Copiar(context, "tipo_queja_reclamo", "serTipoFormulario")) return;
        if (!Copiar(context, "tipo_actividad", "phdTipoActividad")) return;
        if (!Copiar(context, "plantilla_correo", "admPlantillaCorreo")) return;
        if (!Copiar(context, "motivo_retiro", "admMotivoTerminacion")) return;
        if (!Copiar(context, "bitacora_seguimiento", "bitacora_seguimiento")) return;
        if (!Copiar(context, "recurso_humano_info_laboral", "admInfoLaboral")) return;
         * if (!Copiar(context, "ruta_sanitaria", "PhdRutaSanitaria")) return;

        UpdateFotos(context);
        UpdateFiles(context);*/
        context.Response.Write("</body></html>");
    }


    public void RemoveDirectory(string path) {

        foreach (string directorio in Directory.GetDirectories(path))
        {
            RemoveDirectory(directorio);
            Directory.Delete(directorio);
        }
        foreach (string file in Directory.GetFiles(path))
            File.Delete(file);
    }

    public void UpdateFiles(HttpContext context) {

        using (CConectorMS conectorms = new CConectorMS())
        {
            string destino_archivo = Path.Combine(ConfigurationManager.AppSettings["pathFiles"], "pqr");
            Directory.CreateDirectory(destino_archivo);
            RemoveDirectory(destino_archivo);

            int total = Convert.ToInt32(conectorms.QueryString("SELECT COUNT(*) FROM serSeguimiento WHERE archivo IS NOT NULL"));
            int fila = 0;
            int currentPer = 0;

            context.Response.Write("Copiando Archivos de <b>" + "serSeguimiento" + "</b> a <b>" + destino_archivo + "</b> (<b>" + total + "</b>)<br/>0%\n");
            context.Response.Flush();

            Query query = new Query("serSeguimiento");

            query += "qrId";
            query += "sqrId";
            query+="nombre";

            SqlDataReader reader = conectorms.Query(query.GetSelect("archivo is not null"));

            if (reader != null)
            {
                while (reader.Read())
                {
                    fila++;
                    using (SqlConnection connection = new SqlConnection(conectorms.GetConexionString()))
                    {
                        connection.Open();
                        using (SqlCommand command = new SqlCommand(String.Format("SELECT archivo FROM serSeguimiento WHERE qrId={0} AND sqrId={1}"
                            , Query.GetValor(reader["qrId"].ToString())
                            , Query.GetValor(reader["sqrId"].ToString())
                            ), connection))
                        {
                            string directorio = Path.Combine(destino_archivo, reader["qrId"].ToString());
                            Directory.CreateDirectory(directorio);
                            directorio = Path.Combine(directorio, reader["sqrId"].ToString());
                            Directory.CreateDirectory(directorio);
                            using (FileStream file = File.Open(Path.Combine(directorio, reader["nombre"].ToString()), FileMode.CreateNew))
                            {
                                byte[] contenido = (byte[])command.ExecuteScalar();
                                file.Write(contenido, 0, contenido.Length);
                                file.Close();
                            }
                        }
                        connection.Close();
                    }
                    // aumentamos el porcentaje
                    if (((100 * fila / total) % 10) == 0)
                    {
                        if (currentPer == (100 * fila / total))
                            continue;
                        currentPer = (100 * fila / total);
                        context.Response.Write("..." + currentPer.ToString() + "%");
                        context.Response.Flush();
                    }
                }
            }
        }
        context.Response.Write("<br/>");
        context.Response.Flush();
    }
        
    public void UpdateFotos(HttpContext context)
    { 
        using (CConectorMS conectorms = new CConectorMS())
        {
            string destino_archivo = Path.Combine(ConfigurationManager.AppSettings["pathFiles"], "rh");
            Directory.CreateDirectory(destino_archivo);
            foreach (string file in Directory.GetFiles(destino_archivo))
                File.Delete(file);

            int total = Convert.ToInt32(conectorms.QueryString("SELECT COUNT(*) FROM admPersonalHS WHERE archivo IS NOT NULL"));
            int fila = 0;
            int currentPer = 0;

            context.Response.Write("Copiando Imagenes de <b>" + "admPersonalHS" + "</b> a <b>" + destino_archivo + "</b> (<b>" + total + "</b>)<br/>0%\n");
            context.Response.Flush();
            
            Query query = new Query("admPersonalHS");

            query += "perId";

            SqlDataReader reader = conectorms.Query(query.GetSelect("archivo is not null"));

            if (reader != null)
            {
                while (reader.Read())
                {
                    fila++;
                    using (SqlConnection connection = new SqlConnection(conectorms.GetConexionString()))
                    {
                        connection.Open();
                        using (SqlCommand command = new SqlCommand(String.Format("SELECT archivo FROM admPersonalHS WHERE perId={0}", Query.GetValor(reader["perId"].ToString())), connection))
                        {
                            using (FileStream file = File.Open(Path.Combine(destino_archivo, reader["perId"].ToString() + ".jpg"), FileMode.CreateNew))
                            {
                                byte[] contenido = (byte[])command.ExecuteScalar();
                                file.Write(contenido, 0, contenido.Length);
                                file.Close();
                            }
                        }
                        connection.Close();
                    }
                    // aumentamos el porcentaje
                    if (((100 * fila / total) % 10) == 0)
                    {                        
                        if (currentPer == (100 * fila / total))
                            continue;
                        currentPer = (100 * fila / total);
                        context.Response.Write("..." + currentPer.ToString() + "%");
                        context.Response.Flush();
                    }
                }
            }
        }
        context.Response.Write("<br/>");
        context.Response.Flush();
    }

    public bool Copiar(HttpContext context, string tabla_destino, string tabla_fuente)
    {
        using (CConector conector = new CConector())
        using (CConectorMS conectorms = new CConectorMS())
        {
            if (conector.QueryMod("TRUNCATE TABLE " + tabla_destino) == -1 || conector.QueryMod("SET SESSION sql_mode='NO_AUTO_VALUE_ON_ZERO';") == -1)
            {
                context.Response.Write(conector.GetLastError());
                context.Response.Flush();
                return false;
            }
            
            int total= Convert.ToInt32(conectorms.QueryString("SELECT COUNT(*) FROM " + tabla_fuente));

            context.Response.Write("Copiando <b>" + tabla_fuente + "</b> a <b>" + tabla_destino + "</b> (<b>" + total +  "</b>)<br/>0%\n");
            context.Response.Flush();
            int fila = 0;
            int currentPer = 0;
            
            SqlDataReader reader= conectorms.Query("SELECT * FROM " + tabla_fuente);
            
            if (reader != null) {
                while (reader.Read()) {
                    fila++;
                    Query query = new Query(tabla_destino);
                    for(int i=0; i<reader.FieldCount; i++) {
                        string valor=reader[i].ToString();
                        if (reader[i] != DBNull.Value)
                        {
                            if (reader.GetFieldType(i) == typeof(DateTime))
                                valor = Query.GetMySQLDateFormat((DateTime)reader[i], true);
                            else if (reader.GetFieldType(i) == typeof(Double))
                                valor = ((Double)reader[i]).ToString(CultureInfo.InvariantCulture);
                            else if (reader.GetFieldType(i) == typeof(Decimal))
                                valor = ((Decimal)reader[i]).ToString(CultureInfo.InvariantCulture);
                            else if (reader.GetFieldType(i) == typeof(Boolean))
                                valor = ((Boolean)reader[i]) ? "1" : "0";
                        }
                        query[reader.GetName(i)] = valor;
                    }
                    if (conector.QueryMod(query.GetInsert()) == -1) {

                        context.Response.Write(conector.GetLastError());
                        context.Response.Flush();
                        return false;
                    }
                    // aumentamos el porcentaje
                    if (((100 * fila / total)%10)==0)
                    {
                        if (currentPer == (100 * fila / total))
                            continue;
                        currentPer = (100 * fila / total);
                        context.Response.Write("..." + currentPer.ToString() + "%");
                        context.Response.Flush();
                    }
                }
            }
        }
        context.Response.Write("<br/>");
        context.Response.Flush();
        return true;
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}