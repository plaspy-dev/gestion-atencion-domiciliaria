using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class vehiculos_recorrido : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {
            if (Request.QueryString["f"] == null)
                TFecha.Text = DateTime.Now.ToShortDateString(); // fecha actual
            else TFecha.Text = Request.QueryString["f"];
            TFecha.Focus();
            CUsuario usuario = CUsuario.GetUsuario();
            BAceptar.Enabled = usuario.CanInsert();
            GRecorrido.Columns[1].Visible = usuario.CanDelete();
            GRecorrido.Columns[0].Visible = usuario.CanUpdate();
        }
    }
    protected void GRecorrido_SelectedIndexChanged(object sender, EventArgs e)
    {
        try {
            DVehiculo.SelectedValue = GRecorrido.Rows[GRecorrido.SelectedIndex].Cells[2].Text;
        }
        catch (ArgumentOutOfRangeException ex) { }
        try {
            DConductor.SelectedValue = GRecorrido.SelectedDataKey.Values[1].ToString();
        }
        catch (ArgumentOutOfRangeException ex) { }
        TLugar.Text = HttpUtility.HtmlDecode(GRecorrido.Rows[GRecorrido.SelectedIndex].Cells[4].Text);
        TActividad.Text = HttpUtility.HtmlDecode(GRecorrido.Rows[GRecorrido.SelectedIndex].Cells[5].Text);
        TLlegada.Text = GRecorrido.Rows[GRecorrido.SelectedIndex].Cells[6].Text;
        TSalida.Text = GRecorrido.Rows[GRecorrido.SelectedIndex].Cells[7].Text;
        try
        {
            DProfesional.SelectedValue = GRecorrido.SelectedDataKey.Values[2].ToString();
        } catch(ArgumentOutOfRangeException ex) {}
        TObservaciones.Text = HttpUtility.HtmlDecode(GRecorrido.Rows[GRecorrido.SelectedIndex].Cells[8].Text);
        if (TObservaciones.Text == " ")
            TObservaciones.Text = "";
        
        BAceptar.Enabled= CUsuario.GetUsuario().CanUpdate();
        ((MasterPageI)Master).SetModificacion(GRecorrido.SelectedDataKey.Values[0].ToString());
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query query = new Query("vehRecorrido");
        CConectorMS conector = new CConectorMS();

        query["vrcFecha"] = TFecha.Text;
        query["vehPlaca"] = DVehiculo.SelectedValue;
        query["perId"] = DConductor.SelectedValue;
        query["vrcDestino"] = TLugar.Text;
        query["vrcActividad"] = TActividad.Text;
        query["perIdProf"] = DProfesional.SelectedValue;
        query["vrcHoraLleg"] = TLlegada.Text;
        query["vrcHoraSal"] = TSalida.Text;
        query["vrcObservacion"] = TObservaciones.Text;

        string id="";

        if(GRecorrido.SelectedIndex==-1) {

            query.AddCampo("segFechaRegistro","getdate()", false);
            query["segUsuarioRegistro"] = CUsuario.GetUsuario().GetLogin();

            int res = conector.QueryMod(query.GetInsert(), true);
            if (res == -1)
                return;
            id= res.ToString();
        } else {
            id = GRecorrido.SelectedDataKey.Values[0].ToString();
            if (conector.QueryMod(query.GetUpdate("vrcId=" + id)) == -1)
                return;
        }

        if (new CConector().InsertModificacion(id) == -1)
            return;
        Session["szMensaje"] = "Recorrido de " + DVehiculo.Text + " editado.";
        Response.Redirect(Request.Url.AbsolutePath + "?f=" + TFecha.Text);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        if (GRecorrido.SelectedIndex == -1)
        {
            Response.Redirect(Request.Url.AbsolutePath);
        } else {
            Response.Redirect(Request.Url.AbsolutePath + "?f=" + TFecha.Text);
        }
    }
}
