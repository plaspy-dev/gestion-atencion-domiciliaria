using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.ComponentModel;
using SDG.Componentes;

public partial class paciente_autorizaciones : System.Web.UI.UserControl
{
    public static List<Autorizaciones> autorizaciones=null;
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {

        }
    }

    [Bindable(true), Category("Appearance"), DefaultValue("")]
    public string Value
    {
        get { return HId.Value; }
        set { 
            HId.Value = value;
            RDetalles.DataSource = autorizaciones= Autorizaciones.GetAutorizaciones(value);
            RDetalles.DataBind();
        }
    }

    protected void RDetalles_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        Repeater repeater = (Repeater)e.Item.FindControl("RDDetalle");
        Label label = (Label)e.Item.FindControl("LA");
        if(repeater!=null && label!=null) {
            if (autorizaciones==null)
                autorizaciones = Autorizaciones.GetAutorizaciones(HId.Value);
            if(autorizaciones!=null) {

                List<Autorizaciones> resultado= (from aut in autorizaciones
                                   where aut.Autorizacion == label.Text
                                   select aut).ToList();

                if (resultado.Count>0) {
                    repeater.DataSource = resultado.First().detalles;
                    repeater.DataBind();
                }
            }
        }
    }
}
