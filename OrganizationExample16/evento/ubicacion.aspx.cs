using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.IO;

public partial class evento_ubicacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {

            CUsuario usuario = (CUsuario)CUsuario.GetInstance();
            string id = Request.QueryString["ubid"];
            TNombre.Focus();
            BAceptar.Enabled = usuario.CanInsert();
            if (!string.IsNullOrEmpty(id))
            {
                using (CConector conector = new CConector())
                {
                    Query query = new Query("ubicacion");

                    query += "id";
                    query += "nombre";
                    query += "descripcion";
                    query += "eliminado";

                    MySqlDataReader reader= conector.Query(query.GetSelect("id={0}", null, Query.GetValor(id)));
                    if (reader != null && reader.Read()) {

                        BAceptar.Enabled = usuario.CanUpdate() && reader["eliminado"] == DBNull.Value;
                        GDocumentos.Columns[0].Visible = usuario.CanDelete();
                        BEliminar.Visible = usuario.CanDelete() && reader["eliminado"]==DBNull.Value;
                        ViewState["id"]=
                        id = reader["id"].ToString();
                        ((MasterPageI)Master).SetModificacion(id);
                        TNombre.Text= reader["nombre"].ToString();
                        TDescripcion.Text = reader["descripcion"].ToString();
                        SDocumentos.SelectParameters["ubicacion"].DefaultValue = id;
                        GDocumentos.DataBind();
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
            string id = (string)ViewState["id"];
            Query query = new Query("ubicacion");
            conector.StartTransaction();

            query["nombre"] = TNombre.Text;
            query["descripcion"] = TDescripcion.Text;

            if (string.IsNullOrEmpty(id))
            {
                int res= conector.QueryMod(query.GetInsert(), true);
                if (res == -1) {
                    LMessage.Text = conector.LastError;
                    return;
                }
                id = res.ToString();
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1) {
                    LMessage.Text = conector.LastError;
                    return;
                }
            }

            if (conector.InsertModificacion(id) == -1) {
                LMessage.Text = conector.LastError;
                return;
            }

            query = new Query("documentos_ubicacion");
            query["ubicacion"] = id;

            foreach (GridViewRow row in GDocumentos.Rows)
            {
                string idDocumento = GDocumentos.DataKeys[row.RowIndex].Values["id"].ToString();
                query["documento"] = idDocumento;

                FileUpload file = (FileUpload)row.FindControl("F");
                if (file.HasFile)
                {
                    string extension = Path.GetExtension(file.FileName).ToLower();
                    file.SaveAs(Files.GetFilePath(Files.Directorys.UbicacionDocumentos, true, id, idDocumento + extension));
                    query["archivo"] = extension;
                }

                if (conector.QueryMod(query.GetInsertUpdate()) == -1)
                {

                    LMessage.Text = conector.LastError;
                    return;
                }
                query.RemoveCampo("archivo");
            }

            conector.Commit();
            ((MasterPageI)Master).SetResultado(string.Format("Ubicación {0} editada", TNombre.Text));
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BEliminar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            string id = (string)ViewState["id"];
            Query query = new Query("ubicacion");
            conector.StartTransaction();

            query["eliminado"] = "NOW";

            if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1)
            {
                LMessage.Text = conector.LastError;
                return;
            }

            if (conector.InsertModificacion(id) == -1)
            {
                LMessage.Text = conector.LastError;
                return;
            }

            conector.Commit();
            ((MasterPageI)Master).SetResultado(string.Format("Ubicación {0} eliminada", TNombre.Text));
        }
    }

    public void OnValidaFileJPGPDF(object sender, ServerValidateEventArgs e)
    {
        Files.OnValidaFileJPGPDF(sender, e);
    }

    protected void GDocumentos_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        e.Cancel = true;
        string id = (string)ViewState["id"];
        string idDocumento = e.Keys["id"].ToString();
        if (string.IsNullOrEmpty(id))
            return;

        Query query = new Query("documentos_ubicacion");

        using (CConector conector = new CConector())
        {
            if (conector.QueryMod(query.GetDelete("ubicacion={0} AND documento={1}", id, idDocumento)) == -1)
            {
                LMessage.Text = conector.LastError;
                return;
            }
        }
        try { File.Delete(Files.GetFilePath(Files.Directorys.UbicacionDocumentos, true, id, idDocumento + ".jpg")); } catch { }
        try { File.Delete(Files.GetFilePath(Files.Directorys.UbicacionDocumentos, true, id, idDocumento + ".pdf")); } catch { }

        GDocumentos.DataBind();
    }
}