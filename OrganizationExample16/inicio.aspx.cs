using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using System.Configuration;

public partial class inicio : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            RCumpleanos.Visible = Usuario.GetInstance()["cumpleanos"] == "1";
            RAlertas.DataSource = Alertas.GetAlertas();
            RAlertas.DataBind();
        }
    }

    protected Control GetControl(Control parent, string id)
    {

        for (int i = 0; i < parent.Controls.Count; i++)
        {
            if (parent.Controls[i].ID != null && parent.Controls[i].ID.IndexOf(id) != -1)
                return parent.Controls[i];
        }
        return null;
    }

    protected void OnClickBA(object sender, EventArgs e)
    {
        Button boton = (Button)sender;
        Control parent = boton.Parent;

        Image img = (Image)GetControl(parent, "IL");
        if (img != null)
            img.Visible = false;
        boton.Visible = false;

        LinkButton link = (LinkButton)GetControl(parent, "LA");

        SqlDataSource SAlertas = (SqlDataSource)GetControl(parent, "SAlertas");

        List<Alertas> resultado = (from x in Alertas.GetAlertas()
                                   where x.Id == link.CommandArgument
                                   select x).ToList();
        if (resultado.Count == 0)
            return;
        Alertas info = resultado.First();


        SAlertas.SelectCommand = info.SelectCommand;
        SAlertas.ConnectionString = ConfigurationManager.ConnectionStrings["MySQLConnectionString"].ConnectionString;
        SAlertas.ProviderName = ConfigurationManager.ConnectionStrings["MySQLConnectionString"].ProviderName;

        GridView GAlertas = (GridView)GetControl(parent, "GAlertas");

        ((HyperLinkField)GAlertas.Columns[0]).DataNavigateUrlFormatString = link.CommandArgument;
        GAlertas.DataBind();
        GAlertas.Visible = true;
    }

    protected void GAlertas_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
        }
    }
}
