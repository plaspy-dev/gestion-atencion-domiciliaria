using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class administrador_copagos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {
            
            LCategoria.DataBind();
            if (LCategoria.Items.Count == 0)
            {
                BCancelar.Enabled= BAceptar.Enabled = false;
                return;
            }
            LCategoria.SelectedIndex = 0;
            LCategoria_SelectedIndexChanged(sender, e);
        }
    }

    protected void LCategoria_SelectedIndexChanged(object sender, EventArgs e)
    {
        CUsuario usuario = (CUsuario) Usuario.GetUsuario();
        
        HId.Value = "";
        TPorcentaje.Text = "";
        TServicio.Text = "";
        TTotal.Text = "";
        LCategoriaText.Text = "Categoría " + LCategoria.SelectedItem.Text;
        BAceptar.Enabled = usuario.CanInsert();

        Query query = new Query("varios");

        query += "id";
        query += "nombre";
        query += "descripcion";
        query += "szReservado";

        using (CConector conector = new CConector())
        {
            MySqlDataReader reader = conector.Query(query.GetSelect("tipo=14 AND szReservado!=-1 AND parametro1='" + LCategoria.SelectedValue + "'"));
            if (reader != null)
            {
                while (reader.Read())
                {
                    BAceptar.Enabled = usuario.CanUpdate();
                    HId.Value = reader["id"].ToString();
                    TPorcentaje.Text = reader["nombre"].ToString();
                    TServicio.Text = reader["descripcion"].ToString();
                    TTotal.Text = reader["szReservado"].ToString();

                    ((MasterPageI)Master).SetModificacion(HId.Value);
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
            Query query = new Query("varios");

            query["nombre"] = TPorcentaje.Text;
            query["descripcion"] = TServicio.Text.Replace(",", "").Replace("$", "");
            query["szReservado"] = TTotal.Text.Replace(",", "").Replace("$", "");

            if (HId.Value.Length == 0)
            {

                query["tipo"] = "14";
                query["parametro1"] = LCategoria.SelectedValue;
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                    return;
                HId.Value = res.ToString();
            }
            else
            {
                if (conector.QueryMod(query.GetUpdate("id='" + HId.Value + "'")) == -1)
                    return;
            }
            if (conector.InsertModificacion(HId.Value) == -1)
                return;
        }
        Procedimientos.RemoveVarios(HId.Value);
        ((MasterPageI)Master).SetTitulo("Categoría " + LCategoria.SelectedItem.Text + " editada.");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        LCategoria_SelectedIndexChanged(sender, e);
    }
}
