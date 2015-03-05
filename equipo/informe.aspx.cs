using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using SDG.Web.UI.WebControls;

public partial class equipo_informe : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            BBuscar_Click(sender, e);
            ((MasterPageI)Master).Nuevo("~/equipo/equipo.aspx");
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        if (GridUtils.GetRowsCount(GResultados, LTotal) > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e) {
        if (e.Row.RowIndex != -1) {
            LinkButton link= (LinkButton) e.Row.FindControl("LP");
            link.Text = Paciente.GetPaciente(link.Text).NombreCompleto;
            int col = GResultados.GetGridColumnIndex("Funcionario");
            e.Row.Cells[col].Text = Funcionario.GetFuncionario(HttpUtility.HtmlDecode(e.Row.Cells[col].Text).Trim()).Nombres;
        }
    }

    protected void LAccion_Clicked(object sender, EventArgs e) {
        LinkButton link = (LinkButton)sender;
        ViewState["currentEquipo"]= link.CommandName;
        if(link.Text=="Asignar") {
            UCPrestamo.Show((Prestamo)null);
        } else if (link.Text == "Devolver")
        { // devolver
            ViewState["Prestamo"] = link.CommandArgument;
            UCDevolucion.Show();
        } else {  // es un paciente
            UCPrestamo.Show(link.CommandArgument);
        }
    }

    protected void BAgregarPrestamo_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector()) {
            conector.StartTransaction();
            if (conector.QueryMod(UCPrestamo.Guardar(ViewState["currentEquipo"].ToString())) == -1)
                return;
            if (!Prestamo.UpdateEstado(conector, ViewState["currentEquipo"].ToString()))
                return;
            if (conector.InsertModificacion(ViewState["currentEquipo"].ToString(), null, "~/equipo/equipo.aspx") == -1)
                return;
            conector.Commit();
            BBuscar_Click(sender, e);
        }
    }

    protected void BAceptarDevolucion_Click(object sender, EventArgs e) {

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            Query query = new Query("equipo_prestamo");

            query["devolucion"] = Query.GetMySQLDateFormat(UCDevolucion.Fecha);

            if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(ViewState["Prestamo"].ToString()))) == -1)
                return;

            if (!Prestamo.UpdateEstado(conector, ViewState["currentEquipo"].ToString()))
                return;

            if (conector.InsertModificacion(ViewState["currentEquipo"].ToString(), null, "~/equipo/equipo.aspx") == -1)
                return;
            conector.Commit();
            BBuscar_Click(sender, e);
        }
    }
}
