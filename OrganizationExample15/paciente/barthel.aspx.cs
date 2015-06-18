using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.IO;
using SDG.Componentes;
using SDG.Web.UI.WebControls;

public partial class paciente_barthel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack)
        {
            foreach (Calificacion.Escalas info in (Calificacion.Escalas[])Enum.GetValues(typeof(Calificacion.Escalas)))
            {
                DIndice.Items.Add(new ListItem(Calificacion.GetNombreEscala(info), ((int)info).ToString()));
            }

            CUsuario usuario = (CUsuario) Usuario.GetUsuario();

            if (!string.IsNullOrEmpty(Request.QueryString["ioe"]))
                Utilidades.SelectInDropDown(DIndice, Request.QueryString["ioe"]);
            DIndice_SelectedIndexChanged(sender, e);

            BAceptar.Enabled = false;
            PHistorial.Visible = false;

            using (CConector conector = new CConector())
            {

                if (Request.QueryString["pid"] != null)
                {
                    CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                    if (CCDetallePaciente.IdPaciente.Length == 0)
                    {
                        Response.Redirect(Request.Url.AbsolutePath);
                    }
                    else
                    {
                        ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);

                        SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                        SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                        PDatos.Visible = true;

                        
                        TFuncionario.Enabled = usuario.CanAdmin();
                        if (!usuario.CanAdmin())
                        {
                            if (usuario["personal"].Length == 0)
                                BAceptar.Enabled = false;
                            else
                            {
                                TIdFuncionario.Text = usuario["personal"];
                                TFuncionario.Text = conector.QueryString("SELECT perNombre FROM recurso_humano WHERE perId='" + TIdFuncionario.Text + "'");
                            }
                        }

                        TFecha.Focus();
                        BAceptar.Enabled = usuario.CanInsert();
                        if (!string.IsNullOrEmpty(Request.QueryString["f"]))
                            TFecha.Text = Query.GetFromMySQLDate(Query.GetFromMySQLDate(Request.QueryString["f"]), true);
                        else TFecha.Text = Query.GetFromMySQLDate(DateTime.Now, true);

                        if (!string.IsNullOrEmpty(Request.QueryString["bid"]))
                        {
                            Query indice = new Query("indice_barthel");

                            indice += "id";
                            indice += "fecha";
                            indice += "medico";
                            indice += "tipo";

                            MySqlDataReader readermysql = conector.Query(indice.GetSelect("paciente=" + CCDetallePaciente.IdPaciente + " AND id=" + Query.GetValor(Request.QueryString["bid"])));
                            if (readermysql != null && readermysql.Read())
                            {
                                ((MasterPageI)Master).Imprimir("barthel.html");
                                BAceptar.Enabled = usuario.CanUpdate();

                                HIdIndice.Value = readermysql["id"].ToString();
                                TFecha.Text = Query.GetFromMySQLDate(readermysql["fecha"], true);
                                Utilidades.SelectInDropDown(DIndice, readermysql["tipo"]);
                                DIndice_SelectedIndexChanged(sender, e);

                                TIdFuncionario.Text = readermysql["medico"].ToString();
                                TFuncionario.Text = conector.QueryString("SELECT perNombre FROM recurso_humano WHERE perId='" + TIdFuncionario.Text + "'");

                                TTotal.Text = conector.QueryString("SELECT SUM(varios.descripcion) FROM analisis_barthel LEFT JOIN varios ON (varios.id=analisis_barthel.resultado) WHERE analisis_barthel.indice_barthel='" + HIdIndice.Value + "'");
                                try
                                {
                                    LResultado.Text = Calificacion.GetDescripcion(Convert.ToInt32(TTotal.Text), DIndice.SelectedValue);
                                }
                                catch { }

                                ((MasterPageI)Master).SetModificacion(HIdIndice.Value);
                            }
                        }
                        GHistorial.DataBind();
                        LHistorial.Text = GHistorial.Rows.Count + " Índice";
                        LHistorial.Text += GHistorial.Rows.Count == 1 ? "" : "s";
                        PHistorial.Visible = GHistorial.Rows.Count > 0;
                    }
                }
            }
        }
    }
    
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query indice = new Query("indice_barthel");
        using (CConector conector = new CConector())
        {

            indice["fecha"] = Query.GetMySQLDateFormat(TFecha.Text, true);
            indice["medico"] = TIdFuncionario.Text;
            indice["tipo"] = DIndice.SelectedValue;

            string szQuery;
            string mensaje;

            if (HIdIndice.Value.Length == 0)
            {
                indice["paciente"] = CCDetallePaciente.IdPaciente;

                szQuery = indice.GetInsert();
                mensaje = CCDetallePaciente.Nombres + " ingresado";
                int resultado = conector.QueryMod(szQuery, true);
                if (resultado == -1)
                    return;
                HIdIndice.Value = resultado.ToString();
            }
            else
            {
                szQuery = indice.GetUpdate("id='" + HIdIndice.Value + "'");
                mensaje = CCDetallePaciente.Nombres + " editado";
                if (conector.QueryMod(szQuery) == -1)
                    return;
            }
            if (conector.InsertModificacion(HIdIndice.Value) == -1)
                return;

            for (int i = 0; i < RGrupos.Items.Count; i++)
            {
                Query analisis = new Query("analisis_barthel");

                RadioButtonList lista = (RadioButtonList)RGrupos.Items[i].FindControl("RConceptos");
                HiddenField grupo = (HiddenField)RGrupos.Items[i].FindControl("HIdGrupo");
                HiddenField idanalisis = (HiddenField)RGrupos.Items[i].FindControl("HIdAnalisis");

                analisis["grupo"] = grupo.Value;

                string valor = lista.SelectedValue;
                valor = valor.Substring(valor.IndexOf("#", 0) + 1);

                analisis["resultado"] = valor;

                if (idanalisis.Value.Length > 0)
                {
                    conector.QueryMod(analisis.GetUpdate("id='" + idanalisis.Value.ToString() + "'"));
                }
                else
                {
                    analisis["indice_barthel"] = HIdIndice.Value.ToString();
                    conector.QueryMod(analisis.GetInsert());
                }
            }

            if (Usuario.GetUsuario().GetForceURL().Length != 0)
            {
                bool found = false;
                Calificacion.Escalas? proximaescala = null;
                foreach (Calificacion.Escalas escala in (Calificacion.Escalas[])Enum.GetValues(typeof(Calificacion.Escalas)))
                {
                    if (DIndice.SelectedValue == ((int)escala).ToString()) // actualmente esta en esta
                    {
                        found = true;
                        continue;
                    }
                    if (found)
                    {
                        proximaescala = escala;
                        break;
                    }
                }
                if(proximaescala!=null)
                    Usuario.GetUsuario().SetForceURL("~/paciente/barthel.aspx?pid=" + CCDetallePaciente.IdPaciente + "&f=" + HttpUtility.UrlEncode(Query.GetMySQLDateFormat(TFecha.Text, true)) + "&ioe=" + ((int)proximaescala.Value).ToString(), conector);
                else Usuario.GetUsuario().SetForceURL("", conector);
            }

            ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
            ((MasterPageI)Master).SetResultado(mensaje);
        }
    }
    protected void RGrupos_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemIndex != -1)
        {
            RadioButtonList lista = (RadioButtonList)e.Item.FindControl("RConceptos");
            HiddenField idanalisis = (HiddenField)e.Item.FindControl("HIdAnalisis");
            HiddenField resultado = (HiddenField)e.Item.FindControl("HIdResultado");

            for (int i = 0; i < lista.Items.Count; i++)
            {
                string valor = lista.Items[i].Value;
                valor = valor.Substring(valor.IndexOf("#", 0) + 1);
                if(valor == resultado.Value) {
                    lista.Items[i].Selected = true;
                    break;
                }
            }
        }
    }
    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&bid=" + ((ImageButton)sender).CommandArgument);
    }

    protected void GHistorial_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            int descripcion = GHistorial.GetGridColumnIndex("Descripción");
            int calificacion = GHistorial.GetGridColumnIndex("Puntuación");
            try
            {
                e.Row.Cells[descripcion].Text = Calificacion.GetDescripcion(Convert.ToInt32(e.Row.Cells[calificacion].Text), e.Row.Cells[descripcion].Text);
            } catch { }
        }
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;

        string repeater = "<table width=100% border=1 cellspacing=0>";
        RGrupos.DataBind();

        for (int i = 0; i < RGrupos.Items.Count; i++)
        {
            repeater+="<tr><td><b>" + 
                        ((Label)RGrupos.Items[i].FindControl("LN")).Text +
                        "</b></td>";

            RadioButtonList lista = (RadioButtonList)RGrupos.Items[i].FindControl("RConceptos");
            repeater += "<td>";
            for (int j = 0; j < lista.Items.Count; j++) {
                if (j > 0)
                    repeater += "<br/>";
                if (lista.Items[j].Selected)
                    repeater += "<b>";
                repeater += lista.Items[j].Text;
                if (lista.Items[j].Selected)
                    repeater += "</b>";
            }
            repeater += "</td></tr>";
        }
        repeater += "</table>";
        evento.Contenido = evento.Contenido.Replace("$GDetalle$", repeater);

        Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
        evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
        evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

        Query query = new Query("paciente");

        query["szMedico"] = "recurso_humano.perDocumento";
        query["szProfesional"] = "recurso_humano.perDocumento";
        query["szCargo"] = "cargo.carDescripcion";
        query["perId"] = "recurso_humano.perId";

        string idmedico = "";
        using (CConector conector = new CConector())
        {
            MySqlDataReader reader = conector.Query(query.GetSelect("pacId=" + CCDetallePaciente.IdPaciente
                 , "LEFT JOIN recurso_humano ON (recurso_humano.perId=paciente.megId)"
                 + " LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)"
                 ));
            if (reader != null)
            {
                bool l = reader.Read();
                if(l)
                    idmedico = reader["perId"].ToString();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
                }
            }
        }

        using (CConector conector = new CConector())
        {
            evento.Contenido = evento.Contenido.Replace("$szIdUsuario$", conector.QueryString("SELECT id FROM usuario WHERE personal=" + Query.GetValor(idmedico)));
        }
    }

    protected void DIndice_SelectedIndexChanged(object sender, EventArgs e)
    {
        LIncapacidad.Text = Calificacion.GetMensajeDescripcion(DIndice.SelectedValue);
        ScriptManager.RegisterClientScriptBlock(LIncapacidad, typeof(string), "escala", Calificacion.GetArrayMessages(DIndice.SelectedValue), true);
    }
}
