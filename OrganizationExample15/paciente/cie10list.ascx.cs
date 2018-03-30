using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class paciente_cie10list : System.Web.UI.UserControl
{
    public List<Miscelaneos> Codes {
        get { return ViewState["cie10codes"] as List<Miscelaneos>; }
        set {
            ViewState["cie10codes"] = value;
            GCDiagnostico.DataSource = value;
            GCDiagnostico.DataBind();
        }
    }

    public bool Print {
        set {
            GCDiagnostico.Columns[1].Visible=
            GCDiagnostico.Columns[0].Visible = false;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            CUsuario usuario = (CUsuario)CUsuario.GetInstance();
            GCDiagnostico.Columns[0].Visible = usuario.CanInsert();
            GCDiagnostico.Columns[1].Visible = usuario.CanInsert();
            BMasCDiagnostico.Enabled = usuario.CanInsert();
        }
    }

    protected string GetCodigoCIE(string text)
    {
        int pos = text.IndexOf('-');
        if (pos != -1)
        {
            string resultado = text.Substring(0, pos);
            return text.Substring(0, pos).Trim();
        }
        return "";
    }

    public void FillFromPaciente(string idPaciente) {

        List<Miscelaneos> list = new List<Miscelaneos>();
        Paciente paciente = Paciente.GetPaciente(idPaciente);
        for (int i = 0; i < paciente.cie10.Count; i++)
        {
            list.Add(new Miscelaneos(paciente.cie10[i], Procedimientos.GetCodigoCIE(paciente.cie10[i])));
        }
        Codes = list;
    }

    protected void BMasCDiagnostico_Click(object sender, EventArgs e)
    {
        Page.Validate("cie10");
        if (!Page.IsValid)
            return;

        List<Miscelaneos> list = Codes;
        string codigo = GetCodigoCIE(TCIE10.Text);
        if (!list.Exists(x => x.Id == codigo))
        {
            list.Add(new Miscelaneos(codigo, Procedimientos.GetCodigoCIE(codigo)));
            Codes = list;
        }

        GCDiagnostico.SelectedIndex = -1;
        GCDiagnostico.DataBind();

        TCIE10.Text = "";
        TCIE10.Focus();
    }

    protected void GCDiagnostico_SelectedIndexChanged(object sender, EventArgs e)
    {
        TCIE10.Text = HttpUtility.HtmlDecode(GCDiagnostico.SelectedRow.Cells[2].Text).Trim();
        TCIE10.Text += " - " + HttpUtility.HtmlDecode(GCDiagnostico.SelectedRow.Cells[3].Text).Trim();
    }

    protected void GCDiagnostico_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        List<Miscelaneos> list = Codes;
        string codigo = GetCodigoCIE(TCIE10.Text);
        list.RemoveAll(x => x.Id == e.Keys["Id"].ToString());
        Codes = list;

        GCDiagnostico.SelectedIndex = -1;
        GCDiagnostico.DataBind();

        TCIE10.Text = "";
        TCIE10.Focus();
        e.Cancel = true;
    }
}