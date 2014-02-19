using System;
using System.Collections.Generic;
using System.Linq;
using System.Globalization;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class farmacia_devolucion : System.Web.UI.Page
{
    public static int m_nAlmacen = 1;

    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);

        if (!IsPostBack)
        {
            CConfiguracion configuracion = CConfiguracion.GetConfiguracion();

            // costo
            Utilidades.GetGridColumn(GProductos, "Costo U.").Visible =
            Utilidades.GetGridColumn(GProductos, "Costo T.").Visible =
            RCostoF.Visible = RCosto.Visible =
            TCosto.Visible = LCosto.Visible = configuracion.nCosto != 0;

            // lote
            Utilidades.GetGridColumn(GProductos, "Lote").Visible =
            RLote.Visible = TLote.Visible = LLote.Visible = configuracion.bLote;

            // vencimiento
            Utilidades.GetGridColumn(GProductos, "Vence").Visible =
            RVencimiento.Visible = TVencimiento.Visible = LVencimiento.Visible = configuracion.bVencimiento;

            // serial
            Utilidades.GetGridColumn(GProductos, "Serial").Visible =
            RSerial.Visible = TSerial.Visible = LSerial.Visible = configuracion.bSerial;

            // ubicacion
            Utilidades.GetGridColumn(GProductos, "Ubicación").Visible =
            RUbicacionO.Visible = RUbicacion.Visible =
            TUbicacionID.Visible = TUbicacion.Visible = LUbicacion.Visible = configuracion.nUbicacion != 0;

            // ubicacion obligatoria
            RUbicacion.Visible = configuracion.nUbicacion == 1;

            // estado
            Utilidades.GetGridColumn(GProductos, "Estado").Visible =
            REstado.Visible = DEstado.Visible = LEstado.Visible = configuracion.bEstado;

            if (Session["devolucion_clean"] != null)
            {
                ViewState["clean"] = true;
                Session["devolucion_clean"] = null;
            }
            else ViewState["clean"] = false;

            if (Session["ldevolucion"] != null)
            {
                ViewState["urlprint"] = Request.Url.AbsolutePath + "?di=" + Session["ldevolucion"].ToString() + "&p=1";
                LImprimir.Text = "Devolución " + Session["ldevolucion"].ToString() + " Editada.<br/>¿Desea imprimirla?";
                PImprimir.Visible = true;
                Session["ldevolucion"] = null;
            }

            CUsuario usuario = (CUsuario)CUsuario.GetUsuario();
            if (!string.IsNullOrEmpty(Request.QueryString["di"]))
            {
                using (CConector conector = new CConector())
                {

                    Query query = new Query("devolucion" + m_nAlmacen);

                    query += "id";
                    query += "observaciones";
                    query += "fecha";
                    query += "paciente";
                    query += "estado";

                    MySqlDataReader reader = conector.Query(query.GetSelect("id=" + Query.GetValor(Request.QueryString["di"])));
                    if (reader != null && reader.Read())
                    {

                        HId.Value = TNumero.Text = reader["id"].ToString();
                        ((MasterPageI)Master).SetModificacion(HId.Value);
                        ((MasterPageI)Master).Imprimir("devolucion.html");
                        TObservaciones.Text = reader["observaciones"].ToString();
                        TFecha.Text = Query.GetFromMySQLDate(reader["fecha"]);
                        PAnulado.Visible = reader["estado"].ToString() != "";
                        UCPaciente.IdPaciente = reader["paciente"].ToString();

                        Utilidades.GetGridColumn(GProductos, "Ubicación").Visible = TFecha.Text.Length != 0;

                        ProductoUsado productoUsado = ProductoUsado.DesSerialize(HUsado.Value);

                        query = new Query("devolucion_items" + m_nAlmacen);

                        query += "id";
                        query += "producto";
                        query += "cantidad";
                        query += "lote";
                        query += "vence";
                        query += "ubicacion";
                        query += "szSerial";
                        query += "estado";
                        query += "ingreso";
                        query += "costo";

                        reader = conector.Query(query.GetSelect("devolucion=" + HId.Value));
                        if (reader != null)
                        {
                            while (reader.Read())
                            {
                                Producto info = new Producto(reader["producto"].ToString());

                                info.IdTabla = reader["id"].ToString();
                                info.cantidad = Convert.ToDecimal(reader["cantidad"]);
                                info.lote = reader["lote"].ToString();
                                info.vence = "";
                                try { info.vence = Query.GetFromMySQLDate(reader["vence"]); }
                                catch { }
                                info.ubicacion = Convert.ToInt32(reader["ubicacion"]);
                                info.serial = reader["szSerial"].ToString();
                                info.estado = Convert.ToInt32(reader["estado"]);
                                info.Ingreso = reader["ingreso"].ToString();
                                info.Costo = Convert.ToDecimal(reader["costo"]);

                                productoUsado.AddProducto(info);
                            }
                        }

                        GProductos.DataSource = productoUsado.GetProductosUsados();
                        HUsado.Value = productoUsado.SerializeBinary();
                        GProductos.DataBind();
                        GProductos.FooterRow.Cells[Utilidades.GetGridColumnIndex(GProductos, "Costo T.")].Text = string.Format("{0:C}", productoUsado.GetCostoTotal());
                        GProductos.FooterRow.Cells[Utilidades.GetGridColumnIndex(GProductos, "Cantidad")].Text = string.Format("{0:F}", productoUsado.GetTotalProductos());
                        GProductos.FooterRow.Cells[Utilidades.GetGridColumnIndex(GProductos, "Producto")].Text = "Total";

                        TProducto.Focus();
                        BAgregar.Enabled = usuario.CanUpdate();
                        GProductos.Columns[0].Visible = usuario.CanDelete();
                        BAceptar.Enabled = usuario.CanUpdate();
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
                TNumero.Text = conector.QueryString("SELECT IF(MAX(id),MAX(id)+1,1) FROM devolucion" + m_nAlmacen);
            TFecha.Text = DateTime.Now.ToShortDateString();
            TNumero.Focus();
        }
    }

    protected void BAgregar_Click(object sender, EventArgs e)
    {
        Producto producto = new Producto(TProductoID.Text);

        RVencimiento.Enabled = producto.nVence == 1;
        RLote.Enabled = producto.nLote == 1;
        REntero.Enabled = producto.nNumero == 1;
        RDecimal.Enabled = producto.nNumero != 1;
        RSerial.Enabled = producto.nSerial == 1;
        REstado.Enabled = producto.nEstado == 1;

        LSerial.CssClass = TSerial.CssClass = producto.nSerial > 0 ? "" : "hide";
        LEstado.CssClass = DEstado.CssClass = producto.nEstado > 0 ? "" : "hide";
        LVencimiento.CssClass = TVencimiento.CssClass = producto.nVence > 0 ? "" : "hide";
        LLote.CssClass = TLote.CssClass = producto.nLote > 0 ? "" : "hide";
        TLote.CssClass += " tlote";
        TVencimiento.CssClass += " fecha";
        TSerial.CssClass += " tlote";

        Page.Validate("producto");
        if (!Page.IsValid)
            return;

        producto.cantidad = Convert.ToDecimal(TCantidad.Text, CultureInfo.InvariantCulture);
        producto.lote = TLote.Text;
        producto.vence = TVencimiento.Text;
        producto.serial = TSerial.Text;
        try
        {
            producto.Costo = Decimal.Parse(TCosto.Text.Replace("$", ""), NumberStyles.Currency, CultureInfo.InvariantCulture);
        }
        catch { }
        producto.estado = Convert.ToInt32(DEstado.SelectedValue);
        producto.ubicacion = TUbicacionID.Text.Length == 0 ? 0 : Convert.ToInt32(TUbicacionID.Text);

        ProductoUsado productousadoNuevo = new ProductoUsado(HProductos.Value);
        ProductoUsado productoUsado = ProductoUsado.DesSerialize(HUsado.Value);

        if (GProductos.SelectedIndex == -1)
        {
            productoUsado.AddProducto(producto);
        }
        else
        {
            // revisar la edicion
            Producto info = productoUsado.GetProducto(Convert.ToInt32(GProductos.DataKeys[GProductos.SelectedIndex].Values[0]));

            productousadoNuevo.DeleteProducto(info.id, info.cantidad, info.lote, info.vence
                , info.ubicacion, info.estado, info.serial);

            productoUsado.UpdateProducto(info.IdGrid, producto);
        }

        GProductos.SelectedIndex = -1;
        GProductos.DataSource = productoUsado.GetProductosUsados();
        GProductos.DataBind();

        RVencimiento.Enabled = true;
        RLote.Enabled = true;
        REntero.Enabled = true;
        RDecimal.Enabled = true;
        REstado.Enabled = true;
        RSerial.Enabled = true;

        LVencimiento.CssClass = TVencimiento.CssClass = "";
        LLote.CssClass = TLote.CssClass = "";
        LEstado.CssClass = DEstado.CssClass = "";
        LSerial.CssClass = TSerial.CssClass = "";

        TLote.CssClass += " tlote";
        TSerial.CssClass += " tlote";
        TVencimiento.CssClass += " fecha";

        TCosto.Text = TSerial.Text = TProducto.Text = TProductoID.Text = TCantidad.Text = TLote.Text = TVencimiento.Text = "";
        DEstado.SelectedIndex = 0;
        TUbicacion.Text = TUbicacionID.Text = "";
        TProducto.Focus();

        GProductos.FooterRow.Cells[Utilidades.GetGridColumnIndex(GProductos, "Costo T.")].Text = string.Format("{0:C}", productoUsado.GetCostoTotal());
        GProductos.FooterRow.Cells[Utilidades.GetGridColumnIndex(GProductos, "Cantidad")].Text = string.Format("{0:F}", productoUsado.GetTotalProductos());
        GProductos.FooterRow.Cells[Utilidades.GetGridColumnIndex(GProductos, "Producto")].Text = "Total";

        productousadoNuevo.GetProductosUsados().Add(producto);
        HProductos.Value = productousadoNuevo.Serialize();
        HUsado.Value = productoUsado.SerializeBinary();

        ScriptManager.RegisterStartupScript(TProducto, typeof(String), "pregunta", "window.onbeforeunload = function() { return '¿Ha realizado cambios, esta seguro de abandonar la pagina?'; };", true);
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
            TLote.Text = producto.lote;
            TVencimiento.Text = producto.vence;
            TProducto.Text = producto.NombreCompleto;
            TUbicacionID.Text = producto.ubicacion.ToString();
            TUbicacion.Text = producto.NombreUbicacion;
            try { DEstado.SelectedValue = producto.estado.ToString(); }
            catch { }
            TSerial.Text = producto.serial;
            TCosto.Text = producto.Costo.ToString(CultureInfo.InvariantCulture);
            BAgregar_Click(sender, e);
        }
    }

    protected void GProductos_SelectedIndexChanged(object sender, EventArgs e)
    {
    }

    protected void GProductos_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        // en la tabla definitiva
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
        HUsado.Value = productoUsado.SerializeBinary();
        GProductos.FooterRow.Cells[Utilidades.GetGridColumnIndex(GProductos, "Costo T.")].Text = string.Format("{0:C}", productoUsado.GetCostoTotal());
        GProductos.FooterRow.Cells[Utilidades.GetGridColumnIndex(GProductos, "Cantidad")].Text = string.Format("{0:F}", productoUsado.GetTotalProductos());
        GProductos.FooterRow.Cells[Utilidades.GetGridColumnIndex(GProductos, "Producto")].Text = "Total";

        e.Cancel = true;
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

        Query query = new Query("devolucion" + m_nAlmacen);
        using (CConector conector = new CConector())
        {
            query["observaciones"] = TObservaciones.Text;
            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);
            query["paciente"] = UCPaciente.IdPaciente;
            if (sender == BAnular)
                query["estado"] = "-1";

            conector.StartTransaction();

            bool existe = HId.Value.Length > 0;

            if (HId.Value.Length == 0)
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                {
                    LMensaje.Text = conector.GetLastError();
                    return;
                }
                HId.Value = res.ToString();
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("id=" + Query.GetValor(HId.Value))) == -1)
                {
                    LMensaje.Text = conector.GetLastError();
                    return;
                }
            }

            if (conector.InsertModificacion(HId.Value) == -1)
            {
                LMensaje.Text = conector.GetLastError();
                return;
            }

            // actualizamos las ubicaciones de todos
            ProductoUsado productoUsado = ProductoUsado.DesSerialize(HUsado.Value);
            // eliminamos todos los productos
            List<Producto> productos = productoUsado.GetProductoEliminado();
            for (int i = 0; i < productos.Count; i++)
            {
                if (conector.QueryMod(string.Format("DELETE FROM devolucion_items{0} WHERE id={1}", m_nAlmacen, productos[i].IdTabla)) == -1)
                    return;
                if (productos[i].bIngreso)
                {
                    if (!productos[i].DeleteProductoFromEstado(conector, m_nAlmacen.ToString()))
                        return;
                }
            }
            // agregamos los nuevos
            productos = productoUsado.GetProductosUsados();
            for (int i = 0; i < productos.Count; i++)
            {
                // anulamos la salida del traslado
                if (sender == BAnular)
                { // anulamos la entrada aqui

                    bool oldingresoantiguo = false;
                    if (productos[i].pProductoAntiguo != null)
                    {
                        oldingresoantiguo = productos[i].pProductoAntiguo.bIngreso;
                        productos[i].pProductoAntiguo.bIngreso = false;
                    }
                    if (!productos[i].DeleteProductoFromEstado(conector, m_nAlmacen.ToString()))
                        return;
                    if (productos[i].pProductoAntiguo != null)
                    {
                        productos[i].pProductoAntiguo.bIngreso = oldingresoantiguo;
                    }
                }
                productoUsado.UpdateProductoIngreso(productos[i].IdGrid, sender != BAnular && TFecha.Text.Length > 0);

                query = productos[i].GetQuery("devolucion_items" + m_nAlmacen);

                if (string.IsNullOrEmpty(productos[i].IdTabla))
                {
                    query["valor"] = productos[i].GetValor(UCPaciente.IdAsegurador, m_nAlmacen).ToString(CultureInfo.InvariantCulture);
                    query["devolucion"] = HId.Value;
                    if (conector.QueryMod(query.GetInsert()) == -1)
                        return;
                }
                else if (productos[i].pProductoAntiguo != null)
                { // fue actualizado
                    if (conector.QueryMod(query.GetUpdate("id=" + productos[i].IdTabla)) == -1)
                        return;
                }
                else
                {
                    continue;
                }
                if (productos[i].bIngreso)
                {
                    if (!productos[i].AddProductoFromEstado(conector, m_nAlmacen.ToString()))
                        return;
                    if (!productos[i].UpdateCosto(conector, ""))
                        return;
                }
            }

            conector.Commit();
            Session["devolucion_clean"] = 1;

            // Alertas.RemoveAlertas(m_nAlmacen);

            Session["ldevolucion"] = HId.Value;

            ((MasterPageI)Master).SetResultado("Devolución " + HId.Value + " editada.");
        }
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Session["devolucion_clean"] = 1;
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        GProductos.Columns[0].Visible = false;
        PAnulado.Visible = true;
    }
}
