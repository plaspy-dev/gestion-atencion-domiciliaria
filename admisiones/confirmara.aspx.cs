using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class admisiones_confirmara : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {

            DAsegurador_SelectedIndexChanged(sender, e);
        }
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        int total = 0;
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            List<string> listadoPacientes = new List<string>();

            for (int i = 0; i < GResultados.Rows.Count; i++)
            {
                TextBox autorizacion = (TextBox)GResultados.Rows[i].Cells[6].FindControl("TAutorizacion");
                if (autorizacion.Text.Length != 0)
                {
                    // actualizamos todas las autorizaciones
                    string autorizacionactual = GResultados.DataKeys[i].Values["autNumero"].ToString();
                    listadoPacientes.Add(GResultados.DataKeys[i].Values["pacId"].ToString());

                    // verificamos que no este duplicado en otro paciente
                    if (autorizacion.Text != autorizacionactual)
                    {
                        if (conector.QueryString("SELECT autNumero FROM autorizacion WHERE autNumero=" + Query.GetValor(autorizacion.Text)).Length != 0)
                        {
                            autorizacion.Focus();
                            ((MasterPageI)Master).SetMensaje("Ya existe una autorización " + Query.GetValor(autorizacion.Text));
                            return;
                        }
                    }
                    // actualizamos la autorizacion autorizacion
                    Query qAutorizacion = new Query("autorizacion");
                    qAutorizacion["autNumero"] = autorizacion.Text;
                    qAutorizacion["autProvisional"] = "0";
                    qAutorizacion["segUsuarioConfirma"] = qAutorizacion["segUsuarioModifica"] = CUsuario.GetUsuario().GetLogin();
                    qAutorizacion["segFechaConfirma"] = qAutorizacion["segFechaModifica"] = "SYSDATE()";
                    qAutorizacion["autNumeroAnt"] = autorizacionactual;

                    if (conector.QueryMod(qAutorizacion.GetUpdate("autNumero=" + Query.GetValor(autorizacionactual))) == -1)
                        return;

                    if (autorizacion.Text != autorizacionactual)
                    {
                        // actualizamos programacion
                        // actualizamos el detalle autorizacion_detalle

                        Query programacion = new Query("programacion");
                        programacion["autNumero"] = autorizacion.Text;

                        if (conector.QueryMod(programacion.GetUpdate("autNumero=" + Query.GetValor(autorizacionactual))) == -1)
                            return;

                        Query detalle = new Query("autorizacion_detalle");
                        detalle["autNumero"] = autorizacion.Text;

                        if (conector.QueryMod(detalle.GetUpdate("autNumero=" + Query.GetValor(autorizacionactual))) == -1)
                            return;

                        Autorizaciones.UpdateSesiones(conector, autorizacionactual);
                    }
                    Autorizaciones.UpdateSesiones(conector, autorizacion.Text);
                    total++;
                }
            }
            conector.Commit();
            foreach(string paciente in listadoPacientes)
                Autorizaciones.RemoveAutorizaciones(paciente);
        }
        ((MasterPageI)Master).SetResultado(total + " Autorizaciones confirmadas.");
    }
    protected void DAsegurador_SelectedIndexChanged(object sender, EventArgs e)
    {
        GResultados.DataBind();
        if (GResultados.Rows.Count > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
    }
}
