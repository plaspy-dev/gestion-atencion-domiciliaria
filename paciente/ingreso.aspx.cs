using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Text;
using System.IO;
using MySql.Data.MySqlClient;
using componentes;

public partial class paciente_ingreso : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        CConectorMS conector = CConectorMS.GetConector();
        DDocumento.Focus();
        if(!IsPostBack) {

            Usuario usuario = Usuario.GetUsuario();
            BAceptar.Enabled = false;

            TDocumento.Text = Request.QueryString["id"];
            DDocumento.DataBind();
            DDocumento.SelectedValue = Request.QueryString["td"];

            if (TDocumento.Text.Length > 0 && DDocumento.SelectedIndex > -1)
            {
                Query query = new Query("phdPaciente");

                query ["pacId"]= "phdPaciente.pacId";
                query ["pacPNombre"]= "phdPaciente.pacPNombre";
                query["pacSNombre"] = "phdPaciente.pacSNombre";
                query["pacPApellido"] = "phdPaciente.pacPApellido";
                query["pacSApellido"] = "phdPaciente.pacSApellido";
                query["pacDireccion"] = "phdPaciente.pacDireccion";
                query["pacFechaNac"] = "phdPaciente.pacFechaNac";
                query["entNombre"] = "admEntidad.entNombre";
                query["sexoId"] = "phdPaciente.sexoId";

                SqlDataReader reader = conector.Query(query.GetSelect("phdPaciente.pacDocumento='" + TDocumento.Text + "' AND phdPaciente.tdocId='" + DDocumento.SelectedValue + "'", "LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)"));
                if (reader != null && reader.Read())
                {
                    PMujer.Visible = reader["sexoId"].ToString()!="2";

                    BAceptar.Enabled = usuario.CanInsert();
                    Session["parametros"] = "?id=" + Request.QueryString["id"] + "&td=" + Request.QueryString["td"] + "&f=" + CConector.GetDate(DateTime.Now);
                    DMedico.Focus();

                    HId.Value = reader["pacId"].ToString();
                    LNombres.Text= reader["pacPNombre"].ToString() + " " + reader["pacSNombre"].ToString();
                    LApellidos.Text = reader["pacPApellido"].ToString() + " " + reader["pacSApellido"].ToString();
                    LDireccion.Text = reader["pacDireccion"].ToString();
                    LEntidad.Text = reader["entNombre"].ToString();

                    if (reader["pacFechaNac"] != null && reader["pacFechaNac"].ToString().Length != 0)
                    {
                        DateTime birthDate = (DateTime)reader["pacFechaNac"];
                        DateTime now = DateTime.Now;
                        int years = now.Year - birthDate.Year;

                        if (now.Month < birthDate.Month || (now.Month == birthDate.Month && now.Day < birthDate.Day))
                            --years;

                        LEdad.Text = years + " años";
                    }
                }

                Query qIngreso = new Query("ingreso_paciente");

                qIngreso += "id";
                qIngreso += "medico";
                qIngreso += "hora";
                qIngreso += "motivo";
                qIngreso += "segun";
                qIngreso += "enfermedad_actual";
                qIngreso += "ta";
                qIngreso += "fc";
                qIngreso += "fr";
                qIngreso += "t";
                qIngreso += "peso";
                qIngreso += "observacionesa";
                qIngreso += "amplacion";
                qIngreso += "observacionesef";
                qIngreso += "cdi";
                qIngreso += "cde";
                qIngreso += "ddi";
                qIngreso += "dde";
                qIngreso += "conducta";

                CConector conectormysql=  CConector.GetConector();
                MySqlDataReader readermysql= conectormysql.Query(qIngreso.GetSelect("tipo='" + DDocumento.SelectedValue + "' AND documento='" + TDocumento.Text + "'"));
                if(readermysql!=null && readermysql.Read()) {

                    BAceptar.Enabled = usuario.CanUpdate();

                    HIdIngreso.Value=readermysql["id"].ToString();
                    DMedico.SelectedValue= readermysql["medico"].ToString();
                    THora.Text= readermysql["hora"].ToString();
                    TMotivo.Text = readermysql["motivo"].ToString();
                    DMotivo.SelectedValue= readermysql["segun"].ToString();
                    TEnfermedadActual.Text = readermysql["enfermedad_actual"].ToString();
                    TTA.Text = readermysql["ta"].ToString();
                    TFC.Text = readermysql["fc"].ToString();
                    TFR.Text = readermysql["fr"].ToString();
                    TT.Text = readermysql["t"].ToString();
                    TPeso.Text = readermysql["peso"].ToString();
                    TObservacionesAntecedentes.Text = readermysql["observacionesa"].ToString();
                    TAmpliacion.Text = readermysql["amplacion"].ToString();
                    TObservacionesFisico.Text = readermysql["observacionesef"].ToString();
                    TDIngreso.Text= readermysql["cdi"].ToString();
                    TDEgreso.Text = readermysql["cde"].ToString();
                    TDescripcionIngreso.Text = readermysql["ddi"].ToString();
                    TDescripcionEgreso.Text = readermysql["dde"].ToString();
                    TConductaInicial.Text = readermysql["conducta"].ToString();

                    ((MasterPageI)Master).SetModificacion(HIdIngreso.Value);
                }
            }
        }
    }

    public void IBuscar_Click(object sender, EventArgs e)
    {
        CConectorMS conector = CConectorMS.GetConector();
        String documento = conector.QueryString("SELECT pacDocumento FROM phdPaciente WHERE pacDocumento='" + TDocumento.Text + "' AND tdocId='" + DDocumento.SelectedValue + "'");
        if (documento.Length > 0)
        {
            Response.Redirect(Request.Url.AbsolutePath + "?id=" + TDocumento.Text + "&td=" + DDocumento.SelectedValue);
            return;
        }
        string texto = "No se encontraron resultados";
        String count = conector.QueryString("SELECT COUNT(*) FROM phdPaciente WHERE pacDocumento LIKE '%" + TDocumento.Text + "%'");
        int cuenta = 0;
        try
        {
            cuenta = Convert.ToInt32(count);
        }
        catch (System.FormatException ex)
        {
            texto = ex.ToString();
        }
        if (cuenta == 1)
        {
            string tipo = conector.QueryString("SELECT tdocId FROM phdPaciente WHERE pacDocumento='" + TDocumento.Text + "'");
            Response.Redirect(Request.Url.AbsolutePath + "?id=" + TDocumento.Text + "&td=" + tipo);
            return;
        }

        if (cuenta > 1)
        {

            texto = "";
            Query query = new Query("phdPaciente");
            query += "tdocId";
            query += "pacDocumento";
            query += "pacPNombre";
            query += "pacSNombre";
            query += "pacPApellido";
            query += "pacSApellido";

            SqlDataReader reader = conector.Query(query.GetSelect("pacDocumento LIKE '%" + TDocumento.Text + "%' ORDER BY pacPApellido,pacPNombre"));
            Table tabla = new Table();
            tabla.BorderWidth = 1;

            while (reader.Read())
            {

                TableRow row = new TableRow();
                TableCell cell = new TableCell();
                HyperLink link = new HyperLink();
                link.NavigateUrl = Request.Url.AbsolutePath + "?id=" + reader["pacDocumento"].ToString() + "&td=" + reader["tdocId"].ToString();
                link.Text = reader["pacDocumento"].ToString();
                cell.Attributes["align"] = "left";
                cell.Controls.Add(link);
                cell.BorderWidth = 1;
                row.Cells.Add(cell);

                cell = new TableCell();
                link = new HyperLink();
                link.NavigateUrl = Request.Url.AbsolutePath + "?id=" + reader["pacDocumento"].ToString() + "&td=" + reader["tdocId"].ToString();
                link.Text = reader["pacPApellido"].ToString() + " " + reader["pacSApellido"].ToString()
                    + " " + reader["pacPNombre"].ToString() + " " + reader["pacSNombre"].ToString();
                cell.Attributes["align"] = "left";
                cell.Controls.Add(link);
                cell.BorderWidth = 1;
                row.Cells.Add(cell);
                tabla.Rows.Add(row);
            }
            StringBuilder sb = new StringBuilder();
            StringWriter tw = new StringWriter(sb);
            HtmlTextWriter hw = new HtmlTextWriter(tw);

            tabla.RenderControl(hw);
            texto = sb.ToString();
        }
        ((MasterPageI)Master).SetAuxDiag("Busqueda de " + TDocumento.Text, texto);
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        CConector conector = CConector.GetConector();
        Query qIngreso = new Query("ingreso_paciente");

        qIngreso["medico"]= DMedico.SelectedValue;
        qIngreso["hora"]= THora.Text;
        qIngreso["motivo"]= TMotivo.Text;
        qIngreso["segun"]= DMotivo.SelectedValue;
        qIngreso["enfermedad_actual"]= TEnfermedadActual.Text;
        qIngreso["ta"]= TTA.Text;
        qIngreso["fc"]= TFC.Text;
        qIngreso["fr"]= TFR.Text;
        qIngreso["t"]= TT.Text;
        qIngreso["peso"]= TPeso.Text;
        qIngreso["observacionesa"]= TObservacionesAntecedentes.Text;
        qIngreso["amplacion"]= TAmpliacion.Text;
        qIngreso["observacionesef"]= TObservacionesFisico.Text;
        qIngreso["cdi"]= TDIngreso.Text;
        qIngreso["cde"]= TDEgreso.Text;
        qIngreso["ddi"]= TDescripcionIngreso.Text;
        qIngreso["dde"]= TDescripcionEgreso.Text;
        qIngreso["conducta"]= TConductaInicial.Text;

        string szQuery;
        string mensaje;

        if (HIdIngreso.Value.Length == 0)
        {
            qIngreso["tipo"] = DDocumento.SelectedValue;
            qIngreso["documento"] = TDocumento.Text;

            szQuery = qIngreso.GetInsert();
            mensaje = LNombres.Text + " ingresado";
            int resultado = conector.QueryMod(szQuery);
            if (resultado == -1)
                return;
            HIdIngreso.Value = resultado.ToString();
        }
        else
        {
            szQuery = qIngreso.GetUpdate("id='" + HIdIngreso.Value + "'");
            mensaje = LNombres.Text + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;
        }
        if (conector.InsertModificacion(HIdIngreso.Value) == -1)
            return;

        for(int i=0; i<GAntecedentes.Rows.Count; i++) {

            Query antecendentes = new Query("antecedentes_ingreso");
            string id= GAntecedentes.DataKeys[i].Values[1].ToString();

            antecendentes["estado"] = ((CheckBox)GAntecedentes.Rows[i].Cells[0].FindControl("CSi")).Checked ? "1" : "";
            if(id.Length>0) {
                id = antecendentes.GetUpdate("id='" + id + "'");
            } else {
                antecendentes["ingreso_paciente"] = HIdIngreso.Value;
                antecendentes["motivo"] = GAntecedentes.DataKeys[i].Values[0].ToString();
                id = antecendentes.GetInsert();
            }
            conector.QueryMod(id);
        }

        for (int i = 0; i < GRevision.Rows.Count; i++)
        {

            Query antecendentes = new Query("revision_ingreso");
            string id = GRevision.DataKeys[i].Values[1].ToString();

            antecendentes["nor"] = ((CheckBox)GRevision.Rows[i].Cells[1].FindControl("CNor")).Checked ? "1" : "";
            antecendentes["pat"] = ((CheckBox)GRevision.Rows[i].Cells[2].FindControl("CPat")).Checked ? "1" : "";

            if (id.Length > 0)
            {
                id = antecendentes.GetUpdate("id='" + id + "'");
            }
            else
            {
                antecendentes["ingreso_paciente"] = HIdIngreso.Value;
                antecendentes["motivo"] = GRevision.DataKeys[i].Values[0].ToString();
                id = antecendentes.GetInsert();
            }
            conector.QueryMod(id);
        }

         for (int i = 0; i < GExamenFisico.Rows.Count; i++)
        {

            Query antecendentes = new Query("examen_ingreso");
            string id = GExamenFisico.DataKeys[i].Values[1].ToString();

            antecendentes["nor"] = ((CheckBox)GExamenFisico.Rows[i].Cells[1].FindControl("CNor")).Checked ? "1" : "";
            antecendentes["pat"] = ((CheckBox)GExamenFisico.Rows[i].Cells[2].FindControl("CPat")).Checked ? "1" : "";

            if (id.Length > 0)
            {
                id = antecendentes.GetUpdate("id='" + id + "'");
            }
            else
            {
                antecendentes["ingreso_paciente"] = HIdIngreso.Value;
                antecendentes["motivo"] = GExamenFisico.DataKeys[i].Values[0].ToString();
                id = antecendentes.GetInsert();
            }
            conector.QueryMod(id);
        }

        for (int i = 0; i < RVarios.Items.Count; i++)
        {

            Query antecendentes = new Query("varios_ingreso");
            string id = ((HiddenField)RVarios.Items[i].FindControl("HIdVarios")).Value;

            antecendentes["estado"] = ((CheckBox)RVarios.Items[i].FindControl("CVarios")).Checked ? "1" : "";

            if (id.Length > 0)
            {
                id = antecendentes.GetUpdate("id='" + id + "'");
            }
            else
            {
                antecendentes["ingreso_paciente"] = HIdIngreso.Value;
                antecendentes["motivo"] = ((HiddenField)RVarios.Items[i].FindControl("HId")).Value;
                id = antecendentes.GetInsert();
            }
            conector.QueryMod(id);
        }

        Session["parametros"] = "?id=" + Request.QueryString["id"] + "&td=" + Request.QueryString["td"] + "&f=" + CConector.GetDate(DateTime.Now);
        ((MasterPageI)Master).SetResultado(mensaje);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
}
