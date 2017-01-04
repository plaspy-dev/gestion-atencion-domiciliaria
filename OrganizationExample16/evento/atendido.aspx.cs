using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;
public partial class evento_atendido : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            CUsuario usuario = (CUsuario)CUsuario.GetInstance();
            UCEvento.IdEvento = Request.QueryString["e"];
            if (!string.IsNullOrEmpty(Request.QueryString["f"]))
                TFecha.Text = Request.QueryString["f"] + " " + Query.GetFromMySQLDate(DateTime.Now, true).Split(' ')[1];
            else TFecha.Text = Query.GetFromMySQLDate(DateTime.Now, true);
            TFecha.Focus();

            BAceptar.Enabled = usuario.CanInsert();

            if (!string.IsNullOrEmpty(Request.QueryString["pid"])) {

                using (CConector conector = new CConector()) {

                    Query query = new Query("paciente");

                    query += "id";
                    query += "fecha";
                    query += "evento";
                    query += "nombres";
                    query += "apellidos";
                    query += "edad";
                    query += "familiar_documento";
                    query += "familiar_nombres";
                    query += "diagnostico";
                    query += "ipsremision";
                    query += "asegurador";
                    query += "documento";
                    query += "codigo_caso";
                    query += "causa";
                    query += "atributos";
                    query += "ambulancia";

                    MySqlDataReader reader = conector.Query(query.GetSelect("id=" + Query.GetValor(Request.QueryString["pid"])));
                    if (reader != null && reader.Read()) {

                        BAceptar.Enabled = usuario.CanUpdate();
                        BEliminar.Visible = usuario.CanDelete();
                        string id = reader["id"].ToString();
                        ViewState["id"] = id;
                        ((MasterPageI)Master).SetModificacion(id);

                        TFecha.Text = Query.GetFromMySQLDate(reader["fecha"], true);
                        UCEvento.IdEvento= reader["evento"].ToString();
                        TNombres.Text= reader["nombres"].ToString();
                        TApellidos.Text= reader["apellidos"].ToString();
                        TEdad.Text= reader["edad"].ToString();
                        TFDocumento.Text= reader["familiar_documento"].ToString();
                        TFNombres.Text= reader["familiar_nombres"].ToString();
                        TDiagnostico.Text= reader["diagnostico"].ToString();
                        TIPS.Text= reader["ipsremision"].ToString();
                        TAsegurador.Text = reader["asegurador"].ToString();
                        TDocumento.Text = reader["documento"].ToString();
                        TCodigo.Text = reader["codigo_caso"].ToString();
                        TCausa.Text = reader["causa"].ToString();
                        Utilidades.SelectInDropDown(DAmbulancia, reader["ambulancia"]);
                        int atributos = 0;
                        try { atributos = Convert.ToInt32(reader["atributos"]); } catch { }
                        CCadena.Checked = (atributos & 1) == 1;
                        CSeguimiento.Checked = (atributos & 2) == 2;

                        CRemisicion.Checked = TIPS.Text.Length > 0;

                    }
                }
            }
        }
    }

    public bool ValidateField(TextBox text, string mensaje) {

        if (text.Text.Length == 0)
        {
            LMensaje.Text = mensaje;
            text.Focus();
            return false;
        }
        return true;
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        LMensaje.Text = "";
        if (!IsValid)
            return;

        if (CRemisicion.Checked) {
            if (!ValidateField(TIPS, "Por favor ingrese una IPS.")
                || !ValidateField(TAsegurador, "Por favor ingrese un asegurador.")
                || !ValidateField(TDocumento, "Por favor ingrese un numero de documento.")
                || !ValidateField(TCodigo, "Por favor ingrese un código de caso.")
                || !ValidateField(TCausa, "Por favor ingrese una causa.")
                )
                return;
        }

        using (CConector conector = new CConector())
        {
            string id = (string)ViewState["id"];
            conector.StartTransaction();
            Query query = new Query("paciente");

            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text, true);
            query["evento"] =UCEvento.IdEvento;
            query["nombres"] =TNombres.Text;
            query["apellidos"] =TApellidos.Text;
            query["edad"] =TEdad.Text;
            query["familiar_documento"] =TFDocumento.Text;
            query["familiar_nombres"] =TFNombres.Text;
            query["diagnostico"] =TDiagnostico.Text;
            query["ipsremision"] = CRemisicion.Checked ? TIPS.Text : null;

            query["asegurador"] = CRemisicion.Checked ? TAsegurador.Text : null;
            query["documento"] = CRemisicion.Checked? TDocumento.Text : null;
            query["codigo_caso"] = CRemisicion.Checked? TCodigo.Text : null;
            query["causa"] = CRemisicion.Checked? TCausa.Text : null;
            query["ambulancia"] = CRemisicion.Checked ? DAmbulancia.SelectedValue : null;
            int atributos = 0;
            if (CCadena.Checked)
                atributos += 1;
            if(CSeguimiento.Checked)
                atributos += 2;
            query["atributos"] = CRemisicion.Checked? atributos.ToString() : null;

            if (string.IsNullOrEmpty(id)) {
                int res = conector.QueryMod(query.GetInsert());
                if (res == -1) {
                    LMensaje.Text = conector.LastError;
                    return;
                }
                id = res.ToString();
            } else {
                if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(id))) == -1) {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }

            if (conector.InsertModificacion(id)==-1) {
                LMensaje.Text = conector.LastError;
                return;
            }

            conector.Commit();

            ((MasterPageI)Master).SetResultado("Paciente " + TNombres.Text + " editado", false);
            BCancelar_Click(sender, e);
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?f=" + HttpUtility.UrlEncode(TFecha.Text.Split(' ')[0]) + "&e=" + UCEvento.IdEvento);
    }

    protected void BEliminar_Click(object sender, EventArgs e)
    {
        string id = (string)ViewState["id"];
        using (CConector conector = new CConector()) {
            Query query = new Query("paciente");
            if (conector.QueryMod(query.GetDelete("id=" + Query.GetValor(id))) == -1) {
                LMensaje.Text = conector.LastError;
                return;
            }
            ((MasterPageI)Master).SetResultado("Paciente " + TNombres.Text + " eliminado", false);
            BCancelar_Click(sender, e);
        }
    }
}