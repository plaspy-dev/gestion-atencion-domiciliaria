using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Collections.Specialized;
using SDG.Componentes;
using SDG.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class farmacia_entrada : System.Web.UI.Page
{
    public static int m_nAlmacen = 1;

    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);

        if (!IsPostBack)
        {
            CConfiguracion configuracion = CConfiguracion.GetConfiguracion();

            // costo
            GProductos.GetGridColumn("Costo U.").Visible =
            GProductos.GetGridColumn("Costo T.").Visible =
            RCostoF.Visible = RCosto.Visible =
            TCosto.Visible = LCosto.Visible = configuracion.nCosto != 0;

            // lote
            GProductos.GetGridColumn("Lote").Visible =
            RLote.Visible = TLote.Visible = LLote.Visible = configuracion.bLote;

            // vencimiento
            GProductos.GetGridColumn("Vence").Visible =
            RVencimiento.Visible = TVencimiento.Visible = LVencimiento.Visible = configuracion.bVencimiento;

            // serial
            GProductos.GetGridColumn("Serial").Visible =
            RSerial.Visible = TSerial.Visible = LSerial.Visible = configuracion.bSerial;

            // ubicacion
            GProductos.GetGridColumn("Ubicación").Visible =
            GProductos.GetGridColumn("Ubicación ").Visible =
            RUbicacionO.Visible = RUbicacion.Visible =
            TUbicacionID.Visible = TUbicacion.Visible = LUbicacion.Visible = configuracion.nUbicacion != 0;

            // ubicacion obligatoria
            RUbicacion.Visible = configuracion.nUbicacion == 1;

            // estado
            GProductos.GetGridColumn("Estado").Visible =
            REstado.Visible = DEstado.Visible = LEstado.Visible = configuracion.bEstado;

            // tercero
            RIdentificacion.Visible = configuracion.bDocumentoEntrada;

            RTerceroID.Visible = configuracion.bTerceroEntrada && !configuracion.bCrearTerceroEntradas;
            TEMail.ReadOnly = TDireccion.ReadOnly = TTercero.ReadOnly = TTelefono.ReadOnly = !configuracion.bCrearTerceroEntradas;
            RNombre.Visible = RIdentificacion.Visible = configuracion.bCrearTerceroEntradas && configuracion.bTerceroEntrada;
            RDireccion.Visible = RTelefono.Visible = configuracion.bDatosComplementariosTerceroEntrada;

            GProductos.GetGridColumn("Ubicación ").Visible = false;

            if (Session["entrada_clean"] != null)
            {
                ViewState["clean"] = true;
                Session["entrada_clean"] = null;
            }
            else ViewState["clean"] = false;

            if (Session["lentrada"] != null)
            {

                ViewState["urlprint"] = Request.Url.AbsolutePath + "?ei=" + Session["lentrada"].ToString() + "&p=1";
                LImprimir.Text = "Entrada " + Session["lentrada"].ToString() + " Editada.<br/>¿Desea imprimirla?";
                PImprimir.Visible = true;
                Session["lentrada"] = null;
            }

            CUsuario usuario = (CUsuario)CUsuario.GetUsuario();
            if (!string.IsNullOrEmpty(Request.QueryString["ei"]))
            {
                using (CConector conector = new CConector())
                {

                    Query query = new Query("entrada" + m_nAlmacen);

                    query += "id";
                    query += "observaciones";
                    query += "fecha";
                    query += "desde";
                    query += "tercero";
                    query += "estado";
                    query += "centro_costos";

                    MySqlDataReader reader = conector.Query(query.GetSelect("id=" + Query.GetValor(Request.QueryString["ei"])));
                    if (reader != null && reader.Read())
                    {

                        HId.Value = TNumero.Text = reader["id"].ToString();
                        ((MasterPageI)Master).SetModificacion(HId.Value);
                        ((MasterPageI)Master).Imprimir("entrada.html");
                        TObservaciones.Text = reader["observaciones"].ToString();
                        TFecha.Text = Query.GetFromMySQLDate(reader["fecha"]);
                        PAnulado.Visible = reader["estado"].ToString() != "";
                        Utilidades.SelectInDropDown(DCCosto, reader["centro_costos"]);

                        Tercero tercero = new Tercero(reader["tercero"].ToString());
                        TTerceroID.Text = tercero.Id;
                        TTercero.Text = tercero.Documento;
                        TNombre.Text = tercero.Nombre;
                        TTelefono.Text = tercero.Telefono;
                        TDireccion.Text = tercero.Direccion;
                        TEMail.Text = tercero.Email;

                        GProductos.GetGridColumn("Ubicación").Visible = TFecha.Text.Length != 0;
                        GProductos.GetGridColumn("Ubicación ").Visible = TFecha.Text.Length == 0;

                        ProductoUsado productoUsado = ProductoUsado.DesSerialize(HUsado.Value);

                        query = new Query("entrada_items" + m_nAlmacen);

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

                        reader = conector.Query(query.GetSelect("entrada=" + HId.Value));
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
                        if (GProductos.FooterRow != null)
                        {
                            GProductos.FooterRow.Cells[GProductos.GetGridColumnIndex("Costo T.")].Text = string.Format("{0:C}", productoUsado.GetCostoTotal());
                            GProductos.FooterRow.Cells[GProductos.GetGridColumnIndex("Cantidad")].Text = string.Format("{0:F}", productoUsado.GetTotalProductos());
                            GProductos.FooterRow.Cells[GProductos.GetGridColumnIndex("Producto")].Text = "Total";
                        }

                        TProducto.Focus();
                        BAgregar.Enabled = string.IsNullOrEmpty((string)ViewState["TrasladoId"]);
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
                TNumero.Text = conector.QueryString("SELECT IF(MAX(id),MAX(id)+1,1) FROM entrada" + m_nAlmacen);
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
        TLote.Text = producto.lote;
        TVencimiento.Text = producto.vence;
        TProductoID.Text = producto.id;
        TSerial.Text = producto.serial;
        TUbicacionID.Text = producto.ubicacion.ToString();
        TUbicacion.Text = producto.NombreUbicacion;
        DEstado.SelectedValue = producto.estado.ToString();
        TCosto.Text = producto.Costo.ToString(CultureInfo.InvariantCulture);
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

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        if (GProductos.Rows.Count == 0)
        {
            LMensaje.Text = "Por favor ingrese por lo menos un producto";
            return;
        }

        Query query = new Query("entrada" + m_nAlmacen);
        using (CConector conector = new CConector())
        {

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
                }
                else
                {
                    int res = conector.QueryMod(tercero.GetInsert());
                    if (res == -1)
                        return;
                    terceroid = res.ToString();
                }
                Tercero.RemoveTercero(terceroid);
            }

            query["observaciones"] = TObservaciones.Text;
            query["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);
            query["centro_costos"] = DCCosto.SelectedValue;
            query["tercero"] = terceroid;
            if (sender == BAnular)
                query["estado"] = "-1";

            conector.StartTransaction();

            bool existe = HId.Value.Length > 0;

            if (HId.Value.Length == 0)
            {
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

            string almacendesde = string.IsNullOrEmpty((string)ViewState["TrasladoDesde"]) ? "" : ViewState["TrasladoDesde"].ToString();
            string trasladoId = string.IsNullOrEmpty((string)ViewState["TrasladoId"]) ? "" : ViewState["TrasladoId"].ToString();

            if (almacendesde.Length > 0 && trasladoId.Length > 0)
            {
                if (conector.QueryMod(string.Format("UPDATE traslado{0} SET llegada={1} WHERE id={2}"
                    , almacendesde, Query.GetValor(Query.GetMySQLDateFormat(TFecha.Text)), trasladoId)) == -1)
                    return;
                if (sender == BAnular)
                { // anulamos el traslado
                    if (conector.QueryMod(string.Format("UPDATE traslado{0} SET estado=-1 WHERE id={1}", almacendesde, trasladoId)) == -1)
                        return;
                    if (conector.QueryMod(string.Format("UPDATE traslado_items{0} SET ingreso=NULL WHERE traslado={1}", almacendesde, trasladoId)) == -1)
                        return;
                }
            }


            // actualizamos las ubicaciones de todos
            ProductoUsado productoUsado = ProductoUsado.DesSerialize(HUsado.Value);
            if (TFecha.Text.Length > 0 && GProductos.GetGridColumn("Ubicación ").Visible)
            {
                for (int i = 0; i < GProductos.Rows.Count; i++)
                {
                    TextBox ubicacion = (TextBox)GProductos.Rows[i].FindControl("TUbicacionID");
                    if (ubicacion.Text.Length != 0 && ubicacion.Text != "-1")
                    { // se modifico la ubicacion.
                        productoUsado.UpdateProductoUbicacion(Convert.ToInt32(GProductos.DataKeys[i].Values[0]), ubicacion.Text.Length == 0 ? 0 : Convert.ToInt32(ubicacion.Text));
                    }
                }
            }

            // eliminamos todos los productos
            List<Producto> productos = productoUsado.GetProductoEliminado();
            for (int i = 0; i < productos.Count; i++)
            {
                if (conector.QueryMod(string.Format("DELETE FROM entrada_items{0} WHERE id={1}", m_nAlmacen, productos[i].IdTabla)) == -1)
                    return;
                if (productos[i].bIngreso)
                {
                    if (!productos[i].DeleteProductoFromEstado(conector, m_nAlmacen.ToString()))
                        return;
                }
                if (almacendesde.Length > 0 && trasladoId.Length > 0)
                {
                    if (conector.QueryMod(string.Format("DELETE FROM traslado_items{0} WHERE traslado={1} AND entrada_items={2}", almacendesde, trasladoId, productos[i].IdTabla)) == -1)
                        return;
                    bool ingresoold = productos[i].bIngreso;
                    productos[i].bIngreso = true;
                    if (!productos[i].DeleteProductoFromEstado(conector, almacendesde))
                        return;
                    productos[i].bIngreso = ingresoold;
                }
            }
            // agregamos los nuevos
            productos = productoUsado.GetProductosUsados();
            for (int i = 0; i < productos.Count; i++)
            {
                // anulamos la salida del traslado
                if (sender == BAnular && almacendesde.Length > 0)
                {
                    bool oldingresoantiguo = false;
                    bool oldingreso = productos[i].bIngreso;
                    productos[i].bIngreso = true;
                    if (productos[i].pProductoAntiguo != null)
                    {
                        oldingresoantiguo = productos[i].pProductoAntiguo.bIngreso;
                        productos[i].pProductoAntiguo.bIngreso = false;
                    }
                    if (!productos[i].AddProductoFromEstado(conector, almacendesde))
                        return;

                    productos[i].bIngreso = oldingreso;
                    if (productos[i].pProductoAntiguo != null)
                    {
                        productos[i].pProductoAntiguo.bIngreso = oldingresoantiguo;
                    }
                }
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

                query = productos[i].GetQuery("entrada_items" + m_nAlmacen);

                if (string.IsNullOrEmpty(productos[i].IdTabla))
                {

                    query["entrada"] = HId.Value;
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
                    if (!productos[i].UpdateCosto(conector, TTerceroID.Text))
                        return;
                }
            }

            conector.Commit();
            Session["entrada_clean"] = 1;

            // Alertas.RemoveAlertas(m_nAlmacen);

            Session["lentrada"] = HId.Value;

            ((MasterPageI)Master).SetResultado("Entrada " + HId.Value + " editada.");
        }
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Session["entrada_clean"] = 1;
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
        GProductos.Columns[1].Visible =
        GProductos.Columns[0].Visible = false;
        PAnulado.Visible = true;
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
