using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using componentes;

public partial class administrador_Default : System.Web.UI.Page
{
    public class Tipos
    {
        private string _nombre;
        private int _tipo;

        public Tipos(string nombre, int tipo)
        {
            _nombre= nombre;
            _tipo = tipo;
        }
        public string nombre
        {
            get
            {
                return _nombre;
            }
        }
        public int tipo
        {
            get
            {
                return _tipo;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        TNombre.Focus();
        if (!IsPostBack)
        {
            Usuario usuario= Usuario.GetUsuario();

            BAceptar.Enabled= usuario.CanInsert();
            GResultado.Columns[1].Visible = usuario.CanDelete();
            GResultado.Columns[0].Visible = usuario.CanUpdate();

            ArrayList tipos = new ArrayList();
            
            tipos.Add(new Tipos("Según (Hoja de ingreso)", 1));
            tipos.Add(new Tipos("Antecedentes (Hoja de ingreso)", 2));
            tipos.Add(new Tipos("Revisión sistemas (Hoja de ingreso)", 3));
            tipos.Add(new Tipos("Examen físico (Hoja de ingreso)", 4));
            tipos.Add(new Tipos("Varios (Hoja de ingreso)", 5));
            tipos.Add(new Tipos("Varios Inferior (Hoja de ingreso)", 6));
            tipos.Add(new Tipos("Grupos (Indice de Barthel)", 7));
            // tipos.Add(new Tipos("Indice de Barthel", 8));
            tipos.Add(new Tipos("Suministros (Hoja de gastos)", 9));

            GTipo.DataSource = tipos;
            GTipo.DataBind();

            GTipo.SelectedIndex = 0;
            HTipo.Value = "1";
            LTipo.Text = ((Tipos)tipos[0]).nombre;

            for (int i = 0; i < tipos.Count; i++ ) {

                if( ((Tipos)tipos[i]).tipo.ToString()==Request.QueryString["tipo"]) {

                    GTipo.SelectedIndex = i;
                    HTipo.Value = ((Tipos)tipos[i]).tipo.ToString();
                    LTipo.Text= ((Tipos)tipos[i]).nombre;
                    break;
                }
            }
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        Query query = new Query("varios");
        CConector conector= CConector.GetConector();
        string szQuery;
        string mensaje;

        query["nombre"] = TNombre.Text;
        query["descripcion"] = TDescripcion.Text;

        if(HId.Value.Length==0) {
            query["tipo"] = HTipo.Value;
            szQuery = query.GetInsert();
            mensaje = TNombre.Text + " ingresado";
        } else {
            szQuery = query.GetUpdate("id='" + HId.Value + "'");
            mensaje = TNombre.Text + " editado";
        }
        int res = conector.QueryMod(szQuery);
        if (res == -1)
            return;
        if (HId.Value.Length == 0)
            HId.Value = res.ToString();
        if (conector.InsertModificacion(HId.Value) == -1)
            return;
        Response.Redirect("~/administrador/?tipo=" + HTipo.Value + "&m=" + mensaje);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/administrador/?tipo=" + HTipo.Value);
    }

    protected void GResultado_SelectedIndexChanged(object sender, EventArgs e)
    {
        HId.Value= GResultado.SelectedDataKey.Value.ToString();
        TNombre.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[2].Text);
        TDescripcion.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[3].Text);

        ((MasterPageI)Master).SetModificacion(HId.Value);
    }
}
