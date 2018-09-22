using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Collections;
using SDG.Componentes;

public partial class modificaciones : System.Web.UI.UserControl
{
    class Mods
    {
        protected string _usuario;
        protected string _fecha;

        public Mods(string usuario, string fecha)
        {
            _fecha = fecha;
            _usuario = usuario;
        }

        public string Usuario { get { return _usuario; } }
        public string Fecha { get { return _fecha; } }
    }

    protected string _idModificacion="";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Update();
        }
    }

    public void Update()
    {
        using(CConector conector = new CConector()) {
            
            Query query = new Query("modificaciones");

            query["usuario"] = "usuario.nombre";
            query["fecha"] = "modificaciones.fecha";
            string url = Page.AppRelativeVirtualPath;
            MySqlDataReader reader = conector.Query(query.GetSelect("modificaciones.id='" + IdModificacion + "' AND modificaciones.url='" + url + "' ORDER BY modificaciones.fecha", "LEFT JOIN usuario ON (usuario.id=modificaciones.usuario)"));
            if (reader != null)
            {
                PModificaciones.Visible = false;
                if (reader.Read())
                {
                    PModificaciones.Visible = true;
                    GModificaciones.EmptyDataText = "";
                    LCreadoPor.Text = reader["usuario"].ToString();
                    LFechaCreacion.Text = reader["fecha"].ToString();
                }
                ArrayList lista = new ArrayList();
                while (reader.Read())
                {
                    if (LModificadoPor.Text.Length != 0)
                    {
                        lista.Add(new Mods(LModificadoPor.Text, LFechaModificacion.Text));
                    }
                    LModificadoPor.Text = reader["usuario"].ToString();
                    LFechaModificacion.Text = reader["fecha"].ToString();
                }
                PMasModificaciones.Visible = lista.Count != 0;
                GModificaciones.DataSource = lista;
                GModificaciones.DataBind();
            }


            query = new Query("impresiones");

            query["usuario"] = "usuario.nombre";
            query["fecha"] = "impresiones.fecha";
            reader = conector.Query(query.GetSelect("impresiones.id='" + IdModificacion + "' AND impresiones.url='" + url + "' ORDER BY impresiones.fecha", "LEFT JOIN usuario ON (usuario.id=impresiones.usuario)"));
            if (reader != null)
            {
                ArrayList lista = new ArrayList();
                while (reader.Read())
                {
                    lista.Add(new Mods(reader["usuario"].ToString(), reader["fecha"].ToString()));
                }
                PImpresion.Visible = lista.Count != 0;
                GImpresiones.DataSource = lista;
                GImpresiones.DataBind();
            }

        }
    }

    public string IdModificacion
    {
        set { _idModificacion = value; Update(); }
        get { return _idModificacion; }
    }
}
