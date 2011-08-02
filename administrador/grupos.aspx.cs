using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using MySql.Data.MySqlClient;
using componentes;

public partial class administrador_grupos : System.Web.UI.Page
{
    class Permisos
    {
        protected string _Pagina;
        protected string _Titulo;
        protected int permisos;
        
        public Permisos(string tit, string pag) {

            _Titulo = tit;
            _Pagina=pag;
            permisos = 0;
        }
        public Permisos(string tit, string pag, int per)
        {
            _Titulo = tit;
            _Pagina = pag;
            permisos = per;
        }
        public string titulo {
            get { return _Titulo; }
        }
        public string pagina {
            get { return _Pagina; }
        }
        public void SetPermisos(int per)
        {
            permisos = per;
        }
        public bool administrador {
            get { return (permisos&32)==32; }
        }
        public bool eliminar
        {
            get { return (permisos & 16) == 16; }
        }
        public bool edicion
        {
            get { return (permisos & 8) == 8; }
        }
        public bool insercion
        {
            get { return (permisos & 4) == 4; }
        }
        public bool imprimir
        {
            get { return (permisos & 2) == 2; }
        }
        public bool lectura
        {
            get { return (permisos & 1) == 1; }
        }
        public bool todos
        {
            get { return (permisos & 63) == 63; }
        }
    };

    protected void Page_Load(object sender, EventArgs e)
    {
        BEliminar.Visible = false;
        if(!IsPostBack) {

            Usuario usuario = Usuario.GetUsuario();
            BAceptar.Enabled = usuario.CanInsert();

            TNombre.Focus();
            ArrayList permisos = new ArrayList();
            ArrayList menu = Usuario.GetUsuario().GetFullMenu();
            for(int i=0; i<menu.Count; i++) {

                CURLs url = (CURLs)menu[i];
                permisos.Add(new Permisos(url.Titulo, url.URL));
            }
            GPermisos.DataSource = permisos;
            GPermisos.DataBind();
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        Query query= new Query("grupo");
        CConector conector = CConector.GetConector();
        string szQuery;
        string mensaje;
        string grupo = "";

        query["nombre"] = TNombre.Text;
        query["descripcion"] = TDescripcion.Text;

        if(LGrupos.SelectedIndex==-1) {

            szQuery = query.GetInsert();
            mensaje = TNombre.Text + " ingresado";
            int resultado = conector.QueryMod(szQuery);
            if (resultado == -1)
                return;
            grupo = resultado.ToString();
        } else {
            szQuery = query.GetUpdate("id='" + LGrupos.SelectedValue + "'");
            mensaje = TNombre.Text + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;
            grupo = LGrupos.SelectedValue;
        }
        if (conector.InsertModificacion(grupo) == -1)
            return;
        if (conector.QueryMod("DELETE FROM permisos WHERE grupo='" + grupo + "'") == -1)
            return;

        Query permisos = new Query("permisos");
        for (int i = 0; i < GPermisos.Rows.Count; i++)
        {
            permisos["grupo"] = grupo;
            HiddenField pag = (HiddenField)GPermisos.Rows[i].FindControl("pagina");
            permisos["url"] = pag.Value;
            int per = 0;

            CheckBox check;
            check = (CheckBox)GPermisos.Rows[i].FindControl("a");
            if (check.Checked)
                per += 32;
            check = (CheckBox)GPermisos.Rows[i].FindControl("e");
            if (check.Checked)
                per += 16;
            check = (CheckBox)GPermisos.Rows[i].FindControl("d");
            if (check.Checked)
                per += 8;
            check = (CheckBox)GPermisos.Rows[i].FindControl("i");
            if (check.Checked)
                per += 4;
            check = (CheckBox)GPermisos.Rows[i].FindControl("m");
            if (check.Checked)
                per += 2;
            check = (CheckBox)GPermisos.Rows[i].FindControl("l");
            if (check.Checked)
                per += 1;
            if (per == 0) // lo omitimos
                continue;
            if (per > 0 && (per & 1) != 1)
                per += 1;
            permisos["permiso"] = per.ToString();

            if (conector.QueryMod(permisos.GetInsert()) == -1)
                return;
        }

        ((MasterPageI)Master).SetResultado(mensaje);
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void BEliminar_Click(object sender, EventArgs e)
    {
        CConector conector = CConector.GetConector();
        if (conector.QueryMod("DELETE FROM permisos WHERE grupo='" + LGrupos.SelectedValue + "'") == -1)
            return;
        if (conector.QueryMod("DELETE FROM grupo WHERE id='" + LGrupos.SelectedValue + "'") == -1)
            return;
        conector.InsertModificacion(LGrupos.SelectedValue);
        ((MasterPageI)Master).SetResultado("Grupo " + TNombre.Text + " Eliminado.");
    }
    protected void LGrupos_SelectedIndexChanged(object sender, EventArgs e)
    {
        ArrayList permisos = new ArrayList();
        ArrayList menu = Usuario.GetUsuario().GetFullMenu();

        if (LGrupos.SelectedValue == "0")
        {
            BAceptar.Enabled = false;
            BEliminar.Enabled = false;

            TNombre.Text = LGrupos.SelectedItem.Text;
            TDescripcion.Text = "Grupo de administración, con todos los accesos";

            for (int i = 0; i < menu.Count; i++)
            {
                CURLs url = (CURLs)menu[i];
                permisos.Add(new Permisos(url.Titulo, url.URL, 63));
            }
        } else {
            Usuario usuario= Usuario.GetUsuario();

            BAceptar.Enabled = usuario.CanUpdate();
            BEliminar.Enabled = usuario.CanDelete();
            BEliminar.Visible = true;

            CConector conector= CConector.GetConector();

            TNombre.Text = LGrupos.SelectedItem.Text;
            TDescripcion.Text = conector.QueryString("SELECT descripcion FROM grupo WHERE id='" + LGrupos.SelectedValue + "'");

            Query query = new Query("permisos");
            query += "url";
            query += "permiso";

            for (int i = 0; i < menu.Count; i++)
            {
                CURLs url = (CURLs)menu[i];
                permisos.Add(new Permisos(url.Titulo, url.URL, 0));
            }

            MySqlDataReader reader= conector.Query(query.GetSelect("grupo='" + LGrupos.SelectedValue + "'"));
            if (reader != null)
            {
                while (reader.Read())
                {
                    string url= reader["url"].ToString();
                    int nPermisos = Convert.ToInt32(reader["permiso"]);
                    for (int i = 0; i < permisos.Count; i++)
                    {
                        Permisos info = (Permisos)permisos[i];
                        if (info.pagina == url)
                        {
                            info.SetPermisos(nPermisos);
                        }
                    }
                }
            }
        }
        GPermisos.DataSource = permisos;
        GPermisos.DataBind();

        ((MasterPageI)Master).SetModificacion(LGrupos.SelectedValue);
    }
}
