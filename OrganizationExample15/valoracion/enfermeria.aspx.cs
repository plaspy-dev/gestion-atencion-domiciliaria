using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class valoracion_enfermeria : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (IsPostBack) SDG.Web.UI.CompressedPage.FixCheckBoxList(Request.Form, Controls);
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            TFecha.Text = Query.GetFromMySQLDate(DateTime.Now, true);
            UCFuncionario.IdFuncionario = usuario["personal"];
            BAceptar.Enabled = usuario.CanInsert();
            UCFuncionario.ReadOnly = !usuario.CanAdmin();

            using (CConector conector = new CConector())
            {
                if (Request.QueryString["pid"] != null)
                {
                    CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                    if (CCDetallePaciente.IdPaciente.Length == 0)
                    {
                        Response.Redirect(Request.Url.AbsolutePath);
                    } else {
                        Query query = new Query("valoracion_enfermeria");

                        CCDetallePaciente.Visible = 
                        PDatos.Visible = true;

                        ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                        SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                        SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                        if (!string.IsNullOrEmpty(Request.QueryString["veid"]))
                        {
                            query += "id";
                            query += "paciente";
                            query += "fecha";
                            query += "funcionario";
                            query += "revision";
                            query += "talla";
                            query += "peso";
                            query += "hijos";
                            query += "abortos";
                            query += "anticonceptivos";
                            query += "menarquia";
                            query += "fur";
                            query += "fup";
                            query += "auto_mama";
                            query += "prostata";
                            query += "plan";
                            query += "interconsulta";

                            MySqlDataReader reader= conector.Query(query.GetSelect("id={0}", null, Query.GetValor(Request.QueryString["veid"])));

                            if (reader != null && reader.Read()) {

                                if (reader["paciente"].ToString() != Request.QueryString["pid"])
                                    Response.Redirect(Request.Url.AbsolutePath + "?pid=" + reader["paciente"].ToString() + "&evtid=" + Request.QueryString["pid"]);

                                BAceptar.Enabled = usuario.CanUpdate();
                                // BEliminar.Visible = usuario.CanDelete();
                                ((MasterPageI)Master).SetModificacion(reader["id"].ToString());
                                ((MasterPageI)Master).Imprimir("enfermeria.html");


                                HIdValoracion.Value = reader["id"].ToString();
                                CCDetallePaciente.IdPaciente = reader["paciente"].ToString();
                                TFecha.Text = Query.GetFromMySQLDate(reader["fecha"], true);
                                UCFuncionario.IdFuncionario= reader["funcionario"].ToString();
                                TRevision.Text = reader["revision"].ToString();
                                TTalla.Text = reader["talla"].ToString();
                                TPeso.Text = reader["peso"].ToString();
                                THijos.Text = reader["hijos"].ToString();
                                TAbortos.Text = reader["abortos"].ToString();
                                TAnticonceptivos.Text = reader["anticonceptivos"].ToString();
                                TMenarquia.Text = reader["menarquia"].ToString();
                                TFUR.Text = reader["fur"].ToString();
                                TFUP.Text = reader["fup"].ToString();
                                TAutoMama.Text = reader["auto_mama"].ToString();
                                TProstata.Text = reader["prostata"].ToString();
                                TPlanIntervencion.Text = reader["plan"].ToString();
                                TInterconsultas.Text = reader["interconsulta"].ToString();

                                CAutoPersepcion.DataBind();

                                query = new Query("valoracion_enfermeria_patron");
                                
                                query+="tipo";
                                query+="texto";

                                reader= conector.Query(query.GetSelect("valoracion={0} AND grupo={1}", null, Query.GetValor(HIdValoracion.Value), 96));
                                if(reader!=null){
                                    while(reader.Read()) {
                                        ListItem item= CAutoPersepcion.Items.FindByValue(reader["tipo"].ToString());
                                        if(item!=null) {
                                            item.Selected=reader["texto"].ToString()=="1";
                                        }
                                    }
                                }
                            }
                        }

                        PEvoluciones.Visible = GridUtils.GetRowsCount(GEvoluciones, LEvoluciones, "Valoración", "Valoraciones") > 0;
                        /*if(string.IsNullOrEmpty(HIdValoracion.Value)) {
                            query = new Query("valoracion_enfermeria");
                            query+="id";
                            HIdValoracion.Value= conector.QueryString(query.GetSelect("paciente={0}",null, Query.GetValor(CCDetallePaciente.IdPaciente)));
                            if (!string.IsNullOrEmpty(HIdValoracion.Value)) 
                                Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&veid=" + HIdValoracion.Value);
                        }*/
                    }
                }
            }
        }
    }

    public bool InsertRepeater(Conector conector, Repeater repeater, string valoracion, int grupo, string paciente = null)
    {

        Query query = new Query("valoracion_enfermeria_patron");

        if (conector.QueryMod(query.GetDelete("valoracion={0} AND grupo={1}", Query.GetValor(valoracion), grupo)) == -1)
            return false;

        query["valoracion"] = valoracion;
        query["grupo"] = grupo.ToString();

        foreach (RepeaterItem item in repeater.Items) {
            TextBox TValor = (TextBox)item.FindControl("T");
            if (TValor.Text.Length > 0) {
                HiddenField hId = (HiddenField)item.FindControl("H");
                query["tipo"] = hId.Value;
                query["texto"] = TValor.Text;
                CheckBox check = (CheckBox)item.FindControl("C");
                if (check != null)
                    query["estado"] = check.Checked ? "1" : "";

                if (!(string.IsNullOrEmpty(paciente) || Paciente.SaveAntecedente(conector, paciente, hId.Value, check.Checked ? "1" : "", TValor.Text)) 
                    || conector.QueryMod(query.GetInsert()) == -1)
                    return false;
            }
        }
        return true;
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        using (CConector conector = new CConector())
        {
            Query query = new Query("valoracion_enfermeria");
            string id = HIdValoracion.Value;
            conector.StartTransaction();

            query["paciente"] = CCDetallePaciente.IdPaciente;
            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text, true);
            query["funcionario"] = UCFuncionario.IdFuncionario;
            query["revision"] = TRevision.Text;
            query["talla"] = TTalla.Text;
            query["peso"] = TPeso.Text;
            query["hijos"] = THijos.Text;
            query["abortos"] = TAbortos.Text;
            query["anticonceptivos"] = TAnticonceptivos.Text;
            query["menarquia"] = TMenarquia.Text;
            query["fur"] = TFUR.Text;
            query["fup"] = TFUP.Text;
            query["auto_mama"] = TAutoMama.Text;
            query["prostata"] = TProstata.Text;
            query["plan"] = TPlanIntervencion.Text;
            query["interconsulta"] = TInterconsultas.Text;

            if (string.IsNullOrEmpty(id))
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
                id = res.ToString();
            } else {
                if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1)
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

            if(!InsertRepeater(conector, RPercepcion, id, 85)) {
                LMensaje.Text= conector.LastError;
                return;
            }

            if (!InsertRepeater(conector, RAntecendentes, id, 2, CCDetallePaciente.IdPaciente))
            {
                LMensaje.Text= conector.LastError;
                return;
            }

            if(!InsertRepeater(conector, RNutricional, id, 87)) {
                LMensaje.Text= conector.LastError;
                return;
            }

            if(!InsertRepeater(conector, REliminacion, id, 88)) {
                LMensaje.Text= conector.LastError;
                return;
            }

            if(!InsertRepeater(conector, RActividad, id, 89)) {
                LMensaje.Text= conector.LastError;
                return;
            }

            if(!InsertRepeater(conector, RDescanso, id, 90)) {
                LMensaje.Text= conector.LastError;
                return;
            }

            if(!InsertRepeater(conector, RCognitivo, id, 91)) {
                LMensaje.Text= conector.LastError;
                return;
            }

            if(!InsertRepeater(conector, RAutopercepcion, id, 92)) {
                LMensaje.Text= conector.LastError;
                return;
            }

            if(!InsertRepeater(conector, RFuncion, id, 93)) {
                LMensaje.Text= conector.LastError;
                return;
            }

            if(!InsertRepeater(conector, RTolerancia, id, 94)) {
                LMensaje.Text= conector.LastError;
                return;
            }

            if(!InsertRepeater(conector, RCreencias, id, 95)) {
                LMensaje.Text= conector.LastError;
                return;
            }

            query = new Query("valoracion_enfermeria_patron");

            if (conector.QueryMod(query.GetDelete("valoracion={0} AND grupo={1}", Query.GetValor(id), 96)) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }

            query["valoracion"] = id;
            query["grupo"] = "96";

            foreach (ListItem item in CAutoPersepcion.Items)
            {
                if (item.Selected) {
                    query["tipo"] = item.Value;
                    query["texto"] = "1";

                    if (conector.QueryMod(query.GetInsert()) == -1)
                    {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                        
                }
            }


            conector.Commit();

            ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
            ((MasterPageI)Master).SetResultado("Se ha editado una valoración a " + CCDetallePaciente.Nombres);
        }        
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    public void RenderRepeater(StringBuilderEx contenido, Repeater repeater) {

        string texto = "";

        repeater.DataBind();
        foreach (RepeaterItem item in repeater.Items)
        {
            TextBox TValor = (TextBox)item.FindControl("T");
            if (TValor.Text.Length > 0)
            {
                string label = "";
                Label etiqueta = (Label)item.FindControl("L");
                if (etiqueta == null)
                {
                    CheckBox checkBox = (CheckBox)item.FindControl("C");
                    label = checkBox.Text;
                }
                else label = etiqueta.Text;

                if (!string.IsNullOrEmpty(texto))
                    texto += ", ";
                texto += string.Format("<b>{0}</b>: {1}", HttpUtility.HtmlEncode(label), HttpUtility.HtmlEncode(TValor.Text));
            }
        }

        contenido = contenido.Replace("$" + repeater.ID + "$", texto);
    }

    public void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;

        using (CConector conector = new CConector())
        {
            Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
            evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
            evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

            foreach(Control control in PDatos.Controls) 
                if (control is Repeater) 
                    RenderRepeater(evento.Contenido, (Repeater)control);

            string texto = "";
            foreach (ListItem item in CAutoPersepcion.Items) {
                if (item.Selected) {
                    if(!string.IsNullOrEmpty(texto))
                        texto+= ", ";
                    texto += HttpUtility.HtmlEncode(item.Text);
                }
            }

            evento.Contenido = evento.Contenido.Replace("$CAutoPersepcion$", texto);

            Query query = new Query("recurso_humano");

            query["szProfesional"] = "recurso_humano.perDocumento";
            query["szCargo"] = "cargo.carDescripcion";

            MySqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(UCFuncionario.IdFuncionario), " LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)"));
            if (reader != null)
            {
                bool l = reader.Read();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
                }
            }
            evento.Contenido = evento.Contenido.Replace("$szIdUsuario$", conector.QueryString("SELECT id FROM usuario WHERE personal=" + Query.GetValor(UCFuncionario.IdFuncionario)));
        }
    }
}