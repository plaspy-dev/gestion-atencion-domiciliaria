using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using SDG.Componentes;

public partial class valoracion_sicologia : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if(IsPostBack) SDG.Web.UI.CompressedPage.FixCheckBoxList(Request.Form, Controls);
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            TFecha.Text = Query.GetFromMySQLDate(DateTime.Now, true);
            UCFuncionario.IdFuncionario = usuario["personal"];
            BAceptar.Enabled = usuario.CanInsert();
            UCFuncionario.ReadOnly = !usuario.CanAdmin();

            using (CConector conector = new CConector())
            {
                Query query = new Query("valoracion_sicologia");

                if (Request.QueryString["pid"] != null)
                {
                    CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                    if (CCDetallePaciente.IdPaciente.Length == 0)
                    {
                        Response.Redirect(Request.Url.AbsolutePath);
                    }
                    else
                    {
                        CCDetallePaciente.Visible =
                        PDatos.Visible = true;

                        ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                        SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                        SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;


                        if (!string.IsNullOrEmpty(Request.QueryString["vsid"]))
                        {

                            query += "id";
                            query += "paciente";
                            query += "fecha";
                            query += "funcionario";
                            query += "enfermedadacual";
                            query += "revision_sistemas";
                            query += "examen_fisico";
                            query += "porte";
                            query += "actitud";
                            query += "actitudd";
                            query += "conciencia";
                            query += "orientacion";
                            query += "orientaciond";
                            query += "memoria";
                            query += "memoriad";
                            query += "atencion";
                            query += "pensamiento";
                            query += "pensamientod";
                            query += "curso";
                            query += "contenido";
                            query += "afecto";
                            query += "tono";
                            query += "sensopercepcion";
                            query += "sensopercepciond";
                            query += "conducta_motora";
                            query += "inteligencia";
                            query += "lenguaje_verbal";
                            query += "lenguaje_escrito";
                            query += "lenguaje_motriz";
                            query += "sueno";
                            query += "suenod";
                            query += "conducta_alimentaria";
                            query += "conducta_alimentariad";
                            query += "conducta_sexual";
                            query += "introspecion";
                            query += "prospeccion";
                            query += "juicio";
                            query += "paraclinicos";
                            query += "analisis";
                            query += "pronostico";


                            MySqlDataReader reader = conector.Query(query.GetSelect("id={0}", null, Query.GetValor(Request.QueryString["vsid"])));
                            if (reader != null && reader.Read())
                            {

                                if (reader["paciente"].ToString() != Request.QueryString["pid"])
                                    Response.Redirect(Request.Url.AbsolutePath + "?pid=" + reader["paciente"].ToString() + "&evtid=" + Request.QueryString["pid"]);

                                BAceptar.Enabled = usuario.CanUpdate();
                                // BEliminar.Visible = usuario.CanDelete();
                                ((MasterPageI)Master).SetModificacion(reader["id"].ToString());
                                ((MasterPageI)Master).Imprimir("sicologia.html");


                                HIdValoracion.Value = reader["id"].ToString();
                                CCDetallePaciente.IdPaciente = reader["paciente"].ToString();
                                TFecha.Text = Query.GetFromMySQLDate(reader["fecha"], true);
                                UCFuncionario.IdFuncionario = reader["funcionario"].ToString();

                                TEnfermedadActual.Text = reader["enfermedadacual"].ToString();
                                TRevisionSistemas.Text = reader["revision_sistemas"].ToString();
                                TExamenF.Text = reader["examen_fisico"].ToString();
                                DataBindCheckBoxList(CPorte, reader["porte"]);
                                DataBindCheckBoxList(CActitud, reader["actitud"]);
                                TActitud.Text = reader["actitudd"].ToString();
                                DataBindCheckBoxList(CConciencia, reader["conciencia"]);
                                DataBindCheckBoxList(COrientacion, reader["orientacion"]);
                                TOrientacion.Text = reader["orientaciond"].ToString();
                                DataBindCheckBoxList(CMemoria, reader["memoria"]);
                                TMemoria.Text = reader["memoriad"].ToString();
                                DataBindCheckBoxList(CAtencion, reader["atencion"]);
                                DataBindCheckBoxList(CPensamiento, reader["pensamiento"]);
                                TPensamiento.Text = reader["pensamientod"].ToString();
                                DataBindCheckBoxList(CCurso, reader["curso"]);
                                DataBindCheckBoxList(CContenido, reader["contenido"]);
                                DataBindCheckBoxList(CAfecto, reader["afecto"]);
                                DataBindCheckBoxList(CTono, reader["tono"]);
                                DataBindCheckBoxList(CSensopercepcion, reader["sensopercepcion"]);
                                TSensoPersepcion.Text = reader["sensopercepciond"].ToString();
                                DataBindCheckBoxList(CConductaMotora, reader["conducta_motora"]);
                                DataBindCheckBoxList(CInteligencia, reader["inteligencia"]);
                                DataBindCheckBoxList(CLenguajeVerbal, reader["lenguaje_verbal"]);
                                DataBindCheckBoxList(CLenguajeEscrito, reader["lenguaje_escrito"]);
                                DataBindCheckBoxList(CLenguajeMimico, reader["lenguaje_motriz"]);
                                DataBindCheckBoxList(CSueno, reader["sueno"]);
                                TSueno.Text = reader["suenod"].ToString();
                                DataBindCheckBoxList(CConductaAlimentaria, reader["conducta_alimentaria"]);
                                TConductaAlimentaria.Text = reader["conducta_alimentariad"].ToString();
                                DataBindCheckBoxList(CConductaSexual, reader["conducta_sexual"]);
                                DataBindCheckBoxList(CIntrospeccion, reader["introspecion"]);
                                DataBindCheckBoxList(CProspeccion, reader["prospeccion"]);
                                DataBindCheckBoxList(CJuicio, reader["juicio"]);
                                TParaclinicos.Text = reader["paraclinicos"].ToString();
                                TAnalisis.Text = reader["analisis"].ToString();
                                TPronostico.Text = reader["pronostico"].ToString();

                            }
                        }
                        PEvoluciones.Visible = GridUtils.GetRowsCount(GEvoluciones, LEvoluciones, "Valoración", "Valoraciones") > 0;
                        /*if (string.IsNullOrEmpty(HIdValoracion.Value))
                        {
                            query = new Query("valoracion_sicologia");
                            query += "id";
                            HIdValoracion.Value = conector.QueryString(query.GetSelect("paciente={0}", null, Query.GetValor(CCDetallePaciente.IdPaciente)));
                            if (!string.IsNullOrEmpty(HIdValoracion.Value))
                                Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&vsid=" + HIdValoracion.Value);
                        }*/
                    }
                }
            }
        }
    }

    public void DataBindCheckBoxList(CheckBoxList checkboxlist, object valor) {

        string[] valores = valor.ToString().Split(',');
        checkboxlist.DataBind();
        foreach (ListItem item in checkboxlist.Items)
            item.Selected = valores.Contains(item.Value);
    }

    public string GetCheckBoxValues(CheckBoxList checkboxlist) {
        string valores = "";
        foreach (ListItem item in checkboxlist.Items)
        {
            if (item.Selected)
            {
                if (valores.Length > 0)
                    valores += ",";
                valores += item.Value;
            }
        }
        return valores;
    }

    public bool InsertRepeater(Conector conector, Repeater repeater, string valoracion, int grupo, string paciente=null)
    {

        Query query = new Query("valoracion_sicologia_varios");

        if (conector.QueryMod(query.GetDelete("valoracion={0} AND grupo={1}", Query.GetValor(valoracion), grupo)) == -1)
            return false;

        query["valoracion"] = valoracion;
        query["grupo"] = grupo.ToString();

        foreach (RepeaterItem item in repeater.Items)
        {
            TextBox TValor = (TextBox)item.FindControl("T");
            if (TValor.Text.Length > 0)
            {
                HiddenField hId = (HiddenField)item.FindControl("H");
                query["tipo"] = hId.Value;
                query["texto"] = TValor.Text;

                CheckBox check = (CheckBox)item.FindControl("C");
                if (check != null)
                    query["estado"] = check.Checked ? "1" : "";

                if (!(string.IsNullOrEmpty(paciente) || Paciente.SaveAntecedente(conector, paciente, hId.Value, check.Checked ? "1" : "", TValor.Text)) 
                    || conector.QueryMod(query.GetInsert()) == -1)
                    return false;
            }
        }
        return true;
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        using (CConector conector = new CConector())
        {
            Query query = new Query("valoracion_sicologia");
            string id = HIdValoracion.Value;
            conector.StartTransaction();

            query["paciente"] = CCDetallePaciente.IdPaciente;
            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text, true);
            query["funcionario"] = UCFuncionario.IdFuncionario;
            query["enfermedadacual"] = TEnfermedadActual.Text;
            query["revision_sistemas"] = TRevisionSistemas.Text;
            query["examen_fisico"] = TExamenF.Text;
            query["porte"] = GetCheckBoxValues(CPorte);
            query["actitud"] = GetCheckBoxValues(CActitud);
            query["actitudd"] = TActitud.Text;
            query["conciencia"] = GetCheckBoxValues(CConciencia);
            query["orientacion"] = GetCheckBoxValues(COrientacion);
            query["orientaciond"] = TOrientacion.Text;
            query["memoria"] = GetCheckBoxValues(CMemoria);
            query["memoriad"] = TMemoria.Text;
            query["atencion"] = GetCheckBoxValues(CAtencion);
            query["pensamiento"] = GetCheckBoxValues(CPensamiento);
            query["pensamientod"] = TPensamiento.Text;
            query["curso"] = GetCheckBoxValues(CCurso);
            query["contenido"] = GetCheckBoxValues(CContenido);
            query["afecto"] = GetCheckBoxValues(CAfecto);
            query["tono"] = GetCheckBoxValues(CTono);
            query["sensopercepcion"] = GetCheckBoxValues(CSensopercepcion);
            query["sensopercepciond"] = TSensoPersepcion.Text;
            query["conducta_motora"] = GetCheckBoxValues(CConductaMotora);
            query["inteligencia"] = GetCheckBoxValues(CInteligencia);
            query["lenguaje_verbal"] = GetCheckBoxValues(CLenguajeVerbal);
            query["lenguaje_escrito"] = GetCheckBoxValues(CLenguajeEscrito);
            query["lenguaje_motriz"] = GetCheckBoxValues(CLenguajeMimico);
            query["sueno"] = GetCheckBoxValues(CSueno);
            query["suenod"] = TSueno.Text;
            query["conducta_alimentaria"] = GetCheckBoxValues(CConductaAlimentaria);
            query["conducta_alimentariad"] = TConductaAlimentaria.Text;
            query["conducta_sexual"] = GetCheckBoxValues(CConductaSexual);
            query["introspecion"] = GetCheckBoxValues(CIntrospeccion);
            query["prospeccion"] = GetCheckBoxValues(CProspeccion);
            query["juicio"] = GetCheckBoxValues(CJuicio);
            query["paraclinicos"] = TParaclinicos.Text;
            query["analisis"] = TAnalisis.Text;
            query["pronostico"] = TPronostico.Text;

            if (string.IsNullOrEmpty(id))
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
                id = res.ToString();
            }
            else
            {
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

            if (!InsertRepeater(conector, RMotivoC, id, 109))
            {
                LMensaje.Text = conector.LastError;
                return;
            }
            if (!InsertRepeater(conector, RMotivoT, id, 110))
            {
                LMensaje.Text = conector.LastError;
                return;
            }
            if (!InsertRepeater(conector, RAntecedentes, id, 2, CCDetallePaciente.IdPaciente))
            {
                LMensaje.Text = conector.LastError;
                return;
            }
            if (!InsertRepeater(conector, RPerfil, id, 112))
            {
                LMensaje.Text = conector.LastError;
                return;
            }
            if (!InsertRepeater(conector, RImpresionD, id, 136))
            {
                LMensaje.Text = conector.LastError;
                return;
            }
            if (!InsertRepeater(conector, RPlanTratamiento, id, 137))
            {
                LMensaje.Text = conector.LastError;
                return;
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

    public void RenderRepeater(StringBuilderEx contenido, Repeater repeater)
    {
        string texto = "";

        repeater.DataBind();
        foreach (RepeaterItem item in repeater.Items)
        {
            TextBox TValor = (TextBox)item.FindControl("T");
            if (TValor.Text.Length > 0)
            {
                string label = "";
                Label etiqueta = (Label)item.FindControl("L");
                if (etiqueta == null)
                {
                    CheckBox checkBox = (CheckBox)item.FindControl("C");
                    label = checkBox.Text;
                } else label = etiqueta.Text;

                if (!string.IsNullOrEmpty(texto))
                    texto += ", ";
                texto += string.Format("<b>{0}</b>: {1}", HttpUtility.HtmlEncode(label), HttpUtility.HtmlEncode(TValor.Text));
            }
        }

        contenido = contenido.Replace("$" + repeater.ID + "$", texto);
    }

    public void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;

        using (CConector conector = new CConector())
        {
            RenderCheckBoxList(evento.Contenido, CPorte);
            RenderCheckBoxList(evento.Contenido, CActitud);
            RenderCheckBoxList(evento.Contenido, CConciencia);
            RenderCheckBoxList(evento.Contenido, COrientacion);
            RenderCheckBoxList(evento.Contenido, CMemoria);
            RenderCheckBoxList(evento.Contenido, CAtencion);
            RenderCheckBoxList(evento.Contenido, CPensamiento);
            RenderCheckBoxList(evento.Contenido, CCurso);
            RenderCheckBoxList(evento.Contenido, CContenido);
            RenderCheckBoxList(evento.Contenido, CAfecto);
            RenderCheckBoxList(evento.Contenido, CTono);
            RenderCheckBoxList(evento.Contenido, CSensopercepcion);
            RenderCheckBoxList(evento.Contenido, CConductaMotora);
            RenderCheckBoxList(evento.Contenido, CInteligencia);
            RenderCheckBoxList(evento.Contenido, CLenguajeVerbal);
            RenderCheckBoxList(evento.Contenido, CLenguajeEscrito);
            RenderCheckBoxList(evento.Contenido, CLenguajeMimico);
            RenderCheckBoxList(evento.Contenido, CSueno);
            RenderCheckBoxList(evento.Contenido, CConductaAlimentaria);
            RenderCheckBoxList(evento.Contenido, CConductaSexual);
            RenderCheckBoxList(evento.Contenido, CIntrospeccion);
            RenderCheckBoxList(evento.Contenido, CProspeccion);
            RenderCheckBoxList(evento.Contenido, CJuicio);

            RenderRepeater(evento.Contenido, RMotivoC);
            RenderRepeater(evento.Contenido, RMotivoT);
            RenderRepeater(evento.Contenido, RAntecedentes);
            RenderRepeater(evento.Contenido, RPerfil);
            RenderRepeater(evento.Contenido, RImpresionD);
            RenderRepeater(evento.Contenido, RPlanTratamiento);


            Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
            evento.Contenido = evento.Contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
            evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);

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
            evento.Contenido = evento.Contenido.Replace("$szIdUsuario$", UCFuncionario.IdFuncionario);
        }
    }
}