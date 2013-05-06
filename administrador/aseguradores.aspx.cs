using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using SDG.Componentes;

public partial class administrador_aseguradores : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TNombre.Focus();
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();

            BAceptar.Enabled = usuario.CanInsert();
            GResultado.Columns[1].Visible = usuario.CanDelete();
            GResultado.Columns[0].Visible = usuario.CanUpdate();
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query query = new Query("admEntidad");
        CConectorMS conector = new CConectorMS();
        string szQuery;
        string mensaje;
        string id = GResultado.SelectedIndex==-1 ? "" : GResultado.SelectedDataKey.Value.ToString();

        query["entNombre"] = TNombre.Text;
        query["entEPS"] = CEPS.Checked ? "1" : "0";
        query["entARP"] = CARP.Checked ? "1" : "0";
        query["entAFP"] = CAFP.Checked ? "1" : "0";
        query["entPrgNoAut"] = CProgramar.Checked ? "1" : "0";
        query["maximo_mensual"] = TMaximoMensual.Text.Replace(",", "");
        query["maximo_paciente"] = TMaximoPaciente.Text.Replace(",", "");
        
        if (id.Length == 0)
        {
            szQuery = query.GetInsert();
            mensaje = TNombre.Text + " ingresado";
            int res = conector.QueryMod(szQuery, true);
            if (res == -1)
                return;
            id = res.ToString();
        }
        else
        {
            szQuery = query.GetUpdate("entId='" + id + "'");
            mensaje = TNombre.Text + " editado";
            if (conector.QueryMod(szQuery)==-1)
                return;
        }
        if (new CConector().InsertModificacion(id) == -1)
            return;

        Entidad.RemoveEntidad(id);
        ((MasterPageI)Master).SetResultado(mensaje);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void GResultado_SelectedIndexChanged(object sender, EventArgs e)
    {
        TNombre.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[2].Text).Trim();
        CEPS.Checked= ((CheckBox)GResultado.SelectedRow.Cells[5].Controls[0]).Checked;
        CAFP.Checked = ((CheckBox)GResultado.SelectedRow.Cells[6].Controls[0]).Checked;
        CARP.Checked = ((CheckBox)GResultado.SelectedRow.Cells[7].Controls[0]).Checked;
        CProgramar.Checked = ((CheckBox)GResultado.SelectedRow.Cells[8].Controls[0]).Checked;
        TMaximoMensual.Text = "";
        TMaximoPaciente.Text = "";
        try
        {
            TMaximoMensual.Text = double.Parse(GResultado.SelectedRow.Cells[4].Text, NumberStyles.Currency).ToString(CultureInfo.InvariantCulture);
        }
        catch { }
        try {
            TMaximoPaciente.Text = double.Parse(GResultado.SelectedRow.Cells[3].Text, NumberStyles.Currency).ToString(CultureInfo.InvariantCulture);
        }
        catch { }

        ((MasterPageI)Master).SetModificacion(GResultado.SelectedDataKey.Value.ToString());
    }
}
