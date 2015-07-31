using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using SDG.Componentes;

public partial class valoracion_trabajosocial : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            TFecha.Text = Query.GetFromMySQLDate(DateTime.Now, true);
            UCFuncionario.IdFuncionario = usuario["personal"];
            BAceptar.Enabled = usuario.CanInsert();
            UCFuncionario.ReadOnly = !usuario.CanAdmin();

            using (CConector conector = new CConector())
            {
                if (Request.QueryString["pid"] != null)
                {
                    CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                    if (CCDetallePaciente.IdPaciente.Length == 0)
                    {
                        Response.Redirect(Request.Url.AbsolutePath);
                    } else {
                        Query query = new Query("valoracion_trabajo_social");

                        CCDetallePaciente.Visible =
                        PDatos.Visible = true;

                        ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                        SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                        SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                        if (!string.IsNullOrEmpty(Request.QueryString["etsid"]))
                        {
                            query += "id";
                            query += "paciente";
                            query += "fecha";
                            query += "funcionario";
                            query += "tipologia";
                            query += "acontecimiento";
                            query += "afronta_dificultades";
                            query += "afronta_dificultades_descripcion";
                            query += "tenencia";
                            query += "tipo_vivienda";
                            query += "condiciones_vivienda";
                            query += "pisos_habita";
                            query += "piso";
                            query += "estructura";
                            query += "espacios";
                            query += "servicios";
                            query += "varios";
                            query += "aportantes";
                            query += "observaciones";
                            query += "diagnostico";
                            query += "conclusiones";

                            MySqlDataReader reader= conector.Query(query.GetSelect("id={0}", null, Query.GetValor(Request.QueryString["etsid"])));

                            if (reader != null && reader.Read())
                            {
                                if (reader["paciente"].ToString() != Request.QueryString["pid"])
                                    Response.Redirect(Request.Url.AbsolutePath + "?pid=" + reader["paciente"].ToString() + "&evtid=" + Request.QueryString["pid"]);

                                BAceptar.Enabled = usuario.CanUpdate();
                                // BEliminar.Visible = usuario.CanDelete();
                                ((MasterPageI)Master).SetModificacion(reader["id"].ToString());
                                ((MasterPageI)Master).Imprimir("trabajosocial.html");

                                HIdValoracion.Value = reader["id"].ToString();

                                CCDetallePaciente.IdPaciente = reader["paciente"].ToString();
                                TFecha.Text = Query.GetFromMySQLDate(reader["fecha"], true);
                                UCFuncionario.IdFuncionario = reader["funcionario"].ToString();
                                Utilidades.SelectInDropDown(DTipologiaF, reader["tipologia"]);
                                TAcontecimiento.Text = reader["acontecimiento"].ToString();
                                Utilidades.SelectInDropDown(DAfrontaD, reader["afronta_dificultades"]);
                                TAfrontaD.Text = reader["afronta_dificultades_descripcion"].ToString();
                                Utilidades.SelectInDropDown(DTenencia, reader["tenencia"]);
                                Utilidades.SelectInDropDown(DTipoVivienda, reader["tipo_vivienda"]);
                                Utilidades.SelectInDropDown(DCondicionesVivienda, reader["condiciones_vivienda"]);
                                TPisosHabita.Text = reader["pisos_habita"].ToString();
                                TAportantes.Text = reader["aportantes"].ToString();
                                TObservaciones.Text = reader["observaciones"].ToString();
                                TDiagnosticos.Text = reader["diagnostico"].ToString();
                                TConclusiones.Text = reader["conclusiones"].ToString();

                                string []valores= reader["piso"].ToString().Split(',');
                                CPiso.DataBind();
                                foreach(ListItem item in CPiso.Items) 
                                    item.Selected= valores.Contains(item.Value);
                                
                                valores= reader["estructura"].ToString().Split(',');
                                CEstructura.DataBind();
                                foreach(ListItem item in CEstructura.Items) 
                                    item.Selected= valores.Contains(item.Value);

                                valores= reader["servicios"].ToString().Split(',');
                                CServicios.DataBind();
                                foreach(ListItem item in CServicios.Items) 
                                    item.Selected= valores.Contains(item.Value);

                                valores = reader["varios"].ToString().Split(',');
                                CVarios.DataBind();
                                foreach (ListItem item in CVarios.Items)
                                    item.Selected = valores.Contains(item.Value);

                                decimal ingresos = 0, egresos = 0;
                                DIngresos.DataBind();
                                foreach (DataListItem item in DIngresos.Items)
                                {
                                    try { ingresos+= decimal.Parse(((TextBox)item.FindControl("T")).Text.Replace("$", ""), NumberStyles.Currency, CultureInfo.InvariantCulture); } catch { }
                                }

                                DEgresos.DataBind();
                                foreach (DataListItem item in DEgresos.Items)
                                {
                                    try
                                    {
                                        egresos += decimal.Parse(((TextBox)item.FindControl("T")).Text.Replace("$", ""), NumberStyles.Currency, CultureInfo.InvariantCulture);
                                    }
                                    catch { }
                                }

                                TIngresoTotal.Text = ingresos.ToString(CultureInfo.InvariantCulture);
                                TEgresos.Text = egresos.ToString(CultureInfo.InvariantCulture);
                                TBalance.Text = (ingresos - egresos).ToString(CultureInfo.InvariantCulture);
                            }
                        }

                        PEvoluciones.Visible = GridUtils.GetRowsCount(GEvoluciones, LEvoluciones, "Valoración", "Valoraciones") > 0;
                        /*if (string.IsNullOrEmpty(HIdValoracion.Value))
                        {
                            query = new Query("valoracion_trabajo_social");
                            query += "id";
                            HIdValoracion.Value = conector.QueryString(query.GetSelect("paciente={0}", null, Query.GetValor(CCDetallePaciente.IdPaciente)));
                            if (!string.IsNullOrEmpty(HIdValoracion.Value))
                                Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&etsid=" + HIdValoracion.Value);
                        }*/
                    }
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
            Query query = new Query("valoracion_trabajo_social");
            string id = HIdValoracion.Value;
            conector.StartTransaction();

            query["paciente"] = CCDetallePaciente.IdPaciente;
            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text, true);
            query["funcionario"] = UCFuncionario.IdFuncionario;
            query["tipologia"] = DTipologiaF.SelectedValue;
            query["acontecimiento"] = TAcontecimiento.Text;
            query["afronta_dificultades"] = DAfrontaD.SelectedValue;
            query["afronta_dificultades_descripcion"] = TAfrontaD.Text;
            query["tenencia"] = DTenencia.SelectedValue;
            query["tipo_vivienda"] = DTipoVivienda.SelectedValue;
            query["condiciones_vivienda"] = DCondicionesVivienda.SelectedValue;
            query["pisos_habita"] = TPisosHabita.Text;
            query["aportantes"] = TAportantes.Text;
            query["observaciones"] = TObservaciones.Text;
            query["diagnostico"] = TDiagnosticos.Text;
            query["conclusiones"] = TConclusiones.Text;

            string valores="";
            foreach(ListItem item in CPiso.Items)  {
                if(item.Selected) {
                    if(valores.Length>0)
                        valores+=",";
                    valores+= item.Value;
                }
            }
            query["piso"] = valores;

            valores="";
            foreach(ListItem item in CEstructura.Items)  {
                if(item.Selected) {
                    if(valores.Length>0)
                        valores+=",";
                    valores+= item.Value;
                }
            }
            query["estructura"] = valores;

            valores="";
            foreach(ListItem item in CServicios.Items)  {
                if(item.Selected) {
                    if(valores.Length>0)
                        valores+=",";
                    valores+= item.Value;
                }
            }
            query["servicios"] = valores;

            valores="";
            foreach(ListItem item in CVarios.Items)  {
                if(item.Selected) {
                    if(valores.Length>0)
                        valores+=",";
                    valores+= item.Value;
                }
            }
            query["varios"] = valores;

            valores = "";
            string cantidades = "";
            foreach (RepeaterItem item in REspacios.Items)
            {
                CheckBox check = (CheckBox)item.FindControl("C");
                if (check.Checked)
                {
                    HiddenField hId = (HiddenField)item.FindControl("H");
                    TextBox textBox = (TextBox)item.FindControl("T");
                    if (valores.Length > 0)
                    {
                        valores += ",";
                        cantidades += ",";
                    }
                    valores += hId.Value;
                    cantidades+=textBox.Text;
                }
            }
            
            query["espacios"] = valores;
            query["espacios_cantidad"] = cantidades;

            if (string.IsNullOrEmpty(id))
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
                id = res.ToString();
            } else {
                if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }
            if (conector.InsertModificacion(id) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }

            query = new Query("valoracion_trabajo_social_familia");

            if (conector.QueryMod(query.GetDelete("valoracion={0}", Query.GetValor(id))) == -1) {
                LMensaje.Text = conector.LastError;
                return;
            }
            query["valoracion"] = id;

            foreach (GridViewRow row in GEstructuraF.Rows) {
                
                query["numero"] = row.RowIndex;
                query["nombre"]=((TextBox) row.FindControl("N")).Text;
                query["edad"] = ((TextBox)row.FindControl("E")).Text;
                query["parentesco"] = ((TextBox)row.FindControl("P")).Text;
                query["ocupacion"] = ((TextBox)row.FindControl("O")).Text;
                query["escolaridad"] = ((TextBox)row.FindControl("S")).Text;

                if (string.IsNullOrEmpty((string)query["nombre"]) && string.IsNullOrEmpty((string)query["edad"]) && string.IsNullOrEmpty((string)query["parentesco"]) && string.IsNullOrEmpty((string)query["ocupacion"]) && string.IsNullOrEmpty((string)query["escolaridad"]))
                    continue;

                if (conector.QueryMod(query.GetInsert()) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }


            query = new Query("valoracion_trabajo_social_economia");

            if (conector.QueryMod(query.GetDelete("valoracion={0}", Query.GetValor(id))) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }
            query["valoracion"] = id;
            query["ingreso"] = "1";

            foreach (DataListItem item in DIngresos.Items) {
                try
                {
                    decimal valor= decimal.Parse(((TextBox)item.FindControl("T")).Text.Replace("$",""), NumberStyles.Currency, CultureInfo.InvariantCulture);
                    query["valor"] = valor;
                    query["tipo"]= DIngresos.DataKeys[item.ItemIndex].ToString();

                    if (conector.QueryMod(query.GetInsert()) == -1)
                    {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                } catch { }
            }

            query["ingreso"] = "";
            foreach (DataListItem item in DEgresos.Items)
            {
                try
                {
                    decimal valor = decimal.Parse(((TextBox)item.FindControl("T")).Text.Replace("$", ""), NumberStyles.Currency, CultureInfo.InvariantCulture);
                    query["valor"] = valor;
                    query["tipo"] = DEgresos.DataKeys[item.ItemIndex].ToString();

                    if (conector.QueryMod(query.GetInsert()) == -1)
                    {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                }
                catch { }
            }


            conector.Commit();

            ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
            ((MasterPageI)Master).SetResultado("Se ha editado una valoración a " + CCDetallePaciente.Nombres);
        }

    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    public void RenderCheckBoxList(StringBuilderEx contenido, CheckBoxList checkboxlist)
    {

        string texto = "";
        foreach (ListItem item in checkboxlist.Items)
        {
            if (item.Selected)
            {
                if (!string.IsNullOrEmpty(texto))
                    texto += ", ";
                texto += HttpUtility.HtmlEncode(item.Text);
            }
        }

        contenido = contenido.Replace("$" + checkboxlist.ID + "$", texto);
    }

    public void RenderDataList(StringBuilderEx contenido, DataList datalist) {

        string texto = "";

        foreach (DataListItem item in datalist.Items)
        {
            TextBox TValor = (TextBox)item.FindControl("T");
            if (TValor.Text.Length > 0)
            {
                Label etiqueta = (Label)item.FindControl("L");
                if (!string.IsNullOrEmpty(texto))
                    texto += ", ";
                texto += string.Format("<b>{0}</b>: {1}", HttpUtility.HtmlEncode(etiqueta.Text), HttpUtility.HtmlEncode(Convert.ToDecimal(TValor.Text.Replace("$", ""), CultureInfo.InvariantCulture).ToString("C0")));
            }
        }

        contenido = contenido.Replace("$" + datalist.ID + "$", texto);
    }

    public void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;

        using (CConector conector = new CConector())
        {
            Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
            evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
            evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);
            RenderCheckBoxList(evento.Contenido, CPiso);
            RenderCheckBoxList(evento.Contenido, CEstructura);
            RenderCheckBoxList(evento.Contenido, CVarios);
            RenderCheckBoxList(evento.Contenido, CServicios);
            RenderDataList(evento.Contenido, DIngresos);
            RenderDataList(evento.Contenido, DEgresos);
            TIngresoTotal.Text = Convert.ToDecimal(TIngresoTotal.Text.Replace("$", ""), CultureInfo.InvariantCulture).ToString("C0");
            TEgresos.Text = Convert.ToDecimal(TEgresos.Text.Replace("$", ""), CultureInfo.InvariantCulture).ToString("C0");
            TBalance.Text = Convert.ToDecimal(TBalance.Text.Replace("$", ""), CultureInfo.InvariantCulture).ToString("C0");


            string texto = "";

            REspacios.DataBind();
            foreach (RepeaterItem item in REspacios.Items)
            {
                CheckBox check = (CheckBox)item.FindControl("C");
                if (check.Checked)
                {
                    TextBox textBox = (TextBox)item.FindControl("T");
                    if (!string.IsNullOrEmpty(texto))
                        texto += ", ";
                    if (string.IsNullOrEmpty(textBox.Text))
                        texto += string.Format("{0}", HttpUtility.HtmlEncode(check.Text));
                    else texto += string.Format("{0}: {1}", HttpUtility.HtmlEncode(check.Text), HttpUtility.HtmlEncode(textBox.Text));
                }
            }

            evento.Contenido = evento.Contenido.Replace("$" + REspacios.ID + "$", texto);


            Query query = new Query("recurso_humano");

            query["szProfesional"] = "recurso_humano.perDocumento";
            query["szCargo"] = "cargo.carDescripcion";

            MySqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(UCFuncionario.IdFuncionario), " LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)"));
            if (reader != null)
            {
                bool l = reader.Read();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
                }
            }
            evento.Contenido = evento.Contenido.Replace("$szIdUsuario$", conector.QueryString("SELECT id FROM usuario WHERE personal=" + Query.GetValor(UCFuncionario.IdFuncionario)));
        }
    }
}