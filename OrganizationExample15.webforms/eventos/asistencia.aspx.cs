using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class eventos_asistencia : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DEvento.DataBind();
            DEvento_SelectedIndexChanged(sender, e);
        }
    }

    protected void BIr_Click(object sender, EventArgs e)
    {

    }

    protected void DEvento_SelectedIndexChanged(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            MySqlDataReader reader = conector.Query("SELECT inicio,fin FROM programacion_evento WHERE id=" + Query.GetValor(DEvento.SelectedValue));
            BAceptar.Enabled = false;
            if (reader != null && reader.Read())
            {
                DateTime inicio = (DateTime)reader["inicio"];
                DateTime fin = (DateTime)reader["fin"];
                RFecha.MinimumValue = inicio.ToShortDateString();
                RFecha.MaximumValue = fin.ToShortDateString();
                RFecha.Text = "Por favor ingrese una fecha desde " + RFecha.MinimumValue + " hasta " + RFecha.MaximumValue;
                TFecha.Text = RFecha.MinimumValue;
                LFecha.Text = "$('.fecha').datepicker({ minDate: new Date(" + inicio.Year + ", " + (inicio.Month - 1) + ", " + inicio.Day
                    + "), maxDate: new Date("
                    + fin.Year + ", " + (fin.Month - 1) + ", " + fin.Day + ") });";
                if (conector.QueryString("SELECT COUNT(*) FROM asistencia WHERE evento=" + DEvento.SelectedValue + " AND fecha=" + Query.GetValor(Query.GetMySQLDateFormat(TFecha.Text))) == "0")
                {
                    BAceptar.Enabled = Usuario.GetUsuario().CanInsert();
                }
                else
                {
                    BAceptar.Enabled = Usuario.GetUsuario().CanUpdate();
                }
            }
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();

            Query query = new Query("asistencia");

            query["evento"] = DEvento.SelectedValue;
            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);

            for (int i = 0; i < GResultados.Rows.Count; i++)
            {
                query["personal"] = GResultados.DataKeys[i].Values["perId"].ToString();
                TextBox ingreso= ((TextBox)GResultados.Rows[i].FindControl("TIngreso"));
                TextBox salida = ((TextBox)GResultados.Rows[i].FindControl("TSalida"));

                if (ingreso.Text.Length > 0 || salida.Text.Length > 0)
                {
                    query["ingreso"] = ingreso.Text;
                    query["salida"] = salida.Text;

                    if (conector.QueryMod(query.GetUpdate("evento=" + DEvento.SelectedValue + " AND fecha=" + Query.GetValor(Query.GetMySQLDateFormat(TFecha.Text)) + " AND personal=" + GResultados.DataKeys[i].Values["perId"].ToString())) == -1)
                        return;
                    if (conector.QueryMod(query.GetInsert().Replace("INSERT INTO ", "INSERT IGNORE INTO ")) == -1)
                        return;
                }
            }


            query = new Query("asistencia_ambulancia");

            query["evento"] = DEvento.SelectedValue;
            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);

            for (int i = 0; i < GAmbulancias.Rows.Count; i++)
            {
                query["codigo"] = GAmbulancias.DataKeys[i].Values["codigo"].ToString();
                TextBox ingreso = ((TextBox)GAmbulancias.Rows[i].FindControl("TIngreso"));
                TextBox salida = ((TextBox)GAmbulancias.Rows[i].FindControl("TSalida"));

                if (ingreso.Text.Length > 0 || salida.Text.Length > 0)
                {
                    query["ingreso"] = ingreso.Text;
                    query["salida"] = salida.Text;

                    if (conector.QueryMod(query.GetUpdate("evento=" + DEvento.SelectedValue + " AND fecha=" + Query.GetValor(Query.GetMySQLDateFormat(TFecha.Text)) + " AND codigo=" + Query.GetValor(GAmbulancias.DataKeys[i].Values["codigo"].ToString()))) == -1)
                        return;
                    if (conector.QueryMod(query.GetInsert().Replace("INSERT INTO ", "INSERT IGNORE INTO ")) == -1)
                        return;
                }
            }

            if (conector.InsertModificacion(DEvento.SelectedValue) == -1)
                return;



            conector.Commit();
        }
        ((MasterPageI)Master).SetResultado("Asistencia modificada de " + DEvento.SelectedItem.Text);
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
}
