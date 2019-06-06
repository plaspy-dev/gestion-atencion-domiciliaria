using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using Newtonsoft.Json.Linq;
using SDG.Componentes;

public partial class materna_postparto : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            BAceptar.Enabled = false;
            TFecha.Text = Query.GetFromMySQLDate(DateTime.Now.Date, true);
            UCFuncionario.IdFuncionario = usuario["personal"];
            DTV.MinumunValue = DateTime.Now.AddDays(-2);
            DTV.MaximunValue = DateTime.Now.AddMinutes(1);
            DTV.Enabled = !usuario.CanUpdate();
            /*TTA.Focus();*/

            using (CConector conector = new CConector())
            {
                if (Request.QueryString["pid"] != null)
                {
                    CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                    if (CCDetallePaciente.IdPaciente.Length == 0)
                    {
                        Response.Redirect(Request.Url.AbsolutePath);
                    }
                    else
                    {
                        ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                        SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                        SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;
                        TFecha.Text = Query.GetFromMySQLDate(DateTime.Now.Date, true);

                        if (Request.QueryString["npdf"] == "1")
                            Title = CCDetallePaciente.Documento + " - " + CCDetallePaciente.Nombres.Replace("(Inactivo)", "");

                        CCDetallePaciente.Visible =
                        PD.Visible = true;

                        BAceptar.Enabled = usuario.CanInsert();
                        UCFuncionario.ReadOnly = !usuario.CanAdmin();

                        UCH.Init(@"SELECT id,fecha,paciente,recurso_humano.perNombre AS funcionario 
                                    FROM seguimiento_materno
                                    LEFT JOIN recurso_humano ON (recurso_humano.perId=seguimiento_materno.funcionario)
                                    WHERE paciente=@paciente AND tipo=2
                                    ORDER BY fecha DESC"
                            , "~/materna/postparto.aspx?pid={0}&emid={1}"
                            , CCDetallePaciente.IdPaciente, "Seguimiento", "Seguimientos");

                        if (!string.IsNullOrEmpty(Request.QueryString["emid"]))
                        {
                            Query query = new Query("seguimiento_materno");

                            query += "id";
                            query += "paciente";
                            query += "fecha";
                            query += "funcionario";
                            query += "data";
                            query += "tipo";

                            MySqlDataReader reader = conector.Query(query.GetSelect("id={0}", null, Query.GetValor(Request.QueryString["emid"])));
                            if (reader != null && reader.Read())
                            {
                                if (reader["paciente"].ToString() != Request.QueryString["pid"])
                                    Response.Redirect(Request.Url.AbsolutePath + "?pid=" + reader["paciente"].ToString() + "&emid=" + Request.QueryString["emid"]);

                                switch (reader["tipo"].ToString())
                                {
                                    case "1":
                                        Response.Redirect(string.Format("~/materna/seguimiento.aspx?pid={0}&emid={1}", reader["paciente"].ToString(), Request.QueryString["emid"]));
                                        return;
                                    case "3":
                                        Response.Redirect(string.Format("~/Materna/Evolucion?pid={0}&ehid={1}", reader["paciente"].ToString(), Request.QueryString["emid"]));
                                        return;
                                }

                                string id = reader["id"].ToString();
                                DTV.Enabled = false;
                                BAceptar.Enabled = usuario.CanUpdate();
                                BEliminar.Visible = usuario.CanDelete();
                                ((MasterPageI)Master).SetModificacion(id);
                                ((MasterPageI)Master).Imprimir("postparto.html");

                                ViewState["id"] = id;
                                TFecha.Text = Query.GetFromMySQLDate(reader["fecha"], true);
                                UCFuncionario.IdFuncionario = reader["funcionario"].ToString();

                                JObject data = SerializeJSON.DesSerialize(Controls, reader["data"].ToString(), new Control[] { TFecha, UCFuncionario, SeleccionarPaciente, CIE10 });

                                string cie10 = (string)data["cie10"];
                                List<Miscelaneos> list = new List<Miscelaneos>();
                                if (!string.IsNullOrEmpty(cie10))
                                {
                                    foreach (string code in cie10.Split(','))
                                    {
                                        list.Add(new Miscelaneos(code, Procedimientos.GetCodigoCIE(code)));
                                    }
                                }
                                CIE10.Codes = list;

                                SetId(Controls, id);
                            }
                        }

                        if (ViewState["id"] == null)
                        {

                            List<Miscelaneos> list = new List<Miscelaneos>();

                            Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
                            for (int i = 0; i < paciente.cie10.Count; i++)
                            {
                                string codigo = paciente.cie10[i].ToString();
                                list.Add(new Miscelaneos(codigo, Procedimientos.GetCodigoCIE(codigo)));
                            }

                            CIE10.Codes = list;
                        }
                    }
                }
            }
        }
    }

    public void SetId(ControlCollection controles, string id)
    {

        foreach (Control info in controles)
        {

            if (info is SqlDataSource)
            {
                if (((SqlDataSource)info).SelectParameters["seguimiento"] != null)
                    ((SqlDataSource)info).SelectParameters["seguimiento"].DefaultValue = id;
            }
            else
            {
                if (info.HasControls())
                    SetId(info.Controls, id);
            }
        }
    }

    protected void BEliminar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            string id = (string)ViewState["id"];
            Query query = new Query("seguimiento_materno");

            if (conector.QueryMod(query.GetDelete("id=" + Query.GetValor(id))) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }

            query = new Query("seguimiento_materno_items");

            if (conector.QueryMod(query.GetDelete("seguimiento=" + Query.GetValor(id))) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }

            conector.Commit();
            Response.Redirect(Request.Url.AbsolutePath);
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            string id = (string)ViewState["id"];
            Query query = new Query("seguimiento_materno");

            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text, true);
            query["paciente"] = CCDetallePaciente.IdPaciente;
            query["funcionario"] = UCFuncionario.IdFuncionario;
            query["tipo"] = "2";

            List<Miscelaneos> codes = CIE10.Codes;

            query["data"] = SerializeJSON.Serialize(Controls
                , new Control[] { TFecha, UCFuncionario, SeleccionarPaciente, CIE10 }
                , new Dictionary<string, JToken>() { { "cie10", string.Join(",", codes.Select(x => x.Id)) } }
                );

            if (string.IsNullOrEmpty(id))
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
                id = res.ToString();
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(id))) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }
            if (conector.InsertModificacion(id) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }

            query = new Query("seguimiento_materno_items");

            if (conector.QueryMod(query.GetDelete("seguimiento=" + Query.GetValor(id))) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }

            if (!SerializeJSON.SaveGriwRadio(conector, GMotivo, "seguimiento_materno_items", "seguimiento", id)
                || !SerializeJSON.SaveGriwRadio(conector, GRiesgo, "seguimiento_materno_items", "seguimiento", id)
                || !SerializeJSON.SaveRepeaterRadio(conector, RSistemas, "seguimiento_materno_items", "seguimiento", id)
                || !SerializeJSON.SaveRepeaterRadio(conector, RAntecendetes, "seguimiento_materno_items", "seguimiento", id)
                || !SerializeJSON.SaveRepeaterRadio(conector, RAntecendetes2, "seguimiento_materno_items", "seguimiento", id)
                || !SerializeJSON.SaveGriwRadio(conector, GAntecendentes3, "seguimiento_materno_items", "seguimiento", id)
                || !SerializeJSON.SaveRepeaterRadio(conector, REFisico, "seguimiento_materno_items", "seguimiento", id)
                || !SerializeJSON.SaveRepeaterRadio(conector, RSenos, "seguimiento_materno_items", "seguimiento", id)
                || !SerializeJSON.SaveRepeaterRadio(conector, RAbdomen, "seguimiento_materno_items", "seguimiento", id)
                || !SerializeJSON.SaveRepeaterRadio(conector, RMInferiores, "seguimiento_materno_items", "seguimiento", id)
                || !SerializeJSON.SaveGriwRadio(conector, GAObstetrica, "seguimiento_materno_items", "seguimiento", id)
                || !SerializeJSON.SaveGriwRadio(conector, GManejo, "seguimiento_materno_items", "seguimiento", id)
                )
            {
                LMensaje.Text = conector.LastError;
                return;
            }

            // actualizamos el cie10 del paciente
            string cie10 = "", cie102 = "", cie103 = "";

            for (int i = 0; i < codes.Count; i++)
            {
                switch (i)
                {
                    case 0:
                        cie10 = codes[i].Id;
                        break;
                    case 1:
                        cie102 = codes[i].Id;
                        break;
                    case 2:
                        cie103 = codes[i].Id;
                        break;
                }
            }

            if (conector.QueryMod("UPDATE paciente SET cieCodDx=" + Query.GetValor(cie10) + ",cieCodDx_1=" + Query.GetValor(cie102) + ",cieCodDx_2=" + Query.GetValor(cie103) + " WHERE pacId=" + CCDetallePaciente.IdPaciente) == -1)
                return;

            Paciente.RemovePaciente(CCDetallePaciente.IdPaciente);


            conector.Commit();
            ((MasterPageI)Master).SetResultado("Seguimiento de " + CCDetallePaciente.Nombres + " editado.");
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    private bool Printing = false;
    public static Regex regexHeader = new Regex(@"(\d+.?\d* )?(.+)", RegexOptions.Compiled);

    protected string GetHeader(object row)
    {
        if (row == null)
            return null;
        if (Printing)
            return row.ToString();
        string text = row.ToString();
        Match match = regexHeader.Match(text);
        if (match.Success)
            return match.Groups[2].Value;
        return text;
    }

    public string RenderTextBlock(CConector conector, string id, int parametro, bool radio = false)
    {

        StringBuilder text = new StringBuilder();

        string query = string.Format(@"SELECT varios.nombre,seguimiento_materno_items.valor
                            FROM varios 
                            LEFT JOIN seguimiento_materno_items ON (seguimiento_materno_items.seguimiento={1} AND seguimiento_materno_items.tipo=varios.id)
                            WHERE varios.tipo={0} AND varios.szReservado IS NULL 
                            ORDER BY SUBSTRING_INDEX(SUBSTRING_INDEX(varios.nombre, ' ', 1),'.',-1)*1", parametro, id);

        MySqlDataReader reader = conector.Query(query);
        if (reader != null)
        {
            while (reader.Read())
            {
                if (radio)
                    text.AppendFormat("<div>{0}<b class='fr'>{1}</b></div>", HttpUtility.HtmlEncode(reader["nombre"].ToString()), reader["valor"].ToString() == "1" ? "SI" : "NO");
                else text.AppendFormat("<div>{0}: {1}</div>", HttpUtility.HtmlEncode(reader["nombre"].ToString()), HttpUtility.HtmlEncode(reader["valor"].ToString()));
            }
        }

        return text.ToString();
    }

    public string RenderRadioInline(CConector conector, string id, int parametro)
    {

        return RenderMixed(conector, id, x => x == parametro, x => false, parametro);
    }

    public string RenderTextInline(CConector conector, string id, int parametro)
    {

        return RenderMixed(conector, id, x => false, x => x == parametro, parametro);
    }

    public string RenderMixed(CConector conector, string id, Func<int, bool> radiofunction, Func<int, bool> shortText, params int[] parametros)
    {
        StringBuilder text = new StringBuilder();

        string query = string.Format(@"SELECT varios.nombre,varios.descripcion,seguimiento_materno_items.valor,seguimiento_materno_items.valor2,varios.tipo
                            FROM varios 
                            LEFT JOIN seguimiento_materno_items ON (seguimiento_materno_items.seguimiento={1} AND seguimiento_materno_items.tipo=varios.id)
                            WHERE varios.tipo IN ({0}) AND varios.szReservado IS NULL 
                            ORDER BY SUBSTRING_INDEX(SUBSTRING_INDEX(varios.nombre, ' ', 1),'.',-1)*1", string.Join(",", parametros), id);

        MySqlDataReader reader = conector.Query(query);
        if (reader != null)
        {
            while (reader.Read())
            {
                if (radiofunction(Convert.ToInt32(reader["tipo"])))
                {
                    if (string.IsNullOrEmpty(reader["descripcion"].ToString()))
                        text.AppendFormat("<span class='insp'>{0} <b>{1}</b></span>", HttpUtility.HtmlEncode(reader["nombre"].ToString()), reader["valor"].ToString() == "1" ? "SI" : "NO");
                    else text.AppendFormat("<span class='insp'>{0} <b>{1}</b> {2}: <b>{3}</b></span>"
                        , HttpUtility.HtmlEncode(reader["nombre"].ToString()), reader["valor"].ToString() == "1" ? "SI" : "NO"
                        , HttpUtility.HtmlEncode(reader["descripcion"].ToString()), HttpUtility.HtmlEncode(reader["valor2"].ToString())
                        );
                }
                else if (shortText(Convert.ToInt32(reader["tipo"])))
                {
                    text.AppendFormat("<span class='insp'>{0} <b>{1}</b> {2}</span>", HttpUtility.HtmlEncode(reader["nombre"].ToString()), reader["valor"], reader["descripcion"]);
                }
                else
                {
                    text.AppendFormat("<div>{0}: <b>{1}</b></div>", HttpUtility.HtmlEncode(reader["nombre"].ToString()), reader["valor"]);
                }
            }
        }

        return text.ToString();
    }

    public void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;
        using (CConector conector = new CConector())
        {
            Printing = true;

            CIE10.Print = true;
            GAObstetrica.DataBind();
            GAObstetrica.DataSourceID = "";

            string id = (string)ViewState["id"];
            evento.Contenido.Replace("$grid2$", RenderTextBlock(conector, id, 156, true));
            evento.Contenido.Replace("$grid3$", RenderTextBlock(conector, id, 142, true));
            evento.Contenido.Replace("$gantecedentes$", RenderMixed(conector, id, x => x == 158, x => x == 157, 157, 158, 145));
            evento.Contenido.Replace("$grevision$", RenderRadioInline(conector, id, 159));
            evento.Contenido.Replace("$gexamenfisico$", RenderTextInline(conector, id, 152));
            evento.Contenido.Replace("$gsenos$", RenderRadioInline(conector, id, 160));
            evento.Contenido.Replace("$gabdomen$", RenderRadioInline(conector, id, 161));
            evento.Contenido.Replace("$gmiembrosinferiores$", RenderRadioInline(conector, id, 154));
            evento.Contenido.Replace("$gplandemanejo$", RenderTextBlock(conector, id, 155, false)); // 155
            evento.Contenido.Replace("$RRiesgo$", RRiesgo.SelectedValue == "1" ? "ALTO" : RRiesgo.SelectedValue == "2" ? "MEDIO" : "BAJO");
            evento.Contenido.Replace("$RVivo$", RVivo.SelectedValue == "1" ? "SI" : "NO");
            evento.Contenido.Replace("$RMuerto$", RVivo.SelectedValue == "0" ? "SI" : "NO");
            evento.Contenido.Replace("$RCasa$", RUbicacion.SelectedValue == "1" ? "SI" : "NO");
            evento.Contenido.Replace("$RHospitalizado$", RUbicacion.SelectedValue == "0" ? "SI" : "NO");
            
            string interconsultas = "";
            string[] lines = TInterconsultas.Text.Split('\n');
            for (int i = 0; i < lines.Length; i++)
            {
                interconsultas += string.Format("{0}. {1}<br/>", i + 1, HttpUtility.HtmlEncode(lines[i]));
            }
            evento.Contenido.Replace("$ginterconsultas$", interconsultas);

            Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);

            evento.Contenido.Replace("$LNombres$", paciente.pNombre + " " + paciente.sNombre);
            evento.Contenido.Replace("$LApellidos$", paciente.pApellido + " " + paciente.sApellido);
            evento.Contenido.Replace("$TipoDoc$", paciente.tipoDocNombre);
            evento.Contenido.Replace("$LDocumento$", paciente.documento);

            Funcionario funcionario = Funcionario.GetFuncionario(UCFuncionario.IdFuncionario);

            evento.Contenido.Replace("$FuncionarioNombre$", funcionario.Nombres);
            evento.Contenido.Replace("$FuncionarioDocumento$", funcionario.Documento);
            evento.Contenido.Replace("$szIdUsuario$", funcionario.Id.ToString());

            evento.Contenido.Replace("$SYSDATE()$", Query.GetMySQLDateFormat(DateTime.Now, true));
        }
    }
}