using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using SDG.Componentes;

public partial class ctrl_sharehistory : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            P.Visible = !string.IsNullOrEmpty(Request.QueryString["code"]);
            TEmail.Focus();
        }
    }

    protected void BEnviar_Click(object sender, EventArgs e)
    {
        LMessage.Text = "";
        if (!Page.IsValid)
            return;
        string filename = null;
        try
        {
            string code = Request.QueryString["code"];
            string medico = "";
            string fecha = "";

            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("historias-noreply@example.invalid", "Historias Clínicas OrganizationExample15");
            mail.To.Add(TEmail.Text);

            mail.Subject = "OrganizationExample15 Historia clínica";
            mail.IsBodyHtml = true;
            mail.Priority = MailPriority.Normal;

            StringBuilder Contenido = new StringBuilder(File.ReadAllText(Server.MapPath("~/ctrl/historia.html")));

            Contenido = Contenido.Replace("$szCode$", code);

            filename = Archivo.GetHistoryFromCode(code, out medico, out fecha);
            if (string.IsNullOrEmpty(filename))
            {
                LMessage.Text = "No se pudo generar el archivo PDF";
                return;
            }

            Contenido = Contenido.Replace("$szMedico$", medico).Replace("$szFecha$", fecha);

            Contenido = Contenido
                .Replace("../imgs/", string.Format("{0}{1}", ConfigurationManager.AppSettings["servidor"], ResolveUrl("~/imgs/")))
                .Replace("../css/", string.Format("{0}{1}", ConfigurationManager.AppSettings["servidor"], ResolveUrl("~/css/")))
                .Replace("~/imgs/", string.Format("{0}{1}", ConfigurationManager.AppSettings["servidor"], ResolveUrl("~/imgs/")))
                .Replace("~/css/", string.Format("{0}{1}", ConfigurationManager.AppSettings["servidor"], ResolveUrl("~/css/")));

            mail.Body = Contenido.ToString();

            using (MemoryStream ms = new MemoryStream(File.ReadAllBytes(filename)))
            {
                mail.Attachments.Add(new Attachment(ms, code + ".pdf"));
                using (SmtpClient client = new SmtpClient())
                {
                    client.EnableSsl = client.Port == 587 || client.Port == 465;
                    client.Send(mail);
                }
            }
            LMessage.Text = "Correo enviado a " + TEmail.Text + " exitosamente";
        } catch (Exception ex) {
            LMessage.Text = ex.Message;
            if(!string.IsNullOrEmpty(filename))
                File.Delete(filename);
        }
    }
}