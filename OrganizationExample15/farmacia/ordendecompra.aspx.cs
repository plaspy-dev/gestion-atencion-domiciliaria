using System;
using System.Collections.Generic;
using System.Linq;
using System.Configuration;
using System.IO;
using System.Web;
using System.Net.Mail;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using SDG.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text.RegularExpressions;
using System.Text;

public partial class farmacia_ordendecompra : System.Web.UI.Page
{
    public static int m_nAlmacen = 1;

    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);

        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)CUsuario.GetUsuario();

            CConfiguracion configuracion = CConfiguracion.GetConfiguracion();

            // costo
            GProductos.GetGridColumn("Costo U.").Visible =
            GProductos.GetGridColumn("Costo T.").Visible =
            RCostoF.Visible = RCosto.Visible =
            TCosto.Visible = LCosto.Visible = configuracion.nCosto != 0;

            // tercero
            RIdentificacion.Visible = configuracion.bDocumentoEntrada;

            RTerceroID.Visible = configuracion.bTerceroEntrada && !configuracion.bCrearTerceroEntradas;
            TEMail.ReadOnly = TDireccion.ReadOnly = TTercero.ReadOnly = TTelefono.ReadOnly = !configuracion.bCrearTerceroEntradas;
            RNombre.Visible = RIdentificacion.Visible = configuracion.bCrearTerceroEntradas && configuracion.bTerceroEntrada;
            RDireccion.Visible = RTelefono.Visible = configuracion.bDatosComplementariosTerceroEntrada;

            if (Session["orden_compra_clean"] != null)
            {
                ViewState["clean"] = true;
                Session["orden_compra_clean"] = null;
            }
            else ViewState["clean"] = false;

            if (Session["lordencompra"] != null)
            {
                ViewState["urlprint"] = Request.Url.AbsolutePath + "?oci=" + Session["lordencompra"].ToString() + "&p=1";
                LImprimir.Text = "Orden de compra " + Session["lordencompra"].ToString() + " Editada.<br/>¿Desea imprimirla?";
                PImprimir.Visible = true;
                Session["lordencompra"] = null;
            }
            string id=null;
            if (!string.IsNullOrEmpty(Request.QueryString["k"]))
            {
                id = Crypt.DesencriptarDES(Request.QueryString["k"].Replace(" ", "+"), System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY"));
                if (string.IsNullOrEmpty(id))
                    throw new HttpException(404, "Page not found");
            }
            if (string.IsNullOrEmpty(id))
            {
                if (usuario.GetPermisos(Request.Url.AbsolutePath) == (int)Usuario.Permisos.Print) // es un usuario de solo impresion
                    throw new HttpException(404, "Page not found");
                id = Request.QueryString["oci"];
            }
            if (!string.IsNullOrEmpty(id))
            {
                using (CConector conector = new CConector())
                {
                    Query query = new Query("orden_compra" + m_nAlmacen);

                    query += "id";
                    query += "observaciones";
                    query += "fecha";
                    query += "tercero";
                    query += "estado";
                    query += "paciente";
                    query += "prioridad";
                    query += "revisado";
                    query += "creado";
                    query += "centro_costos";
                    query += "lotes";

                    MySqlDataReader reader = conector.Query(query.GetSelect("id=" + Query.GetValor(id)));
                    if (reader != null && reader.Read())
                    {
                        BAceptar.Enabled = usuario.CanUpdate();

                        if (usuario.GetPermisos(Request.Url.AbsolutePath) == (int)Usuario.Permisos.Print) {// es un usuario de solo impresion
                            if (reader["lotes"] == DBNull.Value && Request.QueryString["pdf"]=="1") {
                                Response.Redirect("~/farmacia/ordendecompra.aspx?k=" + Request.QueryString["k"]);
                            } else if (reader["lotes"] != DBNull.Value && Request.QueryString["pdf"]!="1") {
                                Response.Redirect("~/farmacia/ordendecompra.aspx?k=" + Request.QueryString["k"] + "&pdf=1");
                            }
                            UCPaciente.ReadOnly =
                            TFecha.ReadOnly = TTercero.ReadOnly = TNombre.ReadOnly = TDireccion.ReadOnly = TTelefono.ReadOnly = TEMail.ReadOnly =TObservaciones.ReadOnly =
                            TNumero.ReadOnly = true;

                            PProductos.Visible = 
                            TFecha.Enabled =
                            CPrioridad.Enabled = ROrganizationExample15.Enabled = RPaciente.Enabled =
                            DCCosto.Enabled = false;

                            BAceptar.Enabled = true;
                        }

                        bool editLote = usuario.CanUpdate() || usuario.GetPermisos() == (int)Usuario.Permisos.Print;
                        GProductos.GetGridColumn("Vence ").Visible =
                                    GProductos.GetGridColumn("Lote ").Visible = editLote;

                        GProductos.GetGridColumn("Vencimiento").Visible =
                        GProductos.GetGridColumn("Lote").Visible = !editLote;

                        CNotificar.Visible = usuario.CanUpdate();

                        PRevisado.Visible = true;
                        HId.Value = TNumero.Text = reader["id"].ToString();
                        ((MasterPageI)Master).SetModificacion(HId.Value);
                        ((MasterPageI)Master).Imprimir("ordencompra.html");
                        TObservaciones.Text = reader["observaciones"].ToString();
                        TFecha.Text = Query.GetFromMySQLDate(reader["fecha"]);
                        PAnulado.Visible = reader["estado"].ToString() != "";
                        CPrioridad.Checked = reader["prioridad"].ToString()=="1";
                        UCPaciente.IdPaciente= reader["paciente"].ToString();
                        ROrganizationExample15.Checked = string.IsNullOrEmpty(UCPaciente.IdPaciente);
                        RPaciente.Checked = !ROrganizationExample15.Checked;
                        LRevisado.Text = reader["revisado"].ToString();
                        LCreado.Text = reader["creado"].ToString();
                        Utilidades.SelectInDropDown(DCCosto, reader["centro_costos"]);

                        Tercero tercero = new Tercero(reader["tercero"].ToString());
                        TTerceroID.Text = tercero.Id;
                        TTercero.Text = tercero.Documento;
                        TNombre.Text = tercero.Nombre;
                        TTelefono.Text = tercero.Telefono;
                        TDireccion.Text = tercero.Direccion;
                        TEMail.Text = tercero.Email;

                        ProductoUsado productoUsado = ProductoUsado.DesSerialize(HUsado.Value);

                        query = new Query("orden_compra_items" + m_nAlmacen);

                        query += "id";
                        query += "producto";
                        query += "cantidad";
                        query += "ingreso";
                        query += "costo";
                        query += "vence";
                        query += "lote";

                        reader = conector.Query(query.GetSelect("orden_compra=" + HId.Value));
                        if (reader != null)
                        {
                            while (reader.Read())
                            {
                                Producto info = new Producto(reader["producto"].ToString());

                                info.IdTabla = reader["id"].ToString();
                                info.cantidad = Convert.ToDecimal(reader["cantidad"]);
                                info.Ingreso = reader["ingreso"].ToString();
                                info.Costo = Convert.ToDecimal(reader["costo"]);
                                info.lote = reader["lote"].ToString();
                                info.vence = Query.GetFromMySQLDate(reader["vence"]);

                                productoUsado.AddProducto(info);
                            }
                        }

                        GProductos.DataSource = productoUsado.GetProductosUsados();
                        HUsado.Value = productoUsado.SerializeBinary();
                        GProductos.DataBind();
                        if (!editLote)
                        {
                            foreach (GridViewRow row in GProductos.Rows)
                            {
                                ((RequiredFieldValidator)row.FindControl("R1")).Visible = false;
                                ((RequiredFieldValidator)row.FindControl("R2")).Visible = false;
                            }
                        }
                        if (GProductos.FooterRow != null)
                        {
                            GProductos.FooterRow.Cells[GProductos.GetGridColumnIndex("Costo T.")].Text = string.Format("{0:C}", productoUsado.GetCostoTotal());
                            GProductos.FooterRow.Cells[GProductos.GetGridColumnIndex("Cantidad")].Text = string.Format("{0:F}", productoUsado.GetTotalProductos());
                            GProductos.FooterRow.Cells[GProductos.GetGridColumnIndex("Producto")].Text = "Total";
                        }

                        TProducto.Focus();
                        BAgregar.Enabled = string.IsNullOrEmpty((string)ViewState["TrasladoId"]);
                        GProductos.Columns[0].Visible = usuario.CanDelete();
                        BAnular.Visible = usuario.CanAdmin();
                        if (PAnulado.Visible)
                        {
                            LAnulado.Text = "Anulada";
                            GProductos.Columns[0].Visible =
                            BAnular.Enabled = BAceptar.Enabled = false;
                        }
                        return;
                    }
                }
            }
            BAceptar.Enabled = usuario.CanInsert();
            using (CConector conector = new CConector())
                TNumero.Text = conector.QueryString("SELECT IF(MAX(id),MAX(id)+1,1) FROM orden_compra" + m_nAlmacen);
            TFecha.Text = DateTime.Now.ToShortDateString();
            TNumero.Focus();
        }
    }

    protected void GProductos_SelectedIndexChanged(object sender, EventArgs e)
    {

        ProductoUsado productoUsado = ProductoUsado.DesSerialize(HUsado.Value);
        Producto producto = productoUsado.GetProducto(Convert.ToInt32(GProductos.SelectedDataKey[0]));

        TProducto.Text = producto.nombre;
        TCantidad.Text = producto.cantidad.ToString(CultureInfo.InvariantCulture);
        TProductoID.Text = producto.id;
        TCosto.Text = producto.Costo.ToString(CultureInfo.InvariantCulture);
    }

    protected void BAgregar_Click(object sender, EventArgs e)
    {
        Producto producto = new Producto(TProductoID.Text);

        REntero.Enabled = producto.nNumero == 1;
        RDecimal.Enabled = producto.nNumero != 1;

        Page.Validate("producto");
        if (!Page.IsValid)
            return;

        producto.cantidad = Convert.ToDecimal(TCantidad.Text, CultureInfo.InvariantCulture);
        try
        {
            producto.Costo = Decimal.Parse(TCosto.Text.Replace("$",""), NumberStyles.Currency, CultureInfo.InvariantCulture);
        } catch { }
        producto.GetValor(UCPaciente.IdPaciente,m_nAlmacen);

        ProductoUsado productousadoNuevo = new ProductoUsado(HProductos.Value);
        ProductoUsado productoUsado = ProductoUsado.DesSerialize(HUsado.Value);

        if (GProductos.SelectedIndex == -1)
        {
            productoUsado.AddProducto(producto);
        } else {
            // revisar la edicion
            Producto info = productoUsado.GetProducto(Convert.ToInt32(GProductos.DataKeys[GProductos.SelectedIndex].Values[0]));

            productousadoNuevo.DeleteProducto(info.id, info.cantidad, info.lote, info.vence
                , info.ubicacion, info.estado, info.serial);

            productoUsado.UpdateProducto(info.IdGrid, producto);
        }

        GProductos.SelectedIndex = -1;
        GProductos.DataSource = productoUsado.GetProductosUsados();
        GProductos.DataBind();

        if (!GProductos.GetGridColumn("Vence ").Visible)
        {
            foreach (GridViewRow row in GProductos.Rows)
            {
                ((RequiredFieldValidator)row.FindControl("R1")).Visible = false;
                ((RequiredFieldValidator)row.FindControl("R2")).Visible = false;
            }
        }

        REntero.Enabled = true;
        RDecimal.Enabled = true;

        TCosto.Text = TProducto.Text = TProductoID.Text = TCantidad.Text = "";
        TProducto.Focus();

        if (GProductos.FooterRow != null)
        {
            GProductos.FooterRow.Cells[GProductos.GetGridColumnIndex("Costo T.")].Text = string.Format("{0:C}", productoUsado.GetCostoTotal());
            GProductos.FooterRow.Cells[GProductos.GetGridColumnIndex("Cantidad")].Text = string.Format("{0:F}", productoUsado.GetTotalProductos());
            GProductos.FooterRow.Cells[GProductos.GetGridColumnIndex("Producto")].Text = "Total";
        }

        productousadoNuevo.GetProductosUsados().Add(producto);
        HProductos.Value = productousadoNuevo.Serialize();
        HUsado.Value = productoUsado.SerializeBinary();

        ScriptManager.RegisterStartupScript(TProducto, typeof(String), "pregunta", "window.onbeforeunload = function() { return '¿Ha realizado cambios, esta seguro de abandonar la pagina?'; };", true);
    }

    public static bool IsValidEmail(string strIn)
    {
        if (String.IsNullOrEmpty(strIn))
            return false;

        // Return true if strIn is in valid e-mail format. 
        try
        {
            return Regex.IsMatch(strIn,
                  @"^(?("")(""[^""]+?""@)|(([0-9a-z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-z])@))" +
                  @"(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-z][-\w]*[0-9a-z]*\.)+[a-z0-9]{2,24}))$",
                  RegexOptions.IgnoreCase);
        } catch {
            return false;
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        if (GProductos.Rows.Count == 0)
        {
            LMensaje.Text = "Por favor ingrese por lo menos un producto";
            return;
        }

        if (RPaciente.Checked && string.IsNullOrEmpty(UCPaciente.IdPaciente))
        {
            LMensaje.Text = "Por favor ingrese un paciente";
            return;
        }

        Query query = new Query("orden_compra" + m_nAlmacen);

        
        using (CConector conector = new CConector())
        {
            CUsuario usuario = (CUsuario)Usuario.GetInstance();
            // actualizamos las ubicaciones de todos
            ProductoUsado productoUsado = ProductoUsado.DesSerialize(HUsado.Value);
            List<Producto> productos = null;

            if (usuario.GetPermisos() == (int)Usuario.Permisos.Print)
            {
                conector.StartTransaction();
                query["lotes"] = "SYSDATE()";
                if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(HId.Value))) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }

                if (conector.InsertModificacion(HId.Value) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }

                productos = productoUsado.GetProductosUsados();
                foreach (GridViewRow row in GProductos.Rows) {

                    Producto producto= productos.Find(x=>x.IdGrid==(int)GProductos.DataKeys[row.DataItemIndex].Values["IdGrid"]);
                    if (producto == null)
                        continue;

                    query = new Query("orden_compra_items" + m_nAlmacen);

                    query["lote"] = ((TextBox)row.FindControl("TL")).Text;
                    query["vence"] = Query.GetMySQLDateFormat(((TextBox)row.FindControl("TV")).Text);

                    if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(producto.IdTabla))) == -1) {
                        LMensaje.Text = conector.LastError;
                        return;
                    }
                }

                conector.Commit();
                Response.Redirect("~/farmacia/ordendecompra.aspx?k=" + Request.QueryString["k"] + "&pdf=1");
                return;
            }

            bool nueva = false;
            // agregamos el tercero
            string terceroid = TTerceroID.Text;

            if (TNombre.Text.Length > 0 && TTercero.Text.Length > 0)
            {
                Query tercero = new Query("tercero");

                tercero["tipo"] = "2";
                tercero["nombre"] = TNombre.Text;
                tercero["identificacion"] = TTercero.Text;
                tercero["telefono"] = TTelefono.Text;
                tercero["direccion"] = TDireccion.Text;
                tercero["email"] = TEMail.Text;

                if (terceroid.Length > 0)
                {
                    if (conector.QueryMod(tercero.GetUpdate("id=" + Query.GetValor(terceroid))) == -1)
                        return;
                } else {
                    int res = conector.QueryMod(tercero.GetInsert());
                    if (res == -1)
                        return;
                    terceroid = res.ToString();
                }
                Tercero.RemoveTercero(terceroid);
            }

            query["observaciones"] = TObservaciones.Text;
            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);
            query["paciente"] = RPaciente.Checked ? UCPaciente.IdPaciente : "";
            query["tercero"] = terceroid;
            query["prioridad"] = CPrioridad.Checked ? "1" : "";
            query["centro_costos"] = DCCosto.SelectedValue;
            if (sender == BAnular)
                query["estado"] = "-1";

            conector.StartTransaction();

            bool existe = HId.Value.Length > 0;

            if (HId.Value.Length == 0)
            {
                nueva = true;
                query["creado"] = "SYSDATE()";
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
                HId.Value = res.ToString();
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(HId.Value))) == -1)
                {
                    LMensaje.Text = conector.LastError;
                    return;
                }
            }

            if (conector.InsertModificacion(HId.Value) == -1)
            {
                LMensaje.Text = conector.LastError;
                return;
            }

            // eliminamos todos los productos
            productos = productoUsado.GetProductoEliminado();
            for (int i = 0; i < productos.Count; i++)
            {
                if (conector.QueryMod(string.Format("DELETE FROM orden_compra{0} WHERE id={1}", m_nAlmacen, productos[i].IdTabla)) == -1)
                    return;
            }
            // agregamos los nuevos
            productos = productoUsado.GetProductosUsados();
            for (int i = 0; i < productos.Count; i++)
            {
                productoUsado.UpdateProductoIngreso(productos[i].IdGrid, sender != BAnular && TFecha.Text.Length > 0);

                query = productos[i].GetQuery("orden_compra_items" + m_nAlmacen, false);

                for (int j = 0; j < GProductos.Rows.Count; j++) {

                    if ((int)GProductos.DataKeys[j].Values["IdGrid"] == productos[i].IdGrid) {

                        query["lote"] = ((TextBox)GProductos.Rows[j].FindControl("TL")).Text;
                        query["vence"] = Query.GetMySQLDateFormat(((TextBox)GProductos.Rows[j].FindControl("TV")).Text);
                        break;
                    }
                }

                if (string.IsNullOrEmpty(productos[i].IdTabla))
                {
                    query["valor"] = productos[i].GetValor(UCPaciente.IdAsegurador, m_nAlmacen).ToString(CultureInfo.InvariantCulture);
                    query["orden_compra"] = HId.Value;
                    if (conector.QueryMod(query.GetInsert()) == -1)
                        return;
                }
                else if (productos[i].pProductoAntiguo != null)
                { // fue actualizado
                    if (conector.QueryMod(query.GetUpdate("id=" + productos[i].IdTabla)) == -1)
                        return;
                }

                if (!productos[i].UpdateCosto(conector, TTerceroID.Text))
                    return;
            }

            conector.Commit();
            Session["orden_compra_clean"] = 1;

            if (!CNotificar.Visible || !CNotificar.Checked)
            {
                try
                {
                    Tercero tecero = new Tercero(TTerceroID.Text);

                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("demo@example.invalid", "Compras OrganizationExample15");
                    if (IsValidEmail(tecero.Email))
                    { // no le enviamos correo al proveedor
                        mail.To.Add(tecero.Email);
#if DEBUG
                    mail.To.Clear();
                    mail.To.Add("demo@example.invalid");
#endif
                    }
                    // mail.Bcc.Add();

                    mail.Subject = nueva ? "Nueva " : "Actualizada ";
                    mail.Subject += "orden de compra No. " + HId.Value;
                    mail.IsBodyHtml = true;
                    mail.Priority = MailPriority.Normal;

                    StringBuilder Contenido = new StringBuilder();
                    using (StreamReader reader = new StreamReader(Server.MapPath("ordencompracorreo.html")))
                    {
                        Contenido = new StringBuilder(reader.ReadToEnd());
                        reader.Close();
                    }

                    if (ROrganizationExample15.Checked)
                        Contenido = Contenido.Replace("$TPaciente$", "OrganizationExample15");

                    Paciente paciente = Paciente.GetPaciente(UCPaciente.IdPaciente);

                    Contenido = Contenido.Replace("$szDireccion$", paciente.Direccion)
                        .Replace("$TPaciente$", paciente.DocumentoYNombres.Replace("Inactivo - ", ""))
                        .Replace("$szTelefono$", paciente.Telefono)
                        .Replace("$szAsegurador$", paciente.NombreEntidad)
                        .Replace("$szBarrio$", paciente.Barrio)
                        .Replace("$szPrioridad$", CPrioridad.Checked ? "Prioritaria" : "Normal")
                        .Replace("$szIniciales$", new Tercero(TTerceroID.Text).Nombre.Substring(0, 2))
                        .Replace("$szNumero$", TNumero.Text.PadLeft(3, '0'))
                        ;

                    Contenido = Utilidades.ReplaceContenido(Page.Controls, Contenido)
                        .Replace("../imgs/", string.Format("{0}{1}", ConfigurationManager.AppSettings["servidor"], ResolveUrl("~/imgs/")))
                        .Replace("../css/", string.Format("{0}{1}", ConfigurationManager.AppSettings["servidor"], ResolveUrl("~/css/")))
                        .Replace("~/imgs/", string.Format("{0}{1}", ConfigurationManager.AppSettings["servidor"], ResolveUrl("~/imgs/")))
                        .Replace("~/css/", string.Format("{0}{1}", ConfigurationManager.AppSettings["servidor"], ResolveUrl("~/css/")));

                    mail.Body = Contenido.Replace("$szVinculo$", string.Format("{0}{1}?k={3}&pdf=1", ConfigurationManager.AppSettings["servidor"], Request.Url.AbsolutePath, HId.Value, HttpUtility.UrlEncode(Crypt.EncriptarDES(HId.Value, System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY"))))).ToString();

                    SmtpClient client = new SmtpClient();
                    client.EnableSsl = client.Port == 587 || client.Port == 465;
                    if (IsValidEmail(tecero.Email)) // no le enviamos correo al proveedor
                        client.Send(mail);

                    // esta es la copia del correo
                    mail.To.Clear();
                    mail.To.Add(ConfigurationManager.AppSettings["ordenesdecompra:copia"]);
                    mail.Body = Contenido.Replace("$szVinculo$", string.Format("{0}{1}?oci={2}&pdf=1", ConfigurationManager.AppSettings["servidor"], Request.Url.AbsolutePath, HId.Value)).ToString();
                    client.Send(mail);
                }
                catch (Exception ex)
                {
                    ((MasterPageI)Master).SetResultado(ex.Message);
                    return;
                }
            }

            // Alertas.RemoveAlertas(m_nAlmacen);

            // esto es para la impresion.
            // Session["lordencompra"] = HId.Value;

            ((MasterPageI)Master).SetResultado("Orden de compra " + HId.Value + " editada.");
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Session["orden_compra_clean"] = 1;
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void BActualizar_Click(object sender, EventArgs e)
    {
        ProductoUsado productousadoNuevo = new ProductoUsado(HProductos.Value);
        HProductos.Value = "";
        List<Producto> productos = productousadoNuevo.GetProductosUsados();
        for (int i = 0; i < productos.Count; i++)
        {
            Producto producto = productos[i];
            TProductoID.Text = producto.id;
            TCantidad.Text = producto.cantidad.ToString(CultureInfo.InvariantCulture);
            TProducto.Text = producto.NombreCompleto;
            TCosto.Text = producto.Costo.ToString(CultureInfo.InvariantCulture);
            BAgregar_Click(sender, e);
        }
    }
    protected void GProductos_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        // en la tabla definitiva
        ProductoUsado productoUsado = ProductoUsado.DesSerialize(HUsado.Value);
        Producto producto = productoUsado.GetProducto(Convert.ToInt32(GProductos.DataKeys[e.RowIndex].Values[0]));
        if (producto == null)
        {
            e.Cancel = true;
            return;
        }

        // ahora en los temporales
        ProductoUsado productousadoNuevo = new ProductoUsado(HProductos.Value);
        productousadoNuevo.DeleteProducto(producto.id, producto.cantidad, producto.lote, producto.vence, producto.ubicacion, producto.estado, producto.serial);
        HProductos.Value = productousadoNuevo.Serialize();


        productoUsado.DeleteProducto(producto.IdGrid);
        GProductos.DataSource = productoUsado.GetProductosUsados();
        GProductos.DataBind();
        if (!GProductos.GetGridColumn("Vence ").Visible)
        {
            foreach (GridViewRow row in GProductos.Rows)
            {
                ((RequiredFieldValidator)row.FindControl("R1")).Visible = false;
                ((RequiredFieldValidator)row.FindControl("R2")).Visible = false;
            }
        }

        HUsado.Value = productoUsado.SerializeBinary();
        if (GProductos.FooterRow != null)
        {
            GProductos.FooterRow.Cells[GProductos.GetGridColumnIndex("Costo T.")].Text = string.Format("{0:C}", productoUsado.GetCostoTotal());
            GProductos.FooterRow.Cells[GProductos.GetGridColumnIndex("Cantidad")].Text = string.Format("{0:F}", productoUsado.GetTotalProductos());
            GProductos.FooterRow.Cells[GProductos.GetGridColumnIndex("Producto")].Text = "Total";
        }

        e.Cancel = true;
    }
    protected void OnImprimir(object sender, EventArgs e)
    {
        // guardamos la impresion
        using (CConector conector = new CConector())
        {

            conector.QueryMod(Conector.GetModificacion(Usuario.GetInstance().GetID(), HId.Value, null, "impresiones"));
            if (!string.IsNullOrEmpty(Request.QueryString["k"]) && LRevisado.Text.Length == 0)
            {
                Query query = new Query("orden_compra" + m_nAlmacen);
                query["revisado"] = "SYSDATE()";
                if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(HId.Value))) == -1)
                {
                    return;
                }
            }

            PrintEventArgs print = (PrintEventArgs)e;

            if (ROrganizationExample15.Checked)
                print.Contenido = print.Contenido.Replace("$TPaciente$", "OrganizationExample15");

            Paciente paciente = Paciente.GetPaciente(UCPaciente.IdPaciente);

            print.Contenido = print.Contenido.Replace("$szDireccion$", paciente.Direccion)
                .Replace("$TPaciente$", paciente.DocumentoYNombres.Replace("Inactivo - ", ""))
                .Replace("$szTelefono$", paciente.Telefono)
                .Replace("$szAsegurador$", paciente.NombreEntidad)
                .Replace("$szBarrio$", paciente.Barrio)
                .Replace("$szPrioridad$", CPrioridad.Checked ? "Prioritaria" : "Normal")
                .Replace("$szIniciales$", new Tercero(TTerceroID.Text).Nombre.Substring(0, 2))
                .Replace("$szNumero$", TNumero.Text.PadLeft(3, '0'))
                ;

            GProductos.Columns[0].Visible = false;
            PAnulado.Visible = true;
        }
    }

    protected void TTerceroID_TextChanged(object sender, EventArgs e)
    {
        Tercero tercero = new Tercero(TTerceroID.Text);
        TTercero.Text = tercero.Documento;
        TNombre.Text = tercero.Nombre;
        TTelefono.Text = tercero.Telefono;
        TDireccion.Text = tercero.Direccion;
        TEMail.Text = tercero.Email;
    }
}
