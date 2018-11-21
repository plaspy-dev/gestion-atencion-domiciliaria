using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Net.Configuration;
using System.Net.Mail;
using System.Web.Configuration;


public partial class rh_cumple : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TInicio.Text = TFin.Text = Request.QueryString["fn"];
            if (TInicio.Text.Length==0)
                TInicio.Text = TFin.Text = DateTime.Now.ToShortDateString();
            DPlantilla.DataBind();
            DPlantilla_SelectedIndexChanged(sender, e);
            BBuscar_Click(sender, e);
        }
    }
    protected void LEnviar_Click(object sender, EventArgs e)
    {
        PEnviar.Visible = true;
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {

            for (int i = 0; i < GResultados.Rows.Count; i++)
            {
                if (!((CheckBox)GResultados.Rows[i].FindControl("CEnviado")).Checked)
                {

                    if (GResultados.Rows[i].Cells[3].Text.Trim().Length != 0)
                    {

                        SmtpClient client = new SmtpClient();
                        MailAddress to = new MailAddress(GResultados.Rows[i].Cells[3].Text, GResultados.Rows[i].Cells[0].Text);
                        MailAddress from = new MailAddress(ConfigurationManager.AppSettings["frombirthday"], "OrganizationExample15");

                        MailMessage mail = new MailMessage(from, to);
                        mail.Body = TMensaje.Text;
                        mail.Subject = DPlantilla.SelectedItem.Text;

                        try
                        {
                            client.Send(mail);
                        }
                        catch (Exception ex)
                        {

                            ((MasterPageI)Master).SetMensaje(ex.ToString());
                            return;
                        }
                        if (conector.QueryMod("UPDATE admPersonalHS SET felicitacion=YEAR(NOW()) WHERE perId=" + GResultados.DataKeys[i].Value.ToString()) == -1)
                            return;
                    }
                }
            }
        }
        ((MasterPageI)Master).SetMensaje("Correo enviado");
        GResultados.DataBind();
        PEnviar.Visible = false;
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        PEnviar.Visible = false;
    }
    protected void DPlantilla_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (DPlantilla.SelectedIndex == -1)
            return;
        using(CConector conector = new CConector())
            TMensaje.Text = conector.QueryString("SELECT plantTexto FROM plantilla_correo WHERE plantId=" + DPlantilla.SelectedValue);

    }
    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.DataBind();
        LEnviar.Visible = false;
        if (GResultados.Rows.Count > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
            LEnviar.Visible = true;
        }
    }
}
