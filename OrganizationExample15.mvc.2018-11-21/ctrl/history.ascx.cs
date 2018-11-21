using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class ctrl_history : System.Web.UI.UserControl
{
    public void Init(string SelectCommand, string url, string pacienteid, string singular, string plural) {
        ViewState["url"] = url;
        SH.SelectCommand = SelectCommand;
        SH.SelectParameters["paciente"].DefaultValue = pacienteid;
        PH.Visible = GridUtils.GetRowsCount(GH, LH, singular, plural) > 0;
    }

    public string GetURL() {
        return (string)ViewState["url"];
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            
        }
    }
}