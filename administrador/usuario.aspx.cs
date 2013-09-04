using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using System.Data.SqlClient;
using MySql.Data.MySqlClient;
using System.Configuration;

public partial class administrador_usuario : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TNombres.Focus();
        if(!IsPostBack) {
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();

            BMigrar.Visible = false;
            BAceptar.Enabled = usuario.CanInsert();
            GUsuarios.Columns[1].Visible = usuario.CanDelete();
            GUsuarios.Columns[0].Visible = usuario.CanUpdate();
            ViewState["cargos"] = "";
            ViewState["entidades"] = "";
        }
    }
    protected void GUsuarios_SelectedIndexChanged(object sender, EventArgs e)
    {
        RContrasena.Enabled = false;
        HId.Value = GUsuarios.SelectedDataKey.Value.ToString();
        CConector.SelectInComboText(DGrupos, HttpUtility.HtmlDecode(GUsuarios.SelectedRow.Cells[4].Text));
        TNombres.Text = HttpUtility.HtmlDecode(GUsuarios.SelectedRow.Cells[2].Text);
        TUsuario.Text = HttpUtility.HtmlDecode(GUsuarios.SelectedRow.Cells[3].Text);
        TIdPersonal.Text= HttpUtility.HtmlDecode(GUsuarios.SelectedRow.Cells[6].Text).Trim();
        HUsuario.Value = TUsuario.Text;
        using (CConector conector = new CConector())
        {
            ViewState["cargos"] = conector.QueryString("SELECT cargos FROM usuario WHERE id=" + HId.Value);
            ViewState["entidades"] = conector.QueryString("SELECT entidades FROM usuario WHERE id=" + HId.Value);
        }
        GCargos.DataBind();
        GEntidades.DataBind();
        IFirma.Visible = true;
        IFirma.ImageUrl = "~/archivo/firma.ashx?ui=" + HId.Value;
        
        ((MasterPageI)Master).SetModificacion(HId.Value);
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query query = new Query("usuario");
        using (CConector conector = new CConector())
        {
            string szQuery;
            string mensaje;
            string cargos = "";
            string entidad = "";

            query["nombre"] = TNombres.Text;
            query["usuario"] = TUsuario.Text;
            query["grupo"] = DGrupos.SelectedValue;
            query["personal"] = TIdPersonal.Text;

            // agregamos los cargos que puede programar el usuario
            for (int i = 0; i < GCargos.Rows.Count; i++)
            {

                CheckBox box = (CheckBox)GCargos.Rows[i].FindControl("CCargo");
                if (box.Checked)
                {
                    if (cargos.Length > 0)
                        cargos += ",";
                    cargos += GCargos.DataKeys[i].Value.ToString();
                }
            }
            query["cargos"] = cargos;
            // agregamos las entidades que puede ver el usuario
            for (int i = 0; i < GEntidades.Rows.Count; i++)
            {
                CheckBox box = (CheckBox)GEntidades.Rows[i].FindControl("CEntidad");
                if (box.Checked)
                {
                    if (i == 0) // todas las entidades estan chuleadas
                        break;
                    if (entidad.Length > 0)
                        entidad += ",";
                    entidad += GEntidades.DataKeys[i].Value.ToString();
                }
            }
            query["entidades"] = entidad;


            if (TContrasena.Text.Length > 0)
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
            if (res == -1)
                return;
            if (HId.Value.Length == 0)
                HId.Value = res.ToString();
            if (conector.InsertModificacion(HId.Value) == -1)
                return;


            // procedemos a realizar la actualizacion en la base de datos Microsoft SQL
            using (CConectorMS conectorms = new CConectorMS())
            {
                query = new Query("seg_Usuarios");

                query["usIdUsuario"] = TUsuario.Text;
                query["usNombreUsuario"] = TNombres.Text;
                query["usActivo"] = "1";
                if (TContrasena.Text.Length > 0)
                    query["usClave"] = Crypt.EncriptarDES(TContrasena.Text, System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY_4"));

                // verificamos que el usuario no halla existido anteriormente
                if (HUsuario.Value.Length == 0)
                    HUsuario.Value = conectorms.QueryString("SELECT usIdUsuario FROM seg_Usuarios WHERE usIdUsuario='" + TUsuario.Text + "'");

                if (HUsuario.Value.Length > 0)
                {
                    if (conectorms.QueryMod("DELETE FROM Seg_UsuarioMenu WHERE usIdUsuario='" + HUsuario.Value + "'") == -1)
                        return;
                    if (conectorms.QueryMod("DELETE FROM segPermisoEspecial WHERE usIdUsuario='" + HUsuario.Value + "'") == -1)
                        return;
                    if (conectorms.QueryMod("DELETE FROM GenUsuarioTarea WHERE usIdUsuario='" + HUsuario.Value + "'") == -1)
                        return;
                }

                if (HUsuario.Value.Length == 0)
                {
                    if (conectorms.QueryMod(query.GetInsert()) == -1)
                        return;
                }
                else
                {
                    if (conectorms.QueryMod(query.GetUpdate("usIdUsuario='" + HUsuario.Value + "'")) == -1)
                        return;
                }

                if (DGrupos.SelectedValue == "0")
                { // es administrador
                    conectorms.QueryMod("INSERT INTO Seg_UsuarioMenu SELECT meIdMenu,'" + TUsuario.Text + "',1,1,1 FROM seg_menu WHERE meRuta!='';");
                }
                else
                {

                    query = new Query("permisos");

                    query += "url";
                    query += "permiso";

                    MySqlDataReader reader = conector.Query(query.GetSelect("grupo='" + DGrupos.SelectedValue + "'"));
                    if (reader != null)
                    {
                        while (reader.Read())
                        {
                            string url = reader["url"].ToString();
                            if (url[0] == '/')
                            { // es de los nuevos

                                url = url.Replace("/" + ConfigurationSettings.AppSettings["app"], "");
                                Permisos info = new Permisos("", url, (int)reader["permiso"]);

                                string id = conectorms.QueryString("SELECT meIdMenu FROM seg_menu WHERE meRuta='" + info.pagina + "'");
                                if (id.Length == 0)
                                    continue;

                                query = new Query("Seg_UsuarioMenu");
                                query["meIdMenu"] = id;
                                query["usIdUsuario"] = TUsuario.Text;
                                query["umInserta"] = info.insercion ? "1" : "0";
                                query["umModifica"] = info.edicion ? "1" : "0";
                                query["umElimina"] = info.eliminar ? "1" : "0";

                                if (conectorms.QueryMod(query.GetInsert()) == -1)
                                    return;
                            }
                        }
                    }
                }

                Query permisos = new Query("segPermisoEspecial");
                permisos["usIdUsuario"] = TUsuario.Text;

                for (int i = 0; i < GEspeciales.Rows.Count; i++)
                {

                    if (((CheckBox)GEspeciales.Rows[i].FindControl("CPermiso")).Checked)
                    {

                        permisos["perIdPermiso"] = GEspeciales.DataKeys[i].Value.ToString();
                        if (conectorms.QueryMod(permisos.GetInsert()) == -1)
                            return;
                    }
                }

                Query alertas = new Query("GenUsuarioTarea");
                alertas["usIdUsuario"] = TUsuario.Text;

                for (int i = 0; i < GAlertas.Rows.Count; i++)
                {
                    if (((CheckBox)GAlertas.Rows[i].FindControl("CPermiso")).Checked)
                    {
                        alertas["tarId"] = GAlertas.DataKeys[i].Value.ToString();
                        if (conectorms.QueryMod(alertas.GetInsert()) == -1)
                            return;
                    }
                }

                if (FFirma.HasFile)
                {
                    string archivo = ConfigurationManager.AppSettings["pathFiles"] + "firmas\\";
                    System.IO.Directory.CreateDirectory(archivo);
                    archivo += HId.Value + ".jpg";
                    FFirma.SaveAs(archivo);
                }

                ((MasterPageI)Master).SetResultado(mensaje);
            }
        }
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BMigrar_Click(object sender, EventArgs e)
    {
        using(CConector conectorMySQL= new CConector()) 
        using (CConectorMS conector = new CConectorMS())
        {
            int actualizados = 0;
            int insertados = 0;

            SqlDataReader reader = conector.Query("SELECT usIdUsuario,usNombreUsuario,usClave FROM seg_Usuarios WHERE usActivo=1");
            if (reader != null)
            {
                while (reader.Read())
                {

                    string id = conectorMySQL.QueryString("SELECT id FROM usuario WHERE usuario='" + reader["usIdUsuario"].ToString() + "'");
                    string grupoold = conectorMySQL.QueryString("SELECT grupo FROM usuario WHERE usuario='" + reader["usIdUsuario"].ToString() + "'");

                    Query query = new Query("usuario");
                    query["nombre"] = reader["usNombreUsuario"].ToString();
                    query["usuario"] = reader["usIdUsuario"].ToString();
                    string nombre = reader["usIdUsuario"].ToString();
                    string password = Crypt.DesencriptarDES(reader["usClave"].ToString(), System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY_4"));
                    query.AddCampo("contrasena", "PASSWORD(" + Query.GetValor(password) + ")", false);

                    string grupoid = "";
                    if (grupoold != "0")
                    {// es administrador
                        // creamos el grupo en caso de no existir
                        grupoid = conectorMySQL.QueryString("SELECT id FROM grupo WHERE nombre='Grupo_" + nombre + "'");
                        if (grupoid.Length == 0)
                        {
                            int res = conectorMySQL.QueryMod("INSERT INTO grupo (nombre) VALUES ('Grupo_" + nombre + "')", true);
                            grupoid = res.ToString();
                        }
                        query["grupo"] = grupoid;
                    }

                    if (id.Length == 0)
                    {
                        insertados++;

                        int res = conectorMySQL.QueryMod(query.GetInsert(), true);
                        id = res.ToString();
                    }
                    else
                    {
                        actualizados++;
                        conectorMySQL.QueryMod(query.GetUpdate("id='" + id + "'"));
                    }

                    if (grupoold != "0")
                    {
                        using (CConectorMS conector1 = new CConectorMS())
                        {
                            SqlDataReader reader1 = conector1.Query("SELECT meRuta,umInserta,umModifica,umElimina FROM Seg_UsuarioMenu LEFT JOIN seg_menu ON (seg_menu.meIdMenu=Seg_UsuarioMenu.meIdMenu) WHERE usIdUsuario='" + nombre + "';");
                            if (reader1 != null)
                            {
                                conectorMySQL.QueryMod("DELETE FROM permisos WHERE grupo='" + grupoid + "' AND url LIKE '/%'");

                                Query permisos = new Query("permisos");
                                permisos["grupo"] = grupoid;

                                while (reader1.Read())
                                {
                                    int permiso = 0;
                                    permisos["url"] = "/" + ConfigurationSettings.AppSettings["app"] + reader1["meRuta"].ToString();
                                    if (reader1["umInserta"].ToString().ToLower() == "true")
                                        permiso += 1;
                                    if (reader1["umModifica"].ToString().ToLower() == "true")
                                        permiso += 12;
                                    if (reader1["umElimina"].ToString().ToLower() == "true")
                                        permiso += 16;

                                    if (permiso > 0)
                                    {
                                        permisos["permiso"] = permiso.ToString();
                                        conectorMySQL.QueryMod(permisos.GetInsert());
                                    }
                                }
                            }
                            if (grupoold.Length > 0 && grupoold != grupoid)
                            { // actualizamos los permisos que ya tenia el usuario.

                                conectorMySQL.QueryMod("DELETE FROM permisos WHERE grupo='" + grupoid + "' AND url LIKE '~/%'");
                                conectorMySQL.QueryMod("INSERT INTO permisos (grupo,url,permiso) SELECT " + grupoid + ",url, permiso FROM permisos WHERE grupo='" + grupoold + "' AND url LIKE '~/%'");
                            }
                        }
                    }
                }
            }
            GUsuarios.DataBind();
            ((MasterPageI)Master).SetResultado(insertados + " usuarios ingresados y " + actualizados + " actualizados.");
        }
    }
    protected void GUsuarios_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        using (CConector conector = new CConector())
        {
            string nombre = conector.QueryString("SELECT usuario FROM usuario WHERE id=" + e.Keys[0].ToString());
            if (nombre.Length > 0)
            {
                using (CConectorMS conectorms = new CConectorMS())
                    if (conectorms.QueryMod("UPDATE seg_Usuarios SET usActivo=0 WHERE usIdUsuario='" + nombre + "'") == -1)
                        return;
            }
        }
    }
    protected void GCargos_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if(e.Row.RowIndex!=-1) {
            string []valores= ViewState["cargos"].ToString().Split(',');
            for (int i = 0; i < valores.Length; i++) {

                if (valores[i] == GCargos.DataKeys[e.Row.RowIndex].Value.ToString())
                {
                    CheckBox box = (CheckBox)e.Row.FindControl("CCargo");
                    box.Checked = true;
                    break;
                }
            }
        }
    }
    protected void GEntidades_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if(e.Row.RowIndex!=-1) {
            if (string.IsNullOrEmpty((string)ViewState["entidades"]))
            {
                CheckBox box = (CheckBox)e.Row.FindControl("CEntidad");
                box.Checked = true;
            }
            else
            {
                string[] valores = ViewState["entidades"].ToString().Split(',');
                for (int i = 0; i < valores.Length; i++)
                {

                    if (valores[i] == GEntidades.DataKeys[e.Row.RowIndex].Value.ToString())
                    {
                        CheckBox box = (CheckBox)e.Row.FindControl("CEntidad");
                        box.Checked = true;
                        break;
                    }
                }
            }
        }
    }
}
