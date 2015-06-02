using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using SDG.Componentes;

public partial class terapeutico_evoluciones : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack) {

            CUsuario usuario= (CUsuario)CUsuario.GetInstance();
            TInicio.Text = DateTime.Now.AddDays(-1).ToShortDateString();
            TFin.Text = DateTime.Now.ToShortDateString();
            if(!usuario.CanInsert()) {
                UCFuncionario.IdFuncionario= usuario["personal"];
                UCFuncionario.ReadOnly = true;
            }
            ((MasterPageI)Master).RestoreState();
            BBuscar_Click(sender, e);
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        if (sender==BBuscar && !IsValid)
            return;
        ((MasterPageI)Master).Imprimir("evolucion.html", true);
        GridUtils.GetRowsCount(GResultados, LTotal);
    }

    public StringBuilderEx RemoveSection(bool visible, string control, StringBuilderEx Contenido)
    {
        if (!visible)
        {
            Regex regx = new Regex(string.Format(".*<!--.*{0}.*-->(?<content>.*)<!--.*{0}End.*-->.*", control)
                , RegexOptions.IgnoreCase | RegexOptions.Singleline);
            Match match = regx.Match(Contenido.ToString());
            if (match.Success)
            {
                Contenido = Contenido.Replace(match.Groups["content"].Value, "");
            }
        }
        return Contenido;
    }

    public void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;
        StringBuilderEx plantilla= new StringBuilderEx();
        StringBuilderEx plantillaValoracion = new StringBuilderEx();
        StringBuilderEx contenido = new StringBuilderEx();
        GResultados.AllowPaging = false;
        GResultados.DataBind();

        Regex regx = new Regex(".*<body.*?>(?<theBody>.*)\n.*</body>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
        Match match = regx.Match(evento.Contenido.ToString());
        if (match.Success)
        {
            evento.Contenido = evento.Contenido.Replace(match.Groups["theBody"].Value, "{body}");
            plantilla= match.Groups["theBody"].Value;
        }

        using (StreamReader reader = new StreamReader(Server.MapPath("~/paciente/valoracionat.html")))
        {
            match = regx.Match(reader.ReadToEnd());
            if (match.Success)
                plantillaValoracion = match.Groups["theBody"].Value;
            reader.Close();
        }

        // Request.Cookies
        PP.Visible = true;

        using (CConector conector = new CConector())
        {
            for (int i = 0; i < GResultados.Rows.Count; i++)
            {
                CCDetallePaciente.IdPaciente = GResultados.DataKeys[i].Values["paciente"].ToString();
                TPaciente.Text = CCDetallePaciente.Documento;
                LPaciente.Text = CCDetallePaciente.Nombres;
                GFuerza.Visible = false;
                SFuerza.SelectParameters["valoracion"].DefaultValue = "";
                string idFuncionario = "";
                Query query;
                MySqlDataReader reader;

                if (GResultados.DataKeys[i].Values["evolucion"].ToString() == "1")
                {
                    contenido += plantilla.ToString();
                    query = new Query("evolucion_terapeutivo");

                    query["TFecha"] = "fecha";
                    query += "funcionario";
                    query["TFR"] = "fr";
                    query["TFC"] = "fc";
                    query["TTA"] = "ta";
                    query["TNumero"] = "sesion";
                    query["TLogros"] = "logros";
                    query["TPlan"] = "plan";
                    query["DTipo"] = "tipo";
                    query["LFinal"] = "fecha+interval 45 minute";

                    reader = conector.Query(query.GetSelect("id={0}", null, Query.GetValor(GResultados.DataKeys[i].Values["id"].ToString())));
                    if (reader != null && reader.Read())
                    {
                        Producto producto = Producto.GetProducto(reader["DTipo"].ToString());
                        contenido = contenido.Replace(string.Format("${0}$", "DTipo"), producto.NombreCompleto);

                        for (int j = 0; j < reader.FieldCount; j++)
                        {
                            contenido = contenido.Replace(string.Format("${0}$", reader.GetName(j)), reader.GetValue(j).ToString());
                        }
                        idFuncionario = reader["funcionario"].ToString();
                    }
                } else { // valoracion
                    StringBuilderEx valoracionStringBuilder = new StringBuilderEx(plantillaValoracion.ToString());

                    GFuerza.Visible = true;
                    SFuerza.SelectParameters["valoracion"].DefaultValue = GResultados.DataKeys[i].Values["id"].ToString();
                    // GFuerza.DataBind();

                    Query valoracion = new Query("valoracionat");

                    valoracion["TInicio"] = "inicio";
                    valoracion["DTipo"]= "tipo";
                    valoracion["TObservaciones"] = "observaciones";
                    valoracion["funcionario"] = "funcionario";
                    valoracion["LFinal"] = "inicio+interval 45 minute";

                    // panel comun
                    valoracion["TTA"] = "TA";
                    valoracion["TFR"] = "FR";
                    valoracion["TFC"] = "FC";
                    valoracion["TSaturacion"] = "saturacion";
                    valoracion["TJustificacion"] = "justificacion";
                    valoracion["TPatron"] = "revision";
                    valoracion["TActividades"] = "actividades";
                    valoracion["TResultados"] = "resultado";

                    Procedimientos.TipoServicio tiposervicio = Procedimientos.TipoServicio.Ninguno;

                    reader = conector.Query(valoracion.GetSelect("id={0}", null, Query.GetValor(GResultados.DataKeys[i].Values["id"].ToString())));
                    if (reader != null && reader.Read())
                    {
                        try
                        {
                            Producto producto = Producto.GetProducto(reader["DTipo"].ToString());
                            valoracionStringBuilder = valoracionStringBuilder.Replace(string.Format("${0}$", "DTipo"), producto.NombreCompleto);
                            tiposervicio = (Procedimientos.TipoServicio)Convert.ToInt32(producto.TipoServicio);
                        } catch { }

                        for (int j = 0; j < reader.FieldCount; j++)
                        {
                            valoracionStringBuilder = valoracionStringBuilder.Replace(string.Format("${0}$", reader.GetName(j)), reader.GetValue(j).ToString());
                        }
                        idFuncionario = reader["funcionario"].ToString();

                        valoracionStringBuilder = valoracionStringBuilder.Replace("$LNumeroTerapias$"
                            ,conector.QueryString(@"SELECT autorizacion_detalle.autNumSesiones
                            FROM programacion 
                            LEFT JOIN autorizacion_detalle ON (autorizacion_detalle.autNumero=programacion.autNumero AND autorizacion_detalle.actId=programacion.actId)
                            WHERE programacion.pacId={0} 
                            AND programacion.prgFechaProg>SYSDATE()-INTERVAL 7 DAY 
                            AND ({1}=1 OR programacion.perId={2})
                            AND programacion.actId={3} LIMIT 1", GResultados.DataKeys[i].Values["paciente"], 0, Query.GetValor(idFuncionario), reader["DTipo"]));
                    }

                    Query respiratoria = new Query("valoracionat_respiratoria");

                    respiratoria["COxigeno"] = "eoxigeno";
                    respiratoria["TOxigeno"] = "szEOxigeno";
                    respiratoria["CLatrogenia"] = "latrogenia";
                    respiratoria["TLatrogenia"] = "szLatrogenia";

                    reader = conector.Query(respiratoria.GetSelect("valoracion={0}", null, Query.GetValor(GResultados.DataKeys[i].Values["id"].ToString())));
                    if (reader != null && reader.Read())
                    {
                        for (int j = 0; j < reader.FieldCount; j++)
                        {
                            valoracionStringBuilder = valoracionStringBuilder.Replace(string.Format("${0}$", reader.GetName(j)), reader.GetValue(j).ToString());
                        }
                    }

                    Query apoyo = new Query("valoracionat_ocupacional");

                    apoyo["CPresentoEA"] = "presentoEA";
                    apoyo["TPresentoEA"] = "szPresentoEA";
                    apoyo["TMedidas"] = "medidas";

                    reader = conector.Query(apoyo.GetSelect("valoracion={0}", null, Query.GetValor(GResultados.DataKeys[i].Values["id"].ToString())));
                    if (reader != null && reader.Read())
                    {
                        for (int j = 0; j < reader.FieldCount; j++)
                        {
                            valoracionStringBuilder = valoracionStringBuilder.Replace(string.Format("${0}$", reader.GetName(j)), reader.GetValue(j).ToString());
                        }
                    }

                    valoracionStringBuilder = valoracionStringBuilder.Replace(string.Format("${0}$", "LTerapiaOcupacional"), Procedimientos.GetNombreTipoServicio(tiposervicio).ToUpper());

                    valoracionStringBuilder = RemoveSection(tiposervicio == Procedimientos.TipoServicio.TerapiaRespiratoria, "PRespiratoria", valoracionStringBuilder);
                    valoracionStringBuilder = RemoveSection(tiposervicio == Procedimientos.TipoServicio.TerapiaFisica, "PFisica", valoracionStringBuilder);
                    valoracionStringBuilder = RemoveSection(tiposervicio == Procedimientos.TipoServicio.TerapiaOcupacional || tiposervicio == Procedimientos.TipoServicio.TerapiaLenguaje, "POcupacional", valoracionStringBuilder);

                    contenido += valoracionStringBuilder.ToString();
                }

                Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
                contenido = contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
                contenido = contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

                query = new Query("recurso_humano");

                query["TFuncionario"] = "recurso_humano.perNombre";
                query["szProfesional"] = "recurso_humano.perDocumento";
                query["szCargo"] = "cargo.carDescripcion";

                reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(idFuncionario), " LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)"));
                if (reader != null)
                {
                    bool l = reader.Read();
                    for (int j = 0; j < reader.FieldCount; j++)
                    {
                        contenido = contenido.Replace("$" + reader.GetName(j) + "$", l ? reader[j].ToString() : "");
                    }
                }
                contenido = contenido.Replace("$szIdUsuario$", conector.QueryString("SELECT id FROM usuario WHERE personal=" + Query.GetValor(UCFuncionario.IdFuncionario)));
                contenido = Utilidades.ReplaceContenido(PP.Controls, contenido);
            }
        }
        evento.Contenido = evento.Contenido.Replace("{body}", contenido.ToString());
    }
}