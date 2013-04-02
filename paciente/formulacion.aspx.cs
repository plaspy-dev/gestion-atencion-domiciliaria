using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data.SqlClient;
using System.Text;
using System.IO;
using SDG.Componentes;
using System.Collections.Specialized;

public partial class paciente_formulacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);

        if (!IsPostBack)
        {
            // SeleccionarPaciente.Inactivos = false;
            BAceptar.Enabled = false;
            BMasFormulacion.Enabled=false;
            BFecha.Enabled = false;
            BFormula.Visible = false;
            PFormulaciones.Visible = false;

            CUsuario usuario = (CUsuario) Usuario.GetUsuario();
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

                    BAceptar.Enabled = usuario.CanInsert();
                    BMasFormulacion.Enabled= usuario.CanInsert();
                    TFecha.Focus();
                    BFecha.Enabled = true;

                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                    PDatos.Visible = true;

                    CConectorMS conector = CConectorMS.GetConector();
                    CConector conectormy = CConector.GetConector();

                    TFecha.Text = Request.QueryString["f"];
                    if (TFecha.Text.Length == 0)
                        TFecha.Text = DateTime.Now.ToShortDateString();
                    
                    DTipo.DataBind();
                    if (DTipo.Items.FindByValue(Request.QueryString["tf"]) != null)
                        DTipo.SelectedValue = Request.QueryString["tf"];

                    if (DTipo.SelectedIndex != -1)
                    {
                        string singular = DTipo.SelectedItem.Text.ToLower();
                        if (singular[singular.Length - 1] == 's')
                        {
                            singular = DTipo.SelectedItem.Text.Substring(0, DTipo.SelectedItem.Text.Length - 1);
                        }
                        else singular = DTipo.SelectedItem.Text;
                        CConector conectormysql = new CConector();
                        GFormulacion.Columns[5].HeaderText = LPosologia.Text = conectormysql.QueryString("SELECT descripcion FROM varios WHERE id=" + DTipo.SelectedValue);
                        if (LPosologia.Text.ToLower() != "posología") {
                            GFormulacion.Columns[6].Visible = false;
                            GFormulacion.Columns[7].Visible = false;
                            trPosologia.Visible = false;
                        }
                        LFormulacion.Text = DTipo.SelectedItem.Text;
                        LMedicamento.Text = singular;
                        GFormulacion.Columns[3].HeaderText = singular;
                    }

                    Query formulacion = new Query("formulacion");

                    formulacion += "id";
                    formulacion += "fecha";
                    formulacion += "codigo";
                    formulacion += "profesional";

                    MySqlDataReader readermysql = conectormy.Query(formulacion.GetSelect("paciente=" + CCDetallePaciente.IdPaciente + " AND fecha='" + Conector.GetDate(Convert.ToDateTime(TFecha.Text)) + "' AND tipo='" + DTipo.SelectedValue + "'"));
                    if (readermysql != null && readermysql.Read())
                    {
                        string ruta = string.Format("formulacion{0}.html", CCDetallePaciente.AsegurdadorID);
                        ((MasterPageI)Master).Imprimir(File.Exists(Server.MapPath(ruta)) ? ruta : "formulacion.html");

                        BAceptar.Enabled = usuario.CanUpdate();
                        BMasFormulacion.Enabled= usuario.CanInsert();

                        GFormulacion.Columns[0].Visible = usuario.CanUpdate();
                        GFormulacion.Columns[1].Visible = usuario.CanDelete();

                        HIdFormulacion.Value = readermysql["id"].ToString();
                        TFecha.Text = ((DateTime)readermysql["fecha"]).ToShortDateString();
                        ViewState["profesional"] = readermysql["profesional"].ToString();

                        ((MasterPageI)Master).SetModificacion(HIdFormulacion.Value);
                    } else {

                        BFormula.Visible= conectormy.QueryString("SELECT id FROM formulacion WHERE paciente=" + CCDetallePaciente.IdPaciente + " AND tipo='" + DTipo.SelectedValue + "' LIMIT 1;").Length!=0;
                    }

                    GFormulaciones.DataBind();
                    LFormulaciones.Text = GFormulaciones.Rows.Count + " Orden";
                    LFormulaciones.Text += GFormulaciones.Rows.Count == 1 ? "" : "es";
                    LFormulaciones.Text += " médica";
                    LFormulaciones.Text += GFormulaciones.Rows.Count == 1 ? "" : "s";
                    PFormulaciones.Visible = GFormulaciones.Rows.Count > 0;
                }
            }
        }
    }
    
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    private bool OnDataSourceOperationComplete(int count, Exception e)
    {
        if (e != null)
        {
            throw e;
        }
        return false;
    }

    protected void BMasFormulacion_Click(object sender, EventArgs e)
    {
        Page.Validate("medicamento");
        if (!RMedicamento.IsValid || !RCantidad.IsValid)
            return;

        if (!Usuario.GetUsuario().CanAdmin())
        {
            // verificamos que la cantidad no exeda lo permitido por el servicio
            int maximo = Procedimientos.GetMaxServicios(TMedicamentoID.Text, CCDetallePaciente.AsegurdadorID);
            int cantidadactual = Convert.ToInt32(TCantidad.Text);
            if (maximo > 0) // esta restringido
            {
                int nuevacantidad = cantidadactual;
                // esto se guarda linea por linea en la base de datos no hay necesidad de sumar
                /*for (int i = 0; i < GFormulacion.Rows.Count; i++)
                {
                    if (HttpUtility.HtmlDecode(GFormulacion.Rows[i].Cells[2].Text).Trim() == TMedicamentoID.Text)
                        nuevacantidad += Convert.ToInt32(HttpUtility.HtmlDecode(GFormulacion.Rows[i].Cells[4].Text).Trim());
                }*/

                if (maximo < nuevacantidad)
                {  // excede el maximo permitido
                    LMensajeMedicamento.Text = "Excede la cantidad máxima por servicio permitida (" + maximo.ToString() + ")";
                    TMedicamento.Focus();
                    return;
                }

                // verificamos el acumulado de servicios formulados
                string formuladaanterior= new CConector().QueryString("SELECT SUM(medicamento_formulacion.formulada) FROM formulacion LEFT JOIN medicamento_formulacion ON (medicamento_formulacion.formulacion=formulacion.id) WHERE formulacion.paciente=" + CCDetallePaciente.AsegurdadorID + " AND medicamento_formulacion.medicamento=" + Query.GetValor(TMedicamentoID.Text) + " AND fecha>DATE_ADD(DATE(SYSDATE()), INTERVAL -30 DAY);");
                if (formuladaanterior.Length != 0)
                    nuevacantidad += Convert.ToInt32(formuladaanterior);
                if (maximo < nuevacantidad)
                {  // excede el maximo permitido
                    LMensajeMedicamento.Text = "Excede la cantidad máxima por servicio mensual permitida (" + maximo.ToString() + ")";
                    TMedicamento.Focus();
                    return;
                }
            }

            // verificamos el valor maximo por paciente
            double costoprocedimiento = Procedimientos.GetCosto(TMedicamentoID.Text, CCDetallePaciente.AsegurdadorID);
            if ((CCDetallePaciente.TopePaciente > 0 || CCDetallePaciente.TopeAsegurador > 0) && costoprocedimiento > 0) // el tratamiento tiene costo
            {
                double total = cantidadactual * costoprocedimiento; // este es el actual
                // esto se guarda linea por linea en la base de datos no hay necesidad de sumar
                /*for (int i = 0; i < GFormulacion.Rows.Count; i++)
                {
                    total += Convert.ToInt32(HttpUtility.HtmlDecode(GFormulacion.Rows[i].Cells[4].Text).Trim()) *
                        Procedimientos.GetCosto(HttpUtility.HtmlDecode(GFormulacion.Rows[i].Cells[2].Text).Trim(), CCDetallePaciente.AsegurdadorID);
                }*/
                // verificamos el tope del paciente
                if (total > CCDetallePaciente.TopePaciente)
                {
                    LMensajeMedicamento.Text = "Excede el tope de presupuesto del paciente";
                    TMedicamento.Focus();
                    return;
                }
                total += CCDetallePaciente.GetCostoPacienteActual;
                if (total > CCDetallePaciente.TopePaciente)
                {
                    LMensajeMedicamento.Text = "Excede el tope de presupuesto mensual del paciente";
                    TMedicamento.Focus();
                    return;
                }
                // verificamos el tope del asegurador
                if (total > CCDetallePaciente.TopeAsegurador)
                {
                    LMensajeMedicamento.Text = "Excede el tope de presupuesto mensual de la aseguradora";
                    TMedicamento.Focus();
                    return;
                }
                // verificamos que el tope de todos los servicios del asegurador
                total -= CCDetallePaciente.GetCostoPacienteActual;
                total += CCDetallePaciente.GetCostoAseguradoraActual;
                
                // verificamos el tope del asegurador
                if (total > CCDetallePaciente.TopeAsegurador)
                {
                    LMensajeMedicamento.Text = "Los servicios exceden el tope de presupuesto mensual de la aseguradora";
                    TMedicamento.Focus();
                    return;
                }
            }
        }

        IOrderedDictionary data = new OrderedDictionary();
        data.Add("medicamento", TMedicamento.Text);
        data.Add("formulada", TCantidad.Text);
        data.Add("posologia", TPosologia.Text);
        data.Add("medicamen_id", TMedicamentoID.Text);
        data.Add("via", TVia.Text);
        data.Add("tiempo", TTiempo.Text);
        data.Add("costo", Procedimientos.GetCosto(TMedicamentoID.Text, CCDetallePaciente.AsegurdadorID));

        if (GFormulacion.SelectedIndex == -1)
        {
            SFormulacion.GetView().Insert(data, OnDataSourceOperationComplete);
        } 
        else
        {
            data.Add("id", GFormulacion.DataKeys[GFormulacion.SelectedIndex].Value);

            IOrderedDictionary dataold = new OrderedDictionary();
            dataold.Add("medicamento", HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[3].Text).Trim());
            dataold.Add("formulada", HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[4].Text).Trim());
            dataold.Add("posologia", HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[5].Text).Trim());
            dataold.Add("medicamen_id", HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[2].Text).Trim());
            dataold.Add("tiempo", HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[6].Text).Trim());
            dataold.Add("via", HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[7].Text).Trim());
            dataold.Add("id", GFormulacion.DataKeys[GFormulacion.SelectedIndex].Value);

            SFormulacion.GetView().Update(data, data, dataold,OnDataSourceOperationComplete);
        }
        GFormulacion.SelectedIndex = -1;
        GFormulacion.DataBind();

        TMedicamentoID.Text = TMedicamento.Text = TPosologia.Text = TCantidad.Text = "";
        TTiempo.Text = TVia.Text = "";
        CCDetallePaciente.GetCostoPacienteActual = 0;
        CCDetallePaciente.GetCostoAseguradoraActual = 0;
        BAceptar_Click(sender, e);
        // Response.Redirect(Request.Url.ToString());
    }

    protected void BFecha_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&f=" + TFecha.Text + "&tf=" + DTipo.SelectedValue);
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
            
        BMasFormulacion_Click(sender, e);

        if (!RMedicamento.IsValid || !RCantidad.IsValid)
        {
            if (TMedicamentoID.Text.Length != 0 || TCantidad.Text.Length != 0 || TPosologia.Text.Length != 0)
                return;
        }

        Query formulacion = new Query("formulacion");
        CConector conector = CConector.GetConector();

        formulacion["fecha"]= CConector.GetDate(Convert.ToDateTime( TFecha.Text));
        formulacion["tipo"] = DTipo.SelectedValue;
        formulacion["profesional"] = CUsuario.GetUsuario()["personal"];

        string szQuery;
        string mensaje;

        if (HIdFormulacion.Value.Length == 0)
        {
            formulacion["paciente"] = CCDetallePaciente.IdPaciente;

            szQuery = formulacion.GetInsert();
            mensaje = CCDetallePaciente.Nombres + " ingresado";
            int resultado = conector.QueryMod(szQuery, true);
            if (resultado == -1)
                return;
            HIdFormulacion.Value = resultado.ToString();
        }
        else
        {
            szQuery = formulacion.GetUpdate("id='" + HIdFormulacion.Value + "'");
            mensaje = CCDetallePaciente.Nombres + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;
        }
        if (conector.InsertModificacion(HIdFormulacion.Value) == -1)
            return;

        string []querys= SFormulacion.GetQuerys();
        if (querys != null)
        {
            for (int i = 0; i < querys.Length; i++)
            {
                szQuery = querys[i].Replace("@formulacion", Query.GetValor(HIdFormulacion.Value));
                if (conector.QueryMod(szQuery) == -1)
                    return;
            }
        }
        ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
        if(sender==BAceptar)
            ((MasterPageI)Master).SetResultado(mensaje);
    }

    protected void GFormulacion_SelectedIndexChanged(object sender, EventArgs e)
    {
        TMedicamentoID.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[2].Text).Trim();
        TMedicamento.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[3].Text).Trim();
        TCantidad.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[4].Text).Trim();
        TPosologia.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[5].Text).Trim();
        TTiempo.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[6].Text).Trim();
        TVia.Text = HttpUtility.HtmlDecode(GFormulacion.SelectedRow.Cells[7].Text).Trim();
    }

    protected string RenderPage(int inicio, int numero_medicamentos)
    {
        string resultado="";
        GFormulacion.DataBind();
        int i = inicio;

        for (; i < GFormulacion.Rows.Count && i < inicio + numero_medicamentos; i++)
        {

            resultado += "<tr><td>" + GFormulacion.Rows[i].Cells[3].Text + "</td>";
            resultado += "<td>" + NumerosALetras.ToLetras(Convert.ToInt32(GFormulacion.Rows[i].Cells[4].Text)).ToUpper() + " (" + GFormulacion.Rows[i].Cells[4].Text + ")</td>";
            resultado += "<td>" + GFormulacion.Rows[i].Cells[5].Text + "</td>";
            if(trPosologia.Visible) {
                resultado += "<td>" + GFormulacion.Rows[i].Cells[6].Text + "</td>";
                resultado += "<td>" + GFormulacion.Rows[i].Cells[7].Text + "</td>";
            }
            resultado += "</tr>";
        }
        for (; i < inicio + numero_medicamentos; i++)
        {
            resultado += "<tr><td>&nbsp;</td>";
            resultado += "<td>&nbsp;</td>";
            resultado += "<td>&nbsp;</td>";
            if (trPosologia.Visible)
            {
                resultado += "<td>&nbsp;</td>";
                resultado += "<td>&nbsp;</td>";
            }
            resultado += "</tr>";
        }
        return resultado;
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;

        evento.Contenido = evento.Contenido.Replace("$szUsuario$", Usuario.GetUsuario().GetNombre());
        evento.Contenido = evento.Contenido.Replace("$szMedicamento$", LMedicamento.Text);
        evento.Contenido = evento.Contenido.Replace("$szPosologia$", LPosologia.Text);
        
        string encabezado = "";
        if (trPosologia.Visible)
        {
            encabezado += "<td align='center'><strong>Tiempo</strong></td>";
            encabezado += "<td align='center'><strong>Vía</strong></td>";
        }
        evento.Contenido = evento.Contenido.Replace("$GFormulacionHeader$", encabezado);

        Query query = new Query("phdPaciente");

        query["categoria"] = "categoria";
        query["szGrado"] = "pacGrado";
        query["cCIE10"] = "cieCodDx";
        query["szTipoAfiliacion"] = "CASE pacTipoAfiliado WHEN 1 THEN 'Cotizante' WHEN 2 THEN 'Beneficiario' ELSE '' END";

        CConectorMS conectorms = new CConectorMS();

        SqlDataReader reader = conectorms.Query(query.GetSelect("pacId=" + CCDetallePaciente.IdPaciente));
        if (reader != null)
        {
            bool l = reader.Read();
            if (l)
            {
                evento.Contenido = evento.Contenido.Replace("$szCategoria$", new CConector().QueryString("SELECT nombre FROM varios WHERE id='" + reader["categoria"].ToString() + "' AND tipo=13"));
            }
            for (int i = 0; i < reader.FieldCount; i++)
            {
                evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
            }
            evento.Contenido = evento.Contenido.Replace("$szCIE10$", l ? Procedimientos.GetCodigoCIE(reader["cCIE10"].ToString(), conectorms) : "");
        }

        // obtenemos el ID del usuario que lo modifico primero
        string url = HttpContext.Current.Request.Url.AbsolutePath.Replace(HttpContext.Current.Request.ApplicationPath, "~");
        string idmedico = new CConector().QueryString("SELECT usuario.personal FROM modificaciones LEFT JOIN usuario ON (usuario.id=modificaciones.usuario) WHERE modificaciones.id='" + HIdFormulacion.Value + "' AND modificaciones.url='" + url + "' ORDER BY modificaciones.fecha LIMIT 1");

        query = new Query("admPersonalHS");

        query["szProfesional"] = "admPersonalHS.perDocumento";
        query["szMedico"] = "admPersonalHS.perNombre";

        reader = conectorms.Query(query.GetSelect("perId=" + Query.GetValor(idmedico)));
        if (reader != null)
        {
            bool l = reader.Read();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
            }
        }

        int numero_medicamentos = 5;
        if (CCDetallePaciente.AsegurdadorID == "36")
        { // disan
            numero_medicamentos = 3;
        }


        int paginas = (int)Math.Ceiling((double)GFormulacion.Rows.Count / numero_medicamentos);
        if(paginas>1) {
            int pos = evento.Contenido.IndexOf("<div");
            int posf = evento.Contenido.IndexOf("</div>");

            string contenidoreal = evento.Contenido.Substring(pos, posf - pos + 6);
            string contenido = "";

            for(int i=1; i<paginas; i++) {
                contenido += contenidoreal.Replace("$szFormulacion$", RenderPage(i * numero_medicamentos, numero_medicamentos))
                    .Replace("$szConsecutivo$", HIdFormulacion.Value + "-" + (i+1));
            }
            evento.Contenido= evento.Contenido.Insert(posf + 6, contenido);
        }
        // aqui modificamos la primera pagina.
        evento.Contenido = evento.Contenido.Replace("$szFormulacion$", RenderPage(0, numero_medicamentos))
            .Replace("$szConsecutivo$", HIdFormulacion.Value + "-1");
    }

    protected void BFormula_Click(object sender, EventArgs e)
    {
        CConector conector = new CConector();
        string id= conector.QueryString("SELECT id FROM formulacion WHERE paciente=" + CCDetallePaciente.IdPaciente + " AND tipo='" + DTipo.SelectedValue + "' ORDER BY fecha DESC LIMIT 1;");
        if(id.Length!=0) {

            MySqlDataReader reader= conector.Query("SELECT formulada,posologia,medicamento AS medicamentoid,CONCAT(medicamentos.nombre,' [',medicamentos.principio,'], ',medicamentos.concentracion,'-',medicamentos.forma) AS medicamento FROM medicamento_formulacion LEFT JOIN medicamentos ON (medicamentos.id=medicamento_formulacion.medicamento) WHERE formulacion=" + id);
            if(reader!=null) {
                while(reader.Read()) {
                    
                    TMedicamento.Text= reader["medicamento"].ToString();
                    TCantidad.Text = reader["formulada"].ToString();
                    TPosologia.Text = reader["posologia"].ToString();
                    TMedicamentoID.Text = reader["medicamentoid"].ToString();

                    BMasFormulacion_Click(sender, e);
                }
            }
        }
    }

    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/paciente/formulacion.aspx?pid=" + CCDetallePaciente.IdPaciente + "&f=" + string.Format("{0:d}", Convert.ToDateTime(((ImageButton)sender).CommandArgument)) + "&tf=" + ((ImageButton)sender).CommandName);
    }
}

