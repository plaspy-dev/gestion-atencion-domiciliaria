using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Text;
using System.IO;
using componentes;

public partial class seguimiento_paciente : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        CConectorMS conector = CConectorMS.GetConector();
        DDocumento.Focus();
        if(!IsPostBack) {

            Usuario usuario = Usuario.GetUsuario();
            BAceptar.Enabled = usuario.CanInsert();

            TDocumento.Text = Request.QueryString["id"];
            DDocumento.DataBind();
            DDocumento.SelectedValue= Request.QueryString["td"];

            if(TDocumento.Text.Length>0 && DDocumento.SelectedIndex>-1) {

                Query query = new Query("phdPaciente");
                query += "pacId";
                query += "pacPNombre";
                query += "pacSNombre";
                query += "pacPApellido";
                query += "pacSApellido";
                query += "pacCorreo";
                query += "pacDireccion";
                query += "pacBarrio";
                query += "pacTelefono";
                query += "pacCelular";
                query += "pacFechaNac";
                query += "sexoId";
                query += "cieCodDx";
                query += "cieCodDx_1";
                query += "cieCodDx_2";

                SqlDataReader reader = conector.Query(query.GetSelect("pacDocumento='" + TDocumento.Text + "' AND tdocId='" + DDocumento.SelectedValue + "'"));
                if (reader != null && reader.Read())
                {
                    BAceptar.Enabled = usuario.CanUpdate();
                    Session["parametros"] = "?id=" + Request.QueryString["id"] + "&td=" + Request.QueryString["td"] + "&f=" + CConector.GetDate(DateTime.Now);
                    TPApellido.Focus();

                    HId.Value = reader["pacId"].ToString();
                    TPNombre.Text = reader["pacPNombre"].ToString();
                    TSNombre.Text = reader["pacSNombre"].ToString();
                    TPApellido.Text = reader["pacPApellido"].ToString();
                    TSApellido.Text = reader["pacSApellido"].ToString();
                    TCorreo.Text = reader["pacCorreo"].ToString();
                    TDireccion.Text = reader["pacDireccion"].ToString();
                    TBarrio.Text = reader["pacBarrio"].ToString();
                    TTelefono.Text = reader["pacTelefono"].ToString();
                    TMovil.Text = reader["pacCelular"].ToString();
                    DSexo.DataBind();
                    DSexo.SelectedValue = reader["sexoId"].ToString();
                    TNacimiento.Text = CConectorMS.GetDate(reader["pacFechaNac"]);

                    if (reader["pacFechaNac"] != null && reader["pacFechaNac"].ToString().Length!=0)
                    {
                        DateTime birthDate = (DateTime)reader["pacFechaNac"];
                        DateTime now = DateTime.Now;
                        int years = now.Year - birthDate.Year;

                        if (now.Month < birthDate.Month || (now.Month == birthDate.Month && now.Day < birthDate.Day))
                            --years;

                        LEdad.Text = years + " años";
                    }
                }
            }
        }
    }

    protected void IBuscar_Click(object sender, EventArgs e)
    {
        CConectorMS conector = CConectorMS.GetConector();
        String documento = conector.QueryString("SELECT pacDocumento FROM phdPaciente WHERE pacDocumento='" + TDocumento.Text + "' AND tdocId='" + DDocumento.SelectedValue + "'");
        if(documento.Length>0) {
            Response.Redirect(Request.Url.AbsolutePath + "?id=" + TDocumento.Text + "&td=" + DDocumento.SelectedValue);
            return;
        }
        string texto = "No se encontraron resultados";
        String count = conector.QueryString("SELECT COUNT(*) FROM phdPaciente WHERE pacDocumento LIKE '%" + TDocumento.Text + "%'");
        int cuenta =0;
        try {
            cuenta = Convert.ToInt32(count);
        } catch (System.FormatException ex) {
            texto= ex.ToString();
        }
        if(cuenta==1) {
            string tipo = conector.QueryString("SELECT tdocId FROM phdPaciente WHERE pacDocumento='" + TDocumento.Text + "'");
            Response.Redirect(Request.Url.AbsolutePath + "?id=" + TDocumento.Text + "&td=" + tipo);
            return;
        }

        if(cuenta>1) {

            texto = "";
            Query query = new Query("phdPaciente");
            query += "tdocId";
            query += "pacDocumento";
            query += "pacPNombre";
            query += "pacSNombre";
            query += "pacPApellido";
            query += "pacSApellido";

            SqlDataReader reader = conector.Query(query.GetSelect("pacDocumento LIKE '%" + TDocumento.Text + "%' ORDER BY pacPApellido,pacPNombre"));
            Table tabla = new Table();
            tabla.BorderWidth = 1;

            while(reader.Read()) {

                TableRow row = new TableRow();
                TableCell cell = new TableCell();
                HyperLink link = new HyperLink();
                link.NavigateUrl = Request.Url.AbsolutePath + "?id=" + reader["pacDocumento"].ToString() + "&td=" + reader["tdocId"].ToString();
                link.Text = reader["pacDocumento"].ToString();
                cell.Attributes["align"] = "left";
                cell.Controls.Add(link);
                cell.BorderWidth = 1;
                row.Cells.Add(cell);

                cell = new TableCell();
                link = new HyperLink();
                link.NavigateUrl = Request.Url.AbsolutePath + "?id=" + reader["pacDocumento"].ToString() + "&td=" + reader["tdocId"].ToString();
                link.Text = reader["pacPApellido"].ToString() + " " + reader["pacSApellido"].ToString() 
                    + " " + reader["pacPNombre"].ToString() + " " + reader["pacSNombre"].ToString();
                cell.Attributes["align"] = "left";
                cell.Controls.Add(link);
                cell.BorderWidth = 1;
                row.Cells.Add(cell);
                tabla.Rows.Add(row);
            }
            StringBuilder sb = new StringBuilder();
            StringWriter tw = new StringWriter(sb);
            HtmlTextWriter hw = new HtmlTextWriter(tw);

            tabla.RenderControl(hw);
            texto= sb.ToString();
        }
        ((MasterPageI)Master).SetAuxDiag("Busqueda de " + TDocumento.Text, texto);
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        CConectorMS conector = CConectorMS.GetConector();
        Query query = new Query("phdPaciente");
        string szQuery = "";
        string mensaje="";
        
        query["pacPNombre"]=TPNombre.Text;
        query["pacSNombre"]= TSNombre.Text;
        query["pacPApellido"]= TPApellido.Text;
        query["pacSApellido"]= TSApellido.Text;
        query["pacCorreo"]= TCorreo.Text;
        query["pacDireccion"]=TDireccion.Text;
        query["pacBarrio"]=TBarrio.Text;
        query["pacTelefono"]=TTelefono.Text;
        query["pacCelular"]=TMovil.Text;
        query["pacFechaNac"]=TNacimiento.Text;
        query["sexoId"]=DSexo.SelectedValue;
        query["pacDocumento"]= TDocumento.Text;
        query["tdocId"]= DDocumento.SelectedValue;

        if(HId.Value.Length>0) {
            szQuery = query.GetUpdate("pacId='" + HId.Value + "'");
            mensaje = "Paciente " + TDocumento.Text + " editado";
        } else {
            szQuery = query.GetInsert();
            mensaje = "Paciente " + TDocumento.Text + " ingresado";
        }
        if(conector.QueryMod(szQuery)==-1) {
            return;
        }
        ((MasterPageI)Master).SetResultado(mensaje);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
}
