using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class paciente_paraclinicos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack) {
            
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();
            BAceptar.Enabled = false;

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
                    TFecha.Text = DateTime.Now.ToShortDateString();
                    PDatos.Visible = true;
                    BAceptar.Enabled = usuario.CanInsert();

                    DMedico.Enabled = usuario.CanAdmin();
                    if (!usuario.CanAdmin())
                    {
                        DMedico.DataBind();
                        ListItem item = DMedico.Items.FindByValue(usuario["personal"]);
                        if (item == null)
                            BAceptar.Enabled = false;
                        else item.Selected = true;
                    }
                    TPlanManejo.ReadOnly = !usuario.CanAdmin();

                    DMedico.Focus();

                    Query query = new Query("paraclinico");

                    query += "id";
                    query += "fecha";
                    query += "medico";
                    query += "paciente";
                    query += "analisis";
                    query += "plan_manejo";

                    using (CConector conectormysql = new CConector())
                    {
                        MySqlDataReader readermysql = conectormysql.Query(query.GetSelect("id=" + Query.GetValor(Request.QueryString["idpar"])));
                        if (readermysql != null && readermysql.Read())
                        {
                            ViewState["id"] = readermysql["id"].ToString();
                            TAnalisis.Text = readermysql["analisis"].ToString();
                            TFecha.Text = Query.GetFromMySQLDate(readermysql["fecha"]);
                            Utilidades.SelectInDropDown(DMedico, readermysql["medico"]);
                            TPlanManejo.Text = readermysql["plan_manejo"].ToString();
                            
                            if (TPlanManejo.Text.Length == 0)
                            {
                                string procedimientos = Procedimientos.GetPlanDeManejo(conectormysql, CCDetallePaciente.IdPaciente, TFecha.Text);
                                if (procedimientos.Length > 0)
                                {
                                    ViewState["procedimientos"] = procedimientos;
                                    TPlanManejo.Text = procedimientos;
                                }
                            }
                            TPlanManejo.ReadOnly = !usuario.CanAdmin();

                            BAceptar.Enabled = usuario.CanUpdate();
                            BEliminar.Visible = usuario.CanDelete();
                            ((MasterPageI)Master).Imprimir("paraclinico.html");
                        }
                    }

                    GParaclinicos.DataBind();
                    LParaclinicos.Text = GParaclinicos.Rows.Count + " Paraclínico";
                    LParaclinicos.Text += GParaclinicos.Rows.Count == 1 ? "" : "s";
                    PParaclinicos.Visible = GParaclinicos.Rows.Count > 0;
                }
            }

        }
    }

    protected void BCancelar_Click(object sender, EventArgs e) {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BEliminar_Click(object sender, EventArgs e) { 
        
        using (CConector conector = new CConector())
            if (conector.QueryMod("DELETE FROM paraclinico WHERE id=" + Query.GetValor(ViewState["id"].ToString())) == -1)
                return;
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BAceptar_Click(object sender, EventArgs e) {
        
        if (!IsValid)
            return;
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            string id=(string)ViewState["id"];
            Query query = new Query("paraclinico");

            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);
            query["medico"]= DMedico.SelectedValue;
            query["analisis"]= TAnalisis.Text;
            query["paciente"] = CCDetallePaciente.IdPaciente;
            query["asegurador"] = CCDetallePaciente.AsegurdadorID;
            query["plan_manejo"] =
                (string.IsNullOrEmpty((string)ViewState["procedimientos"]) || TPlanManejo.Text != ViewState["procedimientos"].ToString())
                ? TPlanManejo.Text
                : "";

            if (string.IsNullOrEmpty(id))
            {
                int pos= conector.QueryMod(query.GetInsert(), true);
                if (pos == -1)
                    return;
                id = pos.ToString();
            } else { 
                if(conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(id)))==-1)
                    return;
            }
            if (conector.InsertModificacion(id) == -1)
                return;
            conector.Commit();

            ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
            ((MasterPageI)Master).SetResultado("Paciente " + CCDetallePaciente.Nombres + " Editado");
        }
    }

    protected void IIr_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/paciente/paraclinicos.aspx?pid=" + CCDetallePaciente.IdPaciente + "&idpar=" + ((LinkButton)sender).CommandArgument);
    }

    protected void GParaclinicos_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            e.Row.Cells[2].Text = Funcionario.GetFuncionario(e.Row.Cells[2].Text).Nombres;
        }
    }

    protected void OnImprimir(object sender, EventArgs e) {
        
        PrintEventArgs evento = (PrintEventArgs)e;
        // aqui modificamos el evento.Contenido

        evento.Contenido = evento.Contenido.Replace("$szPlanManejo$", "<ol><li>" + TPlanManejo.Text.Replace("\n", "</li><li>") + "</li></ol>");
        evento.Contenido = evento.Contenido.Replace("$szUsuario$", Usuario.GetUsuario().GetNombre());

        using (CConector conector = new CConector())
        {

            Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
            evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
            evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

            Query query = new Query("recurso_humano");

            query["szProfesional"] = "recurso_humano.perDocumento";
            query["szCargo"] = "cargo.carDescripcion";

            MySqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(DMedico.SelectedValue), " LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)"));
            if (reader != null)
            {
                bool l = reader.Read();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
                }
            }
        }
        // limpiamos el inactivo de los pacientes
        evento.Contenido = evento.Contenido.Replace(" (Inactivo)", "");
    }
}
