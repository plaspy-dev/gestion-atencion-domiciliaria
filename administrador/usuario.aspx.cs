using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using componentes;
using System.Data.SqlClient;

public partial class administrador_usuario : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TNombres.Focus();
        if(!IsPostBack) {
            Usuario usuario = Usuario.GetUsuario();

            BAceptar.Enabled = usuario.CanInsert();
            GUsuarios.Columns[1].Visible = usuario.CanDelete();
            GUsuarios.Columns[0].Visible = usuario.CanUpdate();
        }
    }
    protected void GUsuarios_SelectedIndexChanged(object sender, EventArgs e)
    {
        RContrasena.Enabled = false;
        HId.Value = GUsuarios.SelectedDataKey.Value.ToString();
        CConector.SelectInComboText(DGrupos, HttpUtility.HtmlDecode(GUsuarios.SelectedRow.Cells[4].Text));
        TNombres.Text = HttpUtility.HtmlDecode(GUsuarios.SelectedRow.Cells[2].Text);
        TUsuario.Text = HttpUtility.HtmlDecode(GUsuarios.SelectedRow.Cells[3].Text);
        
        ((MasterPageI)Master).SetModificacion(HId.Value);
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        Query query = new Query("usuario");
        CConector conector = CConector.GetConector();
        string szQuery;
        string mensaje;

        query["nombre"] = TNombres.Text;
        query["usuario"] = TUsuario.Text;
        query["grupo"] = DGrupos.SelectedValue;
        if(TContrasena.Text.Length>0)
            query.AddCampo("contrasena", "PASSWORD(" + Query.GetValor(TContrasena.Text) + ")", false);

        if (HId.Value.Length == 0)
        {
            szQuery = query.GetInsert();
            mensaje = TNombres.Text + " ingresado";
        }
        else
        {
            szQuery = query.GetUpdate("id='" + HId.Value + "'");
            mensaje = TNombres.Text + " editado";
        }
        int res = conector.QueryMod(szQuery, true);
        if ( res== -1)
            return;
        if (HId.Value.Length == 0)
            HId.Value = res.ToString();
        if (conector.InsertModificacion(HId.Value) == -1)
            return;
        ((MasterPageI)Master).SetResultado(mensaje);
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void BMigrar_Click(object sender, EventArgs e)
    {
        CConectorMS conector= CConectorMS.GetConector();
        CConector conectorMySQL = CConector.GetConector();
        int actualizados = 0;
        int insertados = 0;

        SqlDataReader reader=  conector.Query("SELECT usIdUsuario,usNombreUsuario,usClave FROM seg_Usuarios WHERE usActivo=1");
        if(reader!=null) {
            while(reader.Read()) {

                string id= conectorMySQL.QueryString("SELECT id FROM usuario WHERE usuario='" + reader["usIdUsuario"].ToString() + "'");

                Query query = new Query("usuario");
                query["nombre"] = reader["usNombreUsuario"].ToString();
                query["usuario"] = reader["usIdUsuario"].ToString();
                string nombre = reader["usIdUsuario"].ToString();
                string password = crypt.Desencriptar(reader["usClave"].ToString(), System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY_3"));
                query.AddCampo("contrasena", "PASSWORD(" + Query.GetValor(password) + ")", false);

                if (id.Length == 0)
                {
                    insertados++;
                    query["grupo"] = "1";
                    conectorMySQL.QueryMod(query.GetInsert()); 
                }
                else
                {
                    actualizados++;
                    conectorMySQL.QueryMod(query.GetUpdate("id='" + id + "'")); 
                }
            }
        }
        ((MasterPageI)Master).SetResultado( insertados+ " usuarios ingresados y " + actualizados + " actualizados.");
    }
}
