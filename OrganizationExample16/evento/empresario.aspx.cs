using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using SDG.Componentes;

public partial class evento_empresario : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)CUsuario.GetInstance();
            string id = Request.QueryString["emid"];
            TDocumento.Focus();
            BAceptar.Enabled = usuario.CanInsert();
            if (!string.IsNullOrEmpty(id))
            {
                using (CConector conector = new CConector())
                {
                    Query query = new Query("empresario");

                    query += "id";
                    query += "nombre";
                    query += "documento";
                    query += "telefono";
                    query += "celular";
                    query += "nombres";
                    query += "apellidos";
                    query += "eliminado";

                    MySqlDataReader reader = conector.Query(query.GetSelect("id={0}", null, Query.GetValor(id)));
                    if (reader != null && reader.Read())
                    {

                        BAceptar.Enabled = usuario.CanUpdate() && reader["eliminado"] == DBNull.Value;
                        GDocumentos.Columns[0].Visible = usuario.CanDelete();
                        BEliminar.Visible = usuario.CanDelete() && reader["eliminado"] == DBNull.Value;
                        ViewState["id"] =
                        id = reader["id"].ToString();
                        ((MasterPageI)Master).SetModificacion(id);
                        TNombre.Text = reader["nombre"].ToString();
                        TDocumento.Text = reader["documento"].ToString();
                        TTelefono.Text = reader["telefono"].ToString();
                        TCelular.Text = reader["celular"].ToString();
                        TNombres.Text = reader["nombres"].ToString();
                        TApellidos.Text = reader["apellidos"].ToString();
                        SDocumentos.SelectParameters["empresario"].DefaultValue = id;
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
            Query query = new Query("empresario");
            conector.StartTransaction();

            query["nombre"] = TNombre.Text;
            query["documento"] = TDocumento.Text;
            query["telefono"] = TTelefono.Text;
            query["celular"] = TCelular.Text;
            query["nombres"] = TNombres.Text;
            query["apellidos"] = TApellidos.Text;

            if (string.IsNullOrEmpty(id))
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                {
                    LMessage.Text = conector.LastError;
                    return;
                }
                id = res.ToString();
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("id={0}", Query.GetValor(id))) == -1)
                {
                    LMessage.Text = conector.LastError;
                    return;
                }
            }

            if (conector.InsertModificacion(id) == -1)
            {
                LMessage.Text = conector.LastError;
                return;
            }

            query = new Query("documentos_empresario");
            query["empresario"] = id;

            foreach (GridViewRow row in GDocumentos.Rows)
            {
                string idDocumento = GDocumentos.DataKeys[row.RowIndex].Values["id"].ToString();
                query["documento"] = idDocumento;

                FileUpload file = (FileUpload)row.FindControl("F");
                if (file.HasFile)
                {
                    string extension = Path.GetExtension(file.FileName).ToLower();
                    file.SaveAs(Files.GetFilePath(Files.Directorys.EmpresarioDocumentos, true, id, idDocumento + extension));
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
            ((MasterPageI)Master).SetResultado(string.Format("Empresario {0} editado", TNombre.Text));
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
            Query query = new Query("empresario");
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
            ((MasterPageI)Master).SetResultado(string.Format("Empresario {0} eliminado", TNombre.Text));
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

        Query query = new Query("documentos_empresario");

        using (CConector conector = new CConector())
        {
            if (conector.QueryMod(query.GetDelete("empresario={0} AND documento={1}", id, idDocumento)) == -1)
            {
                LMessage.Text = conector.LastError;
                return;
            }
        }
        try { File.Delete(Files.GetFilePath(Files.Directorys.EmpresarioDocumentos, true, id, idDocumento + ".jpg")); } catch { }
        try { File.Delete(Files.GetFilePath(Files.Directorys.EmpresarioDocumentos, true, id, idDocumento + ".pdf")); } catch { }

        GDocumentos.DataBind();
    }
}