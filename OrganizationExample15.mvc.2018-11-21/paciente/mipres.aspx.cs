using MySql.Data.MySqlClient;
using SDG.Componentes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class paciente_mipres : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack)
        {
            using (CConector conector = new CConector())
            {
                List<Miscelaneos> servicios= new List<Miscelaneos>();
                CUsuario usuario = null;
                if (!string.IsNullOrEmpty(Request.QueryString["uId"]) && Request.Url.Host == "localhost") {
                    usuario = CUsuario.GetUser(conector, Request.QueryString["uId"]);
                }
                if(usuario==null)
                    usuario = (CUsuario)Usuario.GetUsuario();
                BAceptar.Enabled = false;
                TFecha.Text = Query.GetFromMySQLDate(DateTime.Now.Date, true);
                UCFuncionario.IdFuncionario = usuario["personal"];
                DTV.MinumunValue = DateTime.Now.AddDays(-2);
                DTV.MaximunValue = DateTime.Now.AddMinutes(1);
                DTV.Enabled = !usuario.CanUpdate();
                TId.Focus();

                GServicios.Columns[0].Visible = usuario.CanInsert();
                GServicios.Columns[1].Visible = usuario.CanInsert();
                BMServicio.Enabled = usuario.CanInsert();

            
                TId.Text = conector.QueryString("SELECT IFNULL(MAX(id)+1,1) FROM mipres");
                if (Request.QueryString["pid"] != null)
                {
                    CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                    if (CCDetallePaciente.IdPaciente.Length == 0)
                    {
                        Response.Redirect(Request.Url.AbsolutePath);
                    }
                    else
                    {
                        List<Miscelaneos> list = new List<Miscelaneos>();

                        Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
                        for (int i = 0; i < paciente.cie10.Count; i++)
                        {
                            string codigo = paciente.cie10[i].ToString();
                            list.Add(new Miscelaneos(codigo, Procedimientos.GetCodigoCIE(codigo)));
                        }

                        CIE10.Codes = list;

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
                                    FROM mipres
                                    LEFT JOIN recurso_humano ON (recurso_humano.perId=mipres.elaboradopor)
                                    WHERE paciente=@paciente 
                                    ORDER BY fecha DESC"
                            , "~/paciente/mipres.aspx?pid={0}&ampid={1}"
                            , CCDetallePaciente.IdPaciente, "Acta", "Actas");

                        if (!string.IsNullOrEmpty(Request.QueryString["ampid"]))
                        {
                            Query query = new Query("mipres");

                            query += "id";
                            query += "paciente";
                            query += "fecha";
                            query += "elaboradopor";
                            query += "asistente1";
                            query += "asistente2";
                            query += "asistente3";
                            query += "prescripcion";
                            query += "tipo";
                            query += "estado";
                            query += "numero";
                            query += "justificacion";
                            query += "cie10";
                            query += "servicios";
                            query += "actaid";

                            MySqlDataReader reader = conector.Query(query.GetSelect("id={0}", null, Query.GetValor(Request.QueryString["ampid"])));
                            if (reader != null && reader.Read())
                            {
                                string id = reader["id"].ToString();
                                ViewState["id"] = id;
                                ((MasterPageI)Master).SetModificacion(id);
                                ((MasterPageI)Master).Imprimir("mipres.html");
                                TId.Text = id;
                                if (reader["actaid"] != DBNull.Value)
                                    TId.Text = reader["actaid"].ToString();
                                BAceptar.Enabled = usuario.CanUpdate();
                                BEliminar.Visible = usuario.CanDelete();

                                if (reader["paciente"].ToString() != Request.QueryString["pid"])
                                    Response.Redirect(Request.Url.AbsolutePath + "?pid=" + reader["paciente"].ToString() + "&ampid=" + Request.QueryString["emid"]);

                                UCFuncionario.IdFuncionario = reader["elaboradopor"].ToString();
                                UCAsistente1.IdFuncionario = reader["asistente1"].ToString();
                                UCAsistente2.IdFuncionario = reader["asistente2"].ToString();
                                UCAsistente3.IdFuncionario = reader["asistente3"].ToString();
                                TFecha.Text = Query.GetFromMySQLDate(reader["fecha"], true);
                                TPrescripcion.Text = Query.GetFromMySQLDate(reader["prescripcion"], true);
                                RTipo.SelectedValue = reader["tipo"].ToString();
                                RAprobada.SelectedValue = reader["estado"].ToString();
                                TNumero.Text = reader["numero"].ToString();
                                TJustificacion.Text = reader["justificacion"].ToString();

                                list = new List<Miscelaneos>();

                                foreach(string codigo in reader["cie10"].ToString().Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                                {
                                    list.Add(new Miscelaneos(codigo, Procedimientos.GetCodigoCIE(codigo)));
                                }

                                CIE10.Codes = list;

                                foreach (string codes in reader["servicios"].ToString().Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries)) {
                                    servicios.Add(new Miscelaneos(codes, Varios.Get(codes).Nombre));
                                }
                                GServicios.DataSource = servicios;
                                GServicios.DataBind();
                            }
                        }
                    }
                }
                ViewState["servicios"] = servicios;
            }
        }
    }
    public void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;
        List<Miscelaneos> list = ViewState["servicios"] as List<Miscelaneos>;
        Page.Title= Title = TNumero.Text;

        Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
        evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
        evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

        evento.Contenido = evento.Contenido.Replace("$ListCIE10$", string.Join("<br/>", CIE10.Codes.Select(x => HttpUtility.HtmlEncode(x.Nombre))));
        evento.Contenido = evento.Contenido.Replace("$ListServicios$", 
            "<ul>" + 
            string.Join("", list.Select(x => string.Format("<li>{0}</li>", HttpUtility.HtmlEncode(x.Nombre))))
            + "</ul>"
            );

        Funcionario funcionario = Funcionario.GetFuncionario(UCFuncionario.IdFuncionario);
        evento.Contenido = evento.Contenido.Replace("$ElaboradoPor$", funcionario.Nombres);

        funcionario = Funcionario.GetFuncionario(UCAsistente1.IdFuncionario);

        evento.Contenido = evento.Contenido.Replace("$IdAsistente1$", funcionario.Id)
            .Replace("$szAsistente1$", funcionario.Nombres)
            .Replace("$szProfesional1$", funcionario.Documento)
            .Replace("$szCargo1$", funcionario.Cargo);

        funcionario = Funcionario.GetFuncionario(UCAsistente2.IdFuncionario);

        evento.Contenido = evento.Contenido.Replace("$IdAsistente2$", funcionario.Id)
            .Replace("$szAsistente2$", funcionario.Nombres)
            .Replace("$szProfesional2$", funcionario.Documento)
            .Replace("$szCargo2$", funcionario.Cargo);

        funcionario = Funcionario.GetFuncionario(UCAsistente3.IdFuncionario);

        evento.Contenido = evento.Contenido.Replace("$IdAsistente3$", funcionario.Id)
            .Replace("$szAsistente3$", funcionario.Nombres)
            .Replace("$szProfesional3$", funcionario.Documento)
            .Replace("$szCargo3$", funcionario.Cargo);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            string id = ViewState["id"] as string;
            List<Miscelaneos> list = ViewState["servicios"] as List<Miscelaneos>;

            if (list.Count == 0) {
                LMessage.Text = "Por favor ingrese por lo menos un servicio";
                return;
            }

            Query query = new Query("mipres");

            query["paciente"]= CCDetallePaciente.IdPaciente;
            query["fecha"]= Query.GetMySQLDateFormat(TFecha.Text, true);
            query["elaboradopor"]= UCFuncionario.IdFuncionario;
            query["asistente1"]= UCAsistente1.IdFuncionario;
            query["asistente2"] = UCAsistente2.IdFuncionario;
            query["asistente3"] = UCAsistente3.IdFuncionario;
            query["prescripcion"]= Query.GetMySQLDateFormat(TPrescripcion.Text, true);
            query["tipo"]= RTipo.SelectedValue;
            query["estado"]= RAprobada.SelectedValue;
            query["numero"]= TNumero.Text;
            query["justificacion"]=TJustificacion.Text;
            query["cie10"]= string.Join(",", CIE10.Codes.Select(x=>x.Id));
            query["servicios"] = string.Join(",", list.Select(x => x.Id));

            if (string.IsNullOrEmpty(id))
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                {
                    LMessage.Text = conector.LastError;
                    return;
                }
                id = res.ToString();
            }
            else {
                if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1) {
                    LMessage.Text = conector.LastError;
                    return;
                }
            }
            if (conector.InsertModificacion(id) == -1) {
                LMessage.Text = conector.LastError;
                return;
            }

            conector.Commit();
            ((MasterPageI)Master).SetResultado("Acta MIPRES editada");
        }
    }

    protected void BEliminar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            string id = (string)ViewState["id"];
            Query query = new Query("mipres");

            if (conector.QueryMod(query.GetDelete("id=" + Query.GetValor(id))) == -1)
            {
                LMessage.Text = conector.LastError;
                return;
            }

            conector.Commit();
            Response.Redirect(Request.Url.AbsolutePath);
        }
    }

    protected void GServicios_SelectedIndexChanged(object sender, EventArgs e)
    {
        string code= GServicios.SelectedDataKey["Id"].ToString();
        TIdServicio.Text = code;
        TServicio.Text = Varios.Get(code).Nombre;
        TServicio.Focus();
    }

    protected void GServicios_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        List<Miscelaneos> list = ViewState["servicios"] as List<Miscelaneos>;
        string codigo = e.Keys["Id"].ToString();
        list.RemoveAll(x => x.Id == e.Keys["Id"].ToString());

        GServicios.DataSource = list;
        GServicios.SelectedIndex = -1;
        GServicios.DataBind();

        TIdServicio.Text =
        TServicio.Text = "";
        TServicio.Focus();
        e.Cancel = true;
    }

    protected void BMServicio_Click(object sender, EventArgs e)
    {
        Page.Validate("servicio");
        if (!Page.IsValid)
            return;

        List<Miscelaneos> list = ViewState["servicios"] as List<Miscelaneos>;
        string codigo = TIdServicio.Text;
        if (!list.Exists(x => x.Id == codigo))
        {
            if (GServicios.SelectedIndex != -1)
            {
                list.RemoveAt(GServicios.SelectedIndex);
                list.Insert(GServicios.SelectedIndex, new Miscelaneos(codigo, Varios.Get(codigo).Nombre));
            } else list.Add(new Miscelaneos(codigo, Varios.Get(codigo).Nombre));
        }

        GServicios.DataSource = list;
        GServicios.SelectedIndex = -1;
        GServicios.DataBind();

        TIdServicio.Text =
        TServicio.Text = "";
        TServicio.Focus();
    }
}