using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data.SqlClient;
using System.Globalization;
using SDG.Componentes;
using SDG.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class paciente_formatoctc : System.Web.UI.Page
{
    [Serializable]
    public class Medicamento
    {
        public int IdGrid { get; set; }
        public string Id { get; set; }
        public string Nombre { get; set; }
        public double Cantidad { get; set; }
        public string Tiempo { get; set; }
        public string Efecto { get; set; }
        public string Respuesta { get; set; }
        public string EfectosSecundarios { get; set; }
        public string Dosis { get; set; }
        public string Posologia { get; set; }

        public Medicamento(int idgrid)
        {
            IdGrid = idgrid;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack)
        {
            BAceptar.Enabled = false;
            BMasFormulacion.Enabled = false;
            BFecha.Enabled = false;
            BFormula.Visible = false;
            PFormulaciones.Visible = false;

            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            if (!string.IsNullOrEmpty(Request.QueryString["fcid"]))
            {
                using (CConector conectormy = new CConector())
                {
                    Query formulacion = new Query("formato_ctc");

                    formulacion += "paciente";
                    formulacion += "fecha";

                    MySqlDataReader readermysql = conectormy.Query(formulacion.GetSelect("id=" + Query.GetValor(Request.QueryString["fcid"])));
                    if (readermysql != null && readermysql.Read())
                    {
                        Response.Redirect("~/paciente/formatoctc.aspx?pid=" + readermysql["paciente"].ToString() + "&f=" + string.Format("{0:d}", Convert.ToDateTime(readermysql["fecha"])));
                    }
                }
            }
            if (Request.QueryString["pid"] != null)
            {
                CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                if (CCDetallePaciente.IdPaciente.Length == 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath);
                }
                else
                {
                    GFormulacion.DataBind();
                    GPOS.DataBind();
                    GMedicamentos.DataBind();
                    ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);

                    BAceptar.Enabled = usuario.CanInsert();
                    BMasFormulacion.Enabled = usuario.CanInsert();
                    TFecha.Focus();
                    BFecha.Enabled = true;

                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                    PDatos.Visible = true;

                    using (CConector conector = new CConector())
                    {
                        TFecha.Text = Request.QueryString["f"];
                        if (TFecha.Text.Length == 0)
                            TFecha.Text = DateTime.Now.ToShortDateString();

                        Query formulacion = new Query("formato_ctc");

                        formulacion += "id";
                        formulacion += "fecha";
                        formulacion += "profesional";
                        formulacion += "respuesta";
                        formulacion += "contraindicacion";

                        MySqlDataReader readermysql = conector.Query(formulacion.GetSelect("paciente=" + CCDetallePaciente.IdPaciente + " AND fecha='" + Query.GetMySQLDateFormat(Convert.ToDateTime(TFecha.Text)) + "'"));
                        if (readermysql != null && readermysql.Read())
                        {
                            ((MasterPageI)Master).Imprimir("formatoctc.html");

                            BAceptar.Enabled = usuario.CanUpdate();
                            BMasFormulacion.Enabled = usuario.CanInsert();

                            GFormulacion.Columns[0].Visible = usuario.CanUpdate();
                            GFormulacion.Columns[1].Visible = usuario.CanDelete();

                            HIdFormulacion.Value = readermysql["id"].ToString();
                            TFecha.Text = ((DateTime)readermysql["fecha"]).ToShortDateString();
                            ViewState["profesional"] = readermysql["profesional"].ToString();
                            TContraindicacion.Text = readermysql["contraindicacion"].ToString();
                            TRespuestaClinica.Text = readermysql["respuesta"].ToString();

                            List<Medicamento> listadopos = new List<Medicamento>();

                            Query qpos = new Query("formato_ctc_pos_items");

                            qpos += "id";
                            qpos += "principio";
                            qpos += "posologia";
                            qpos += "dosis";
                            qpos += "cantidad";
                            qpos += "tiempo";

                            readermysql = conector.Query(qpos.GetSelect("formato_ctc=" + HIdFormulacion.Value));
                            if (readermysql != null)
                            {
                                while (readermysql.Read())
                                {
                                    Medicamento info = new Medicamento(listadopos.Count);
                                    info.Id = readermysql["id"].ToString();
                                    info.Cantidad = Convert.ToDouble(readermysql["cantidad"]);
                                    info.Nombre = readermysql["principio"].ToString();
                                    info.Posologia = readermysql["posologia"].ToString();
                                    info.Dosis = readermysql["dosis"].ToString();
                                    info.Tiempo = readermysql["tiempo"].ToString();
                                    listadopos.Add(info);
                                }
                            }

                            HPOS.Value = Serializar.SerializeBinary(listadopos);
                            GPOS.DataSource = listadopos;
                            GPOS.DataBind();

                            List<Medicamento> medicamentos = new List<Medicamento>();
                            List<Medicamento> medicamentosNoPos = new List<Medicamento>();

                            Query qmedicamentos = new Query("formato_ctc_items");

                            qmedicamentos += "id";
                            qmedicamentos += "nombre";
                            qmedicamentos += "cantidad";
                            qmedicamentos += "tiempo";
                            qmedicamentos += "efecto";
                            qmedicamentos += "respuesta";
                            qmedicamentos += "efecto_secundario";
                            qmedicamentos += "tipo";
                            qmedicamentos += "posologia";
                            qmedicamentos += "dosis";

                            readermysql = conector.Query(qmedicamentos.GetSelect("formato_ctc=" + HIdFormulacion.Value));
                            if (readermysql != null)
                            {
                                while (readermysql.Read())
                                {
                                    Medicamento info = new Medicamento(readermysql["tipo"].ToString()=="1" ? medicamentosNoPos.Count : medicamentos.Count);

                                    info.Id = readermysql["id"].ToString();
                                    info.Cantidad = Convert.ToDouble(readermysql["cantidad"]);
                                    info.Nombre = readermysql["nombre"].ToString();
                                    info.Tiempo = readermysql["tiempo"].ToString();
                                    info.Efecto = readermysql["efecto"].ToString();
                                    info.Respuesta = readermysql["respuesta"].ToString();
                                    info.EfectosSecundarios = readermysql["efecto_secundario"].ToString();
                                    info.Posologia = readermysql["posologia"].ToString();
                                    info.Dosis = readermysql["dosis"].ToString();
                                    if (readermysql["tipo"].ToString() == "1")
                                        medicamentosNoPos.Add(info);
                                    else medicamentos.Add(info);
                                }
                            }

                            HFormulacion.Value = Serializar.SerializeBinary(medicamentos);
                            GFormulacion.DataSource = medicamentos;
                            GFormulacion.DataBind();

                            HMedicamentos.Value = Serializar.SerializeBinary(medicamentosNoPos);
                            GMedicamentos.DataSource = medicamentosNoPos;
                            GMedicamentos.DataBind();

                            ((MasterPageI)Master).SetModificacion(HIdFormulacion.Value);
                        }
                        else
                        {
                            BFormula.Visible = conector.QueryString("SELECT id FROM formato_ctc WHERE paciente=" + CCDetallePaciente.IdPaciente + " LIMIT 1;").Length != 0;
                        }

                        BAceptar.OnClientClick = GFormulacion.Rows.Count == 0 ? "confirm('¿Está seguro de guardar la orden sin medicamentos o procedimientos?')" : "";


                        GFormulaciones.DataBind();
                        LFormulaciones.Text = GFormulaciones.Rows.Count + " Formato";
                        LFormulaciones.Text += GFormulaciones.Rows.Count == 1 ? "" : "s";
                        PFormulaciones.Visible = GFormulaciones.Rows.Count > 0;
                    }
                }
            }
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BMasFormulacion_Click(object sender, EventArgs e)
    {
        try
        {
            if (!IsValid)
                return;
        } catch { }

        List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);

        Medicamento info = null;
        if (GFormulacion.SelectedIndex != -1)
        {
            List<Medicamento> resultado = (from t in medicamentos
                                           where t.IdGrid.ToString() == GFormulacion.SelectedDataKey.Value.ToString()
                                           select t).ToList();
            if (resultado.Count != 0)
                info = resultado.First();
        }
        if (info == null)
        {
            info = new Medicamento(medicamentos.Count);
            medicamentos.Add(info);
        }

        info.Nombre= TNombre.Text;
        info.Cantidad= Convert.ToDouble(TCantidad.Text,CultureInfo.InvariantCulture);
        info.Tiempo= TTiempo.Text;
        info.Efecto= TEfecto.Text;
        info.Respuesta= TRespuesta.Text;
        info.EfectosSecundarios= TEfectosSecundarios.Text;

        HFormulacion.Value = Serializar.SerializeBinary(medicamentos);
        GFormulacion.SelectedIndex = -1;
        GFormulacion.DataSource = medicamentos;
        GFormulacion.DataBind();

        BAceptar.OnClientClick = GFormulacion.Rows.Count == 0 ? "confirm('¿Está seguro de guardar la orden sin medicamentos o procedimientos?')" : "";

        TNombre.Text= TCantidad.Text = TTiempo.Text= TEfecto.Text= TRespuesta.Text= TEfectosSecundarios.Text= "";
        TNombre.Focus();
    }

    protected void BFecha_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?pid=" + CCDetallePaciente.IdPaciente + "&f=" + TFecha.Text);
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        try
        {
            if (!IsValid)
                return;
        }
        catch { }

        CUsuario usuario = (CUsuario)CUsuario.GetInstance();
        Query formulacion = new Query("formato_ctc");

        if (!usuario.CanDelete() && (GFormulacion.Rows.Count == 0 || GMedicamentos.Rows.Count==0))
        {
            LMensajeMedicamento.Text = "Por favor ingrese por lo menos un medicamento.";
            return;
        }

        string szQuery;
        string mensaje;

        using (CConector conector = new CConector())
        {
            
            conector.StartTransaction();

            DateTime fecha = Convert.ToDateTime(TFecha.Text);

            formulacion["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);
            formulacion["profesional"] = usuario["personal"];
            formulacion["asegurador"] = CCDetallePaciente.AsegurdadorID;
            formulacion["respuesta"] = TRespuestaClinica.Text;
            formulacion["contraindicacion"] = TContraindicacion.Text;

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

            Query qpos = new Query("formato_ctc_pos_items");

            List<Medicamento> listadopos = Serializar.DesSerializeBinary<List<Medicamento>>(HPOS.Value);
            for (int i = 0; i < listadopos.Count; i++)
            {
                Medicamento info = listadopos[i];

                qpos["principio"] = info.Nombre;
                qpos["cantidad"] = info.Cantidad.ToString(CultureInfo.InvariantCulture);
                qpos["posologia"] = info.Posologia;
                qpos["dosis"] = info.Dosis;
                qpos["tiempo"] = info.Tiempo;

                if (string.IsNullOrEmpty(info.Id))
                {
                    qpos["formato_ctc"] = HIdFormulacion.Value;
                    if (conector.QueryMod(qpos.GetInsert()) == -1)
                        return;
                }
                else
                {
                    if (conector.QueryMod(qpos.GetUpdate("id=" + info.Id)) == -1)
                        return;
                }
            }

            Query medicamento = new Query("formato_ctc_items");

            List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);
            for (int i = 0; i < medicamentos.Count; i++)
            {
                Medicamento info = medicamentos[i];

                medicamento["nombre"] = info.Nombre;
                medicamento["cantidad"] = info.Cantidad.ToString(CultureInfo.InvariantCulture);
                medicamento["tiempo"] = info.Tiempo;
                medicamento["efecto"] = info.Efecto;
                medicamento["respuesta"] = info.Respuesta;
                medicamento["efecto_secundario"] = info.EfectosSecundarios;

                if (string.IsNullOrEmpty(info.Id))
                {
                    medicamento["formato_ctc"] = HIdFormulacion.Value;
                    if (conector.QueryMod(medicamento.GetInsert()) == -1)
                        return;
                }
                else
                {
                    if (conector.QueryMod(medicamento.GetUpdate("id=" + info.Id)) == -1)
                        return;
                }
            }

            medicamento = new Query("formato_ctc_items");

            List<Medicamento> listadonopos = Serializar.DesSerializeBinary<List<Medicamento>>(HMedicamentos.Value);
            for (int i = 0; i < listadonopos.Count; i++)
            {
                Medicamento info = listadonopos[i];

                medicamento["nombre"] = info.Nombre;
                medicamento["cantidad"] = info.Cantidad.ToString(CultureInfo.InvariantCulture);
                medicamento["posologia"] = info.Posologia;
                medicamento["dosis"] = info.Dosis;
                medicamento["tiempo"] = info.Tiempo;
                medicamento["efecto"] = info.Efecto;
                medicamento["respuesta"] = info.Respuesta;
                medicamento["efecto_secundario"] = info.EfectosSecundarios;

                if (string.IsNullOrEmpty(info.Id))
                {
                    medicamento["tipo"] = "1";
                    medicamento["formato_ctc"] = HIdFormulacion.Value;
                    if (conector.QueryMod(medicamento.GetInsert()) == -1)
                        return;
                }
                else
                {
                    if (conector.QueryMod(medicamento.GetUpdate("id=" + info.Id)) == -1)
                        return;
                }
            }

            conector.Commit();
        }

        ((MasterPageI)Master).SetParametros("?pid=" + CCDetallePaciente.IdPaciente);
        ((MasterPageI)Master).SetResultado(mensaje);
    }

    protected void GMedicamentos_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

        e.Cancel = true;
        List<Medicamento> listadonopos = Serializar.DesSerializeBinary<List<Medicamento>>(HMedicamentos.Value);
        List<Medicamento> resultado = (from t in listadonopos
                                       where t.IdGrid.ToString() == GMedicamentos.DataKeys[e.RowIndex].Value.ToString()
                                       select t).ToList();
        if (resultado.Count != 0)
        {
            Medicamento info = resultado.First();
            if (!string.IsNullOrEmpty(info.Id))
            {
                using (CConector conector = new CConector())
                {
                    if (conector.QueryMod("DELETE FROM formato_ctc_items WHERE id=" + Query.GetValor(info.Id)) == -1)
                    {
                        LMensajeMedicamento.Text = conector.LastError;
                        return;
                    }
                }
            }

            listadonopos.Remove(info);
            for (int i = 0; i < listadonopos.Count; i++)
                listadonopos[i].IdGrid = i;

            HMedicamentos.Value = Serializar.SerializeBinary(listadonopos);
            GMedicamentos.SelectedIndex = -1;
            GMedicamentos.DataSource = listadonopos;
            GMedicamentos.DataBind();
        }
    }


    protected void GPOS_RowDeleting(object sender, GridViewDeleteEventArgs e) {

        e.Cancel = true;
        List<Medicamento> listadopos = Serializar.DesSerializeBinary<List<Medicamento>>(HPOS.Value);
        List<Medicamento> resultado = (from t in listadopos
                                       where t.IdGrid.ToString() == GPOS.DataKeys[e.RowIndex].Value.ToString()
                                       select t).ToList();
        if (resultado.Count != 0)
        {
            Medicamento info = resultado.First();
            if (!string.IsNullOrEmpty(info.Id))
            {
                using (CConector conector = new CConector())
                {
                    if (conector.QueryMod("DELETE FROM formato_ctc_pos_items WHERE id=" + Query.GetValor(info.Id)) == -1)
                    {
                        LMensajeMedicamento.Text = conector.LastError;
                        return;
                    }
                }
            }

            listadopos.Remove(info);
            for (int i = 0; i < listadopos.Count; i++)
                listadopos[i].IdGrid = i;

            HPOS.Value = Serializar.SerializeBinary(listadopos);
            GPOS.SelectedIndex = -1;
            GPOS.DataSource = listadopos;
            GPOS.DataBind();
        }
    }

    protected void GMedicamentos_SelectedIndexChanged(object sender, EventArgs e)
    {

        List<Medicamento> listadonopos = Serializar.DesSerializeBinary<List<Medicamento>>(HMedicamentos.Value);
        List<Medicamento> resultado = (from info in listadonopos
                                       where info.IdGrid.ToString() == GMedicamentos.SelectedDataKey.Value.ToString()
                                       select info).ToList();

        if (resultado.Count != 0)
        {
            Medicamento info = resultado.First();

            TPrincipioNoPOS.Text = info.Nombre;
            TCantidadNoPOS.Text = info.Cantidad.ToString(CultureInfo.InvariantCulture);
            TPosologiaNoPOS.Text = info.Posologia;
            TDosisNoPOS.Text = info.Dosis;
            TTiempoNoPOS.Text = info.Tiempo;
            TEfectoNoPOS.Text= info.Efecto;
            TRespuestaNoPOS.Text= info.Respuesta;
            TEfectosSecundariosNoPOS.Text= info.EfectosSecundarios;
        }
    }

    protected void GPOS_SelectedIndexChanged(object sender, EventArgs e) {

        List<Medicamento> listadopos = Serializar.DesSerializeBinary<List<Medicamento>>(HPOS.Value);
        List<Medicamento> resultado = (from info in listadopos
                                       where info.IdGrid.ToString() == GPOS.SelectedDataKey.Value.ToString()
                                       select info).ToList();

        if (resultado.Count != 0)
        {
            Medicamento info = resultado.First();

            TPrincipio.Text= info.Nombre;
            TCantidadPOS.Text = info.Cantidad.ToString(CultureInfo.InvariantCulture);
            TPosologia.Text= info.Posologia;
            TDosis.Text= info.Dosis;
            TTiempoPOS.Text= info.Tiempo;
        }
    }

    protected void GFormulacion_SelectedIndexChanged(object sender, EventArgs e)
    {
        List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);
        List<Medicamento> resultado = (from info in medicamentos
                                       where info.IdGrid.ToString() == GFormulacion.SelectedDataKey.Value.ToString()
                                       select info).ToList();

        if (resultado.Count != 0)
        {

            Medicamento info = resultado.First();

            TNombre.Text = info.Nombre;
            TCantidad.Text = info.Cantidad.ToString(CultureInfo.InvariantCulture);
            TTiempo.Text = info.Tiempo;
            TEfecto.Text = info.Efecto;
            TRespuesta.Text = info.Respuesta;
            TEfectosSecundarios.Text = info.EfectosSecundarios;
        }
    }


    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;

        Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
        evento.Contenido = evento.Contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);
        evento.Contenido = evento.Contenido.Replace("$Apellidos$", paciente.pApellido + " " + paciente.sApellido);
        evento.Contenido = evento.Contenido.Replace("$Nombres$", paciente.pNombre+ " " + paciente.sNombre);
        evento.Contenido = evento.Contenido.Replace("$szTipoDocumento$", paciente.tipoDocNombre);

        evento.Contenido = evento.Contenido.Replace("$contributivo$", paciente.tipopago=="POS" ? "X" : "_");
        evento.Contenido = evento.Contenido.Replace("$subsidiado$", paciente.tipopago == "POS" ? "_" : "X");

        string szPos = "";
        for (int i = 0; i<GPOS.Rows.Count; i++) {
            szPos += (i+1) + ". ";
            for (int j = 2; j < GPOS.Columns.Count; j++) {
                szPos += GPOS.Columns[j].HeaderText + ": <b>" + GPOS.Rows[i].Cells[j].Text + "</b>&nbsp;&nbsp;&nbsp;";
            }
            szPos += "<br/>";
        }
        evento.Contenido = evento.Contenido.Replace("$szPOS$", szPos);

        string []fecha= TFecha.Text.Split('/');
        evento.Contenido = evento.Contenido.Replace("$dia$", fecha[0]);
        evento.Contenido = evento.Contenido.Replace("$mes$", fecha[1]);
        evento.Contenido = evento.Contenido.Replace("$ano$", fecha[2]);

        using(CConector conector=new CConector())
        {
            string url = HttpContext.Current.Request.Url.AbsolutePath.Replace(HttpContext.Current.Request.ApplicationPath, "~");
            string idmedico = conector.QueryString("SELECT usuario.personal FROM modificaciones LEFT JOIN usuario ON (usuario.id=modificaciones.usuario) WHERE modificaciones.id='" + HIdFormulacion.Value + "' AND modificaciones.url='" + url + "' ORDER BY modificaciones.fecha LIMIT 1");
            Query query = new Query("recurso_humano");

            query["szProfesional"] = "recurso_humano.perDocumento";
            query["szMedico"] = "recurso_humano.perNombre";
            query["szCargo"] = "cargo.carDescripcion";

            MySqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(idmedico), " LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)"));
            if (reader != null)
            {
                bool l = reader.Read();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    evento.Contenido = evento.Contenido.Replace("$" + reader.GetName(i) + "$", l ? reader[i].ToString() : "");
                }
            }

            query = new Query("ingreso_paciente");
            
            query += "id";
            query += "enfermedad_actual";

            MySqlDataReader myreader= conector.Query(query.GetSelect("paciente=" + paciente.Id));
            if (myreader != null && myreader.Read())
            {
                evento.Contenido = evento.Contenido.Replace("$hclinica$", myreader["id"].ToString());
                evento.Contenido = evento.Contenido.Replace("$enfermedad_actual$", myreader["enfermedad_actual"].ToString());
            }
            
            evento.Contenido = evento.Contenido.Replace("$szIdUsuario$", conector.QueryString("SELECT id FROM usuario WHERE personal=" + Query.GetValor(idmedico)));
        }


        int pos = evento.Contenido.IndexOf("<page");
        int posf = evento.Contenido.IndexOf("</page>");
        string contenidoreal = evento.Contenido.Substring(pos, posf - pos + 7);
        bool primero = true;

        // agregamos los medicamentos no pos
        for (int i = 0; i < GMedicamentos.Rows.Count; i++)
        {
            string contenido = primero ? evento.Contenido.ToString() : contenidoreal;
            szPos = "";
            for (int j = 2; j < GMedicamentos.Columns.Count-3; j++)
            {
                szPos += GMedicamentos.Columns[j].HeaderText + ": <b>" + GMedicamentos.Rows[i].Cells[j].Text + "</b>&nbsp;&nbsp;&nbsp;";
            }
            contenido = contenido.Replace("$szNoPOS$", szPos)
                .Replace("$Efecto$", GMedicamentos.Rows[i].Cells[GMedicamentos.GetGridColumnIndex("Efecto deseado")].Text)
                .Replace("$Respuesta$", GMedicamentos.Rows[i].Cells[GMedicamentos.GetGridColumnIndex("Tiempo de respuesta esperado")].Text)
                .Replace("$EfectosSecundarios$", GMedicamentos.Rows[i].Cells[GMedicamentos.GetGridColumnIndex("Efectos secundarios y posibles riesgos")].Text)

                .Replace("$Nombre$", "")
                .Replace("$Cantidad$", "")
                .Replace("$Tiempo$", "");
                
            if (primero)
            {
                evento.Contenido = contenido;
                posf = evento.Contenido.IndexOf("</page>");
            } 
            else
            {
                evento.Contenido = evento.Contenido.Insert(posf + 7, contenido);
            }
            primero = false;
        }

        // agregamos los servicios no pos

        List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);
        for (int i = medicamentos.Count-1; i >= 0; i--)
        {
            string contenido = primero ? evento.Contenido.ToString() : contenidoreal;

            contenido = contenido.Replace("$Nombre$", medicamentos[i].Nombre)
                .Replace("$Cantidad$", medicamentos[i].Cantidad.ToString())
                .Replace("$Tiempo$", medicamentos[i].Tiempo)
                .Replace("$Efecto$", medicamentos[i].Efecto)
                .Replace("$Respuesta$", medicamentos[i].Respuesta)
                .Replace("$EfectosSecundarios$", medicamentos[i].EfectosSecundarios)
                
                .Replace("$szNoPOS$", "");

            if (primero)
            {
                evento.Contenido = contenido;
                posf = evento.Contenido.IndexOf("</page>");
            } 
            else
            {
                evento.Contenido = evento.Contenido.Insert(posf + 7, contenido);
            }
            primero = false;
        }

        evento.Contenido = evento.Contenido.Replace("<page", "<div").Replace("</page", "</div");
    }

    protected void BFormula_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            string id = conector.QueryString("SELECT id FROM formato_ctc WHERE paciente=" + CCDetallePaciente.IdPaciente + " ORDER BY fecha DESC LIMIT 1;");
            if (id.Length != 0)
            {
                Query qpos = new Query("formato_ctc_pos_items");

                qpos += "principio";
                qpos += "posologia";
                qpos += "dosis";
                qpos += "cantidad";
                qpos += "tiempo";

                MySqlDataReader reader = conector.Query(qpos.GetSelect("formato_ctc=" + HIdFormulacion.Value));
                if (reader != null)
                {
                    while (reader.Read())
                    {
                        TPosologia.Text = reader["posologia"].ToString();
                        TPrincipio.Text = reader["principio"].ToString();
                        TCantidadPOS.Text = Convert.ToDouble(reader["cantidad"]).ToString(CultureInfo.InvariantCulture);
                        TDosis.Text = reader["dosis"].ToString();
                        TTiempoPOS.Text= reader["tiempo"].ToString();

                        BAgregarPOS_Click(sender, e);
                    }
                }

                Query medicamento = new Query("formato_ctc_items");

                medicamento += "nombre";
                medicamento += "cantidad";
                medicamento += "tiempo";
                medicamento += "efecto";
                medicamento += "respuesta";
                medicamento += "efecto_secundario";
                medicamento += "tipo";
                medicamento += "posologia";
                medicamento += "dosis";

                reader = conector.Query(medicamento.GetSelect("formato_ctc=" + id));
                if (reader != null)
                {
                    while (reader.Read())
                    {
                        if (reader["tipo"].ToString() == "1")
                        {
                            TPrincipioNoPOS.Text = reader["nombre"].ToString();
                            TPosologiaNoPOS.Text = reader["posologia"].ToString();
                            TDosisNoPOS.Text = reader["dosis"].ToString();
                            TCantidadNoPOS.Text = Convert.ToDouble(reader["cantidad"]).ToString(CultureInfo.InvariantCulture);
                            TTiempoNoPOS.Text = reader["tiempo"].ToString();
                            TEfecto.Text= reader["efecto"].ToString();
                            TRespuesta.Text= reader["respuesta"].ToString();
                            TEfectosSecundarios.Text= reader["efecto_secundario"].ToString();

                            BMedicamentos_Click(sender, e);
                        } else {
                            TNombre.Text = reader["nombre"].ToString();
                            TCantidad.Text = Convert.ToDouble(reader["cantidad"]).ToString(CultureInfo.InvariantCulture);
                            TTiempo.Text = reader["tiempo"].ToString();
                            TEfecto.Text = reader["efecto"].ToString();
                            TRespuesta.Text = reader["respuesta"].ToString();
                            TEfectosSecundarios.Text = reader["efecto_secundario"].ToString();

                            BMasFormulacion_Click(sender, e);
                        }
                    }
                }
            }
        }
    }

    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/paciente/formatoctc.aspx?pid=" + CCDetallePaciente.IdPaciente + "&f=" + string.Format("{0:d}", Convert.ToDateTime(((ImageButton)sender).CommandArgument)));
    }

    protected void GFormulacion_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        e.Cancel = true;
        List<Medicamento> medicamentos = Serializar.DesSerializeBinary<List<Medicamento>>(HFormulacion.Value);
        List<Medicamento> resultado = (from t in medicamentos
                                       where t.IdGrid.ToString() == GFormulacion.DataKeys[e.RowIndex].Value.ToString()
                                       select t).ToList();
        if (resultado.Count != 0)
        {

            Medicamento info = resultado.First();
            if (!string.IsNullOrEmpty(info.Id))
            {
                using (CConector conector = new CConector())
                {
                    if (conector.QueryMod("DELETE FROM formato_ctc_items WHERE id=" + Query.GetValor(info.Id)) == -1)
                    {
                        LMensajeMedicamento.Text = conector.LastError;
                        return;
                    }
                }
            }

            medicamentos.Remove(info);
            for (int i = 0; i < medicamentos.Count; i++)
                medicamentos[i].IdGrid = i;

            HFormulacion.Value = Serializar.SerializeBinary(medicamentos);
            GFormulacion.SelectedIndex = -1;
            GFormulacion.DataSource = medicamentos;
            GFormulacion.DataBind();

            BAceptar.OnClientClick = GFormulacion.Rows.Count == 0 ? "confirm('¿Está seguro de guardar la orden sin medicamentos o procedimientos?')" : "";
        }
    }

    protected void BMedicamentos_Click(object sender, EventArgs e)
    {
        try
        {
            if (!IsValid)
                return;
        }
        catch { }

        List<Medicamento> listadonopos = Serializar.DesSerializeBinary<List<Medicamento>>(HMedicamentos.Value);

        Medicamento info = null;
        if (GMedicamentos.SelectedIndex != -1)
        {
            List<Medicamento> resultado = (from t in listadonopos
                                           where t.IdGrid.ToString() == GMedicamentos.SelectedDataKey.Value.ToString()
                                           select t).ToList();
            if (resultado.Count != 0)
                info = resultado.First();
        }
        if (info == null)
        {
            info = new Medicamento(listadonopos.Count);
            listadonopos.Add(info);
        }

        info.Nombre = TPrincipioNoPOS.Text;
        info.Cantidad = Convert.ToDouble(TCantidadNoPOS.Text, CultureInfo.InvariantCulture);
        info.Posologia = TPosologiaNoPOS.Text;
        info.Dosis = TDosisNoPOS.Text;
        info.Tiempo = TTiempoNoPOS.Text;
        info.Efecto = TEfectoNoPOS.Text;
        info.Respuesta = TRespuestaNoPOS.Text;
        info.EfectosSecundarios = TEfectosSecundariosNoPOS.Text;

        HMedicamentos.Value = Serializar.SerializeBinary(listadonopos);
        GMedicamentos.SelectedIndex = -1;
        GMedicamentos.DataSource = listadonopos;
        GMedicamentos.DataBind();

        TEfectoNoPOS.Text= TRespuestaNoPOS.Text= TEfectosSecundariosNoPOS.Text= 
        TPrincipioNoPOS.Text = TCantidadNoPOS.Text = TPosologiaNoPOS.Text = TDosisNoPOS.Text = TTiempoNoPOS.Text = "";
        TPrincipioNoPOS.Focus();
    }

    protected void BAgregarPOS_Click(object sender, EventArgs e)
    {
        try
        {
            if (!IsValid)
                return;
        }
        catch { }

        List<Medicamento> listadopos = Serializar.DesSerializeBinary<List<Medicamento>>(HPOS.Value);

        Medicamento info = null;
        if (GPOS.SelectedIndex != -1)
        {
            List<Medicamento> resultado = (from t in listadopos
                                           where t.IdGrid.ToString() == GPOS.SelectedDataKey.Value.ToString()
                                           select t).ToList();
            if (resultado.Count != 0)
                info = resultado.First();
        }
        if (info == null)
        {
            info = new Medicamento(listadopos.Count);
            listadopos.Add(info);
        }

        info.Nombre = TPrincipio.Text;
        info.Cantidad = Convert.ToDouble(TCantidadPOS.Text, CultureInfo.InvariantCulture);
        info.Posologia = TPosologia.Text;
        info.Dosis = TDosis.Text;
        info.Tiempo = TTiempoPOS.Text;

        HPOS.Value = Serializar.SerializeBinary(listadopos);
        GPOS.SelectedIndex = -1;
        GPOS.DataSource = listadopos;
        GPOS.DataBind();

        TPrincipio.Text= TCantidadPOS.Text= TPosologia.Text= TDosis.Text= TTiempoPOS.Text="";
        TPrincipio.Focus();
    }
}
