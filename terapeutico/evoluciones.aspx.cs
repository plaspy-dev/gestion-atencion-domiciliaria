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

    public void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;
        StringBuilderEx plantilla= new StringBuilderEx();
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

        // Request.Cookies
        PP.Visible = true;

        using (CConector conector = new CConector())
        {
            for (int i = 0; i < GResultados.Rows.Count; i++)
            {
                contenido += plantilla.ToString();
                CCDetallePaciente.IdPaciente = GResultados.DataKeys[i].Values["paciente"].ToString();
                TPaciente.Text = CCDetallePaciente.Documento;
                LPaciente.Text = CCDetallePaciente.Nombres;


                Query query = new Query("evolucion_terapeutivo");
                string idFuncionario = "";

                query["TFecha"] = "fecha";
                query += "funcionario";
                query["TFR"] = "fr";
                query["TFC"] = "fc";
                query["TTA"] = "ta";
                query["TNumero"] = "sesion";
                query["TLogros"] = "logros";
                query["TPlan"] = "plan";
                query["DTipo"] = "tipo";

                MySqlDataReader reader = conector.Query(query.GetSelect("id={0}", null, Query.GetValor(GResultados.DataKeys[i].Values["id"].ToString())));
                if (reader != null && reader.Read())
                {
                    for (int j = 0; j < reader.FieldCount; j++)
                    {
                        contenido = contenido.Replace(string.Format("${0}$", reader.GetName(j)), reader.GetValue(j).ToString());
                    }
                    idFuncionario = reader["funcionario"].ToString();
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
                evento.Contenido = Utilidades.ReplaceContenido(PP.Controls, evento.Contenido);
                /*string url = string.Format("~/terapeutico/evolucion.aspx?pid={0}&evtid={1}&p=1", GResultados.DataKeys[i].Values["paciente"], GResultados.DataKeys[i].Values["id"]);
                url= Utilidades.GetURLFullPath(url);
                Logs.Write(url);
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                request.CookieContainer = new CookieContainer();
                foreach(string cookie in Request.Cookies)
                    request.CookieContainer.Add(new Cookie(cookie, Request.Cookies[cookie].Value, Request.Cookies[cookie].Path, Request.Url.Host));
                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                {
                    using (StreamReader sreader = new StreamReader(response.GetResponseStream()))
                    {
                        string responseFromServer = sreader.ReadToEnd();

                        Regex regx = new Regex(".*<body.*?>(?<theBody>.*)\n.*</body>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
                        Match match = regx.Match(responseFromServer);
                        if (match.Success)
                        {
                            if (string.IsNullOrEmpty(contenido))
                                contenido = responseFromServer.Replace(match.Groups["theBody"].Value, "{body}");
                            responseFromServer = match.Groups["theBody"].Value;
                        }
                        temp += responseFromServer;
                    }
                }*/
            }
        }
        evento.Contenido = evento.Contenido.Replace("{body}", contenido.ToString());
    }
}