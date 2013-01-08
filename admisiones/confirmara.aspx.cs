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
        CConectorMS conector = new CConectorMS();
        conector.StartTransaction();
        for(int i=0; i<GResultados.Rows.Count; i++) {

            TextBox autorizacion= (TextBox) GResultados.Rows[i].Cells[6].FindControl("TAutorizacion");
            if(autorizacion.Text.Length!=0) {
                // actualizamos todas las autorizaciones
                string autorizacionactual = GResultados.DataKeys[i].Value.ToString();
                
                // verificamos que no este duplicado en otro paciente
                if (autorizacion.Text != autorizacionactual)
                {
                    if (conector.QueryString("SELECT autNumero FROM phdAutorizacion WHERE autNumero=" + Query.GetValor(autorizacion.Text)).Length != 0)
                    {
                        autorizacion.Focus();
                        ((MasterPageI)Master).SetMensaje("Ya existe una autorización " + Query.GetValor(autorizacion.Text));
                        return;
                    }
                }
                // actualizamos la autorizacion phdAutorizacion
                Query qAutorizacion = new Query("phdAutorizacion");
                qAutorizacion["autNumero"] = autorizacion.Text;
                qAutorizacion["autProvisional"] = "0";
                qAutorizacion["segUsuarioConfirma"] = qAutorizacion["segUsuarioModifica"] = CUsuario.GetUsuario().GetLogin();
                qAutorizacion["segFechaConfirma"] = qAutorizacion["segFechaModifica"] = "GETDATE()";
                qAutorizacion["autNumeroAnt"] = autorizacionactual;

                if (conector.QueryMod(qAutorizacion.GetUpdate("autNumero=" + Query.GetValor(autorizacionactual))) == -1)
                    return;

                if (autorizacion.Text != autorizacionactual) {
                    // actualizamos programacion
                    // actualizamos el detalle phdDetalleAutorizacion

                    Query programacion = new Query("programacion");
                    programacion["autNumero"] = autorizacion.Text;

                    if (conector.QueryMod(programacion.GetUpdate("autNumero=" + Query.GetValor(autorizacionactual))) == -1)
                        return;

                    Query detalle = new Query("phdDetalleAutorizacion");
                    detalle["autNumero"] = autorizacion.Text;

                    if (conector.QueryMod(detalle.GetUpdate("autNumero=" + Query.GetValor(autorizacionactual))) == -1)
                        return;
                }

                total++;
            }
        }
        conector.Commit();
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
