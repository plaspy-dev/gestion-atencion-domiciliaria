using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class auditoria_Costos : System.Web.UI.Page
{
    protected class Grafica {
        public String fecha { get; set; }
        public int autorizada { get; set; }
        public int realizada { get; set; }
        public Decimal cAutorizada { get; set; }
        public Decimal cRealizada { get; set; }
        public Grafica(string fecha) {
            this.fecha = fecha;
        }
    }

    List<Grafica> grafica = new List<Grafica>();
    int nFecha = -1;
    int actividad = -1;
    int intensidad = -1;
    int costoautorizado = -1;
    int costoprogramado = -1;
    int sesionesprogramadas = -1;
    int sesionesautorizadas = -1;
    int difSesiones = -1;
    int difCosto = -1;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        SResultados.SelectCommand = SResultados.SelectCommand.Replace("@area", DArea.SelectedValue);
        SResumen.SelectCommand = SResumen.SelectCommand.Replace("@area", DArea.SelectedValue);
        if (!IsPostBack)
        {
            TInicio.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            TFin.Text = DateTime.Now.ToShortDateString();
            GResumen.Visible= GResultados.Visible = false;
        }
    }
    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            // reemplazamos las actividades
            if (nFecha == -1)
                nFecha = Utilidades.GetGridColumnIndex(GResultados, "Fecha");
            if (actividad == -1)
                actividad = Utilidades.GetGridColumnIndex(GResultados, "Actividad");
            if (intensidad == -1)
                intensidad = Utilidades.GetGridColumnIndex(GResultados, "Intensidad");
            if ( costoautorizado== -1)
                costoautorizado = Utilidades.GetGridColumnIndex(GResultados, "Costo autorizadas");
            if ( costoprogramado== -1)
                costoprogramado = Utilidades.GetGridColumnIndex(GResultados, "Costo programadas");
            if ( sesionesprogramadas== -1)
                sesionesprogramadas = Utilidades.GetGridColumnIndex(GResultados, "Sesiones programadas");
            if ( sesionesautorizadas== -1)
                sesionesautorizadas = Utilidades.GetGridColumnIndex(GResultados, "Sesiones Autorizadas");
            if (difSesiones == -1)
                difSesiones = Utilidades.GetGridColumnIndex(GResultados, "Diferencia sesiones");
            if ( difCosto== -1)
                difCosto = Utilidades.GetGridColumnIndex(GResultados, "Diferencia costo");



            string fecha = e.Row.Cells[nFecha].Text;
            string asegurador = HttpUtility.HtmlDecode(e.Row.Cells[costoautorizado].Text).Trim();
            string procedimiento= HttpUtility.HtmlDecode(e.Row.Cells[actividad].Text).Trim();
            string szIntensidad = HttpUtility.HtmlDecode(e.Row.Cells[intensidad].Text).Trim();
            decimal costo=Procedimientos.GetCosto(asegurador, procedimiento, szIntensidad);
            decimal cAutorizada = 0;
            decimal cProgramada = 0;
            int sAutorizada = 0;
            int sProgramada = 0;

            try
            {
                sAutorizada= Convert.ToInt32(e.Row.Cells[sesionesautorizadas].Text);
                cAutorizada= sAutorizada * costo;
                e.Row.Cells[costoautorizado].Text = string.Format("{0:C}", cAutorizada);
            }
            catch { }
            try
            {
                sProgramada = Convert.ToInt32(e.Row.Cells[sesionesprogramadas].Text);
                cProgramada=sProgramada * costo;
                e.Row.Cells[costoprogramado].Text = string.Format("{0:C}", cProgramada);
            }
            catch { }

            e.Row.Cells[difSesiones].Text = (sProgramada - sAutorizada).ToString();
            e.Row.Cells[difCosto].Text = string.Format("{0:C}",cProgramada - cAutorizada);

            e.Row.Cells[actividad].Text = Procedimientos.GetProcedimiento(procedimiento);
            e.Row.Cells[intensidad].Text = Procedimientos.GetVarios(szIntensidad);

            List<Grafica> resultado = (from g in grafica where g.fecha == fecha select g).ToList();
            Grafica info = null;
            if (resultado.Count != 0)
                info=resultado.First();
            if (info == null) {
                info = new Grafica(fecha);
                grafica.Add(info);
            }
            info.autorizada += sAutorizada;
            info.realizada += sProgramada;
            info.cRealizada += cProgramada;
            info.cAutorizada += cAutorizada;
        }
    }

    protected void GResumen_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            switch (e.Row.Cells[0].Text)
            {
                case "-1":
                    e.Row.Cells[0].Text = "Total Pacientes";
                    break;
                case "5000000":
                    e.Row.Cells[0].Text = "Sesiones Autorizadas";
                    break;
                case "-3":
                    e.Row.Cells[0].Text = "Total Autorizaciones";
                    break;
                default:
                    e.Row.Cells[0].Text = Procedimientos.GetProcedimiento(e.Row.Cells[0].Text);
                    break;
            }
        }
    }
    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResumen.Visible = GResultados.Visible = true;
        GResultados.AllowPaging = false;
        GResultados.DataBind();
        if (GResultados.Rows.Count > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }

        // GResultados.AllowPaging = true;

        GResultados.FooterRow.Cells[actividad].Text = "Total";

        GResultados.FooterRow.Cells[sesionesautorizadas].Text = grafica.Sum(x => x.autorizada).ToString();
        GResultados.FooterRow.Cells[sesionesprogramadas].Text = grafica.Sum(x => x.realizada).ToString();
        GResultados.FooterRow.Cells[difSesiones].Text = (grafica.Sum(x => x.realizada) - grafica.Sum(x => x.autorizada)).ToString();

        GResultados.FooterRow.Cells[costoautorizado].Text = string.Format("{0:C}", grafica.Sum(x => x.cAutorizada));
        GResultados.FooterRow.Cells[costoprogramado].Text = string.Format("{0:C}", grafica.Sum(x => x.cRealizada));
        GResultados.FooterRow.Cells[difCosto].Text = string.Format("{0:C}", grafica.Sum(x => x.cRealizada) - grafica.Sum(x => x.cAutorizada));

        GResumen.DataBind();

        // ahora las graficas
        RGrafica.DataSource = grafica;
        RGrafica.DataBind();
    }
}
