using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

[ValidationPropertyAttribute("IdActividad")]
public partial class control_actividad : System.Web.UI.UserControl
{
    public bool ReadOnly
    {
        set
        {
            TProcedimiento.ReadOnly = value;
            TProcedimientoID.ReadOnly = value;
        }
        get
        {
            return TProcedimiento.ReadOnly;
        }
    }
    public string IdActividad
    {
        set
        {
            TProcedimiento.Text = "";
            TProcedimientoID.Text = "";
            if (!string.IsNullOrEmpty(value))
            {
                using (CConector conector = new CConector())
                {
                    TProcedimientoID.Text = value;
                    MySqlDataReader reader= conector.Query("SELECT nombre,principio,concentracion,forma,codigo FROM medicamentos WHERE id={0}", Query.GetValor(value));
                    if (reader != null && reader.Read()) {
                        string nombre = reader["codigo"].ToString() + " - ";
                        nombre += reader["nombre"].ToString();
                        if (reader["principio"].ToString().Length != 0)
                            nombre += " [" + reader["principio"].ToString() + "]";
                        if (reader["concentracion"].ToString().Length != 0)
                            nombre += ", " + reader["concentracion"].ToString();
                        if (reader["forma"].ToString().Length != 0)
                            nombre += "-" + reader["forma"].ToString();
                        TProcedimiento.Text = nombre;
                    }
                }
            }
        }
        get { return TProcedimientoID.Text; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.ClientScript.IsClientScriptIncludeRegistered("actidadadSimple"))
            Page.ClientScript.RegisterClientScriptInclude("actidadadSimple", ResolveUrl("~/control/actividad.ascx.js"));
        Page.ClientScript.RegisterClientScriptBlock(typeof(string), "actidadadSimpleI", "initActividad('" + ResolveClientUrl("~/") + "', '" + TProcedimiento.ClientID + "', '" + TProcedimientoID.ClientID + "');", true);
    }
}