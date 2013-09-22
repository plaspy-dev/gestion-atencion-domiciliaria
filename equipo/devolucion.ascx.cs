using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class equipo_devolucion : System.Web.UI.UserControl
{
    public event EventHandler BAceptarClicked = null;
    public event EventHandler BCancelarClicked = null;

    public string Fecha {
        get { return TFecha.Text; }
        set { TFecha.Text = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public void Show()
    {
        if(TFecha.Text.Length==0)
            TFecha.Text = Conector.GetFromMySQLDate(DateTime.Now);
        PDevolucion.Visible = true;
        ScriptManager.RegisterStartupScript(PDevolucion, typeof(String), "devolucionDlg", "addDialog('#" + PDevolucion.ClientID + "', '#dDevolucion');", true);
    }

    public void Hide()
    {
        PDevolucion.Visible = false;
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (BAceptarClicked != null)
            BAceptarClicked(sender, e);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        if (BCancelarClicked != null)
            BCancelarClicked(sender, e);
        Hide();
    }
}
